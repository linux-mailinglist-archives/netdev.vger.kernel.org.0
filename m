Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B169312F27
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 11:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbhBHKgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 05:36:55 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:43118 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232106AbhBHKef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 05:34:35 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612780458; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=if8BgcAyVuu8lFUgsMnxiuvsLOBk24GIfI2rVHMQR9U=;
 b=MWTZISI34xpXAyZebcTqt7M6NW1fA/rKpCjW3F0nnVmmqFW2TIJ+oJ32oDD06DiuxTZdzhax
 oP+mraDBieiVZCQxxsJbMyUhtthd57ecli/eu2C/KTwKllXgQs5A0K62YRROhiQt+/rvNG2b
 jCwNGAnxo4S+EWXHtRuozaJpEh0=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 6021138334db06ef79402be2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Feb 2021 10:33:39
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B2591C43464; Mon,  8 Feb 2021 10:33:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EECF8C433CA;
        Mon,  8 Feb 2021 10:33:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EECF8C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] rtlwifi: rtl8192se: Simplify bool comparison
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1611043150-78723-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1611043150-78723-1-git-send-email-abaci-bugfix@linux.alibaba.com>
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        Larry.Finger@lwfinger.net, chiu@endlessos.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210208103339.B2591C43464@smtp.codeaurora.org>
Date:   Mon,  8 Feb 2021 10:33:39 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Zhong <abaci-bugfix@linux.alibaba.com> wrote:

> Fix the follow coccicheck warnings:
> 
> ./drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:2305:6-27:
> WARNING: Comparison of 0/1 to bool variable.
> 
> ./drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1376:5-26:
> WARNING: Comparison of 0/1 to bool variable.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>

Patchwork still gives me Abaci team in the from field. I don't take patches
from generic team addresses as I'm not sure what the legal implications are.
[1] Please use your own email address and real name.

Patch set to Changes Requested.

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#developer-s-certificate-of-origin-1-1

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1611043150-78723-1-git-send-email-abaci-bugfix@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

