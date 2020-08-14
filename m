Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DDD244B53
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 16:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgHNOp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 10:45:27 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:16739 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728887AbgHNOp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 10:45:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597416325; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=SQs4//8TbfR7d2cP4Bv4Z3+yWKhO+3eaDI8LVupXJxU=;
 b=QKChrGu4r+NCb5fdsLQu+yC/yAQs2QKyyN6jVAsU61sBHe3LuhF2J8cAQJ9g3IrZifyoLABQ
 KaZNl33pwHjvDN34Kxqe1Ae8c8PPhvybmD02M3W1L7r0h5gE7JZ7hwQj9EHzaHntCddM2xUt
 rW2ZaZgZFfhmMqjDEnKr4965ncA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f36a37685672017517a449f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 14 Aug 2020 14:45:10
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2B7EEC433A0; Fri, 14 Aug 2020 14:45:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6A1C7C433C6;
        Fri, 14 Aug 2020 14:45:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6A1C7C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: Fix typo in function name
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200724083910.GA31930@amd>
References: <20200724083910.GA31930@amd>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200814144510.2B7EEC433A0@smtp.codeaurora.org>
Date:   Fri, 14 Aug 2020 14:45:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:

> Typo "destoy" made me wonder if correct patch is wrong; fix it. No
> functional change.
> 
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

743adae9da12 ath9k: Fix typo in function name

-- 
https://patchwork.kernel.org/patch/11682639/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

