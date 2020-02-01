Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBEC214FA8B
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 21:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgBAUqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 15:46:51 -0500
Received: from smtprelay0176.hostedemail.com ([216.40.44.176]:45940 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726469AbgBAUqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 15:46:51 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 9561A100E7B42;
        Sat,  1 Feb 2020 20:46:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:4:41:69:355:379:599:800:857:871:960:966:967:973:982:988:989:1000:1260:1263:1313:1314:1345:1359:1431:1437:1516:1518:1575:1594:1605:1730:1747:1764:1777:1792:1801:2194:2196:2197:2198:2199:2200:2201:2202:2393:2525:2553:2568:2634:2682:2685:2693:2743:2859:2894:2895:2899:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3653:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4385:4559:4605:4659:5007:6117:6119:6121:6506:6747:6748:7281:7514:7809:7875:7903:7909:7974:8599:8957:9025:9038:9388:10004:10049:10394:10848:11035:11232:11256:11257:11604:11657:11658:11914:12043:12050:12291:12297:12555:12683:12726:12737:12740:12895:13439:13846:14096:14659:21060:21080:21221:21433:21451:21611:21627:21691:21740:21773:21774:21789:21990:30054:30055:30056:30060:30064:30065:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,Domai
X-HE-Tag: loss76_ee2ba6d545d
X-Filterd-Recvd-Size: 18558
Received: from XPS-9350 (unknown [172.58.95.93])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Sat,  1 Feb 2020 20:46:46 +0000 (UTC)
Message-ID: <68504e9043cbe71437460241a1814529ff2a8be4.camel@perches.com>
Subject: Re: [PATCH] MAINTAINERS: correct entries for ISDN/mISDN section
From:   Joe Perches <joe@perches.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Karsten Keil <isdn@linux-pingi.de>, Arnd Bergmann <arnd@arndb.de>,
        isdn4linux@listserv.isdn4linux.de, Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Sat, 01 Feb 2020 12:45:08 -0800
In-Reply-To: <CAKXUXMyToKuJf_kGXWjP1pu33XbiMD4kpBcqUhJu==-OBQ8TQQ@mail.gmail.com>
References: <20200201124301.21148-1-lukas.bulwahn@gmail.com>
         <08d88848280f93c171e4003027644a35740a8e8e.camel@perches.com>
         <CAKXUXMyToKuJf_kGXWjP1pu33XbiMD4kpBcqUhJu==-OBQ8TQQ@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-yBGuuoEgBc28KLhikCcE"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-yBGuuoEgBc28KLhikCcE
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit

On Sat, 2020-02-01 at 20:15 +0100, Lukas Bulwahn wrote:
> On Sat, Feb 1, 2020 at 7:43 PM Joe Perches <joe@perches.com> wrote:
> > Perhaps this is a defect in the small script as
> > get_maintainer does already show the directory and
> > files as being maintained.
> > 
> > ie: get_maintainer.pl does this:
> > 
> >                 ##if pattern is a directory and it lacks a trailing slash, add one
> >                 if ((-d $value)) {
> >                     $value =~ s@([^/])$@$1/@;
> >                 }
> > 
> 
> True. My script did not implement that logic; I will add that to my
> script as well.
> Fortunately, that is not the major case of issues I have found and
> they might need some improvements.

You might also try ./scripts/get_maintainer.pl --self-test

And here's an attached script to update any missing
MAINTAINER [FX]: directory slashes and what it produces
against today's -next.
--
 MAINTAINERS | 110 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 55 insertions(+), 55 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6b32153b..6430ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -375,7 +375,7 @@ M:	Sudeep Holla <sudeep.holla@arm.com>
 L:	linux-acpi@vger.kernel.org
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-F:	drivers/acpi/arm64
+F:	drivers/acpi/arm64/
 
 ACPI I2C MULTI INSTANTIATE DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
@@ -1136,7 +1136,7 @@ L:	devel@driverdev.osuosl.org
 L:	dri-devel@lists.freedesktop.org
 L:	linaro-mm-sig@lists.linaro.org (moderated for non-subscribers)
 S:	Supported
-F:	drivers/staging/android/ion
+F:	drivers/staging/android/ion/
 F:	drivers/staging/android/uapi/ion.h
 
 AOA (Apple Onboard Audio) ALSA DRIVER
@@ -1561,10 +1561,10 @@ M:	Jesper Nilsson <jesper.nilsson@axis.com>
 M:	Lars Persson <lars.persson@axis.com>
 S:	Maintained
 L:	linux-arm-kernel@axis.com
-F:	arch/arm/mach-artpec
+F:	arch/arm/mach-artpec/
 F:	arch/arm/boot/dts/artpec6*
-F:	drivers/clk/axis
-F:	drivers/crypto/axis
+F:	drivers/clk/axis/
+F:	drivers/crypto/axis/
 F:	drivers/mmc/host/usdhi6rol0.c
 F:	drivers/pinctrl/pinctrl-artpec*
 F:	Documentation/devicetree/bindings/pinctrl/axis,artpec6-pinctrl.txt
@@ -1720,7 +1720,7 @@ F:	drivers/clk/sirf/
 F:	drivers/clocksource/timer-prima2.c
 F:	drivers/clocksource/timer-atlas7.c
 N:	[^a-z]sirf
-X:	drivers/gnss
+X:	drivers/gnss/
 
 ARM/CZ.NIC TURRIS MOX SUPPORT
 M:	Marek Behun <marek.behun@nic.cz>
@@ -2406,7 +2406,7 @@ M:	Orson Zhai <orsonzhai@gmail.com>
 M:	Baolin Wang <baolin.wang7@gmail.com>
 M:	Chunyan Zhang <zhang.lyra@gmail.com>
 S:	Maintained
-F:	arch/arm64/boot/dts/sprd
+F:	arch/arm64/boot/dts/sprd/
 N:	sprd
 N:	sc27xx
 N:	sc2731
@@ -2900,7 +2900,7 @@ M:	Bradley Grove <linuxdrivers@attotech.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.attotech.com
 S:	Supported
-F:	drivers/scsi/esas2r
+F:	drivers/scsi/esas2r/
 
 ATUSB IEEE 802.15.4 RADIO DRIVER
 M:	Stefan Schmidt <stefan@datenfreihafen.org>
@@ -3007,7 +3007,7 @@ S:	Maintained
 F:	drivers/video/backlight/
 F:	include/linux/backlight.h
 F:	include/linux/pwm_backlight.h
-F:	Documentation/devicetree/bindings/leds/backlight
+F:	Documentation/devicetree/bindings/leds/backlight/
 F:	Documentation/ABI/stable/sysfs-class-backlight
 F:	Documentation/ABI/testing/sysfs-class-backlight
 
@@ -3052,7 +3052,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	https://linuxtv.org
 S:	Supported
-F:	drivers/media/platform/sti/bdisp
+F:	drivers/media/platform/sti/bdisp/
 
 BECKHOFF CX5020 ETHERCAT MASTER DRIVER
 M:	Dariusz Marcinkiewicz <reksio@newterm.pl>
@@ -3290,7 +3290,7 @@ T:	git git://github.com/anholt/linux
 S:	Maintained
 N:	bcm2711
 N:	bcm2835
-F:	drivers/staging/vc04_services
+F:	drivers/staging/vc04_services/
 F:	Documentation/devicetree/bindings/pci/brcm,stb-pcie.yaml
 F:	drivers/pci/controller/pcie-brcmstb.c
 
@@ -3857,7 +3857,7 @@ T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 S:	Supported
 F:	Documentation/media/kapi/cec-core.rst
-F:	Documentation/media/uapi/cec
+F:	Documentation/media/uapi/cec/
 F:	drivers/media/cec/
 F:	drivers/media/rc/keymaps/rc-cec.c
 F:	include/media/cec.h
@@ -4542,14 +4542,14 @@ M:	Karen Xie <kxie@chelsio.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.chelsio.com
 S:	Supported
-F:	drivers/scsi/cxgbi/cxgb3i
+F:	drivers/scsi/cxgbi/cxgb3i/
 
 CXGB4 CRYPTO DRIVER (chcr)
 M:	Atul Gupta <atul.gupta@chelsio.com>
 L:	linux-crypto@vger.kernel.org
 W:	http://www.chelsio.com
 S:	Supported
-F:	drivers/crypto/chelsio
+F:	drivers/crypto/chelsio/
 
 CXGB4 ETHERNET DRIVER (CXGB4)
 M:	Vishal Kulkarni <vishal@chelsio.com>
@@ -4563,7 +4563,7 @@ M:	Karen Xie <kxie@chelsio.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.chelsio.com
 S:	Supported
-F:	drivers/scsi/cxgbi/cxgb4i
+F:	drivers/scsi/cxgbi/cxgb4i/
 
 CXGB4 IWARP RNIC DRIVER (IW_CXGB4)
 M:	Potnuri Bharat Teja <bharat@chelsio.com>
@@ -4804,7 +4804,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	https://linuxtv.org
 S:	Supported
-F:	drivers/media/platform/sti/delta
+F:	drivers/media/platform/sti/delta/
 
 DENALI NAND DRIVER
 M:	Masahiro Yamada <yamada.masahiro@socionext.com>
@@ -4901,7 +4901,7 @@ S:	Supported
 F:	net/core/devlink.c
 F:	include/net/devlink.h
 F:	include/uapi/linux/devlink.h
-F:	Documentation/networking/devlink
+F:	Documentation/networking/devlink/
 
 DIALOG SEMICONDUCTOR DRIVERS
 M:	Support Opensource <support.opensource@diasemi.com>
@@ -5119,7 +5119,7 @@ DOCUMENTATION/ITALIAN
 M:	Federico Vaga <federico.vaga@vaga.pv.it>
 L:	linux-doc@vger.kernel.org
 S:	Maintained
-F:	Documentation/translations/it_IT
+F:	Documentation/translations/it_IT/
 
 DOCUMENTATION SCRIPTS
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
@@ -5156,7 +5156,7 @@ DPAA2 DATAPATH I/O (DPIO) DRIVER
 M:	Roy Pledge <Roy.Pledge@nxp.com>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
-F:	drivers/soc/fsl/dpio
+F:	drivers/soc/fsl/dpio/
 
 DPAA2 ETHERNET DRIVER
 M:	Ioana Radulescu <ruxandra.radulescu@nxp.com>
@@ -5177,7 +5177,7 @@ M:	Ioana Radulescu <ruxandra.radulescu@nxp.com>
 M:	Ioana Ciornei <ioana.ciornei@nxp.com>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
-F:	drivers/staging/fsl-dpaa2/ethsw
+F:	drivers/staging/fsl-dpaa2/ethsw/
 
 DPT_I2O SCSI RAID DRIVER
 M:	Adaptec OEM Raid Solutions <aacraid@microsemi.com>
@@ -5658,7 +5658,7 @@ M:	Vincent Abriou <vincent.abriou@st.com>
 L:	dri-devel@lists.freedesktop.org
 T:	git git://anongit.freedesktop.org/drm/drm-misc
 S:	Maintained
-F:	drivers/gpu/drm/sti
+F:	drivers/gpu/drm/sti/
 F:	Documentation/devicetree/bindings/display/st,stih4xx.txt
 
 DRM DRIVERS FOR STM
@@ -5669,7 +5669,7 @@ M:	Vincent Abriou <vincent.abriou@st.com>
 L:	dri-devel@lists.freedesktop.org
 T:	git git://anongit.freedesktop.org/drm/drm-misc
 S:	Maintained
-F:	drivers/gpu/drm/stm
+F:	drivers/gpu/drm/stm/
 F:	Documentation/devicetree/bindings/display/st,stm32-ltdc.txt
 
 DRM DRIVERS FOR TI LCDC
@@ -6382,7 +6382,7 @@ EZchip NPS platform support
 M:	Vineet Gupta <vgupta@synopsys.com>
 M:	Ofer Levi <oferle@mellanox.com>
 S:	Supported
-F:	arch/arc/plat-eznps
+F:	arch/arc/plat-eznps/
 F:	arch/arc/boot/dts/eznps.dts
 
 F2FS FILE SYSTEM
@@ -6706,13 +6706,13 @@ FREESCALE QORIQ DPAA ETHERNET DRIVER
 M:	Madalin Bucur <madalin.bucur@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	drivers/net/ethernet/freescale/dpaa
+F:	drivers/net/ethernet/freescale/dpaa/
 
 FREESCALE QORIQ DPAA FMAN DRIVER
 M:	Madalin Bucur <madalin.bucur@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	drivers/net/ethernet/freescale/fman
+F:	drivers/net/ethernet/freescale/fman/
 F:	Documentation/devicetree/bindings/net/fsl-fman.txt
 
 FREESCALE QORIQ PTP CLOCK DRIVER
@@ -7111,7 +7111,7 @@ R:	Jon Olson <jonolson@google.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/device_drivers/google/gve.rst
-F:	drivers/net/ethernet/google
+F:	drivers/net/ethernet/google/
 
 GPD POCKET FAN DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
@@ -7429,7 +7429,7 @@ M:	Mike Marciniszyn <mike.marciniszyn@intel.com>
 M:	Dennis Dalessandro <dennis.dalessandro@intel.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
-F:	drivers/infiniband/hw/hfi1
+F:	drivers/infiniband/hw/hfi1/
 
 HFS FILESYSTEM
 L:	linux-fsdevel@vger.kernel.org
@@ -7572,7 +7572,7 @@ HISILICON PMU DRIVER
 M:	Shaokun Zhang <zhangshaokun@hisilicon.com>
 W:	http://www.hisilicon.com
 S:	Supported
-F:	drivers/perf/hisilicon
+F:	drivers/perf/hisilicon/
 F:	Documentation/admin-guide/perf/hisi-pmu.rst
 
 HISILICON ROCE DRIVER
@@ -7715,7 +7715,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	https://linuxtv.org
 S:	Supported
-F:	drivers/media/platform/sti/hva
+F:	drivers/media/platform/sti/hva/
 
 HWPOISON MEMORY FAILURE HANDLING
 M:	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
@@ -7750,7 +7750,7 @@ F:	arch/x86/include/asm/mshyperv.h
 F:	arch/x86/include/asm/trace/hyperv.h
 F:	arch/x86/include/asm/hyperv-tlfs.h
 F:	arch/x86/kernel/cpu/mshyperv.c
-F:	arch/x86/hyperv
+F:	arch/x86/hyperv/
 F:	drivers/clocksource/hyperv_timer.c
 F:	drivers/hid/hid-hyperv.c
 F:	drivers/hv/
@@ -7926,7 +7926,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/i3c/linux.git
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-bus-i3c
 F:	Documentation/devicetree/bindings/i3c/
-F:	Documentation/driver-api/i3c
+F:	Documentation/driver-api/i3c/
 F:	drivers/i3c/
 F:	include/linux/i3c/
 
@@ -8127,7 +8127,7 @@ F:	Documentation/networking/ieee802154.rst
 IFE PROTOCOL
 M:	Yotam Gigi <yotam.gi@gmail.com>
 M:	Jamal Hadi Salim <jhs@mojatatu.com>
-F:	net/ife
+F:	net/ife/
 F:	include/net/ife.h
 F:	include/uapi/linux/ife.h
 
@@ -8907,7 +8907,7 @@ L:	linux-rdma@vger.kernel.org
 L:	target-devel@vger.kernel.org
 S:	Supported
 W:	http://www.linux-iscsi.org
-F:	drivers/infiniband/ulp/isert
+F:	drivers/infiniband/ulp/isert/
 
 ISDN/mISDN SUBSYSTEM
 M:	Karsten Keil <isdn@linux-pingi.de>
@@ -8915,8 +8915,8 @@ L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
 L:	netdev@vger.kernel.org
 W:	http://www.isdn4linux.de
 S:	Maintained
-F:	drivers/isdn/mISDN
-F:	drivers/isdn/hardware
+F:	drivers/isdn/mISDN/
+F:	drivers/isdn/hardware/
 
 ISDN/CMTP OVER BLUETOOTH
 M:	Karsten Keil <isdn@linux-pingi.de>
@@ -9365,7 +9365,7 @@ L3MDEV
 M:	David Ahern <dsahern@kernel.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	net/l3mdev
+F:	net/l3mdev/
 F:	include/net/l3mdev.h
 
 L7 BPF FRAMEWORK
@@ -9392,8 +9392,8 @@ LANTIQ MIPS ARCHITECTURE
 M:	John Crispin <john@phrozen.org>
 L:	linux-mips@vger.kernel.org
 S:	Maintained
-F:	arch/mips/lantiq
-F:	drivers/soc/lantiq
+F:	arch/mips/lantiq/
+F:	drivers/soc/lantiq/
 
 LAPB module
 L:	linux-x25@vger.kernel.org
@@ -9646,7 +9646,7 @@ F:	drivers/rtc/rtc-opal.c
 F:	drivers/scsi/ibmvscsi/
 F:	drivers/tty/hvc/hvc_opal.c
 F:	drivers/watchdog/wdrtas.c
-F:	tools/testing/selftests/powerpc
+F:	tools/testing/selftests/powerpc/
 N:	/pmac
 N:	powermac
 N:	powernv
@@ -10929,7 +10929,7 @@ MICROCHIP AUDIO ASOC DRIVERS
 M:	Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
-F:	sound/soc/atmel
+F:	sound/soc/atmel/
 
 MICROCHIP DMA DRIVER
 M:	Ludovic Desroches <ludovic.desroches@microchip.com>
@@ -11855,7 +11855,7 @@ M:	Pavel Machek <pavel@ucw.cz>
 M:	Sakari Ailus <sakari.ailus@iki.fi>
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	drivers/media/i2c/et8ek8
+F:	drivers/media/i2c/et8ek8/
 F:	drivers/media/i2c/ad5820.c
 
 NOKIA N900 POWER SUPPLY DRIVERS
@@ -12002,7 +12002,7 @@ NXP SJA1105 ETHERNET SWITCH DRIVER
 M:	Vladimir Oltean <olteanv@gmail.com>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
-F:	drivers/net/dsa/sja1105
+F:	drivers/net/dsa/sja1105/
 
 NXP TDA998X DRM DRIVER
 M:	Russell King <linux@armlinux.org.uk>
@@ -12026,7 +12026,7 @@ M:	Clément Perrochaud <clement.perrochaud@effinnov.com>
 R:	Charles Gorand <charles.gorand@effinnov.com>
 L:	linux-nfc@lists.01.org (moderated for non-subscribers)
 S:	Supported
-F:	drivers/nfc/nxp-nci
+F:	drivers/nfc/nxp-nci/
 
 OBJAGG
 M:	Jiri Pirko <jiri@mellanox.com>
@@ -12411,7 +12411,7 @@ M:	Dennis Dalessandro <dennis.dalessandro@intel.com>
 M:	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
-F:	drivers/infiniband/ulp/opa_vnic
+F:	drivers/infiniband/ulp/opa_vnic/
 
 OPEN FIRMWARE AND DEVICE TREE OVERLAYS
 M:	Pantelis Antoniou <pantelis.antoniou@konsulko.com>
@@ -13358,7 +13358,7 @@ W:	https://01.org/pm-graph
 B:	https://bugzilla.kernel.org/buglist.cgi?component=pm-graph&product=Tools
 T:	git git://github.com/intel/pm-graph
 S:	Supported
-F:	tools/power/pm-graph
+F:	tools/power/pm-graph/
 
 PNI RM3100 IIO DRIVER
 M:	Song Qiang <songqiang1304521@gmail.com>
@@ -13535,7 +13535,7 @@ F:	drivers/block/ps3vram.c
 PSAMPLE PACKET SAMPLING SUPPORT:
 M:	Yotam Gigi <yotam.gi@gmail.com>
 S:	Maintained
-F:	net/psample
+F:	net/psample/
 F:	include/net/psample.h
 F:	include/uapi/linux/psample.h
 
@@ -13933,7 +13933,7 @@ M:	Avinash Patil <avinashp@quantenna.com>
 M:	Sergey Matyukevich <smatyukevich@quantenna.com>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
-F:	drivers/net/wireless/quantenna
+F:	drivers/net/wireless/quantenna/
 
 RADEON and AMDGPU DRM DRIVERS
 M:	Alex Deucher <alexander.deucher@amd.com>
@@ -13999,7 +13999,7 @@ RALINK MIPS ARCHITECTURE
 M:	John Crispin <john@phrozen.org>
 L:	linux-mips@vger.kernel.org
 S:	Maintained
-F:	arch/mips/ralink
+F:	arch/mips/ralink/
 
 RALINK RT2X00 WIRELESS LAN DRIVER
 M:	Stanislaw Gruszka <stf_xl@wp.pl>
@@ -14056,7 +14056,7 @@ R:	Lai Jiangshan <jiangshanlai@gmail.com>
 L:	rcu@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git dev
-F:	tools/testing/selftests/rcutorture
+F:	tools/testing/selftests/rcutorture/
 
 RDC R-321X SoC
 M:	Florian Fainelli <florian@openwrt.org>
@@ -14073,7 +14073,7 @@ M:	Dennis Dalessandro <dennis.dalessandro@intel.com>
 M:	Mike Marciniszyn <mike.marciniszyn@intel.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
-F:	drivers/infiniband/sw/rdmavt
+F:	drivers/infiniband/sw/rdmavt/
 
 RDS - RELIABLE DATAGRAM SOCKETS
 M:	Santosh Shilimkar <santosh.shilimkar@oracle.com>
@@ -14605,7 +14605,7 @@ F:	include/media/drv-intf/saa7146*
 SAFESETID SECURITY MODULE
 M:     Micah Morton <mortonm@chromium.org>
 S:     Supported
-F:     security/safesetid/
+F:	security/safesetid/
 F:     Documentation/admin-guide/LSM/SafeSetID.rst
 
 SAMSUNG AUDIO (ASoC) DRIVERS
@@ -14675,7 +14675,7 @@ M:	Robert Baldyga <r.baldyga@samsung.com>
 M:	Krzysztof Opasiak <k.opasiak@samsung.com>
 L:	linux-nfc@lists.01.org (moderated for non-subscribers)
 S:	Supported
-F:	drivers/nfc/s3fwrn5
+F:	drivers/nfc/s3fwrn5/
 
 SAMSUNG S5C73M3 CAMERA DRIVER
 M:	Kyungmin Park <kyungmin.park@samsung.com>
@@ -16083,7 +16083,7 @@ F:	Documentation/devicetree/bindings/clock/snps,pll-clock.txt
 SYNOPSYS ARC SDP platform support
 M:	Alexey Brodkin <abrodkin@synopsys.com>
 S:	Supported
-F:	arch/arc/plat-axs10x
+F:	arch/arc/plat-axs10x/
 F:	arch/arc/boot/dts/ax*
 F:	Documentation/devicetree/bindings/arc/axs10*
 
@@ -18220,7 +18220,7 @@ L:	platform-driver-x86@vger.kernel.org
 L:	x86@kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/core
 S:	Maintained
-F:	arch/x86/platform
+F:	arch/x86/platform/
 
 X86 VDSO
 M:	Andy Lutomirski <luto@kernel.org>
@@ -18238,7 +18238,7 @@ F:	lib/idr.c
 F:	lib/xarray.c
 F:	include/linux/idr.h
 F:	include/linux/xarray.h
-F:	tools/testing/radix-tree
+F:	tools/testing/radix-tree/
 
 XBOX DVD IR REMOTE
 M:	Benjamin Valentin <benpicco@googlemail.com>


--=-yBGuuoEgBc28KLhikCcE
Content-Type: application/x-perl; name="maintainer_slashes.perl"
Content-Disposition: attachment; filename="maintainer_slashes.perl"
Content-Transfer-Encoding: base64

IyEvdXNyL2Jpbi9lbnYgcGVybAoKbXkgQG5ldyA9ICgpOwoKb3BlbiAobXkgJG1haW50LCAnPCcs
ICJNQUlOVEFJTkVSUyIpCiAgICBvciBkaWUgIiRQOiBDYW4ndCByZWFkIE1BSU5UQUlORVJTIGZp
bGU6ICQhXG4iOwp3aGlsZSAoPCRtYWludD4pIHsKICAgIG15ICRsaW5lID0gJF87CiAgICBjaG9t
cCAkbGluZTsKCiAgICBpZiAoJGxpbmUgPX4gbS9eKFtGWF0pOlxzKiguKikvKSB7CglteSAkdHlw
ZSA9ICQxOwoJbXkgJHZhbHVlID0gJDI7CgoJJHZhbHVlID1+IHNAXC5AXFxcLkBnOyAgICAgICAj
I0NvbnZlcnQgLiB0byBcLgoJJHZhbHVlID1+IHMvXCovXC5cKi9nOyAgICAgICAjI0NvbnZlcnQg
KiB0byAuKgoJJHZhbHVlID1+IHMvXD8vXC4vZzsgICAgICAgICAjI0NvbnZlcnQgPyB0byAuCgkj
I2lmIHBhdHRlcm4gaXMgYSBkaXJlY3RvcnkgYW5kIGl0IGxhY2tzIGEgdHJhaWxpbmcgc2xhc2gs
IGFkZCBvbmUKCWlmICgoLWQgJHZhbHVlKSkgewoJICAgICR2YWx1ZSA9fiBzQChbXi9dKSRAJDEv
QDsKCSAgICAkbGluZSA9ICIkdHlwZTpcdCR2YWx1ZSI7Cgl9CiAgICB9CiAgICBwdXNoKEBuZXcs
ICRsaW5lKTsKfQpjbG9zZSgkbWFpbnQpOwoKb3BlbiAobXkgJG1haW50LCAnPicsICJNQUlOVEFJ
TkVSUyIpCiAgICBvciBkaWUgIiRQOiBDYW4ndCB3cml0ZSBNQUlOVEFJTkVSUyBmaWxlOiAkIVxu
IjsKCmZvcmVhY2ggbXkgJGxpbmUgKEBuZXcpIHsKICAgIHByaW50ICRtYWludCAiJGxpbmVcbiI7
Cn0KY2xvc2UoJG1haW50KTsK


--=-yBGuuoEgBc28KLhikCcE--

