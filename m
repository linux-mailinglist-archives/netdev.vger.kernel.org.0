Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928D34A6B1A
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244683AbiBBE61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiBBE6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 23:58:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BCCC061714;
        Tue,  1 Feb 2022 20:58:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B0C2B83004;
        Wed,  2 Feb 2022 04:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC50C004E1;
        Wed,  2 Feb 2022 04:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643777902;
        bh=3R1brSBq8s2swVV3kMHwHt7HZxFvwsGSwnLUB8YoKTk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qYPsl6kmBXicSMJRej/pS/2fURkTz2mm+tAC3SA3enCS27v0Yj+scLV7zlGMfZfxD
         QbB4FpDEvQnoWpm5JFro5DS1cE+tYzdRGCXbVNfY6h7ED8/9iZB1OsU74z9oKtMPjF
         qoAGLExZziJMB8zSCuSp3Y60vcRh9kG1j8q75s3zeQ2BUyl/zO7dy+H4q9ffRHFKv2
         ZCkMwxmyzQW+L3j0QG3Sh/NZe5VbqmK0spmcTiaNg0OD1RsGH68vM3Yt0K81J7IML+
         ENvyz35TnKgkFlj2O03s12dvc2k4GdL5DU/miCODdF9IgLZhJzf7FLRJPV95s+UjMi
         L8ydXhJozy31Q==
Date:   Tue, 1 Feb 2022 20:58:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Einon <mark.einon@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Chris Snook <chris.snook@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jon Mason <jdmason@kudzu.us>,
        Simon Horman <simon.horman@corigine.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jiri Pirko <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Rob Herring <robh@kernel.org>, l.stelmach@samsung.com,
        rafal@milecki.pl, Edwin Peer <edwin.peer@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Slark Xiao <slark_xiao@163.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Liming Sun <limings@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Gary Guo <gary@garyguo.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, intel-wired-lan@lists.osuosl.org,
        linux-hyperv@vger.kernel.org, oss-drivers@corigine.com,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH net-next] net: kbuild: Don't default net vendor configs
 to y
Message-ID: <20220201205818.2f28cfe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220202044603.tuchbk72iujdyxi4@sx1>
References: <20220131172450.4905-1-saeed@kernel.org>
        <20220131095905.08722670@hermes.local>
        <CAMuHMdU17cBzivFm9q-VwF9EG5MX75Qct=is=F2h+Kc+VddZ4g@mail.gmail.com>
        <20220131183540.6ekn3z7tudy5ocdl@sx1>
        <30ed8220-e24d-4b40-c7a6-4b09c84f9a1f@gmail.com>
        <20220131121027.4fe3e8dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7dc930c6-4ffc-0dd0-8385-d7956e7d16ff@gmail.com>
        <20220131151315.4ec5f2d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <dd1497ca-b1da-311a-e5fc-7c7265eb3ddf@gmail.com>
        <20220202044603.tuchbk72iujdyxi4@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Feb 2022 20:46:03 -0800 Saeed Mahameed wrote:
> I am getting mixed messages here, on one hand we know that this patch
> might break some old or def configs, but on the other hand people claim
> that they have to manually fixup their own configs every time 
> "something in configs" changes and they are fine with that. 
> 
> Obviously I belong to the 2nd camp, hence this patch..
> 
> I can sum it up with "it's fine to controllably break *some* .configs for 
> the greater good" .. that's my .2cent.

I think we agree that we don't care about oldconfigs IOW someone's
random config.

But we do care about defconfigs in the tree, if those indeed include
ethernet drivers which would get masked out by vendor=n - they need
fixin':

$ find arch/ | grep defconfig
arch/x86/configs/i386_defconfig
arch/x86/configs/x86_64_defconfig
arch/ia64/configs/generic_defconfig
arch/ia64/configs/gensparse_defconfig
...

First one from the top:

$ make O=build_tmp/ i386_defconfig
$ $EDITOR drivers/net/ethernet/intel/Kconfig
$ git diff
diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 3facb55b7161..b9fdf2a835b0 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_INTEL
        bool "Intel devices"
-       default y
        help
          If you have a network (Ethernet) card belonging to this class, say Y.
 
$ make O=build_tmp/ i386_defconfig
$ diff -urpb build_tmp/.config.old build_tmp/.config
--- build_tmp/.config.old	2022-02-01 20:55:37.087373905 -0800
+++ build_tmp/.config	2022-02-01 20:56:32.126044628 -0800
@@ -1784,22 +1784,7 @@ CONFIG_NET_VENDOR_GOOGLE=y
 # CONFIG_GVE is not set
 CONFIG_NET_VENDOR_HUAWEI=y
 # CONFIG_HINIC is not set
-CONFIG_NET_VENDOR_I825XX=y
-CONFIG_NET_VENDOR_INTEL=y
-CONFIG_E100=y
-CONFIG_E1000=y
-CONFIG_E1000E=y
-CONFIG_E1000E_HWTS=y
-# CONFIG_IGB is not set
-# CONFIG_IGBVF is not set
-# CONFIG_IXGB is not set
-# CONFIG_IXGBE is not set
-# CONFIG_IXGBEVF is not set
-# CONFIG_I40E is not set
-# CONFIG_I40EVF is not set
-# CONFIG_ICE is not set
-# CONFIG_FM10K is not set
-# CONFIG_IGC is not set
+# CONFIG_NET_VENDOR_INTEL is not set
 CONFIG_NET_VENDOR_MICROSOFT=y
 # CONFIG_JME is not set
 CONFIG_NET_VENDOR_LITEX=y
