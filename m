Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1410482DED
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 05:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiACE7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 23:59:41 -0500
Received: from sonic303-20.consmr.mail.ne1.yahoo.com ([66.163.188.146]:46680
        "EHLO sonic303-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229677AbiACE7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 23:59:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1641185980; bh=0054i2junWY2++SFYAJ7cUpehjxvbT0yTNyekkqVXSU=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=qKy22Ng/z0vHzFLEOg2QlLa6u6RMwJDJMN+dEVPAtKYMevPcIhsZ+JAZcSolR2N4FpLmMPKJ7Vca4/tKsOCeextYWKWlAaSUclXDUXjyZ99Y3BRCH4LvLf+lbJfP3zgA1DGezxcYkXb6J4fNxOLxqWDz+an/AgqKDx5WkQv5vD4AET0cxTTJf4l1YB9Cfy1S/WHhDSMTiW1MM8Gtyud9hZg6YISsk1GuhljFU2zH1uKfjYUHwIaJExZ6R2ugwpOziIH+QouH0gvJ77mlp0qbrvk4eiPb4BUS3sInyzuc2NDI1GbUaqiCNOBeAlKtrIpwUHWe9L/oFGJSJoctVyHCmA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1641185980; bh=On6QlG9gsBxx5cKMkjmUbQua7UGe6aVQ4EzeXuoQKWK=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=LZXijv23jXJyWABm91kAY7YjYfjlhjR8zQpz2v5HNTwJP4S5Nd4ySRncsDKBwN32YIPUFs0ko+nV4AjUkiP/9C3bSO++/32HkmA9SAaFirn1pjqQtsO5WPy17RsTivdOHzV7kS+a8CKrAUJ01nZOC2Xn/somIDfPWl0PRU1n1FUgBUCXvoHrMcqeWqrfRHdzVhTZWgz/He8tTahGHXEU7ttcfMhFQf5i4voAQmeNBuBxwoxO6Ln8STTOne/nf4nGSLFKRCQ+12DJRLDiNsr7WG8anAz+gRuISTjKAtLjqWNKYowQIl/GyzQbh+HI+3wDsBzoDdkiF8O5Hu4yOdwDVQ==
X-YMail-OSG: NHEl.i4VM1k_V_MGuhvwLJ0.RpCXIPnt1E.FZ3d5FjeKal3NcfEC7vmQKHq_Lsf
 9LhaznDugzQM_l56Hu8ZsWdwlomwEhHmSXSDbvsWe9tgDI10jn85OVxqevhDquwr4c4TWLKHPZRG
 9KFkLZlYhWn4JpkzeAmeJC5mRce9ZSZm0RgO9Sna_QDVxfnMa6eVMSki8RYUn0_Y8e2Mp8_DaBMy
 MP94M4hRgVkNNR5ku8B3zE53xKycFCZssiRNpxNOF.k83RyRSOiZ7QR0bFru8dpNvWMCLkbTIvQM
 hp.bqSrGnEq1NjMuWYs4AnKKDdEpNW6xjdH34wx8z_40Ux8qJHHi_O.B5W6w.vHzzEYl3NVpeHMx
 _M0RWudSH3lcn2MIvqMV8PLmKpzIM54QB3yeoZiL7IpPuZShU4vU_zlbv5tFmmjNEU5cMPsN.rEY
 jjyVCPR6hJgErYiXFSBW8F_IXCiMlt7SgNkQtmNcpqJQywtoO72X_cvODDTolN2W5DsaLNf5hFPt
 yE58_fe1dnnikGL16R8J0nqM2Oe1fMUrwfxU9HgpR7qSAbZyky3cV6TVJfcRrj3rKshF_qSbCfiT
 tLzAROb7w9HtD8lh0_AOH79TyCqic6RY2qcPN2muoKUvDO12LOP0O5VWBe.InVs4tdJWNkvQlrot
 Wl6ApJekxE1U3Y2Er1ohy4tv5pJqmyxQdt84hHkYhEFaDmy81cvBIb7hNvVVTwXwiGfBBhYC1JMX
 Y0tNbcsRTN4w1fuYMjOw_afBZwPY43QdAX8IHHD.aufPXDE98eHRRqEiXQKzegPU_nDiTlPqRRK2
 8WtdbqyznqPSB1RBOpq8Y37Fq.L.P6IBt5ghlXqFbDz.TNlaMkcctWN4p_q1xxEH0CT92mBqE8Af
 5ZNJijwjGvEWLPgQfovc2zuXWOgcmGbsvRj6wcUDjO4nrJpnynXXvbcXsk9bJ5IOPqGuQURXsDpr
 wMHeZXj39NW6_iHTYHzHJeYcy32Hmz5XswRw5g3XpQeRij0U2kKEnn4U3ilNj_z1rfTksKrSpcBv
 WWI7IBZ2BvDg1VIDZ2AjbZSivlEsr.RD9LYeAhvwd.3vArgBWLo6fQ6RGnm2PSpqGCZjb0WB.m3K
 gNo3ew6fw0zmDvCfxdWJjT5AvNzTl7neR1.DNB0dd0r.t3VDpjJqf8Ly1dtHzjXfkfqJvqa3o7YW
 4iARArHRAVzAN3p8BnfcWSj7CpIc.VTmYtCi.B.vLbSyceum6JVb3UOQhC9hme2MKjLZJnal.Ujl
 WG1q9XqHy1L_HC7ObwcSuKX3PWeO0rjLFLFU0K2hHHackaA0HZ.jCxg5KlqbvDAX2C4iD3LFdG6E
 WjWy93XxQ2EXuF.lebc8Ru8jh7mgE0VBz0MfKNAGEPtxfe2SxK3NRle2B51JuoB9MtpB61qOv0bi
 NbyQyxJHyFIMzBgxj6bghWeotPSf.hlqMaD2nJRE0cZDAMiVW_bWOFS4iaUFy7GDzQK7luPi9P54
 MjwLgur2ity2jsV5YDUmnVpKbpyWwQSk0Eway5UCqmDw_S2nQANAD7NsjorQwvuBy9_jEvot5iHZ
 R2CS1ET9P8kJAsUlyJoMu52BJQXrxFaCwO1FFnDsAn70CyxEQRu2ceOYtIyC0Q29Grk_Tn5pLQVy
 v7kwcLF6BF94azSqCQJPiwo1MD6oESxVjCcMlBEjRiXkRXACWbqKNh__CVQ9Gz1a_s5mielbvRRi
 yg38vQm4Lm1F0FpFpKPMfn4XeS4nSArE9Uz0E.PBTic4To7cVGqf.l.ggAIkJ8ay09uB5jSJuCht
 nbyl2jYGrG7yovqgpGk8P66lqawe.UtcdaKrGl5v5m7KQczNHyTZwpQFCNfDFYppafJy7rGARbRo
 8pWcI3Trx1Y93coR9xkNkVOrJg8p8_YsMT4MMXjFlFAGBNucaGRi6cfbJRVdl3wAPb2yWg9kH3q6
 lWvzAC1d.yTWdyajCAxUwazqIFVX.fycLuluJqZqZ2TVungBO0oAts_SfxdMyt8iprJOqsQYw0k.
 nyI2mJgGCjXGBwbafNrlpqZ_qLOW7xnFaMceG70jlhixFojm68Kvyv.e8HL5Z7.Ay08S8C.ykgBS
 6zIonc5eUfs7DNYfD8ByzFwiKfL65LBbEQZ_IcYOT4DPELios0epzAIXq6BgQXHGYfbmrPUszTzC
 i69VVxqi7viyKSpBD5HiJIBQ0rISmV3A9NGV7H2.lVqZ6za.33w_fW815QkJsDC_RHE_yjBq7QbO
 ljI5C28AsjkG0_RDCtJkl02bWarMwjr49XTDY1_qX4vIbzQXvGLG7ASYbTVVosgs9leT2YDTjylQ
 _
X-Sonic-MF: <xiangyu.chen@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Mon, 3 Jan 2022 04:59:40 +0000
Received: by kubenode501.mail-prod1.omega.sg3.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 0fe6a32c13286f62e3403d57a6ca9169;
          Mon, 03 Jan 2022 04:59:36 +0000 (UTC)
From:   Xiangyu Chen <xiangyu.chen@aol.com>
To:     grygorii.strashko@ti.com, davem@davemloft.net, kuba@kernel.org,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     xiangyu.chen@msn.com, Xiangyu Chen <xiangyu.chen@aol.com>
Subject: [PATCH 1/2] net: ethernet: ti: cpsw-phy-sel: add support slave interface using internal clock in dual rmii emac mode
Date:   Mon,  3 Jan 2022 12:56:17 +0800
Message-Id: <20220103045614.6266-1-xiangyu.chen@aol.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20220103045614.6266-1-xiangyu.chen.ref@aol.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Maintainer,

Firstly, happy new year.

This patch regarding to add a way to setup/config the TI-AM335x series
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
[   29.747480] net eth1: initializing cpsw version 1.12 (0)
[   30.806444] cpsw 4a100000.ethernet eth1: Link is Up - 100Mbps/Full - flow control off

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

From 6c7220aca37176df0ea46846b0f5c6e68d73aca0 Mon Sep 17 00:00:00 2001
From: Xiangyu Chen <xiangyu.chen@aol.com>
Date: Fri, 31 Dec 2021 10:28:14 +0800
Subject: [PATCH 1/2] net: ethernet: ti: cpsw-phy-sel: add support slave
 interface using internal clock in dual rmii emac mode

The am335x support dual emac in rmii mode, the rmii clock
can be provided by external osc or internal soc by ref_clk pin.
When rmii-clock-ext has been set in device tree, both emac
has been set to external clock mode, otherwise both emac has
been set to internal clock mode.

In some case, one slave can be used external clock, another
slave can be used internal clock.

This commit to support define a method to tell driver which
slave phy use internal clock when the "rmii-clock-ext" has
been set.

Signed-off-by: Xiangyu Chen <xiangyu.chen@aol.com>
---
 drivers/net/ethernet/ti/cpsw-phy-sel.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw-phy-sel.c b/drivers/net/ethernet/ti/cpsw-phy-sel.c
index e8f38e3f7..332d8e018 100644
--- a/drivers/net/ethernet/ti/cpsw-phy-sel.c
+++ b/drivers/net/ethernet/ti/cpsw-phy-sel.c
@@ -30,6 +30,7 @@
 
 struct cpsw_phy_sel_priv {
 	struct device	*dev;
+	u32		ignore_slave;
 	u32 __iomem	*gmii_sel;
 	bool		rmii_clock_external;
 	void (*cpsw_phy_sel)(struct cpsw_phy_sel_priv *priv,
@@ -78,10 +79,13 @@ static void cpsw_gmii_sel_am3352(struct cpsw_phy_sel_priv *priv,
 	mode <<= slave * 2;
 
 	if (priv->rmii_clock_external) {
-		if (slave == 0)
-			mode |= AM33XX_GMII_SEL_RMII1_IO_CLK_EN;
-		else
-			mode |= AM33XX_GMII_SEL_RMII2_IO_CLK_EN;
+		if (slave == 0) {
+			if (priv->ignore_slave != slave)
+				mode |= AM33XX_GMII_SEL_RMII1_IO_CLK_EN;
+		} else {
+			if (priv->ignore_slave != slave)
+				mode |= AM33XX_GMII_SEL_RMII2_IO_CLK_EN;
+		}
 	}
 
 	if (rgmii_id) {
@@ -221,6 +225,7 @@ static int cpsw_phy_sel_probe(struct platform_device *pdev)
 
 	priv->dev = &pdev->dev;
 	priv->cpsw_phy_sel = of_id->data;
+	priv->ignore_slave = 0xff;
 
 	priv->gmii_sel = devm_platform_ioremap_resource_byname(pdev, "gmii-sel");
 	if (IS_ERR(priv->gmii_sel))
@@ -229,6 +234,8 @@ static int cpsw_phy_sel_probe(struct platform_device *pdev)
 	if (of_find_property(pdev->dev.of_node, "rmii-clock-ext", NULL))
 		priv->rmii_clock_external = true;
 
+	of_property_read_u32(pdev->dev.of_node, "ignore-slave", &priv->ignore_slave);
+
 	dev_set_drvdata(&pdev->dev, priv);
 
 	return 0;
-- 
2.25.1

