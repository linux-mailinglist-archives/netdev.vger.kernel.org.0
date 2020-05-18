Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06B41D785B
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 14:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgERMTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 08:19:49 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:38252 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726682AbgERMTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 08:19:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589804388; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=RkLZWqjK5J2QQRE7bqK/5Ne832290KHKl7J2BIb/wP8=;
 b=Uy9asZZduAWGAzGiob23+fgzhdqmNcsCQy7DfK+melehbZopM5Vt0kPUNZfIPfLKykzrAt2C
 E2WyAWQsPi1dCKUgXWfioSS4lYE8DOAFxVYtW0Ytgvq9U/pe1c06JTV72lLq9He6Yk2DHSmD
 9ZV/P94ZrQ+a7jND1BnAi7JWReM=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ec27d54.7fdbc1d299d0-smtp-out-n03;
 Mon, 18 May 2020 12:19:32 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CBE53C433D2; Mon, 18 May 2020 12:19:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3A4DAC433F2;
        Mon, 18 May 2020 12:19:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3A4DAC433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8192ee: remove redundant for-loop
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200515102226.29819-1-colin.king@canonical.com>
References: <20200515102226.29819-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200518121932.CBE53C433D2@smtp.codeaurora.org>
Date:   Mon, 18 May 2020 12:19:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The for-loop seems to be redundant, the assignments for indexes
> 0..2 are being over-written by the last index 3 in the loop. Remove
> the loop and use index 3 instead.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

b0a4bb7693be rtlwifi: rtl8192ee: remove redundant for-loop

-- 
https://patchwork.kernel.org/patch/11551059/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
