Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC68363191
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 19:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbhDQRfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 13:35:08 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:61937 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236787AbhDQRfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 13:35:07 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618680880; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=vHzVqvpG9stfZc1C1dbqK8QLjSadjvQFwEC9I5Qaof4=;
 b=eoeZiAS3MCYqy3cYVTRhmezAi7YlGUcRulyLjTU563jFDJ1b1KE+re1b325x4l5Vc+45qfmG
 Z0W0PQHIiSmm0dnCqbDytV3Kv/c5PA+sS8INARoxF5f7F/b3uNmY72jiOsraDhdl7seyiNBk
 bxl3k7yvmZ3hjSYEZW47dTyXWgc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 607b1c30215b831afb28ca1e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 17 Apr 2021 17:34:40
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 33E9CC433F1; Sat, 17 Apr 2021 17:34:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D0C2C433D3;
        Sat, 17 Apr 2021 17:34:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8D0C2C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] rtlwifi: rtl8192de: Use DEFINE_SPINLOCK() for
 spinlock
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1617711406-49649-1-git-send-email-huangguobin4@huawei.com>
References: <1617711406-49649-1-git-send-email-huangguobin4@huawei.com>
To:     Huang Guobin <huangguobin4@huawei.com>
Cc:     <huangguobin4@huawei.com>, Ping-Ke Shih <pkshih@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210417173440.33E9CC433F1@smtp.codeaurora.org>
Date:   Sat, 17 Apr 2021 17:34:40 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Huang Guobin <huangguobin4@huawei.com> wrote:

> From: Guobin Huang <huangguobin4@huawei.com>
> 
> spinlock can be initialized automatically with DEFINE_SPINLOCK()
> rather than explicitly calling spin_lock_init().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Guobin Huang <huangguobin4@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

e9642be26a37 rtlwifi: rtl8192de: Use DEFINE_SPINLOCK() for spinlock

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1617711406-49649-1-git-send-email-huangguobin4@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

