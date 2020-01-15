Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A51E13BC40
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 10:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbgAOJS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 04:18:27 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:29782 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729414AbgAOJS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 04:18:27 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579079906; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=LwpyJ0UYPR60KAvjTtDBpUcnBmCujeM5UzXPAG1UXVM=;
 b=OqdshJ+skMLiMQKXatqTOXUU7eZ4OwaAdF3lEl71m0TrFWFY9kO8lY4EJrknYBEcXkah3S0l
 jLwKDjIpZBkdC8QqPPqX5HzlvX5BLy+NqGVqphTdIXBvei4W16IsUI2c3RqM72nC9LgAEh8i
 cOvIcgFcAupo7Ya6CSipsqRH9rg=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e1ed8dd.7f4002311fb8-smtp-out-n02;
 Wed, 15 Jan 2020 09:18:21 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1A5C0C43383; Wed, 15 Jan 2020 09:18:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8CF1EC433CB;
        Wed, 15 Jan 2020 09:18:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8CF1EC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next] ath11k: add dependency for struct ath11k member
 debug
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191213012417.130719-1-maowenan@huawei.com>
References: <20191213012417.130719-1-maowenan@huawei.com>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     <davem@davemloft.net>, <msinada@codeaurora.org>,
        <periyasa@codeaurora.org>, <mpubbise@codeaurora.org>,
        <julia.lawall@lip6.fr>, <milehu@codeaurora.org>,
        <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200115091820.1A5C0C43383@smtp.codeaurora.org>
Date:   Wed, 15 Jan 2020 09:18:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mao Wenan <maowenan@huawei.com> wrote:

> If CONFIG_ATH11K, CONFIG_MAC80211_DEBUGFS are set,
> and CONFIG_ATH11K_DEBUGFS is not set, below error can be found,
> drivers/net/wireless/ath/ath11k/debugfs_sta.c: In function ath11k_dbg_sta_open_htt_peer_stats:
> drivers/net/wireless/ath/ath11k/debugfs_sta.c:411:4: error: struct ath11k has no member named debug
>   ar->debug.htt_stats.stats_req = stats_req;
> 
> It is to add the dependency for the member of struct ath11k.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Arnd already did something what I proposed:
https://patchwork.kernel.org/patch/11321921/

Patch set to Superseded.

-- 
https://patchwork.kernel.org/patch/11289709/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
