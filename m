Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176B01C7B9B
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgEFU5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:57:33 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47400 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgEFU5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:57:33 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046Kui98091661;
        Wed, 6 May 2020 15:56:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588798604;
        bh=WC2aBjr6iCQTQw2lr1Yyk+xrI/M0eVGwOwtMPjsKnbw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Rndq67NlN2lHEUXyT7jVZCcToac28Ol1pr9Ne8fdhHotn5szrumPVTmv7qNuEl2Wl
         7ZJzhMsEtzLJJZvngVnggYqyhGTHVpUHJVZvhDFVvqqaQ4Obs+lJyR/FevNlAATiP6
         QvAcI1PdVhOABhgu5k4A+G8xXPlobJ3iYCYVDM5Y=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046Kui5N020143
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 15:56:44 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 15:56:43 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 15:56:43 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046KubRW051537;
        Wed, 6 May 2020 15:56:38 -0500
Subject: Re: [PATCH v2] net: ethernet: ti: Remove TI_CPTS_MOD workaround
To:     Clay McClure <clay@daemons.net>
CC:     Arnd Bergmann <arnd@arndb.de>, kbuild test robot <lkp@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <CAK8P3a1m-zmiTx0_KJb-9PTW0iK+Zkh10gKsaBzge0OJALBFmQ@mail.gmail.com>
 <20200504165711.5621-1-clay@daemons.net>
 <f07c695b-5537-41bf-e4f8-0d8012532f64@ti.com>
 <20200506065105.GA3226@arctic-shiba-lx>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <1654101f-9dd7-2e10-7344-0d08e32bc309@ti.com>
Date:   Wed, 6 May 2020 23:56:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506065105.GA3226@arctic-shiba-lx>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/05/2020 09:51, Clay McClure wrote:
> On Tue, May 05, 2020 at 10:41:26AM +0300, Grygorii Strashko wrote:
> 
>> It's better if you send v2 not as reply to v1.
> 
> Noted, thank you, and thank you for taking the time to review my patch.
> 
>> just to clarify. After these two patches
>>   - the PTP_1588_CLOCK can still be set to "M"
>>   - which will cause TI_CPTS to be "M",
>>   - but TI_CPSW will still be "Y".
>>
>> and all above will build and produce built-in CPSW without CPTS support
>> and cpts.ko which is loadable, but not functional.
>>
>> Sorry, I'm a little bit lost regarding the target you'are trying to achieve.
>> At least previously "imply PTP_1588_CLOCK" allowed to select properly PTP_1588_CLOCK
>> without modifying every defconfig.
> 
> Well, I just wanted to squelch a WARN_ON(). As Arnd pointed out in [1],
> code that uses the stubbed cpts functions is supposed to gracefully
> handle receiving a null pointer. Splatting a warning is not graceful,
> and that's what I was trying to fix.
> 
> But your question in [2] prompted me to consider whether it should be
> possible to build TI_CPTS without PTP_1588_CLOCK at all. I think the
> answer is no, so I tried to fix it, but you're right, it's still
> possible to end up with a nonfunctional module after my patch.
> 
> If you prefer to revert, that's fine with me. Should I post a patch, or
> just ask David to revert?
> 

Ok. After some thinking and hence you commit b6d49cab44b5 ("net: Make PTP-specific drivers depend on PTP_1588_CLOCK")
seems was merged in net (not net-next)
1) for-net: defconfig changes can be separated to fix build fail, but add change for multi_v7_defconfig
2) for-net-next: rest of changes plus below diff on top of it

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index f3f8bb724294..62f809b67469 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -49,6 +49,7 @@ config TI_CPSW_PHY_SEL
  config TI_CPSW
         tristate "TI CPSW Switch Support"
         depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
+       depends on TI_CPTS || !TI_CPTS
         select TI_DAVINCI_MDIO
         select MFD_SYSCON
         select PAGE_POOL
@@ -64,6 +65,7 @@ config TI_CPSW_SWITCHDEV
         tristate "TI CPSW Switch Support with switchdev"
         depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
         depends on NET_SWITCHDEV
+       depends on TI_CPTS || !TI_CPTS
         select PAGE_POOL
         select TI_DAVINCI_MDIO
         select MFD_SYSCON
@@ -78,11 +80,9 @@ config TI_CPSW_SWITCHDEV
  
  config TI_CPTS
         tristate "TI Common Platform Time Sync (CPTS) Support"
-       depends on TI_CPSW || TI_KEYSTONE_NETCP || TI_CPSW_SWITCHDEV || COMPILE_TEST
+       depends on ARCH_OMAP2PLUS || ARCH_KEYSTONE || COMPILE_TEST
         depends on COMMON_CLK
         depends on PTP_1588_CLOCK
-       default y if TI_CPSW=y || TI_KEYSTONE_NETCP=y || TI_CPSW_SWITCHDEV=y
-       default m
         ---help---
           This driver supports the Common Platform Time Sync unit of
           the CPSW Ethernet Switch and Keystone 2 1g/10g Switch Subsystem.
@@ -109,6 +109,7 @@ config TI_KEYSTONE_NETCP
         select TI_DAVINCI_MDIO
         depends on OF
         depends on KEYSTONE_NAVIGATOR_DMA && KEYSTONE_NAVIGATOR_QMSS
+       depends on TI_CPTS || !TI_CPTS
         ---help---
           This driver supports TI's Keystone NETCP Core.

It should properly resolve "M" vs "Y" dependencies between
  PTP_1588_CLOCK->TI_CPTS->TI_CPSW

On thing, TI_CPTS can be selected without TI_CPSW, but it's probably ok.

-- 
Best regards,
grygorii
