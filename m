Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E36124FD6
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 18:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfLRRyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 12:54:15 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:10233 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727175AbfLRRyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 12:54:14 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576691654; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=ajjyd3Yo3+ZsBvu259j63q3wagxykCtDZbUspQRGj2g=;
 b=CjPuGy12TRb62D4vOFBrIepypoNFr3D+s3NJSrJulAf66QZaA3BFmQvTWKnpKxxvbEqf+wR9
 bpF7wqdfvo871ff0XZazzNy5a7yS8k0FB/u/GTlOzmTr8CoMpCxteZ04aCKkP3aGbKhiMhLh
 0iyEo/bDF7mKa+7cuQ1IzIbKyhU=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfa67c4.7f3ccedcf688-smtp-out-n01;
 Wed, 18 Dec 2019 17:54:12 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CA98AC43383; Wed, 18 Dec 2019 17:54:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 14D29C433CB;
        Wed, 18 Dec 2019 17:54:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 14D29C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: fix missing free of skb on error return path
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191212194251.108343-1-colin.king@canonical.com>
References: <20191212194251.108343-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Ganesh Sesetti <gseset@codeaurora.org>,
        Karthikeyan Periyasamy <periyasa@codeaurora.org>,
        John Crispin <john@phrozen.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191218175411.CA98AC43383@smtp.codeaurora.org>
Date:   Wed, 18 Dec 2019 17:54:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> The error handling when the call to ath11k_hal_srng_get_entrysize fails
> leaks skb, fix this by returning via the err_free return path that will
> ensure the skb is free'd.
> 
> Addresses-Coverity: ("Resource leak")
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

4358bcb54bb9 ath11k: fix missing free of skb on error return path

-- 
https://patchwork.kernel.org/patch/11289341/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
