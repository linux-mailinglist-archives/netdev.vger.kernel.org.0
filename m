Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52DBC8E7A
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfJBQfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:35:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45670 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJBQfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:35:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id r5so20376767wrm.12
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/vAHg6YpuAM+T8hSe2G21rYXSPfkdYvVRxvzFLiOgwg=;
        b=JCDmCpdGFhRUco2xouUiynSfrCujChPIU1V4TWhV6VyHWnIsVgItc8ijH3Hmj1P8IL
         HYdXInNPrFGyAs7RtQP+jM2TZa5r3zLTu26i0aItC1elelRMUYsRFH8z/TggvZvyI+LH
         2GRdct8mCtIehQ6VFyHvSBAa6nPCM0aBUtx0Z7KV0JsfEUda/cC557J8C3ax5bPfCZD5
         PME13OtKtKiOHYxddWwGZUSAjQLyIBnIJlCc7MitTd9P3JASMaCWSaQtD0iqx8Iqm/pC
         pTOvv6KQkJ2N/JMczVvMrThtIu/ntQgRMgyEf0LlTHDoLeLiB80gL5iMdGMZ/io8gRJ+
         HZWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/vAHg6YpuAM+T8hSe2G21rYXSPfkdYvVRxvzFLiOgwg=;
        b=OKVpJ74dwuYRJ4lvkETuSe2Uuk6LQy7LyM1xAPRkObo0pTnuHhAgis+pxhncUz6fwH
         YvCFCj+e4U8qFcGLU0pnWTIXxptdn/3tq0BERgcjhhkrpnaq81HHR1QZi+AwWYBzxfL8
         onSbMhrpGsWYOFR5YiIXTDFWpoKwvO6c2b33Z3bEoGOPSCQjWJVmYGuHM/wnxQxJFjZw
         VJLjtZKWKf8ExRlhrtagNHnwmNGIz4wV3UATUyJHMoNQnWAl75uCMieR1SOZlVQ5vxeT
         0fDlfJjAw8ZMq0qcn9PIL+qvfennJ3Or24mdA/gmuQSk4fM0FsLw6lurHqiWGakdlfiw
         CXHQ==
X-Gm-Message-State: APjAAAXgwHKdrHGV5B5w0twSf6Zx/zofx4Pr9R5lTREhYatrveICSXfj
        oLC0BIB0TbtKzUi8qi+0RVXmgrRtvI4=
X-Google-Smtp-Source: APXvYqx7+d1vZ+otmDTrUFbgO92bnbzaAjt2tkaYIPu/5iRjf46cqPlsPvq9HZ9LENlOf25YKeYE/Q==
X-Received: by 2002:a5d:4ecf:: with SMTP id s15mr3361707wrv.234.1570034127163;
        Wed, 02 Oct 2019 09:35:27 -0700 (PDT)
Received: from mail.hipco.ch ([185.243.164.39])
        by smtp.gmail.com with ESMTPSA id g1sm18547606wrv.68.2019.10.02.09.35.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 09:35:26 -0700 (PDT)
X-Virus-Scanned: HIPCO Annihilation Daemon
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (HIPCO Message Framework v1091)
Subject: Re: Gentoo Linux 5.x - Tigon3
From:   Rudolf Spring <rudolf.spring@gmail.com>
In-Reply-To: <CACKFLikbp+sTxFBNEnUYFK2oAqeYm58uULE=AXfCp2Afg3x4ew@mail.gmail.com>
Date:   Wed, 2 Oct 2019 17:35:23 +0100
Cc:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A1527477-EC6E-4B64-880F-B014E8CFCB9D@gmail.com>
References: <1923F6C8-A3CC-4904-B2E7-176BDB52AF1B@gmail.com>
 <CACKFLikbp+sTxFBNEnUYFK2oAqeYm58uULE=AXfCp2Afg3x4ew@mail.gmail.com>
To:     Michael Chan <michael.chan@broadcom.com>
X-Mailer: HIPCO Mail (2.1091)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The output of dmesg and ethtool is identical between 4.19.72 and 5.3.2. =
Any suggestions ?

0000:01:00.0: enabling device (0000 -> 0002)
[    1.140738] tg3 0000:01:00.0 eth0: Tigon3 [partno(BCM957766a) rev =
57766001] (PCI Express) MAC address a8:20:66:28:e6:95
[    1.140741] tg3 0000:01:00.0 eth0: attached PHY is 57765 =
(10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[    1.140743] tg3 0000:01:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] =
ASF[0] TSOcap[1]
[    1.140744] tg3 0000:01:00.0 eth0: dma_rwctrl[00000001] =
dma_mask[64-bit]
[   10.290239] tg3 0000:01:00.0 eth0: Link is up at 1000 Mbps, full =
duplex
[   10.290241] tg3 0000:01:00.0 eth0: Flow control is on for TX and on =
for RX
[   10.290242] tg3 0000:01:00.0 eth0: EEE is enabled

ethtool eth0
Settings for eth0:
	Supported ports: [ TP ]
	Supported link modes:   10baseT/Half 10baseT/Full=20
	                        100baseT/Half 100baseT/Full=20
	                        1000baseT/Half 1000baseT/Full=20
	Supported pause frame use: No
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT/Half 10baseT/Full=20
	                        100baseT/Half 100baseT/Full=20
	                        1000baseT/Half 1000baseT/Full=20
	Advertised pause frame use: Symmetric
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  10baseT/Half 10baseT/Full=20=

	                                     100baseT/Half 100baseT/Full=20=

	                                     1000baseT/Full=20
	Link partner advertised pause frame use: Symmetric
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Port: Twisted Pair
	PHYAD: 1
	Transceiver: internal
	Auto-negotiation: on
	MDI-X: off
	Supports Wake-on: g
	Wake-on: g
	Current message level: 0x000000ff (255)
			       drv probe link timer ifdown ifup rx_err =
tx_err
	Link detected: yes

ethtool -a eth0
Pause parameters for eth0:
Autonegotiate:	on
RX:		on
TX:		on
RX negotiated:	on
TX negotiated:	on

ethtool -g eth0
Ring parameters for eth0:
Pre-set maximums:
RX:		511
RX Mini:	0
RX Jumbo:	255
TX:		511
Current hardware settings:
RX:		200
RX Mini:	0
RX Jumbo:	100
TX:		511

ethtool -c eth0
Coalesce parameters for eth0:
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 20
rx-frames: 5
rx-usecs-irq: 0
rx-frames-irq: 5

tx-usecs: 72
tx-frames: 53
tx-usecs-irq: 0
tx-frames-irq: 5

rx-usecs-low: 0
rx-frame-low: 0
tx-usecs-low: 0
tx-frame-low: 0

rx-usecs-high: 0
rx-frame-high: 0
tx-usecs-high: 0
tx-frame-high: 0

ethtool -k eth0
Features for eth0:
rx-checksumming: on
tx-checksumming: on
	tx-checksum-ipv4: on
	tx-checksum-ip-generic: off [fixed]
	tx-checksum-ipv6: on
	tx-checksum-fcoe-crc: off [fixed]
	tx-checksum-sctp: off [fixed]
scatter-gather: on
	tx-scatter-gather: on
	tx-scatter-gather-fraglist: off [fixed]
tcp-segmentation-offload: on
	tx-tcp-segmentation: on
	tx-tcp-ecn-segmentation: on
	tx-tcp-mangleid-segmentation: off
	tx-tcp6-segmentation: on
udp-fragmentation-offload: off
generic-segmentation-offload: on
generic-receive-offload: on
large-receive-offload: off [fixed]
rx-vlan-offload: on [fixed]
tx-vlan-offload: on [fixed]
ntuple-filters: off [fixed]
receive-hashing: off [fixed]
highdma: on
rx-vlan-filter: off [fixed]
vlan-challenged: off [fixed]
tx-lockless: off [fixed]
netns-local: off [fixed]
tx-gso-robust: off [fixed]
tx-fcoe-segmentation: off [fixed]
tx-gre-segmentation: off [fixed]
tx-gre-csum-segmentation: off [fixed]
tx-ipxip4-segmentation: off [fixed]
tx-ipxip6-segmentation: off [fixed]
tx-udp_tnl-segmentation: off [fixed]
tx-udp_tnl-csum-segmentation: off [fixed]
tx-gso-partial: off [fixed]
tx-sctp-segmentation: off [fixed]
tx-esp-segmentation: off [fixed]
tx-udp-segmentation: off [fixed]
fcoe-mtu: off [fixed]
tx-nocache-copy: off
loopback: off [fixed]
rx-fcs: off [fixed]
rx-all: off [fixed]
tx-vlan-stag-hw-insert: off [fixed]
rx-vlan-stag-hw-parse: off [fixed]
rx-vlan-stag-filter: off [fixed]
l2-fwd-offload: off [fixed]
hw-tc-offload: off [fixed]
esp-hw-offload: off [fixed]
esp-tx-csum-hw-offload: off [fixed]
rx-udp_tunnel-port-offload: off [fixed]
tls-hw-tx-offload: off [fixed]
tls-hw-rx-offload: off [fixed]
rx-gro-hw: off [fixed]
tls-hw-record: off [fixed]

ethtool -n eth0
4 RX rings available
rxclass: Cannot get RX class rule count: Operation not supported
RX classification rule retrieval failed

ethtool -t eth0
The test result is PASS
The test extra info:
nvram test        (online) 	 0
link test         (online) 	 0
register test     (offline)	 0
memory test       (offline)	 0
mac loopback test (offline)	 0
phy loopback test (offline)	 0
ext loopback test (offline)	 0
interrupt test    (offline)	 0

ethtool -T eth0
Time stamping parameters for eth0:
Capabilities:
	software-transmit     (SOF_TIMESTAMPING_TX_SOFTWARE)
	software-receive      (SOF_TIMESTAMPING_RX_SOFTWARE)
	software-system-clock (SOF_TIMESTAMPING_SOFTWARE)
PTP Hardware Clock: none
Hardware Transmit Timestamp Modes:
	off                   (HWTSTAMP_TX_OFF)
	on                    (HWTSTAMP_TX_ON)
Hardware Receive Filter Modes:
	none                  (HWTSTAMP_FILTER_NONE)
	ptpv1-l4-event        (HWTSTAMP_FILTER_PTP_V1_L4_EVENT)
	ptpv2-l4-event        (HWTSTAMP_FILTER_PTP_V2_L4_EVENT)
	ptpv2-l2-event        (HWTSTAMP_FILTER_PTP_V2_L2_EVENT)

ethtool -l eth0
Channel parameters for eth0:
Pre-set maximums:
RX:		4
TX:		1
Other:		0
Combined:	0
Current hardware settings:
RX:		4
TX:		1
Other:		0
Combined:	0

ethtool --show-eee eth0
EEE Settings for eth0:
	EEE status: enabled - active
	Tx LPI: 2047 (us)
	Supported EEE link modes:  100baseT/Full=20
	                           1000baseT/Full=20
	Advertised EEE link modes:  100baseT/Full=20
	                            1000baseT/Full=20
	Link partner advertised EEE link modes:  100baseT/Full=20
	                                         1000baseT/Full=20

> These are all the tg3 changes between 4.19 and 5.0:
>=20
> 750afb08ca71 cross-tree: phase out dma_zalloc_coherent()
> cddaf02bcb73 tg3: optionally use eth_platform_get_mac_address() to get
> mac address
> 3c1bcc8614db net: ethernet: Convert phydev advertize and supported
> from u32 to link mode
> 6fe42e228dc2 tg3: extend PTP gettime function to read system clock
> 310fc0513ea9 tg3: Fix fall-through annotations
> 22b7d29926b5 net: ethernet: Add helper to determine if pause
> configuration is supported
> 70814e819c11 net: ethernet: Add helper for set_pauseparam for Asym =
Pause
> af8d9bb2f2f4 net: ethernet: Add helper for MACs which support asym =
pause
> 04b7d41d8046 net: ethernet: Fix up drivers masking pause support
> 58056c1e1b0e net: ethernet: Use phy_set_max_speed() to limit =
advertised speed
>=20
> Most of the changes are related to PHY settings.  I suggest that you
> check the link settings, including speed, pause, asym pause, etc
> between the working kernel and the non-working kernel to see if there
> are differences in the settings.

