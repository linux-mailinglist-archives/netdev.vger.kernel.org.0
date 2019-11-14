Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86738FC9A8
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKNPQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:16:22 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:23193 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfKNPQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:16:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1573744577;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=dIdO6+wWmfeQm+EP9ocIN+ER7iLsR+gearCu29RvDj8=;
        b=pSyCIHS8/1KAKUVF1Jiyz1A47gb8fTEjSqtwUEo7ExOs/5Fojli+GIOemZfPtJshkm
        NOPgUius99rQk5SvaDJFOSAeKVpeNISEZYsWGgLew78IjpfNtNhgJta6uw1Q2j0zZZaz
        +deiCAxzmTmP/A7bBXPAjs5Zy00FqK1IaG2dQ1R4xcsAruzTb/IfQoBEI4DlInxUKwBZ
        bcjxIFs9mF1odJdj9gKUV7Vf/HNfWZFoknnySx/ggnevKH2P2bQqzEpR5PK2sigsCcVG
        lBpIuhJ33KrsSvZKyfDXzormoy4NTJE9m8g+oGP7+zXALJ2qPaMHytpV5dSgk3PbVIPZ
        XbIg==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj5Qpw97WFDVCbXA4F8vU="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3vAEFFiEyY
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 14 Nov 2019 16:15:44 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH v3 00/12] OpenPandora: make wl1251 connected to mmc3 sdio port of OpenPandora work again
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <CAPDyKFrntf2Kd9Zf7uxRCUk_OrKD8B3xOKmvPaf04X21L5HwWA@mail.gmail.com>
Date:   Thu, 14 Nov 2019 16:15:44 +0100
Cc:     =?utf-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, kernel@pyra-handheld.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <5F5A5FC0-8F91-4D5B-9EF6-AF36FE38B588@goldelico.com>
References: <cover.1573122644.git.hns@goldelico.com> <CAPDyKFrntf2Kd9Zf7uxRCUk_OrKD8B3xOKmvPaf04X21L5HwWA@mail.gmail.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ulf,

> Am 14.11.2019 um 15:18 schrieb Ulf Hansson <ulf.hansson@linaro.org>:
>=20
> On Thu, 7 Nov 2019 at 11:31, H. Nikolaus Schaller <hns@goldelico.com> =
wrote:
>>=20
>>=20
>> * add a revisit note for special wl1251 handling code because it =
should
>>  be solved more generic in mmc core - suggested by Ulf Hansson =
<ulf.hansson@linaro.org>
>> * remove init_card callback from platform_data/hsmmc-omap.h - =
suggested by Ulf Hansson <ulf.hansson@linaro.org>
>> * remove obstructive always-on for vwlan regulator - suggested by Ulf =
Hansson <ulf.hansson@linaro.org>
>> * rename DT node - suggested by Rob Herring <robh@kernel.org>
>> * fix ARM: dts: subject prefix - suggested by Tony Lindgren =
<tony@atomide.com>
>> * also remove omap2_hsmmc_info and obc-y line in Makefile - suggested =
by Tony Lindgren <tony@atomide.com>
>=20
> No further comments from my side. Let's just agree on how to deal with
> the ti,power-gpio, then I can apply this.

I'd say it can be a separate patch since it does not fix the Pandora
issues, but is a new and independent optimization.

And in case someone complains and uses it for some out-of tree purpose
it can be discussed or even be reverted easier if it is a separate =
patch.

I can do it in the next days.

> Thanks a lot for fixing all this mess!

I hope the users also appreciate our work.

Best regards,
Nikolaus

>=20
> Kind regards
> Uffe
>=20
>>=20
>> PATCH V2 2019-10-19 20:41:47:
>> * added acked-by for wl1251 patches - Kalle Valo =
<kvalo@codeaurora.org>
>> * really removed old pdata-quirks code (not through #if 0)
>> * splited out a partial revert of
>>        efdfeb079cc3b ("regulator: fixed: Convert to use GPIO =
descriptor only")
>>  because that was introduced after v4.19 and stops the removal of
>>  the pdata-quirks patch from cleanly applying to v4.9, v4.14, v4.19
>>  - reported by Sasha Levin <sashal@kernel.org>
>> * added a new patch to remove old omap hsmmc since pdata quirks
>>  were last user - suggested by Tony Lindgren <tony@atomide.com>
>>=20
>> PATCH V1 2019-10-18 22:25:39:
>> Here we have a set of scattered patches to make the OpenPandora WiFi =
work again.
>>=20
>> v4.7 did break the pdata-quirks which made the mmc3 interface
>> fail completely, because some code now assumes device tree
>> based instantiation.
>>=20
>> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for =
requesting DMA channel")
>>=20
>> v4.11 did break the sdio qirks for wl1251 which made the driver no =
longer
>> load, although the device was found as an sdio client.
>>=20
>> Fixes: 884f38607897 ("mmc: core: move some sdio IDs out of quirks =
file")
>>=20
>> To solve these issues:
>> * we convert mmc3 and wl1251 initialization from pdata-quirks
>>  to device tree
>> * we make the wl1251 driver read properties from device tree
>> * we fix the mmc core vendor ids and quirks
>> * we fix the wl1251 (and wl1271) driver to use only vendor ids
>>  from header file instead of (potentially conflicting) local
>>  definitions
>>=20
>>=20
>> H. Nikolaus Schaller (12):
>>  Documentation: dt: wireless: update wl1251 for sdio
>>  net: wireless: ti: wl1251 add device tree support
>>  ARM: dts: pandora-common: define wl1251 as child node of mmc3
>>  mmc: host: omap_hsmmc: add code for special init of wl1251 to get =
rid
>>    of pandora_wl1251_init_card
>>  omap: pdata-quirks: revert pandora specific gpiod additions
>>  omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251
>>  omap: remove omap2_hsmmc_info in old hsmmc.[ch] and update Makefile
>>  mmc: host: omap-hsmmc: remove init_card pdata callback from pdata
>>  mmc: sdio: fix wl1251 vendor id
>>  mmc: core: fix wl1251 sdio quirks
>>  net: wireless: ti: wl1251 use new SDIO_VENDOR_ID_TI_WL1251 =
definition
>>  net: wireless: ti: remove local VENDOR_ID and DEVICE_ID definitions
>>=20
>> .../bindings/net/wireless/ti,wl1251.txt       |  26 +++
>> arch/arm/boot/dts/omap3-pandora-common.dtsi   |  36 +++-
>> arch/arm/mach-omap2/Makefile                  |   3 -
>> arch/arm/mach-omap2/common.h                  |   1 -
>> arch/arm/mach-omap2/hsmmc.c                   | 171 =
------------------
>> arch/arm/mach-omap2/hsmmc.h                   |  32 ----
>> arch/arm/mach-omap2/pdata-quirks.c            | 105 -----------
>> drivers/mmc/core/quirks.h                     |   7 +
>> drivers/mmc/host/omap_hsmmc.c                 |  30 ++-
>> drivers/net/wireless/ti/wl1251/sdio.c         |  23 ++-
>> drivers/net/wireless/ti/wlcore/sdio.c         |   8 -
>> include/linux/mmc/sdio_ids.h                  |   2 +
>> include/linux/platform_data/hsmmc-omap.h      |   3 -
>> 13 files changed, 111 insertions(+), 336 deletions(-)
>> delete mode 100644 arch/arm/mach-omap2/hsmmc.c
>> delete mode 100644 arch/arm/mach-omap2/hsmmc.h
>>=20
>> --
>> 2.23.0
>>=20

