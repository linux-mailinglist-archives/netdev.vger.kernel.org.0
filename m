Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C003F1A9759
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895026AbgDOIrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:47:32 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:36832 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895027AbgDOIr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 04:47:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586940448; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=fvi4ED+QTGD3lFB2nEF4L9OZBm+1tfFfScpv1utfIDM=;
 b=OQYquMdQtA/7iOoBLCZSNjxZmrVMT/dWzPvFY7Oklj7o/V7/+QxMNXUPTLPCkvOoc0F3/wQX
 p1KtNv+hLDkmlP0d+htONlIoqFsM9PMkoOVCtL+cGIqdVhr+36qqJi6nETGkm6jZceYTgeKz
 YoMmsmtiy+8toyMhqSw7GdR87b0=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e96ca1c.7fe7ecffb880-smtp-out-n02;
 Wed, 15 Apr 2020 08:47:24 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BC0D7C433F2; Wed, 15 Apr 2020 08:47:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B0301C433BA;
        Wed, 15 Apr 2020 08:47:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B0301C433BA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] orinoco: remove useless variable 'err' in
 spectrum_cs_suspend()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200413082043.22468-1-yanaijie@huawei.com>
References: <20200413082043.22468-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <davem@davemloft.net>, <yanaijie@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200415084723.BC0D7C433F2@smtp.codeaurora.org>
Date:   Wed, 15 Apr 2020 08:47:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> Fix the following coccicheck warning:
> 
> drivers/net/wireless/intersil/orinoco/spectrum_cs.c:281:5-8: Unneeded
> variable: "err". Return "0" on line 286
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

7b9ae69d5441 orinoco: remove useless variable 'err' in spectrum_cs_suspend()

-- 
https://patchwork.kernel.org/patch/11485247/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
