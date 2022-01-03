Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D18482DF5
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 06:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiACFFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 00:05:02 -0500
Received: from sonic309-22.consmr.mail.ne1.yahoo.com ([66.163.184.148]:42696
        "EHLO sonic309-22.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229638AbiACFFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 00:05:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1641186301; bh=yBDBE0PZweAkDrHcHiTGpa/UvqNIVeFYn63WXzwZdms=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=A4c9U3URMTQqdoad06nVvVrj9A13U69y2Gw7IVhqde5+9myycPrJmUqmqwxAO9pJ3JLBQFtQvNifSCJNpSesjNhChk7I9FlEEe2xR7ReR2iQsO/bbNhFcPzsf4JkEdwqSO/sUgD0IUrty+RE3A0TnUV512pctvmd4FkUeN4ukAxsCkcIWN/J6jwSRHdm+Ng4TssZ0VZGNd6pneiuN+3KdPPrioNj4HwV3BO3TCXHFOvaw8ZOlJDFAl1ssuQFYayjztZ+iZFpil0daPN7SH8+qo9WbYbTUfFNzlig/OvFfCLufmqMTigQRpsEY1aWdS+IOH6J4RW0z75plhqW4V1baA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1641186301; bh=pKJFiU57z6Xj1JXVQtJay2V5q/iTflziEJRGxvPZsGg=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=W1qp0tg+apCOCjXoMN11y2fnRzzXMB8jedJkZ7pMHvKEQ1fYsxyk0e/Dzd2Cqqpg3k3xkinlKMKQWVEql9CKc8YYvlMZTMM6/zASyd076Rl2fJ40bYS8I1xHoDNfSYfZFQYmuRo3uwOPWmUsz/sZoDvePdCcbecpJK/Np85dzSdjGSDFQyZjnni6+cF55jdxBy7k8EaJg2dTuHa1NWIjjF6SaqRoohtRm/Quh82ivQ4JDDOwijAn9B1HydHjNZXrsrlLB3yZXp9hAsiUWBh9Pps8IA+Ba4MEgO4absni8gGXcou1Ma7nMZAoO9U7BcsFYnNX0Gi/E6vdOwemJpo8IA==
X-YMail-OSG: 9jGWoYMVM1kRwrEA.igP5sBldOMm2w83EreTMib9w1smGwVWUFMMGNRAJ37UgGR
 pbXBzny7y2soZw58aBpc5X1HCDyOfJGaNpLW1hJli2VDSD5sN6YD5qD6EJzM9eUMlG9oci58no7d
 vQI0hcis.SLfekmBOoFgUcsqCk4heLEJB7bkD1GLWCVQRuQmSeVsybcgJIsP96VAcQXQjAS6Fnfn
 u41aFOYZ5UiOSvwRTNHTD1retNpXjA3.RrVeVSIbQC6BQmiAuyINA7tFl6jNOmdsoCepEPHM.WbW
 KkwOsAw5l2l4f5QjWwcMmUp64sLZ44Rs1sA4V7pph47K56Rn8gAHk_5T3VnoxwbkZRoaoqfdlzfi
 T9F73doldsiIuavPhOl90s7iNut.k_.1XZWsuZhEEjEPhtxqJMS7yYcIA86zbsaI.hR6e53oSco4
 W5ff2h3nATnQWODN91SQe5xu6k2nDOcUBLwFg8bRyOHgzjMmrqFc0J18R7DedJjet6aEIHWzphyw
 5fKveKv.sREqccWdrMhYeWf0mzQskfL_GRLOBdYZNsdVAGnQA7DbMEsqXLjkUzg2PmlAPcQP2p6L
 lwtsZuHAgwN9WK9zRurt46c3Q9z2QW4mcNQHP3nKx6SUlQ8UkkPV1pIXCLtFWPFgQw.BDvKCFbk2
 x4HwA0czauii9BXzeeLYJkBmry4K663QdvGwSLw5FJiWvTLMV4arcw0VmGNIuVHGnjZFq8HJk9Kp
 RDeilDQ_tDdHSfx4FG4tGhkWgmwftOfKu1CEvLfpdRS46wJ1ZEfRzMoRL0_LZS.WlVT3BSt89gDY
 GyKt1L4a7Q5qHmbKwUvvnuNfFswCtQvr_JGXt_vSxH.1lYscxz2k4VWK.C5W7Plfj_SgMhTPRcRQ
 5IWJK3R0BbYn7zHL.FK88JTycnCwT0rjuyCliY9g9ELCLV54ZgMtyKg6WHrZQjXUiKiyS_lxYbo.
 gyGNpzaf2zN5jLQTdL0x02RN2wMMaoSSpaU_4Rc8mAOlwtnSExGtc.sbcMnBYeQCoYa6uxByCT3C
 iaUjVXMSqRg__s7beEI3b90SY6Th.NjVQyppkivRUcZAq7JISnlgXwIDRJ92LJJGOmdo_tXmAZ3L
 hO4cSq5EoFM.sVmMzj2zOUtOJKVCn984VzvddsBWC6ugNIed5W43IVUc5_0b9as8GljnSu8zB_fx
 cvSvTny8mZO5VOjB.oLSF_Ef5y5vSUz730GhRtypeVOytm1YOTf4fCx3ahmGH.3uB11uyMY7MEXH
 d2cbSSuiQRf1CQHw73iw.p.biATLHLBpmGEdxr.YsB0nzu2sGTpHW6_oD7fCJMSAJrMleJArWIP3
 bwxnICLtTQlBNCDBB9nEi8lGrMSgETlVID6hqN8s2x3ffAWhQZNtbXSQce_rgefiXQUNa4xKhth4
 f.bmceezPcfEJ1iCI5dLOZbjgciaYvmBdNYkS_70w91Y0L2a5T8BpjWO.fCgCTwCcjHYGdIZkNtL
 xOGU2CuzOt7PnwoQkDw4qafYTGvgAgCMg0Ak2LBIooz7pNSJNAKCLfups3Cj.Jn143QPYt8__LZN
 DP0mayV41IMsBaVN8onPWy6vNR0Vip37XVXhJuO3Cmz5sIUIHpltpT3Jm.T1roqvUJUzILw_DQEb
 GZCI4z8BHgPV8Gm8A1LpLswcKm5TTkm8tU0y3vbwFV4st1QwZJbAcHi47xmejiao3XtH48yrtspW
 2IvcKqxbiP6PEyica2GSzM40I8tLhHYLwnL.CvXHtBOofaanjuNrfb2L4IVYCiHYeQjBL_Z_DDkO
 TnWiqkCUgGqEG7ye1jwc4rmBSbmiC3jkgT4JsefEpSt6GTZSahmcHKvztWWCv0g9nKmJKSO6YfLA
 NY_LSvghfkn7AoiyBY6qBoaa8ZrG9WDXl25R_8dJEqYHP4x7ppT8HbSwjA0IkVtUO7FKzt.QiHC2
 uxfvVKdFLsQJ4g6OSYSTQzYRzpMqqHBWK3i._vOtAwxZV2muyXTkIGVhe3._hBM2YkkOT4xhwW_X
 kMhUASbnww4_La1KB.htWGZMmglscoA0avg7rtL5hCX.jOw3HqDtegm.ocKhl0A4mDeRsCMcIb5c
 IoVo_CX6IZBQ.9CQtI6iepvouOvVMR5XebyepaDSQnsoQido1HfBUirm8LkEZYTVVz3Cjp8rs8zZ
 IK3y.TIdTTUzBUn_nkC5vEnBRO1uor9vrMQlehA74FgXWv95uQgailIjxrccEfl1ZRgpOKWnDYos
 JtP5.mA0BFFurYu6IwL3xIgdsmy.clclrAYd5_.7pfF.czy9SQSfeOWNHVy0zi8hIA7BkYaX6L_b
 JeUnIMA--
X-Sonic-MF: <xiangyu.chen@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Mon, 3 Jan 2022 05:05:01 +0000
Received: by kubenode512.mail-prod1.omega.sg3.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID ee53bc8633c4367d8e7d99fb5970b2f8;
          Mon, 03 Jan 2022 05:04:56 +0000 (UTC)
From:   Xiangyu Chen <xiangyu.chen@aol.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     xiangyu.chen@msn.com, Xiangyu Chen <xiangyu.chen@aol.com>
Subject: [PATCH 2/2] dt-bindings: net: ti:add support slave interface using internal clock in dual rmii emac mode
Date:   Mon,  3 Jan 2022 13:02:02 +0800
Message-Id: <20220103050200.6382-1-xiangyu.chen@aol.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20220103050200.6382-1-xiangyu.chen.ref@aol.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the second patch of as subject said topic. It contains dts
 document modification.


Those patches regarding to add a way to setup/config the TI-AM335x series
Soc for 2 ways phy clock mode under RMII mode.

The basic scenario is when we have 2 PHYs connected to AM335x in RMII
mode, either we set the both of phy in external clock mode or we set the phy in internal
clock mode.

As TI suggetsion, when under RMII mode, the clock should use an external
osc due to AM335x cannot generate a low-jitter stable 50MHz clock, this
might cause some PHY cannot work correctly. But in some case (e.g. our
design, no impact on using low speed PHY for debugging/management).
There is no impact on some model phys.

So I think we should provide a way to allow user can set/config the PHY
chose clock mode in dual RMII emac mode.

Tests:

Below is my testing environment:

am335x SOC --RMII 1--> PHY1 (eth0) which using internal clock
          |-RMII 2--> PHY2 (eth1) which using external clock

Booting log:
Booting log:

[    1.843108] cpsw 4a100000.ethernet: Detected MACID = 78:04:73:37:68:6c
[    1.850924] cpsw 4a100000.ethernet: initialized cpsw ale version 1.4
[    1.857842] cpsw 4a100000.ethernet: ALE Table size 1024
[    1.863449] cpsw 4a100000.ethernet: cpts: overflow check period 500 (jiffies)
[    1.874620] cpsw 4a100000.ethernet: cpsw: Detected MACID = 78:04:73:37:68:6e
[    4.017695] net eth0: initializing cpsw version 1.12 (0)
[    5.207867] cpsw 4a100000.ethernet eth0: Link is Up - 10Mbps/Full - flow control off
[  29.747480] net eth1: initializing cpsw version 1.12 (0)
[  30.806444] cpsw 4a100000.ethernet eth1: Link is Up - 100Mbps/Full - flow control off

# ifconfig

eth0      Link encap:Ethernet  HWaddr 00:FA:F9:00:61:88
          inet addr:192.168.0.20  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::2fa:f9ff:fe00:6188/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:20 errors:0 dropped:0 overruns:0 frame:0
          TX packets:35 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1394 (1.3 KiB)  TX bytes:3272 (3.1 KiB)
          Interrupt:50

eth1      Link encap:Ethernet  HWaddr 78:04:73:37:68:6E
          inet addr:10.176.28.165  Bcast:10.176.29.255  Mask:255.255.254.0
          inet6 addr: fe80::7a04:73ff:fe37:686e/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:1809 errors:0 dropped:0 overruns:0 frame:0
          TX packets:99 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:123057 (120.1 KiB)  TX bytes:9012 (8.8 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:44 errors:0 dropped:0 overruns:0 frame:0
          TX packets:44 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:4872 (4.7 KiB)  TX bytes:4872 (4.7 KiB)

PHY1 (eth0, using internal clock from AM335x) ping:
#ping 192.168.0.20

PING 192.168.0.20 (192.168.0.20): 56 data bytes
64 bytes from 192.168.0.20: seq=0 ttl=64 time=1.340 ms

^C

--- 192.168.0.20 ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 1.340/1.340/1.340 ms

PHY2 (eth1, using external clock to AM335x) ping:
# ping 10.176.28.1

PING 10.176.28.1 (10.176.28.1): 56 data bytes
64 bytes from 10.176.28.1: seq=1 ttl=254 time=1.967 ms
64 bytes from 10.176.28.1: seq=2 ttl=254 time=1.652 ms
64 bytes from 10.176.28.1: seq=3 ttl=254 time=1.688 ms

^C

--- 10.176.28.1 ping statistics ---


Both phy working normally.


Thanks and Best regrads,

Xiangyu

From df2b0c2f7723deedcf4195e48e851de16b400775 Mon Sep 17 00:00:00 2001
From: Xiangyu Chen <xiangyu.chen@aol.com>
Date: Fri, 31 Dec 2021 10:38:03 +0800
Subject: [PATCH 2/2] dt-bindings: net: ti:add support slave interface using
 internal clock in dual rmii emac mode

The am335x support dual emac in rmii mode, the rmii clock can be
provided by external osc or internal soc by ref_clk pin.
When rmii-clock-ext has been set in device tree, both emac has been
set to external clock mode, otherwise both emac has been set to internal
clock mode.

In some case, one slave can be used external clock, another slave can be
used internal clock.

This commit to support define a method to tell driver which slave phy
use internal clock when the "rmii-clock-ext" has been set.

Signed-off-by: Xiangyu Chen <xiangyu.chen@aol.com>
---
 .../devicetree/bindings/net/cpsw-phy-sel.txt        | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/cpsw-phy-sel.txt b/Documentation/devicetree/bindings/net/cpsw-phy-sel.txt
index 5d76f991c..d3b91824d 100644
--- a/Documentation/devicetree/bindings/net/cpsw-phy-sel.txt
+++ b/Documentation/devicetree/bindings/net/cpsw-phy-sel.txt
@@ -13,6 +13,10 @@ Optional properties:
 -rmii-clock-ext		: If present, the driver will configure the RMII
 			  interface to external clock usage
 
+-ignore-slave		: If dual rmii emac enabled and rmii-clock-ext present,
+			  this value will tell driver which slave want to use
+			  internal clock instead of external clock
+
 Examples:
 
 	phy_sel: cpsw-phy-sel@44e10650 {
@@ -28,3 +32,12 @@ Examples:
 		reg-names = "gmii-sel";
 		rmii-clock-ext;
 	};
+
+(or)
+	phy_sel: cpsw-phy-sel@44e10650 {
+		compatible = "ti,am3352-cpsw-phy-sel";
+		reg= <0x44e10650 0x4>;
+		reg-names = "gmii-sel";
+		rmii-clock-ext;
+		ignore-slave = <0>;
+	};
-- 
2.25.1

