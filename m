Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BD91B6054
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 18:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbgDWQHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 12:07:14 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:22371 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729515AbgDWQHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 12:07:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1587658032; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=qbSJxZQNaWxw8mAgGamaaFomuWjyilvDfwW/TLq0WJQ=;
 b=t9ZGvrnp0scZCOrM/H6PwPWwapisyipQZiUnW/zFNrpC+T6ts2mliQVbohlXQRWykwFcemOO
 kQeAeWvZ8sGWkHiBApWezAsvWHocEUTmlDsKijDm1IXmeyhHyF8u0XSNL5fzGXa+7umKNxmt
 tZmmdCT3PO94v8WaMsBcNjVHt3E=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ea1bd2a.7f736ae07c38-smtp-out-n01;
 Thu, 23 Apr 2020 16:07:06 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E24FDC433D2; Thu, 23 Apr 2020 16:07:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BCF2BC433D2;
        Thu, 23 Apr 2020 16:07:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BCF2BC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 2/2] rtw88: Use udelay instead of usleep in atomic context
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200423073007.3566-1-kai.heng.feng@canonical.com>
References: <20200423073007.3566-1-kai.heng.feng@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     yhchuang@realtek.com, Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org (open list:REALTEK WIRELESS DRIVER
        (rtw88)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200423160704.E24FDC433D2@smtp.codeaurora.org>
Date:   Thu, 23 Apr 2020 16:07:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:

> It's incorrect to use usleep in atomic context.
> 
> Switch to a macro which uses udelay instead of usleep to prevent the issue.
> 
> Fixes: 6343a6d4b213 ("rtw88: Add delay on polling h2c command status bit")
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

For patch 1 please also CC linux-wireless, otherwise patchwork cannot see it.

-- 
https://patchwork.kernel.org/patch/11505147/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
