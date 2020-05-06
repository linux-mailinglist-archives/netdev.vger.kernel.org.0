Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562F31C6C30
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgEFIr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:47:28 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:36468 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728884AbgEFIr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:47:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588754846; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=tNMr8x+2F+qLKKXKI6NALEiJM0Osay1Pha5cZINZ9mw=;
 b=Bnqdej0OrKicQ/y9Yfu3pWHV60yPCT3P2oO23MI3KyNpdUuWl/5l+Ho0RLsL8Kezno/vI0x3
 mrBht+P6MuhzC1TyBimExrT7N6pZkybmzczYg1HcxoVyyN6pFxQ6pAsSuLaMwre+pyZNMvZa
 3847UPMDHZb/AnRu5RFxXF8Rs1E=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb2799c.7f2dc613a110-smtp-out-n03;
 Wed, 06 May 2020 08:47:24 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CE932C432C2; Wed,  6 May 2020 08:47:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BD13FC433F2;
        Wed,  6 May 2020 08:47:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BD13FC433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8188ee: remove Comparison to bool in rf.c
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200504113321.41118-1-yanaijie@huawei.com>
References: <20200504113321.41118-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jason Yan <yanaijie@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200506084724.CE932C432C2@smtp.codeaurora.org>
Date:   Wed,  6 May 2020 08:47:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> Fix the following coccicheck warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.c:476:6-14: WARNING:
> Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.c:54:5-22: WARNING:
> Comparison to bool
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

cbb1404f6541 rtlwifi: rtl8188ee: remove Comparison to bool in rf.c

-- 
https://patchwork.kernel.org/patch/11525533/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
