Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302BE255708
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 11:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgH1JAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 05:00:02 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:33197 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728218AbgH1I75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 04:59:57 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598605197; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=fotnpsF0EYIr+SiKtcUih+0Uan6DLmURDNPjSJ8hGBA=; b=PLuz3whksxn3bNgUzK9g6U3idKQSf19SE5d/morQ0Mi1QZqbCnNHpPDouyiDisb7mrLO2KzL
 UXRC6EKko6o0W62zfIcuc0NsesMXhwC0FAyof2pu/TEUJta3EI1l8vZoB/jVegPKQkevYHMK
 ySQrvg8PryguFEiBoR7FQhgKM8A=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5f48c78112acec35e2f3fbc6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 28 Aug 2020 08:59:45
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EEEC5C433C6; Fri, 28 Aug 2020 08:59:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 101C9C433CB;
        Fri, 28 Aug 2020 08:59:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 101C9C433CB
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
        <202008172335.02988.linux@zary.sk> <87v9h4le9z.fsf@codeaurora.org>
        <202008272223.57461.linux@zary.sk>
Date:   Fri, 28 Aug 2020 11:59:37 +0300
In-Reply-To: <202008272223.57461.linux@zary.sk> (Ondrej Zary's message of
        "Thu, 27 Aug 2020 22:23:57 +0200")
Message-ID: <87lfhz9mdi.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ondrej Zary <linux@zary.sk> writes:

> On Thursday 27 August 2020 09:49:12 Kalle Valo wrote:
>> Ondrej Zary <linux@zary.sk> writes:
>> 
>> > On Monday 17 August 2020 20:27:06 Jesse Brandeburg wrote:
>> >> On Mon, 17 Aug 2020 16:27:01 +0300
>> >> Kalle Valo <kvalo@codeaurora.org> wrote:
>> >> 
>> >> > I was surprised to see that someone was using this driver in 2015, so
>> >> > I'm not sure anymore what to do. Of course we could still just remove
>> >> > it and later revert if someone steps up and claims the driver is still
>> >> > usable. Hmm. Does anyone any users of this driver?
>> >> 
>> >> What about moving the driver over into staging, which is generally the
>> >> way I understood to move a driver slowly out of the kernel?
>> >
>> > Please don't remove random drivers.
>> 
>> We don't want to waste time on obsolete drivers and instead prefer to
>> use our time on more productive tasks. For us wireless maintainers it's
>> really hard to know if old drivers are still in use or if they are just
>> broken.
>> 
>> > I still have the Aironet PCMCIA card and can test the driver.
>> 
>> Great. Do you know if the airo driver still works with recent kernels?
>
> Yes, it does.

Nice, I'm very surprised that so old and unmaintained driver still
works. Thanks for testing.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
