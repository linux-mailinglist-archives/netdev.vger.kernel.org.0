Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 746A2CBC4E
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 15:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388862AbfJDNxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 09:53:22 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46691 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388270AbfJDNxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 09:53:22 -0400
Received: by mail-wr1-f66.google.com with SMTP id o18so7275027wrv.13
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 06:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ehVYgPPteTyUUTpmdGUAb+zR8Dyyz5GSKC9xnTRflw4=;
        b=Edhm2bDc1sYB5UeGz7EXaW51z3jLlMOATeFAHQhZb7ifpT4k+VZUyIr2q9xHEmzPte
         Xc5dWFmslt6uzy0zY+fEaEg4bieXweb/fW4qCsVAUPgR2zDBZ5d8CmPxjbsw/Jsed3bl
         5S2WXGu0U17w/yMG6MONVbVqicFFv3KgL5j4riE5xFt0kgB6/REzfhnw0fLei4LPAeNG
         en9sbCo7NHYETy9s75SkSR0dWuCaMq3dIsMuERVDhHbyI6CIcaox90Uae0kYnqFx2x2S
         7UcvgtR9KS2Weg2dNLSMPuSAnxLkPFi6MaUvCVk/NbGL9y82CLYRFTDB+vCrbTpNfDYw
         btMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ehVYgPPteTyUUTpmdGUAb+zR8Dyyz5GSKC9xnTRflw4=;
        b=iP6Tpl2ImnTHrlwk72UtZr//IsvO5MAsXeg094xUSPpApm5YOxBY7oW9QB33VLRS6m
         NEP3MrNVa8kc0E39cOQD8g6WcPBe55R9MTTQV+VwJY6OmgXdrR4aRQHciUGYhfp4ugZb
         01O0oLetXDVb7LTfRAQcqh2txtXWjwLMG9IWyo+MaEKxmPwWHRWvBiZED6raXdPMvJXf
         CKeLVRettIOFhm/twM1HbXnvTyqKiNNtxpyMZnFzN9ebEiMTPzAwffqaTe07PeubOLNe
         bagWc5Rxal/dAgz20LKiUMcr0KToPHqo/+SWGcaLe9kZHT+mrjN+wjAxVJSNU4Br+zG+
         V0yw==
X-Gm-Message-State: APjAAAUZ7oYvX6JAAjZX3ITY/gBLZUKTu4WPHaO/8COdynnuyRpiPJi9
        HEFGqnLAxDmxjKujZsyXy6E=
X-Google-Smtp-Source: APXvYqy+Zp6IjbxoZj5SC88ocYkufm+nU8+SmPAXweuHgUnkVTXQ+yMsry8oASicKmkLQTrpbvZgGw==
X-Received: by 2002:a5d:4f8a:: with SMTP id d10mr12518921wru.276.1570197198635;
        Fri, 04 Oct 2019 06:53:18 -0700 (PDT)
Received: from mail.hipco.ch ([185.243.164.39])
        by smtp.gmail.com with ESMTPSA id l13sm4621191wmj.25.2019.10.04.06.53.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 06:53:18 -0700 (PDT)
X-Virus-Scanned: HIPCO Annihilation Daemon
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (HIPCO Message Framework v1091)
Subject: Re: Gentoo Linux 5.x - Tigon3
From:   Rudolf Spring <rudolf.spring@gmail.com>
In-Reply-To: <CAMet4B7vi6yYu2HZd1Pj7rhtxme8FmT4wbXTjQOnQEqJp0Z_3w@mail.gmail.com>
Date:   Fri, 4 Oct 2019 14:53:15 +0100
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5AC684B1-79CA-41EB-9553-FFBFD7284085@gmail.com>
References: <1923F6C8-A3CC-4904-B2E7-176BDB52AF1B@gmail.com>
 <CACKFLikbp+sTxFBNEnUYFK2oAqeYm58uULE=AXfCp2Afg3x4ew@mail.gmail.com>
 <A1527477-EC6E-4B64-880F-B014E8CFCB9D@gmail.com>
 <CAMet4B7vi6yYu2HZd1Pj7rhtxme8FmT4wbXTjQOnQEqJp0Z_3w@mail.gmail.com>
To:     Siva Reddy Kallam <siva.kallam@broadcom.com>
X-Mailer: HIPCO Mail (2.1091)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With Kernel 5.3.2. Interesting all are tx_mac_errors.

ifconfig  eth0
eth0: flags=3D4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9000
        ether a8:20:66:28:e6:95  txqueuelen 1000  (Ethernet)
        RX packets 1649204  bytes 775261068 (739.3 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1144621  bytes 1241414276 (1.1 GiB)
        TX errors 369  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 16 =20

ethtool -S eth0
NIC statistics:
     rx_octets: 752756285
     rx_fragments: 0
     rx_ucast_packets: 1132211
     rx_mcast_packets: 128115
     rx_bcast_packets: 372162
     rx_fcs_errors: 0
     rx_align_errors: 0
     rx_xon_pause_rcvd: 0
     rx_xoff_pause_rcvd: 0
     rx_mac_ctrl_rcvd: 0
     rx_xoff_entered: 0
     rx_frame_too_long_errors: 0
     rx_jabbers: 0
     rx_undersize_packets: 0
     rx_in_length_errors: 0
     rx_out_length_errors: 0
     rx_64_or_less_octet_packets: 0
     rx_65_to_127_octet_packets: 0
     rx_128_to_255_octet_packets: 0
     rx_256_to_511_octet_packets: 0
     rx_512_to_1023_octet_packets: 0
     rx_1024_to_1522_octet_packets: 0
     rx_1523_to_2047_octet_packets: 0
     rx_2048_to_4095_octet_packets: 0
     rx_4096_to_8191_octet_packets: 0
     rx_8192_to_9022_octet_packets: 0
     tx_octets: 1236703101
     tx_collisions: 0
     tx_xon_sent: 0
     tx_xoff_sent: 0
     tx_flow_control: 0
     tx_mac_errors: 369
     tx_single_collisions: 0
     tx_mult_collisions: 0
     tx_deferred: 0
     tx_excessive_collisions: 0
     tx_late_collisions: 0
     tx_collide_2times: 0
     tx_collide_3times: 0
     tx_collide_4times: 0
     tx_collide_5times: 0
     tx_collide_6times: 0
     tx_collide_7times: 0
     tx_collide_8times: 0
     tx_collide_9times: 0
     tx_collide_10times: 0
     tx_collide_11times: 0
     tx_collide_12times: 0
     tx_collide_13times: 0
     tx_collide_14times: 0
     tx_collide_15times: 0
     tx_ucast_packets: 986854
     tx_mcast_packets: 146951
     tx_bcast_packets: 1117
     tx_carrier_sense_errors: 0
     tx_discards: 0
     tx_errors: 0
     dma_writeq_full: 0
     dma_write_prioq_full: 0
     rxbds_empty: 0
     rx_discards: 0
     rx_errors: 0
     rx_threshold_hit: 0
     dma_readq_full: 0
     dma_read_prioq_full: 0
     tx_comp_queue_full: 0
     ring_set_send_prod_index: 0
     ring_status_update: 0
     nic_irqs: 0
     nic_avoided_irqs: 0
     nic_tx_threshold_hit: 0
     mbuf_lwm_thresh_hit: 0

> On 4 Oct 2019, at 12:52, Siva Reddy Kallam <siva.kallam@broadcom.com> =
wrote:
>=20
>=20
>=20
> On Wed, Oct 2, 2019 at 10:05 PM Rudolf Spring =
<rudolf.spring@gmail.com> wrote:
> The output of dmesg and ethtool is identical between 4.19.72 and =
5.3.2. Any suggestions ?
> Can you please provide the output of "ethtool -S eth0" command?
> In the mean time, I will review the register dump and also try to =
reproduce in our lab.
> 0000:01:00.0: enabling device (0000 -> 0002)
> [    1.140738] tg3 0000:01:00.0 eth0: Tigon3 [partno(BCM957766a) rev =
57766001] (PCI Express) MAC address a8:20:66:28:e6:95
> [    1.140741] tg3 0000:01:00.0 eth0: attached PHY is 57765 =
(10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
> [    1.140743] tg3 0000:01:00.0 eth0: RXcsums[1] LinkChgREG[0] =
MIirq[0] ASF[0] TSOcap[1]
> [    1.140744] tg3 0000:01:00.0 eth0: dma_rwctrl[00000001] =
dma_mask[64-bit]
> [   10.290239] tg3 0000:01:00.0 eth0: Link is up at 1000 Mbps, full =
duplex
> [   10.290241] tg3 0000:01:00.0 eth0: Flow control is on for TX and on =
for RX
> [   10.290242] tg3 0000:01:00.0 eth0: EEE is enabled
>=20
> ethtool eth0
> Settings for eth0:
>         Supported ports: [ TP ]
>         Supported link modes:   10baseT/Half 10baseT/Full=20
>                                 100baseT/Half 100baseT/Full=20
>                                 1000baseT/Half 1000baseT/Full=20
>         Supported pause frame use: No
>         Supports auto-negotiation: Yes
>         Supported FEC modes: Not reported
>         Advertised link modes:  10baseT/Half 10baseT/Full=20
>                                 100baseT/Half 100baseT/Full=20
>                                 1000baseT/Half 1000baseT/Full=20
>         Advertised pause frame use: Symmetric
>         Advertised auto-negotiation: Yes
>         Advertised FEC modes: Not reported
>         Link partner advertised link modes:  10baseT/Half 10baseT/Full=20=

>                                              100baseT/Half =
100baseT/Full=20
>                                              1000baseT/Full=20
>         Link partner advertised pause frame use: Symmetric
>         Link partner advertised auto-negotiation: Yes
>         Link partner advertised FEC modes: Not reported
>         Speed: 1000Mb/s
>         Duplex: Full
>         Port: Twisted Pair
>         PHYAD: 1
>         Transceiver: internal
>         Auto-negotiation: on
>         MDI-X: off
>         Supports Wake-on: g
>         Wake-on: g
>         Current message level: 0x000000ff (255)
>                                drv probe link timer ifdown ifup rx_err =
tx_err
>         Link detected: yes
>=20
> ethtool -a eth0
> Pause parameters for eth0:
> Autonegotiate:  on
> RX:             on
> TX:             on
> RX negotiated:  on
> TX negotiated:  on
>=20
> ethtool -g eth0
> Ring parameters for eth0:
> Pre-set maximums:
> RX:             511
> RX Mini:        0
> RX Jumbo:       255
> TX:             511
> Current hardware settings:
> RX:             200
> RX Mini:        0
> RX Jumbo:       100
> TX:             511
>=20
> ethtool -c eth0
> Coalesce parameters for eth0:
> Adaptive RX: off  TX: off
> stats-block-usecs: 0
> sample-interval: 0
> pkt-rate-low: 0
> pkt-rate-high: 0
>=20
> rx-usecs: 20
> rx-frames: 5
> rx-usecs-irq: 0
> rx-frames-irq: 5
>=20
> tx-usecs: 72
> tx-frames: 53
> tx-usecs-irq: 0
> tx-frames-irq: 5
>=20
> rx-usecs-low: 0
> rx-frame-low: 0
> tx-usecs-low: 0
> tx-frame-low: 0
>=20
> rx-usecs-high: 0
> rx-frame-high: 0
> tx-usecs-high: 0
> tx-frame-high: 0
>=20
> ethtool -k eth0
> Features for eth0:
> rx-checksumming: on
> tx-checksumming: on
>         tx-checksum-ipv4: on
>         tx-checksum-ip-generic: off [fixed]
>         tx-checksum-ipv6: on
>         tx-checksum-fcoe-crc: off [fixed]
>         tx-checksum-sctp: off [fixed]
> scatter-gather: on
>         tx-scatter-gather: on
>         tx-scatter-gather-fraglist: off [fixed]
> tcp-segmentation-offload: on
>         tx-tcp-segmentation: on
>         tx-tcp-ecn-segmentation: on
>         tx-tcp-mangleid-segmentation: off
>         tx-tcp6-segmentation: on
> udp-fragmentation-offload: off
> generic-segmentation-offload: on
> generic-receive-offload: on
> large-receive-offload: off [fixed]
> rx-vlan-offload: on [fixed]
> tx-vlan-offload: on [fixed]
> ntuple-filters: off [fixed]
> receive-hashing: off [fixed]
> highdma: on
> rx-vlan-filter: off [fixed]
> vlan-challenged: off [fixed]
> tx-lockless: off [fixed]
> netns-local: off [fixed]
> tx-gso-robust: off [fixed]
> tx-fcoe-segmentation: off [fixed]
> tx-gre-segmentation: off [fixed]
> tx-gre-csum-segmentation: off [fixed]
> tx-ipxip4-segmentation: off [fixed]
> tx-ipxip6-segmentation: off [fixed]
> tx-udp_tnl-segmentation: off [fixed]
> tx-udp_tnl-csum-segmentation: off [fixed]
> tx-gso-partial: off [fixed]
> tx-sctp-segmentation: off [fixed]
> tx-esp-segmentation: off [fixed]
> tx-udp-segmentation: off [fixed]
> fcoe-mtu: off [fixed]
> tx-nocache-copy: off
> loopback: off [fixed]
> rx-fcs: off [fixed]
> rx-all: off [fixed]
> tx-vlan-stag-hw-insert: off [fixed]
> rx-vlan-stag-hw-parse: off [fixed]
> rx-vlan-stag-filter: off [fixed]
> l2-fwd-offload: off [fixed]
> hw-tc-offload: off [fixed]
> esp-hw-offload: off [fixed]
> esp-tx-csum-hw-offload: off [fixed]
> rx-udp_tunnel-port-offload: off [fixed]
> tls-hw-tx-offload: off [fixed]
> tls-hw-rx-offload: off [fixed]
> rx-gro-hw: off [fixed]
> tls-hw-record: off [fixed]
>=20
> ethtool -n eth0
> 4 RX rings available
> rxclass: Cannot get RX class rule count: Operation not supported
> RX classification rule retrieval failed
>=20
> ethtool -t eth0
> The test result is PASS
> The test extra info:
> nvram test        (online)       0
> link test         (online)       0
> register test     (offline)      0
> memory test       (offline)      0
> mac loopback test (offline)      0
> phy loopback test (offline)      0
> ext loopback test (offline)      0
> interrupt test    (offline)      0
>=20
> ethtool -T eth0
> Time stamping parameters for eth0:
> Capabilities:
>         software-transmit     (SOF_TIMESTAMPING_TX_SOFTWARE)
>         software-receive      (SOF_TIMESTAMPING_RX_SOFTWARE)
>         software-system-clock (SOF_TIMESTAMPING_SOFTWARE)
> PTP Hardware Clock: none
> Hardware Transmit Timestamp Modes:
>         off                   (HWTSTAMP_TX_OFF)
>         on                    (HWTSTAMP_TX_ON)
> Hardware Receive Filter Modes:
>         none                  (HWTSTAMP_FILTER_NONE)
>         ptpv1-l4-event        (HWTSTAMP_FILTER_PTP_V1_L4_EVENT)
>         ptpv2-l4-event        (HWTSTAMP_FILTER_PTP_V2_L4_EVENT)
>         ptpv2-l2-event        (HWTSTAMP_FILTER_PTP_V2_L2_EVENT)
>=20
> ethtool -l eth0
> Channel parameters for eth0:
> Pre-set maximums:
> RX:             4
> TX:             1
> Other:          0
> Combined:       0
> Current hardware settings:
> RX:             4
> TX:             1
> Other:          0
> Combined:       0
>=20
> ethtool --show-eee eth0
> EEE Settings for eth0:
>         EEE status: enabled - active
>         Tx LPI: 2047 (us)
>         Supported EEE link modes:  100baseT/Full=20
>                                    1000baseT/Full=20
>         Advertised EEE link modes:  100baseT/Full=20
>                                     1000baseT/Full=20
>         Link partner advertised EEE link modes:  100baseT/Full=20
>                                                  1000baseT/Full=20
>=20
> > These are all the tg3 changes between 4.19 and 5.0:
> >=20
> > 750afb08ca71 cross-tree: phase out dma_zalloc_coherent()
> > cddaf02bcb73 tg3: optionally use eth_platform_get_mac_address() to =
get
> > mac address
> > 3c1bcc8614db net: ethernet: Convert phydev advertize and supported
> > from u32 to link mode
> > 6fe42e228dc2 tg3: extend PTP gettime function to read system clock
> > 310fc0513ea9 tg3: Fix fall-through annotations
> > 22b7d29926b5 net: ethernet: Add helper to determine if pause
> > configuration is supported
> > 70814e819c11 net: ethernet: Add helper for set_pauseparam for Asym =
Pause
> > af8d9bb2f2f4 net: ethernet: Add helper for MACs which support asym =
pause
> > 04b7d41d8046 net: ethernet: Fix up drivers masking pause support
> > 58056c1e1b0e net: ethernet: Use phy_set_max_speed() to limit =
advertised speed
> >=20
> > Most of the changes are related to PHY settings.  I suggest that you
> > check the link settings, including speed, pause, asym pause, etc
> > between the working kernel and the non-working kernel to see if =
there
> > are differences in the settings.
>=20

