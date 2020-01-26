Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211EC149B1B
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 15:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbgAZO35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 09:29:57 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:52779 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728977AbgAZO3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 09:29:53 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580048992; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=IIMDGd4zV+ZgbPiKxg03y4lXV+gjwEI2OaWScM763GA=;
 b=kUXyMiP8ouGN/Xvx5b8VEju775/hUEE2lQyD/7RI66ozk144nmhAL0y4nJGre+nGZHNjBFOs
 34urMLa52hC11bkTWKMTu29SLzjpzn36dXvPj/AOdEK71OyT5xcjE45egRchXL+INliraz6t
 TurOAZLVmDXvZlNjKg+L6z6tZZE=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2da25e.7fe44d070928-smtp-out-n02;
 Sun, 26 Jan 2020 14:29:50 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A54F3C4479F; Sun, 26 Jan 2020 14:29:49 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0ACB1C433CB;
        Sun, 26 Jan 2020 14:29:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0ACB1C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Add newlines to printk messages
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200123232456.36197-1-swboyd@chromium.org>
References: <20200123232456.36197-1-swboyd@chromium.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126142949.A54F3C4479F@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 14:29:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Boyd <swboyd@chromium.org> wrote:

> Some printks in here don't have newlines at the end, meaning the log
> will be sort of hard to read. Add newlines.
> 
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

79a4b788451d ath10k: Add newlines to printk messages

-- 
https://patchwork.kernel.org/patch/11349347/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
