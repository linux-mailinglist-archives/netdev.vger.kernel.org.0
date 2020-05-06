Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781861C6C0B
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgEFImU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:42:20 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:33883 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728475AbgEFImT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:42:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588754539; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=xj3E/SpCjWDvkJx+g6pYrv8tXv0DsbD4yvgEyoegG7I=;
 b=S3RgV3ZrUo0fuZ6WQh877gCzLRRObkJ7h4MXoEB28KXSCvlvj09Zj2oZWSecMSAe/yUdiVti
 2ubJHRBthDNlYXRMJ/rOKf9XVUjdNIbv0IKwfI9hB3NE8y8RAzfhZSPU5HYfagqKX4z2spB4
 5ghty7xCcoIOTMAbciKASsVLBEk=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb27864.7f4fb31c2d18-smtp-out-n03;
 Wed, 06 May 2020 08:42:12 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 50A33C433F2; Wed,  6 May 2020 08:42:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D2E29C43637;
        Wed,  6 May 2020 08:42:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D2E29C43637
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: remove Comparison to bool in brcms_b_txstatus()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200504113357.41422-1-yanaijie@huawei.com>
References: <20200504113357.41422-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <davem@davemloft.net>,
        <yuehaibing@huawei.com>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jason Yan <yanaijie@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200506084211.50A33C433F2@smtp.codeaurora.org>
Date:   Wed,  6 May 2020 08:42:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> Fix the following coccicheck warning:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:1060:6-12:
> WARNING: Comparison to bool
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

4f5cf93395d7 brcmsmac: remove Comparison to bool in brcms_b_txstatus()

-- 
https://patchwork.kernel.org/patch/11525541/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
