# rubocop:disable Metrics/BlockLength
RSpec.describe Yaml::Pathfinder::Pathfinder do
  it 'has a version number' do
    expect(Yaml::Pathfinder::VERSION).not_to be nil
  end

  describe '#paths' do
    subject { described_class.new(yaml_lines).paths }

    let(:yaml_lines) do
      [
        "en:\n",
        "  foo:\n",
        "    bar: meh\n"
      ]
    end

    specify :aggregate_failures do
      expect(
        described_class.new([
                              "en:\n",
                              "  foo:\n",
                              "    bar: meh\n"
                            ]).paths
      ).to eq %w[en en.foo en.foo.bar]

      expect(
        described_class.new([
                              "en:\n",
                              "  foo:\n",
                              "    bar: meh\n",
                              "  baz: meh\n"
                            ]).paths
      ).to eq %w[en en.foo en.foo.bar en.baz]

      expect(
        described_class.new([
                              "en:\n",
                              "  foo:\n",
                              "    bar: meh\n",
                              "es: meh\n"
                            ]).paths
      ).to eq %w[en en.foo en.foo.bar es]

      expect(
        described_class.new([
                              "en:\n",
                              "  foo:\n",
                              "    bar: meh\n",
                              "    bas: false\n",
                              "  fpp:\n",
                              "    baz: value\n",
                              "es: meh\n"
                            ]).paths
      ).to eq %w[en en.foo en.foo.bar en.foo.bas en.fpp en.fpp.baz es]

      expect(
        described_class.new([
                              "en:\n",
                              "  elements:\n",
                              "    -\n",
                              "      bar: meh\n",
                              "      baz: xxx\n",
                              "    -\n",
                              "      bar: notmeh\n",
                              "  fpp:\n",
                              "    baz: value\n",
                              "es: meh\n"
                            ]).paths
      ).to eq %w[
        en
        en.elements
        en.elements.-
        en.elements.-.bar
        en.elements.-.baz
        en.elements.- en.elements.-.bar en.fpp
        en.fpp.baz es
      ]
    end
  end
end
# rubocop:enable Metric/BlockLength
