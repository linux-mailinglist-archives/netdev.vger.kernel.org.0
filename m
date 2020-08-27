Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF668253F93
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 09:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgH0Htp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 03:49:45 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:63925 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728328AbgH0Hto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 03:49:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598514584; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=t5gOl7DiMwPormDKrvq/jDuEzzPigBia0L5h8NiJzbE=; b=fGt2KG+QpN/O+/v2dB7d7bVVXXl2rdGCvNwAihewTvmCgZc6GXvaQ2+Cwplho4hHcUTAd0f8
 lZd+aTjMabiMFjpxz/ffswg2TBkFV9wHIwyZV2h6MNnp+gV18Lvhyw8g9ORa3Mvfbvwctel/
 /CDYvaohDRM7j6kP7m/ZganZBIE=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f47657ffb5eb2479c9e4641 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 07:49:19
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 63DA4C433C6; Thu, 27 Aug 2020 07:49:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0D5B5C433CA;
        Thu, 27 Aug 2020 07:49:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0D5B5C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ondrej Zary <linux@zary.sk>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lee Jones <lee.jones@linaro.org>, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Reed <breed@users.sourceforge.net>,
        Javier Achirica <achirica@users.sourceforge.net>,
        Jean Tourrilhes <jt@hpl.hp.com>,
        "Fabrice Bellet" <fabrice@bellet.info>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 12/30] net: wireless: cisco: airo: Fix a myriad of coding style issues
References: <20200814113933.1903438-1-lee.jones@linaro.org>
        <87a6ytmmhm.fsf@codeaurora.org> <20200817112706.000000f2@intel.com>
        <202008172335.02988.linux@zary.sk>
Date:   Thu, 27 Aug 2020 10:49:12 +0300
In-Reply-To: <202008172335.02988.linux@zary.sk> (Ondrej Zary's message of
        "Mon, 17 Aug 2020 23:35:02 +0200")
Message-ID: <87v9h4le9z.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ondrej Zary <linux@zary.sk> writes:

> On Monday 17 August 2020 20:27:06 Jesse Brandeburg wrote:
>> On Mon, 17 Aug 2020 16:27:01 +0300
>> Kalle Valo <kvalo@codeaurora.org> wrote:
>> 
>> > I was surprised to see that someone was using this driver in 2015, so
>> > I'm not sure anymore what to do. Of course we could still just remove
>> > it and later revert if someone steps up and claims the driver is still
>> > usable. Hmm. Does anyone any users of this driver?
>> 
>> What about moving the driver over into staging, which is generally the
>> way I understood to move a driver slowly out of the kernel?
>
> Please don't remove random drivers.

We don't want to waste time on obsolete drivers and instead prefer to
use our time on more productive tasks. For us wireless maintainers it's
really hard to know if old drivers are still in use or if they are just
broken.

> I still have the Aironet PCMCIA card and can test the driver.

Great. Do you know if the airo driver still works with recent kernels?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
