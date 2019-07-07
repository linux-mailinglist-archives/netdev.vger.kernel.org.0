Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0AE61470
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfGGIPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:15:42 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:45683 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725822AbfGGIPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:15:41 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9888214C0;
        Sun,  7 Jul 2019 04:15:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:15:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=RcUR/d7hQMT9rxfNN2LWwVCWHM8jm2LT5ZV42Yoty
        FM=; b=GCudrbAcVMGkg8Dwo86iOjy8q6AKBR1aLhpGo7KrVteJ3EuSduS/3MdSF
        Jw2meh0tWo09mLVy6UemX5S7sTd+lRuDxVxDzBmPTBoNWEaQvhvyRZ9lzpQhS7vJ
        Aasgaa5D47jsYnIdjne5s2JXZe2A7WPjLq6w8xxBg0B3uxiW8+rWf/eFZosrsvCt
        J7qmQ+2oHaEO5SltDXJgtX9Qa0O2I9BH+5nfGrTIIRO8+QB8MhtFIYfNyP8ZcNJp
        2S+yy0vtj5TgOyIz4jzmEfJIKqD2EpYpycCq7UBjFfkkuHQPhqqOaeRvM1J7YulY
        gkLVOCaQGNrbE6LVorvX3vIXlRcAw==
X-ME-Sender: <xms:KaohXe3JW1Wj2eTzYpt4WlojEOVfwpWCEh1tUsSxXybkbjbXF02rgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeekgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtugfgjggfsehtke
    ertddtreejnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucffohhmrghinhepghhithhhuhgsrdgtohhmpdhprhhomhgvth
    hhvghushdrihhopdgtlhhouhgufhhlrghrvgdrtghomhenucfkphepudelfedrgeejrddu
    ieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstg
    hhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:KaohXYMZG--N3c5TV63_7aoXj_cdQ3OBzgTVntajn7dG-LXSadrNaQ>
    <xmx:KaohXZQLFDaGLUlN6S7DHIAW8m-TLzhKEaEvZbRkn5Bnn_vq9hRRAg>
    <xmx:KaohXZjQv8p5-SJaMndR1xD1OlN1ZrCUluYPGYwUETmLeS2X_CbMgA>
    <xmx:LKohXZhve9wcvf5u7FrOOEDpPhgIZEKiwerf9ZsStreTHakGeSXbJw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2E49180060;
        Sun,  7 Jul 2019 04:15:37 -0400 (EDT)
Date:   Sun, 7 Jul 2019 11:15:35 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 00/11] Add drop monitor for offloaded data paths
Message-ID: <20190707081535.GA4204@splinter>
References: <20190707075828.3315-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190707075828.3315-1-idosch@idosch.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More info that I did not want to put in the cover letter:

Wrote a Wireshark dissector [1] for devlink packets. It dissects various
devlink packets and is especially useful for trap report packets. Both
the metadata about the trapped packet (e.g., trap reason) and also the
trapped Ethernet packet itself are dissected and displayed. Example [6].
Will submit it after the kernel infrastructure is accepted.

Jiri wrote devlink_exporter [2] for Prometheus [3]. This allows one to
export trap statistics as metrics to Prometheus. Eventually, this should
be integrated into node_exporter [4]. We also experimented with
Cloudflare's ebpf_exporter [5], which allows for more fine-grained
statistics (e.g., number of drops per {5-tuple, drop reason}).

I imagine that Wireshark will be mainly used by kernel engineers that
need to pinpoint a specific problem, whereas Prometheus (and similar
time series databases) will be used by network engineers that need to
monitor the network 24x7.

[1] https://github.com/idosch/wireshark/blob/devlink/epan/dissectors/packet-netlink-devlink.c
[2] https://github.com/jpirko/prometheus-devlink-exporter/blob/master/devlink-exporter.py
[3] https://prometheus.io/
[4] https://github.com/prometheus/node_exporter
[5] https://blog.cloudflare.com/introducing-ebpf_exporter/
[6]
Linux netlink (cooked header)
    Link-layer address type: Netlink (824)
    Family: Generic (0x0010)
Linux Generic Netlink protocol
    Netlink message header (type: 0x0013)
        Length: 224
        Family ID: 0x13 (devlink)
        Flags: 0x0000
            .... .... .... ...0 = Request: 0
            .... .... .... ..0. = Multipart message: 0
            .... .... .... .0.. = Ack: 0
            .... .... .... 0... = Echo: 0
            .... .... ...0 .... = Dump inconsistent: 0
            .... .... ..0. .... = Dump filtered: 0
        Sequence: 0
        Port ID: 0
    Command: Trap report (65)
    Family Version: 1
    Reserved
Linux devlink (device netlink) protocol
    Attribute: Bus name: pci
        Len: 8
        Type: 0x0001, Bus name (1)
            0... .... .... .... = Nested: 0
            .0.. .... .... .... = Network byte order: 0
            Attribute type: Bus name (1)
        Bus name: pci
    Attribute: Device name: 0000:01:00.0
        Len: 17
        Type: 0x0002, Device name (2)
            0... .... .... .... = Nested: 0
            .0.. .... .... .... = Network byte order: 0
            Attribute type: Device name (2)
        Device name: 0000:01:00.0
    Attribute: Trap group name: l2_drops
        Len: 13
        Type: 0x0089, Trap group name (137)
            0... .... .... .... = Nested: 0
            .0.. .... .... .... = Network byte order: 0
            Attribute type: Trap group name (137)
        Trap group name: l2_drops
    Attribute: Trap name: source_mac_is_multicast
        Len: 28
        Type: 0x0080, Trap name (128)
            0... .... .... .... = Nested: 0
            .0.. .... .... .... = Network byte order: 0
            Attribute type: Trap name (128)
        Trap name: source_mac_is_multicast
    Attribute: Trap type
        Len: 5
        Type: 0x0083, Trap type (131)
            0... .... .... .... = Nested: 0
            .0.. .... .... .... = Network byte order: 0
            Attribute type: Trap type (131)
        Trap type: Drop (0)
    Attribute: Trap timestamp
        Len: 20
        Type: 0x0086, Trap timestamp (134)
            0... .... .... .... = Nested: 0
            .0.. .... .... .... = Network byte order: 0
            Attribute type: Trap timestamp (134)
        Trap timestamp: Jul  6, 2019 18:16:11.396492223 IDT
    Attribute: Trap input port
        Len: 40
        Type: 0x8087, Nested, Trap input port (135)
            1... .... .... .... = Nested: 1
            .0.. .... .... .... = Network byte order: 0
            Attribute type: Unknown (32903)
        Attribute: Port index: 17
            Len: 8
            Type: 0x0003, Port index (3)
                0... .... .... .... = Nested: 0
                .0.. .... .... .... = Network byte order: 0
                Attribute type: Port index (3)
            Port index: 17
        Attribute: Port type
            Len: 6
            Type: 0x0004, Port type (4)
                0... .... .... .... = Nested: 0
                .0.. .... .... .... = Network byte order: 0
                Attribute type: Port type (4)
            Port type: Ethernet (2)
        Attribute: Net device index: 133
            Len: 8
            Type: 0x0006, Net device index (6)
                0... .... .... .... = Nested: 0
                .0.. .... .... .... = Network byte order: 0
                Attribute type: Net device index (6)
            Port net device index: 133
        Attribute: Net device name: swp3
            Len: 9
            Type: 0x0007, Net device name (7)
                0... .... .... .... = Nested: 0
                .0.. .... .... .... = Network byte order: 0
                Attribute type: Net device name (7)
            Port net device name: swp3
    Attribute: Trap payload
        Len: 64
        Type: 0x0088, Trap payload (136)
            0... .... .... .... = Nested: 0
            .0.. .... .... .... = Network byte order: 0
            Attribute type: Trap payload (136)
        Ethernet II, Src: Woonsang_04:05:06 (01:02:03:04:05:06), Dst: Mellanox_ff:27:d1 (7c:fe:90:ff:27:d1)
            Destination: Mellanox_ff:27:d1 (7c:fe:90:ff:27:d1)
                Address: Mellanox_ff:27:d1 (7c:fe:90:ff:27:d1)
                .... ..0. .... .... .... .... = LG bit: Globally unique address (factory default)
                .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
            Source: Woonsang_04:05:06 (01:02:03:04:05:06)
                [Expert Info (Warning/Protocol): Source MAC must not be a group address: IEEE 802.3-2002, Section 3.2.3(b)]
                    [Source MAC must not be a group address: IEEE 802.3-2002, Section 3.2.3(b)]
                    [Severity level: Warning]
                    [Group: Protocol]
                Address: Woonsang_04:05:06 (01:02:03:04:05:06)
                .... ..0. .... .... .... .... = LG bit: Globally unique address (factory default)
                .... ...1 .... .... .... .... = IG bit: Group address (multicast/broadcast)
            Type: IPv4 (0x0800)
            Trailer: 000000000000000000000000000000000000000000000000…
        Internet Protocol Version 4, Src: 192.0.2.1, Dst: 192.0.2.2
            0100 .... = Version: 4
            .... 0101 = Header Length: 20 bytes (5)
            Differentiated Services Field: 0x00 (DSCP: CS0, ECN: Not-ECT)
                0000 00.. = Differentiated Services Codepoint: Default (0)
                .... ..00 = Explicit Congestion Notification: Not ECN-Capable Transport (0)
            Total Length: 20
            Identification: 0x0000 (0)
            Flags: 0x0000
                0... .... .... .... = Reserved bit: Not set
                .0.. .... .... .... = Don't fragment: Not set
                ..0. .... .... .... = More fragments: Not set
            ...0 0000 0000 0000 = Fragment offset: 0
            Time to live: 255
            Protocol: IPv6 Hop-by-Hop Option (0)
            Header checksum: 0x37e6 [validation disabled]
            [Header checksum status: Unverified]
            Source: 192.0.2.1
            Destination: 192.0.2.2
