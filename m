Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1D41C6C11
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgEFInQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:43:16 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:20797 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728681AbgEFInQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:43:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588754595; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Ruhn4TrDAa9eXV41Exn0uX4NRP+6khiDavNt/3n4Uo0=;
 b=lKp755gKeSJNnsYRmyslSc2QTTwOfyNyrD3QqNS7ZHKcl18iAuBgqMNxa2IDv64jSqwE2ngY
 QVUfc8oH067EN0MbPN014iyC2Y7/QK9ZCgRL1SxAj5ehbRFimn9olLRlfAgVG706a2xAHSoW
 IP5K5vNXvNuY1idCi1VLhVk1FN4=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb27898.7fe0ad2a4b58-smtp-out-n04;
 Wed, 06 May 2020 08:43:04 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5F898C433BA; Wed,  6 May 2020 08:43:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A0587C433F2;
        Wed,  6 May 2020 08:43:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A0587C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: remove comparison of 0/1 to bool variable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200429140924.7750-1-yanaijie@huawei.com>
References: <20200429140924.7750-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jason Yan <yanaijie@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200506084304.5F898C433BA@smtp.codeaurora.org>
Date:   Wed,  6 May 2020 08:43:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> The variable 'rtlpriv->rfkill.rfkill_state' is bool and can directly
> assigned to bool values.
> 
> Fix the following coccicheck warning:
> 
> drivers/net/wireless/realtek/rtlwifi/core.c:1725:14-42: WARNING:
> Comparison of 0/1 to bool variable
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

1b56bed20212 rtlwifi: remove comparison of 0/1 to bool variable

-- 
https://patchwork.kernel.org/patch/11517573/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
