Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE20E553
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 16:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfD2Ouk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 10:50:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42016 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728350AbfD2Ouj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 10:50:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3C462605A2; Mon, 29 Apr 2019 14:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556549439;
        bh=Med0BVNCDB0qzfpASZ4nce6f8HqonA2tKuVNkYHuYQI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Ah5nNChgvOOw6mOmFgT7PL5tXnN5pdBdG8kBIovG6ogqF8qbt5KsONyyvZkLpNIjB
         iHA5ZelqrKgwdeoAq1WjsWY1uy7C6x7mOROm+Nl2EMGKIIgilQgFUF5X4HfHK5XD86
         Pp1cZMfjQaEqBwWVBT0/ZyO1POKTO3k9qaBrZKY0=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6E88060214;
        Mon, 29 Apr 2019 14:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556549438;
        bh=Med0BVNCDB0qzfpASZ4nce6f8HqonA2tKuVNkYHuYQI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=eqFUYsKYQ/rCJUcCjTjobW0O2VTsNvQOhxsfHu/6Vez8QwUFRBnH2SFAdOuS/hTka
         078kCQE1N3wui2PpI8xCGaKM64GRqIyWR4Z7C7brfagSNkF0X27Q+RnnMzJET9Fi0g
         85S8YUEwaylKD48uLyOKMcmKhJgH1fTa5g5PbpL8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6E88060214
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath6kl: remove redundant check of status != 0
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190404134723.24667-1-colin.king@canonical.com>
References: <20190404134723.24667-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190429145039.3C462605A2@smtp.codeaurora.org>
Date:   Mon, 29 Apr 2019 14:50:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> The check on status not being zero is redundant as previous code
> paths that set status to an error value break out of the while
> loop and hence status is never non-zero at the check. Remove
> this redundant code.
> 
> Addresses-Coverity: ("Logically dead code")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

e643da21e19a ath6kl: remove redundant check of status != 0

-- 
https://patchwork.kernel.org/patch/10885625/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

