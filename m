Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206B41B26F4
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 14:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgDUM7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 08:59:16 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:42228 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728337AbgDUM7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 08:59:15 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1587473954; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=YtfAXEXFjPsB+JY6QMaE7heGtGH15YpE1RkTM1QT/TY=;
 b=GmCBZXtANZefW7v/igfa6vnp3KQqTc8kkbD05GNchR00cMt5WHBbqXkG16aMoHJ31EbZ1IJ5
 5XE7mOZCE+s0icBgN6t52cwipUlqNykhoKT3BjmrJcHHwi+lRwVtKq6rGP0P/8S94fEd2Ssa
 UZMQPddsL+tMgFdnwPIbJv05Mj0=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e9eee10.7f9dbfb35c38-smtp-out-n01;
 Tue, 21 Apr 2020 12:58:56 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F290CC44791; Tue, 21 Apr 2020 12:58:54 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A96C9C433CB;
        Tue, 21 Apr 2020 12:58:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A96C9C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8723ae: fix warning comparison to bool
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200420042658.18733-1-yanaijie@huawei.com>
References: <20200420042658.18733-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>, <yanaijie@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200421125854.F290CC44791@smtp.codeaurora.org>
Date:   Tue, 21 Apr 2020 12:58:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> Fix the following coccicheck warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c:617:14-20: WARNING:
> Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c:622:13-19: WARNING:
> Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c:627:14-20: WARNING:
> Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c:632:13-19: WARNING:
> Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c:937:5-13: WARNING:
> Comparison to bool
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

887e74239805 rtlwifi: rtl8723ae: fix warning comparison to bool

-- 
https://patchwork.kernel.org/patch/11498041/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
