Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45664381657
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 08:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhEOGhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 02:37:02 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:55353 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhEOGhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 02:37:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621060549; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=qVFIrg7dlwoQDpzSgwse4EGxnQM5X1en6xgZpyJAz5k=;
 b=T4MQTT9iY6jD5vW3mYNnIVtuDnyvcMLKPH/WIth6j0cFIMZxrioNef8MXcmo367ObW+I2mFX
 ZZgf590JnPcBwPrNuz//XmmENySq0qsJcQt4j03/VguJ5G239APQ963ZhZZ0f3k00siQ134E
 /2Xlz1No8+f3pgjUKK3WgtHtFgc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 609f6bc4ac38d679b3e7024d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 15 May 2021 06:35:48
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CE287C433D3; Sat, 15 May 2021 06:35:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0F54BC433D3;
        Sat, 15 May 2021 06:35:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0F54BC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next v2] drivers: net: CONFIG_ATH9K select LEDS_CLASS and
 NEW_LEDS
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210330120533.102712-1-zhangjianhua18@huawei.com>
References: <20210330120533.102712-1-zhangjianhua18@huawei.com>
To:     Zhang Jianhua <zhangjianhua18@huawei.com>
Cc:     <ath9k-devel@qca.qualcomm.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <zhangjianhua18@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <johnny.chenyi@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210515063547.CE287C433D3@smtp.codeaurora.org>
Date:   Sat, 15 May 2021 06:35:47 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Jianhua <zhangjianhua18@huawei.com> wrote:

> If CONFIG_ATH9K=y, the following errors will be seen while compiling
> gpio.c
> 
> drivers/net/wireless/ath/ath9k/gpio.o: In function `ath_deinit_leds':
> gpio.c:(.text+0x604): undefined reference to `led_classdev_unregister'
> gpio.c:(.text+0x604): relocation truncated to fit: R_AARCH64_CALL26
> against undefined symbol `led_classdev_unregister'
> drivers/net/wireless/ath/ath9k/gpio.o: In function `ath_init_leds':
> gpio.c:(.text+0x708): undefined reference to `led_classdev_register_ext'
> gpio.c:(.text+0x708): relocation truncated to fit: R_AARCH64_CALL26
> against undefined symbol `led_classdev_register_ext'
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Jianhua <zhangjianhua18@huawei.com>

No responses to my questions so I'm dropping this.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210330120533.102712-1-zhangjianhua18@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

