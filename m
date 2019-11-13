Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C31BFB0CF
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 13:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfKMMwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 07:52:10 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33234 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfKMMwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 07:52:10 -0500
Received: by mail-wr1-f68.google.com with SMTP id w9so2255804wrr.0
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 04:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nxLgiOBtFS25lrLKrP7UjBxM8OoRGxXncWGndBaclAo=;
        b=Sp90kMoQrFSjnUNpmLBhmrGWzBN3f8+9G5mOMOzS4H/rJpc7cof+yfIZilRPXPX2rP
         kBSeBEjuuE0zaEmY9g67DyMIFmI8U8sGutBRIMv7gYYqwtNGFH07pN0zNnVlD0ZU+uC1
         9VLAjJebCDcWfz1wcwKmVXlPu1i7vc6I1uA2qPy9/xuT2US8uttlfz32evtdpDexTcaA
         GM2+f2XfKbfmSRvw9/OU+r6O8DHY8dragvQqM/2D6dBUg1Df60/ri61IQdK1BcLopuh2
         V64jBE8cGDJrKBvc1C+IqtRPfWFaXV/tW2M+tOO+TPufJh325Y0FT9EeB4pSuMv2SLOs
         6p2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nxLgiOBtFS25lrLKrP7UjBxM8OoRGxXncWGndBaclAo=;
        b=SFezxB8uEcjnkf0tHksm8o/AfQA/zskhIewoUfQCrQvG122GWmIjxF17FT0dajVCWv
         OU6nUEVUlhq1sGlmxnLf0NFeZ4zI4TeFThBhhfgIiOyRz4m9ScEp4t/oGwQw1h0P4acf
         sUR6y60p1lmn5YcfC6Q4y4epLf3oyypdAH4RMCM2J5Or7iUb5IMYzYGotTUfY4TDd6rQ
         zbIhle3h8ldKwwbL04MOvfrfHt/A++i5MlnYCMcIRN1EPawFVyEBrHMcAlhYg2yvse9u
         MKnhOBQ0AO3fPSeYxGBo0ZLwUeZPzPzIZTgUqDhveubt8LqgR2nHTVGmc2Ssgt2sBr6c
         r90Q==
X-Gm-Message-State: APjAAAUAw+MpOG4drXWw98pysmH5vX6C0x4Np4m9UIrVUC1YQvfqdxR2
        rmEE2epn0UjVqm/gbUGbSKk45QimEBA=
X-Google-Smtp-Source: APXvYqy+fJaY2UA/e+3tTkoEMLRY49nkBUm3JBMQ1n/ZRq2ojNBtumW7PwXd/0VvBAGKMYSCHPqGZw==
X-Received: by 2002:adf:9c81:: with SMTP id d1mr2609047wre.144.1573649525909;
        Wed, 13 Nov 2019 04:52:05 -0800 (PST)
Received: from mail.hipco.ch ([185.243.164.39])
        by smtp.gmail.com with ESMTPSA id y16sm2694211wro.25.2019.11.13.04.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 04:52:05 -0800 (PST)
X-Virus-Scanned: HIPCO Annihilation Daemon
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (HIPCO Message Framework v1091)
Subject: Re: Gentoo Linux 5.x - Tigon3
From:   Rudolf Spring <rudolf.spring@gmail.com>
In-Reply-To: <E3ACAA7C-97EF-4EC0-B306-72AE3AAF18C5@gmail.com>
Date:   Wed, 13 Nov 2019 12:52:00 +0000
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7F804C96-2567-4D97-87CB-D86A2E630126@gmail.com>
References: <1923F6C8-A3CC-4904-B2E7-176BDB52AF1B@gmail.com>
 <CACKFLikbp+sTxFBNEnUYFK2oAqeYm58uULE=AXfCp2Afg3x4ew@mail.gmail.com>
 <A1527477-EC6E-4B64-880F-B014E8CFCB9D@gmail.com>
 <CAMet4B7vi6yYu2HZd1Pj7rhtxme8FmT4wbXTjQOnQEqJp0Z_3w@mail.gmail.com>
 <5AC684B1-79CA-41EB-9553-FFBFD7284085@gmail.com>
 <CACE64B8-91DE-4F25-B2F7-2C86526986FD@gmail.com>
 <CAMet4B7npXtDd4U7HOKFN74hwpcAYmyq_LH3N_jtcyxtm43JNg@mail.gmail.com>
 <CAMet4B6csj+6umj+h7mdPfz+rnLrOFYe6RBhVb+-ykiAwjxJUg@mail.gmail.com>
 <7C0AE73E-DB62-45D1-B358-3CC47D0EB6B0@gmail.com>
 <3FA0ADFD-6F62-43E4-9119-64F7AC1BCD27@gmail.com>
 <E3ACAA7C-97EF-4EC0-B306-72AE3AAF18C5@gmail.com>
To:     Siva Reddy Kallam <siva.kallam@broadcom.com>
X-Mailer: HIPCO Mail (2.1091)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The problem is annoying. Any suggestions.

This happens if I download a 5GB iso file and surf the internet =
simultaneously. I think I will go back to 4.19. =20

[140077.602708] tg3 0000:01:00.0 eth0: Link is down
[140077.886946] br0: port 1(eth0) entered disabled state
[140081.391091] tg3 0000:01:00.0 eth0: Link is up at 1000 Mbps, full =
duplex
[140081.391095] tg3 0000:01:00.0 eth0: Flow control is on for TX and on =
for RX
[140081.391108] tg3 0000:01:00.0 eth0: EEE is enabled
[140081.391132] br0: port 1(eth0) entered blocking state
[140081.391134] br0: port 1(eth0) entered forwarding state
[140617.773819] tg3 0000:01:00.0 eth0: Link is down
[140618.059022] br0: port 1(eth0) entered disabled state
[140621.542857] tg3 0000:01:00.0 eth0: Link is up at 1000 Mbps, full =
duplex
[140621.542859] tg3 0000:01:00.0 eth0: Flow control is on for TX and on =
for RX
[140621.542860] tg3 0000:01:00.0 eth0: EEE is enabled
[140621.542872] br0: port 1(eth0) entered blocking state
[140621.542874] br0: port 1(eth0) entered forwarding state
[140688.432489] tg3 0000:01:00.0 eth0: Link is down
[140688.717079] br0: port 1(eth0) entered disabled state
[140692.181432] tg3 0000:01:00.0 eth0: Link is up at 1000 Mbps, full =
duplex
[140692.181434] tg3 0000:01:00.0 eth0: Flow control is on for TX and on =
for RX
[140692.181435] tg3 0000:01:00.0 eth0: EEE is enabled
[140692.181447] br0: port 1(eth0) entered blocking state
[140692.181449] br0: port 1(eth0) entered forwarding state
[141381.695473] tg3 0000:01:00.0 eth0: Link is down
[141381.979806] br0: port 1(eth0) entered disabled state
[141385.484010] tg3 0000:01:00.0 eth0: Link is up at 1000 Mbps, full =
duplex
[141385.484012] tg3 0000:01:00.0 eth0: Flow control is on for TX and on =
for RX
[141385.484013] tg3 0000:01:00.0 eth0: EEE is enabled
[141385.484030] br0: port 1(eth0) entered blocking state
[141385.484032] br0: port 1(eth0) entered forwarding state
[141948.494116] tg3 0000:01:00.0 eth0: Link is down
[141948.779708] br0: port 1(eth0) entered disabled state
[141952.243529] tg3 0000:01:00.0 eth0: Link is up at 1000 Mbps, full =
duplex
[141952.243536] tg3 0000:01:00.0 eth0: Flow control is on for TX and on =
for RX
[141952.243539] tg3 0000:01:00.0 eth0: EEE is enabled
[141952.243573] br0: port 1(eth0) entered blocking state
[141952.243576] br0: port 1(eth0) entered forwarding state


> On 11 Nov 2019, at 13:44, Rudolf Spring <rudolf.spring@gmail.com> =
wrote:
>=20
> Problem remains. Workaround not successful.
>=20
> tx_mac_errors: 19
>=20
> eth0: flags=3D4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9000
>        ether a8:20:66:28:e6:95  txqueuelen 1000  (Ethernet)
>        RX packets 450085  bytes 287538677 (274.2 MiB)
>        RX errors 0  dropped 0  overruns 0  frame 0
>        TX packets 381863  bytes 444155170 (423.5 MiB)
>        TX errors 19  dropped 0 overruns 0  carrier 0  collisions 0
>        device interrupt 16 =20
>=20
>=20
> [ 9257.566343] tg3 0000:01:00.0 eth0: Link is down
> [ 9257.849823] br0: port 1(eth0) entered disabled state
> [ 9261.358018] tg3 0000:01:00.0 eth0: Link is up at 1000 Mbps, full =
duplex
> [ 9261.358022] tg3 0000:01:00.0 eth0: Flow control is on for TX and on =
for RX
> [ 9261.358025] tg3 0000:01:00.0 eth0: EEE is enabled
> [ 9261.358064] br0: port 1(eth0) entered blocking state
> [ 9261.358066] br0: port 1(eth0) entered forwarding state
>=20
>> On 11 Nov 2019, at 08:15, Rudolf Spring <rudolf.spring@gmail.com> =
wrote:
>>=20
>> I found a workaround. Changing the mac of br0 to the mac of the tg3 =
and so far no more tx mac errors. I=E2=80=99m not sure but its probably =
a bridge and not a tg3 problem. With kernel < 5.0 this was not =
necessary.
>>=20
>>> On 31 Oct 2019, at 19:42, Rudolf Spring <rudolf.spring@gmail.com> =
wrote:
>>>=20
>>> I=E2=80=99m using it in bridged mode with wlan adapters and hostapd. =
The problem only happens if I access over eth0 not over wlan0 or wlan1. =
STP is not the problem. Same config with 4.19 has no problems only after =
5.0.
>>>=20
>>> driver: tg3
>>> version: 3.137
>>> firmware-version: 57766a-v1.13
>>> expansion-rom-version:=20
>>> bus-info: 0000:01:00.0
>>> supports-statistics: yes
>>> supports-test: yes
>>> supports-eeprom-access: yes
>>> supports-register-dump: yes
>>> supports-priv-flags: no
>>>=20
>>>> On 31 Oct 2019, at 11:49, Siva Reddy Kallam =
<siva.kallam@broadcom.com> wrote:
>>>>=20
>>>> Tried reproducing local with 5.4.0-rc3 kernel and I couldn't =
observe the issue.
>>>> I used the internet for almost 15-20 mins and no MAC errors =
observed.
>>>> Can you please provide ethtool -i output? I will use the same f/w
>>>> version and try.
>>>>=20
>>>> On Fri, Oct 18, 2019 at 12:21 PM Siva Reddy Kallam
>>>> <siva.kallam@broadcom.com> wrote:
>>>>>=20
>>>>> On Thu, Oct 17, 2019 at 11:03 PM Rudolf Spring =
<rudolf.spring@gmail.com> wrote:
>>>>>>=20
>>>>>> Can you reproduce the error in the lab ? Same behaviour with =
Kernel 5.3.6.
>>>>>>=20
>>>>> Yes. We are trying to reproduce in our local lab.  We will update =
once
>>>>> we have reproduction.
>>>>>>=20
>>>>>> eth0: flags=3D4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9000
>>>>>>     ether a8:20:66:28:e6:95  txqueuelen 1000  (Ethernet)
>>>>>>     RX packets 13844854  bytes 2298858755 (2.1 GiB)
>>>>>>     RX errors 0  dropped 2  overruns 0  frame 0
>>>>>>     TX packets 14831625  bytes 75684684566 (70.4 GiB)
>>>>>>     TX errors 158  dropped 0 overruns 0  carrier 0  collisions 0
>>>>>>     device interrupt 16
>>>>>>=20
>>>>>>  tx_octets: 75686159197
>>>>>>  tx_collisions: 0
>>>>>>  tx_xon_sent: 0
>>>>>>  tx_xoff_sent: 0
>>>>>>  tx_flow_control: 0
>>>>>>  tx_mac_errors: 158
>>>>>>  tx_single_collisions: 0
>>>>>>  tx_mult_collisions: 0
>>>>>>  tx_deferred: 0
>>>>>>  tx_excessive_collisions: 0
>>>>>>  tx_late_collisions: 0
>>>>>>  tx_collide_2times: 0
>>>>>>  tx_collide_3times: 0
>>>>>>  tx_collide_4times: 0
>>>>>>  tx_collide_5times: 0
>>>>>>  tx_collide_6times: 0
>>>>>>  tx_collide_7times: 0
>>>>>>  tx_collide_8times: 0
>>>>>>  tx_collide_9times: 0
>>>>>>  tx_collide_10times: 0
>>>>>>  tx_collide_11times: 0
>>>>>>  tx_collide_12times: 0
>>>>>>  tx_collide_13times: 0
>>>>>>  tx_collide_14times: 0
>>>>>>  tx_collide_15times: 0
>>>>>>  tx_ucast_packets: 14400082
>>>>>>  tx_mcast_packets: 435104
>>>>>>  tx_bcast_packets: 1542
>>>>>>  tx_carrier_sense_errors: 0
>>>>>>  tx_discards: 0
>>>>>>  tx_errors: 0
>>>>>>=20
>>>>>>=20
>>>>>>> On 4 Oct 2019, at 14:53, Rudolf Spring <rudolf.spring@gmail.com> =
wrote:
>>>>>>>=20
>>>>>>> With Kernel 5.3.2. Interesting all are tx_mac_errors.
>>>>>>>=20
>>>>>>> ifconfig  eth0
>>>>>>> eth0: flags=3D4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9000
>>>>>>>    ether a8:20:66:28:e6:95  txqueuelen 1000  (Ethernet)
>>>>>>>    RX packets 1649204  bytes 775261068 (739.3 MiB)
>>>>>>>    RX errors 0  dropped 0  overruns 0  frame 0
>>>>>>>    TX packets 1144621  bytes 1241414276 (1.1 GiB)
>>>>>>>    TX errors 369  dropped 0 overruns 0  carrier 0  collisions 0
>>>>>>>    device interrupt 16
>>>>>>>=20
>>>>>>> ethtool -S eth0
>>>>>>> NIC statistics:
>>>>>>> rx_octets: 752756285
>>>>>>> rx_fragments: 0
>>>>>>> rx_ucast_packets: 1132211
>>>>>>> rx_mcast_packets: 128115
>>>>>>> rx_bcast_packets: 372162
>>>>>>> rx_fcs_errors: 0
>>>>>>> rx_align_errors: 0
>>>>>>> rx_xon_pause_rcvd: 0
>>>>>>> rx_xoff_pause_rcvd: 0
>>>>>>> rx_mac_ctrl_rcvd: 0
>>>>>>> rx_xoff_entered: 0
>>>>>>> rx_frame_too_long_errors: 0
>>>>>>> rx_jabbers: 0
>>>>>>> rx_undersize_packets: 0
>>>>>>> rx_in_length_errors: 0
>>>>>>> rx_out_length_errors: 0
>>>>>>> rx_64_or_less_octet_packets: 0
>>>>>>> rx_65_to_127_octet_packets: 0
>>>>>>> rx_128_to_255_octet_packets: 0
>>>>>>> rx_256_to_511_octet_packets: 0
>>>>>>> rx_512_to_1023_octet_packets: 0
>>>>>>> rx_1024_to_1522_octet_packets: 0
>>>>>>> rx_1523_to_2047_octet_packets: 0
>>>>>>> rx_2048_to_4095_octet_packets: 0
>>>>>>> rx_4096_to_8191_octet_packets: 0
>>>>>>> rx_8192_to_9022_octet_packets: 0
>>>>>>> tx_octets: 1236703101
>>>>>>> tx_collisions: 0
>>>>>>> tx_xon_sent: 0
>>>>>>> tx_xoff_sent: 0
>>>>>>> tx_flow_control: 0
>>>>>>> tx_mac_errors: 369
>>>>>>> tx_single_collisions: 0
>>>>>>> tx_mult_collisions: 0
>>>>>>> tx_deferred: 0
>>>>>>> tx_excessive_collisions: 0
>>>>>>> tx_late_collisions: 0
>>>>>>> tx_collide_2times: 0
>>>>>>> tx_collide_3times: 0
>>>>>>> tx_collide_4times: 0
>>>>>>> tx_collide_5times: 0
>>>>>>> tx_collide_6times: 0
>>>>>>> tx_collide_7times: 0
>>>>>>> tx_collide_8times: 0
>>>>>>> tx_collide_9times: 0
>>>>>>> tx_collide_10times: 0
>>>>>>> tx_collide_11times: 0
>>>>>>> tx_collide_12times: 0
>>>>>>> tx_collide_13times: 0
>>>>>>> tx_collide_14times: 0
>>>>>>> tx_collide_15times: 0
>>>>>>> tx_ucast_packets: 986854
>>>>>>> tx_mcast_packets: 146951
>>>>>>> tx_bcast_packets: 1117
>>>>>>> tx_carrier_sense_errors: 0
>>>>>>> tx_discards: 0
>>>>>>> tx_errors: 0
>>>>>>> dma_writeq_full: 0
>>>>>>> dma_write_prioq_full: 0
>>>>>>> rxbds_empty: 0
>>>>>>> rx_discards: 0
>>>>>>> rx_errors: 0
>>>>>>> rx_threshold_hit: 0
>>>>>>> dma_readq_full: 0
>>>>>>> dma_read_prioq_full: 0
>>>>>>> tx_comp_queue_full: 0
>>>>>>> ring_set_send_prod_index: 0
>>>>>>> ring_status_update: 0
>>>>>>> nic_irqs: 0
>>>>>>> nic_avoided_irqs: 0
>>>>>>> nic_tx_threshold_hit: 0
>>>>>>> mbuf_lwm_thresh_hit: 0
>>>>>>>=20
>>>>>>>> On 4 Oct 2019, at 12:52, Siva Reddy Kallam =
<siva.kallam@broadcom.com> wrote:
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>> On Wed, Oct 2, 2019 at 10:05 PM Rudolf Spring =
<rudolf.spring@gmail.com> wrote:
>>>>>>>> The output of dmesg and ethtool is identical between 4.19.72 =
and 5.3.2. Any suggestions ?
>>>>>>>> Can you please provide the output of "ethtool -S eth0" command?
>>>>>>>> In the mean time, I will review the register dump and also try =
to reproduce in our lab.
>>>>>>>> 0000:01:00.0: enabling device (0000 -> 0002)
>>>>>>>> [    1.140738] tg3 0000:01:00.0 eth0: Tigon3 =
[partno(BCM957766a) rev 57766001] (PCI Express) MAC address =
a8:20:66:28:e6:95
>>>>>>>> [    1.140741] tg3 0000:01:00.0 eth0: attached PHY is 57765 =
(10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
>>>>>>>> [    1.140743] tg3 0000:01:00.0 eth0: RXcsums[1] LinkChgREG[0] =
MIirq[0] ASF[0] TSOcap[1]
>>>>>>>> [    1.140744] tg3 0000:01:00.0 eth0: dma_rwctrl[00000001] =
dma_mask[64-bit]
>>>>>>>> [   10.290239] tg3 0000:01:00.0 eth0: Link is up at 1000 Mbps, =
full duplex
>>>>>>>> [   10.290241] tg3 0000:01:00.0 eth0: Flow control is on for TX =
and on for RX
>>>>>>>> [   10.290242] tg3 0000:01:00.0 eth0: EEE is enabled
>>>>>>>>=20
>>>>>>>> ethtool eth0
>>>>>>>> Settings for eth0:
>>>>>>>>    Supported ports: [ TP ]
>>>>>>>>    Supported link modes:   10baseT/Half 10baseT/Full
>>>>>>>>                            100baseT/Half 100baseT/Full
>>>>>>>>                            1000baseT/Half 1000baseT/Full
>>>>>>>>    Supported pause frame use: No
>>>>>>>>    Supports auto-negotiation: Yes
>>>>>>>>    Supported FEC modes: Not reported
>>>>>>>>    Advertised link modes:  10baseT/Half 10baseT/Full
>>>>>>>>                            100baseT/Half 100baseT/Full
>>>>>>>>                            1000baseT/Half 1000baseT/Full
>>>>>>>>    Advertised pause frame use: Symmetric
>>>>>>>>    Advertised auto-negotiation: Yes
>>>>>>>>    Advertised FEC modes: Not reported
>>>>>>>>    Link partner advertised link modes:  10baseT/Half =
10baseT/Full
>>>>>>>>                                         100baseT/Half =
100baseT/Full
>>>>>>>>                                         1000baseT/Full
>>>>>>>>    Link partner advertised pause frame use: Symmetric
>>>>>>>>    Link partner advertised auto-negotiation: Yes
>>>>>>>>    Link partner advertised FEC modes: Not reported
>>>>>>>>    Speed: 1000Mb/s
>>>>>>>>    Duplex: Full
>>>>>>>>    Port: Twisted Pair
>>>>>>>>    PHYAD: 1
>>>>>>>>    Transceiver: internal
>>>>>>>>    Auto-negotiation: on
>>>>>>>>    MDI-X: off
>>>>>>>>    Supports Wake-on: g
>>>>>>>>    Wake-on: g
>>>>>>>>    Current message level: 0x000000ff (255)
>>>>>>>>                           drv probe link timer ifdown ifup =
rx_err tx_err
>>>>>>>>    Link detected: yes
>>>>>>>>=20
>>>>>>>> ethtool -a eth0
>>>>>>>> Pause parameters for eth0:
>>>>>>>> Autonegotiate:  on
>>>>>>>> RX:             on
>>>>>>>> TX:             on
>>>>>>>> RX negotiated:  on
>>>>>>>> TX negotiated:  on
>>>>>>>>=20
>>>>>>>> ethtool -g eth0
>>>>>>>> Ring parameters for eth0:
>>>>>>>> Pre-set maximums:
>>>>>>>> RX:             511
>>>>>>>> RX Mini:        0
>>>>>>>> RX Jumbo:       255
>>>>>>>> TX:             511
>>>>>>>> Current hardware settings:
>>>>>>>> RX:             200
>>>>>>>> RX Mini:        0
>>>>>>>> RX Jumbo:       100
>>>>>>>> TX:             511
>>>>>>>>=20
>>>>>>>> ethtool -c eth0
>>>>>>>> Coalesce parameters for eth0:
>>>>>>>> Adaptive RX: off  TX: off
>>>>>>>> stats-block-usecs: 0
>>>>>>>> sample-interval: 0
>>>>>>>> pkt-rate-low: 0
>>>>>>>> pkt-rate-high: 0
>>>>>>>>=20
>>>>>>>> rx-usecs: 20
>>>>>>>> rx-frames: 5
>>>>>>>> rx-usecs-irq: 0
>>>>>>>> rx-frames-irq: 5
>>>>>>>>=20
>>>>>>>> tx-usecs: 72
>>>>>>>> tx-frames: 53
>>>>>>>> tx-usecs-irq: 0
>>>>>>>> tx-frames-irq: 5
>>>>>>>>=20
>>>>>>>> rx-usecs-low: 0
>>>>>>>> rx-frame-low: 0
>>>>>>>> tx-usecs-low: 0
>>>>>>>> tx-frame-low: 0
>>>>>>>>=20
>>>>>>>> rx-usecs-high: 0
>>>>>>>> rx-frame-high: 0
>>>>>>>> tx-usecs-high: 0
>>>>>>>> tx-frame-high: 0
>>>>>>>>=20
>>>>>>>> ethtool -k eth0
>>>>>>>> Features for eth0:
>>>>>>>> rx-checksumming: on
>>>>>>>> tx-checksumming: on
>>>>>>>>    tx-checksum-ipv4: on
>>>>>>>>    tx-checksum-ip-generic: off [fixed]
>>>>>>>>    tx-checksum-ipv6: on
>>>>>>>>    tx-checksum-fcoe-crc: off [fixed]
>>>>>>>>    tx-checksum-sctp: off [fixed]
>>>>>>>> scatter-gather: on
>>>>>>>>    tx-scatter-gather: on
>>>>>>>>    tx-scatter-gather-fraglist: off [fixed]
>>>>>>>> tcp-segmentation-offload: on
>>>>>>>>    tx-tcp-segmentation: on
>>>>>>>>    tx-tcp-ecn-segmentation: on
>>>>>>>>    tx-tcp-mangleid-segmentation: off
>>>>>>>>    tx-tcp6-segmentation: on
>>>>>>>> udp-fragmentation-offload: off
>>>>>>>> generic-segmentation-offload: on
>>>>>>>> generic-receive-offload: on
>>>>>>>> large-receive-offload: off [fixed]
>>>>>>>> rx-vlan-offload: on [fixed]
>>>>>>>> tx-vlan-offload: on [fixed]
>>>>>>>> ntuple-filters: off [fixed]
>>>>>>>> receive-hashing: off [fixed]
>>>>>>>> highdma: on
>>>>>>>> rx-vlan-filter: off [fixed]
>>>>>>>> vlan-challenged: off [fixed]
>>>>>>>> tx-lockless: off [fixed]
>>>>>>>> netns-local: off [fixed]
>>>>>>>> tx-gso-robust: off [fixed]
>>>>>>>> tx-fcoe-segmentation: off [fixed]
>>>>>>>> tx-gre-segmentation: off [fixed]
>>>>>>>> tx-gre-csum-segmentation: off [fixed]
>>>>>>>> tx-ipxip4-segmentation: off [fixed]
>>>>>>>> tx-ipxip6-segmentation: off [fixed]
>>>>>>>> tx-udp_tnl-segmentation: off [fixed]
>>>>>>>> tx-udp_tnl-csum-segmentation: off [fixed]
>>>>>>>> tx-gso-partial: off [fixed]
>>>>>>>> tx-sctp-segmentation: off [fixed]
>>>>>>>> tx-esp-segmentation: off [fixed]
>>>>>>>> tx-udp-segmentation: off [fixed]
>>>>>>>> fcoe-mtu: off [fixed]
>>>>>>>> tx-nocache-copy: off
>>>>>>>> loopback: off [fixed]
>>>>>>>> rx-fcs: off [fixed]
>>>>>>>> rx-all: off [fixed]
>>>>>>>> tx-vlan-stag-hw-insert: off [fixed]
>>>>>>>> rx-vlan-stag-hw-parse: off [fixed]
>>>>>>>> rx-vlan-stag-filter: off [fixed]
>>>>>>>> l2-fwd-offload: off [fixed]
>>>>>>>> hw-tc-offload: off [fixed]
>>>>>>>> esp-hw-offload: off [fixed]
>>>>>>>> esp-tx-csum-hw-offload: off [fixed]
>>>>>>>> rx-udp_tunnel-port-offload: off [fixed]
>>>>>>>> tls-hw-tx-offload: off [fixed]
>>>>>>>> tls-hw-rx-offload: off [fixed]
>>>>>>>> rx-gro-hw: off [fixed]
>>>>>>>> tls-hw-record: off [fixed]
>>>>>>>>=20
>>>>>>>> ethtool -n eth0
>>>>>>>> 4 RX rings available
>>>>>>>> rxclass: Cannot get RX class rule count: Operation not =
supported
>>>>>>>> RX classification rule retrieval failed
>>>>>>>>=20
>>>>>>>> ethtool -t eth0
>>>>>>>> The test result is PASS
>>>>>>>> The test extra info:
>>>>>>>> nvram test        (online)       0
>>>>>>>> link test         (online)       0
>>>>>>>> register test     (offline)      0
>>>>>>>> memory test       (offline)      0
>>>>>>>> mac loopback test (offline)      0
>>>>>>>> phy loopback test (offline)      0
>>>>>>>> ext loopback test (offline)      0
>>>>>>>> interrupt test    (offline)      0
>>>>>>>>=20
>>>>>>>> ethtool -T eth0
>>>>>>>> Time stamping parameters for eth0:
>>>>>>>> Capabilities:
>>>>>>>>    software-transmit     (SOF_TIMESTAMPING_TX_SOFTWARE)
>>>>>>>>    software-receive      (SOF_TIMESTAMPING_RX_SOFTWARE)
>>>>>>>>    software-system-clock (SOF_TIMESTAMPING_SOFTWARE)
>>>>>>>> PTP Hardware Clock: none
>>>>>>>> Hardware Transmit Timestamp Modes:
>>>>>>>>    off                   (HWTSTAMP_TX_OFF)
>>>>>>>>    on                    (HWTSTAMP_TX_ON)
>>>>>>>> Hardware Receive Filter Modes:
>>>>>>>>    none                  (HWTSTAMP_FILTER_NONE)
>>>>>>>>    ptpv1-l4-event        (HWTSTAMP_FILTER_PTP_V1_L4_EVENT)
>>>>>>>>    ptpv2-l4-event        (HWTSTAMP_FILTER_PTP_V2_L4_EVENT)
>>>>>>>>    ptpv2-l2-event        (HWTSTAMP_FILTER_PTP_V2_L2_EVENT)
>>>>>>>>=20
>>>>>>>> ethtool -l eth0
>>>>>>>> Channel parameters for eth0:
>>>>>>>> Pre-set maximums:
>>>>>>>> RX:             4
>>>>>>>> TX:             1
>>>>>>>> Other:          0
>>>>>>>> Combined:       0
>>>>>>>> Current hardware settings:
>>>>>>>> RX:             4
>>>>>>>> TX:             1
>>>>>>>> Other:          0
>>>>>>>> Combined:       0
>>>>>>>>=20
>>>>>>>> ethtool --show-eee eth0
>>>>>>>> EEE Settings for eth0:
>>>>>>>>    EEE status: enabled - active
>>>>>>>>    Tx LPI: 2047 (us)
>>>>>>>>    Supported EEE link modes:  100baseT/Full
>>>>>>>>                               1000baseT/Full
>>>>>>>>    Advertised EEE link modes:  100baseT/Full
>>>>>>>>                                1000baseT/Full
>>>>>>>>    Link partner advertised EEE link modes:  100baseT/Full
>>>>>>>>                                             1000baseT/Full
>>>>>>>>=20
>>>>>>>>> These are all the tg3 changes between 4.19 and 5.0:
>>>>>>>>>=20
>>>>>>>>> 750afb08ca71 cross-tree: phase out dma_zalloc_coherent()
>>>>>>>>> cddaf02bcb73 tg3: optionally use =
eth_platform_get_mac_address() to get
>>>>>>>>> mac address
>>>>>>>>> 3c1bcc8614db net: ethernet: Convert phydev advertize and =
supported
>>>>>>>>> from u32 to link mode
>>>>>>>>> 6fe42e228dc2 tg3: extend PTP gettime function to read system =
clock
>>>>>>>>> 310fc0513ea9 tg3: Fix fall-through annotations
>>>>>>>>> 22b7d29926b5 net: ethernet: Add helper to determine if pause
>>>>>>>>> configuration is supported
>>>>>>>>> 70814e819c11 net: ethernet: Add helper for set_pauseparam for =
Asym Pause
>>>>>>>>> af8d9bb2f2f4 net: ethernet: Add helper for MACs which support =
asym pause
>>>>>>>>> 04b7d41d8046 net: ethernet: Fix up drivers masking pause =
support
>>>>>>>>> 58056c1e1b0e net: ethernet: Use phy_set_max_speed() to limit =
advertised speed
>>>>>>>>>=20
>>>>>>>>> Most of the changes are related to PHY settings.  I suggest =
that you
>>>>>>>>> check the link settings, including speed, pause, asym pause, =
etc
>>>>>>>>> between the working kernel and the non-working kernel to see =
if there
>>>>>>>>> are differences in the settings.
>>>>>>>>=20
>>>>>>>=20
>>>>>>=20
>>>=20
>>=20
>=20

