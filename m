Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673ABDF3D3
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 19:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbfJURIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 13:08:07 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:32198 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfJURIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 13:08:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1571677682;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=g5fftcy+sbjcXJkucAV/OZbKo+UWi5WQTkrvCV2Jtos=;
        b=MCpa+9rRKrdom/xaOpun1m6gqtX0goa1UYwlgcdk+bUa7vOK5N5D/I6Gpd2icxGPFb
        VPW3wd2o3OPlb6EII1dFDERgH46BzQRrXeWmsg5QSFUpNQBjNKt7p27ys1l/c/xfPDjy
        GxudTskSRd6qrn2lWgpMdDF68/6tGAGD14y3tLP1f7rhGJIFtUIBMP90yQOwuo/RAjij
        OoQz2iiSsyt+2CDiNGYpMCWOcJtyHk0fQWQu4AU2wcNPtw5QMhnJINkwqlmfViY8G7hJ
        lXufkL/Pu1Wyg+TvB99AN5V6UAt1m6bCwmifRDuBiqREsTYbwtmOBOpxS+0tTQ2ByCuk
        QE9w==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj5Qpw97WFDVCbXA4Ewxc="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 44.28.1 DYNA|AUTH)
        with ESMTPSA id R0b2a8v9LH7VLxq
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 21 Oct 2019 19:07:31 +0200 (CEST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH v2 07/11] omap: remove old hsmmc.[ch] and in Makefile
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20191021143008.GS5610@atomide.com>
Date:   Mon, 21 Oct 2019 19:07:31 +0200
Cc:     =?utf-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
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
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com
Content-Transfer-Encoding: 7bit
Message-Id: <3FDBE28F-B2C5-4EDE-905C-687F601462B6@goldelico.com>
References: <cover.1571510481.git.hns@goldelico.com> <9bd4c0bb0df26523d7f5265cdb06d86d63dafba8.1571510481.git.hns@goldelico.com> <20191021143008.GS5610@atomide.com>
To:     Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Am 21.10.2019 um 16:30 schrieb Tony Lindgren <tony@atomide.com>:
> 
> * H. Nikolaus Schaller <hns@goldelico.com> [191019 18:43]:
>> --- a/arch/arm/mach-omap2/Makefile
>> +++ b/arch/arm/mach-omap2/Makefile
>> @@ -216,7 +216,6 @@ obj-$(CONFIG_MACH_NOKIA_N8X0)		+= board-n8x0.o
>> 
>> # Platform specific device init code
>> 
>> -omap-hsmmc-$(CONFIG_MMC_OMAP_HS)	:= hsmmc.o
>> obj-y					+= $(omap-hsmmc-m) $(omap-hsmmc-y)
> 
> The related obj-y line can go now too, right?

Yes, I think so. It is a construction that I have never seen before :)
Therefore I did not recognize that it is related.

> And looks like common.h also has struct omap2_hsmmc_info
> so maybe check by grepping for hsmmc_info to see it's gone.

Yes, it is just a forward-declaration of the struct name with
no user anywhere.

Scheduled for v3.

BTW: should this series go through your tree since it is an
omap machine?

BR and thanks,
Nikolaus

