Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91A42149B9B
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 16:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgAZPr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 10:47:28 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:26938 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726323AbgAZPr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 10:47:28 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580053647; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=G+/DVGqC+SR9MedkNHgKsJSkunVLn/gMN8RbNOzODpA=;
 b=PXNOV2eb1rRUEJInbIOsbMm/0KCUPdOP086LlMi9gGWT56UAzhjXnQe1SzcP5OsisHZfydJR
 yl9aGWBD5ZSjORy7hZ9l1bKGBCLQ7O52KwsHjKULPnKWsV1gt8jom/YWt4pAN2w5KPzM32/P
 w4uI/BaZGZ/9dYWN2kGpIObjp50=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2db48f.7ff3823c14c8-smtp-out-n02;
 Sun, 26 Jan 2020 15:47:27 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 35A1EC43383; Sun, 26 Jan 2020 15:47:27 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E6074C433CB;
        Sun, 26 Jan 2020 15:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E6074C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8723ae: remove unused variables
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200121030428.14760-1-yuehaibing@huawei.com>
References: <20200121030428.14760-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>,
        <bernd.edlinger@hotmail.de>, <yuehaibing@huawei.com>,
        <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126154727.35A1EC43383@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 15:47:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c:16:18:
>  warning: ofdmswing_table defined but not used [-Wunused-const-variable=]
> drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c:56:17:
>  warning: cckswing_table_ch1ch13 defined but not used [-Wunused-const-variable=]
> drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c:92:17:
>  warning: cckswing_table_ch14 defined but not used [-Wunused-const-variable=]
> 
> These variable is never used, so remove them.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

c5f985241109 rtlwifi: rtl8723ae: remove unused variables

-- 
https://patchwork.kernel.org/patch/11343053/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
