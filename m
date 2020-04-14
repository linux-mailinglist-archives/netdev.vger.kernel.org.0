Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA271A8132
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407223AbgDNPFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:05:02 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:22454 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407172AbgDNPE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 11:04:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586876698; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=it0gpSRDcAsaDyVlnGJ2QcKtZyPaaAyuAv6Y770rulQ=;
 b=CiU7e8sbRLHl9Tu9qFPbsssrUqkKAwIc9QEO13PGd4N8mWo/RSR3f0j99sMDvIv4Ee8PdFLP
 HtZi7sPVd6U8NglCZN9S9/5vyHcvnDLgJQV5B1U36oqDldKjXMqPddzSLDU5B2sFtNR3j7kw
 aQJKisgLzoOpeM2qEdH8jSbfSfQ=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e95d10f.7f78045c7730-smtp-out-n01;
 Tue, 14 Apr 2020 15:04:47 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DEC05C433BA; Tue, 14 Apr 2020 15:04:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2F946C4478F;
        Tue, 14 Apr 2020 15:04:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2F946C4478F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: fix a typo "throld" -> "threshold"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1585837078-6149-1-git-send-email-hqjagain@gmail.com>
References: <1585837078-6149-1-git-send-email-hqjagain@gmail.com>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     amitkarwar@gmail.com, siva8118@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200414150446.DEC05C433BA@smtp.codeaurora.org>
Date:   Tue, 14 Apr 2020 15:04:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qiujun Huang <hqjagain@gmail.com> wrote:

> There is a typo in debug message. Fix it.
> s/throld/threshold
> 
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

f9f46bca59d1 rsi: fix a typo "throld" -> "threshold"

-- 
https://patchwork.kernel.org/patch/11470829/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
