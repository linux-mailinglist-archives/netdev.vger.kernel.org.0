Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F98434750
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhJTIw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:52:56 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:50817 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229764AbhJTIwz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 04:52:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634719841; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=HBQ3L1Q9DP2ke7hrN55rY3sAmUH25FHoGf4Xq4g6QAY=;
 b=gG6jAGGYZUMi3Pbh5pjrQJF5FMReIgfPSI21Y2xu9MlbmsP3bWQTo+n71JTLWJaMqtaTjgam
 ZWYx4T6kgVorex/dY9J8AOtoaLwsOieEwQ7/j+uhrp3RJQvT7Zcfd9sXe3f48w3qq0pTTEYu
 02dAabDhtmqwt/CbHfLwIcjrGoE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 616fd8545ca800b6c137d956 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 20 Oct 2021 08:50:28
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CA73DC43460; Wed, 20 Oct 2021 08:50:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 65786C4338F;
        Wed, 20 Oct 2021 08:50:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 65786C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw89: fix error function parameter
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211019035311.974706-1-lv.ruyi@zte.com.cn>
References: <20211019035311.974706-1-lv.ruyi@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, pkshih@realtek.com,
        lv.ruyi@zte.com.cn, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163471982441.1743.9901035714649893101.kvalo@codeaurora.org>
Date:   Wed, 20 Oct 2021 08:50:28 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> This patch fixes the following Coccinelle warning:
> drivers/net/wireless/realtek/rtw89/rtw8852a.c:753:
> WARNING  possible condition with no effect (if == else)
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Failed to apply, please rebase on top of wireless-drivers-next.

error: patch failed: drivers/net/wireless/realtek/rtw89/rtw8852a.c:753
error: drivers/net/wireless/realtek/rtw89/rtw8852a.c: patch does not apply
error: Did you hand edit your patch?
It does not apply to blobs recorded in its index.
hint: Use 'git am --show-current-patch' to see the failed patch
Applying: rtw89: fix error function parameter
Using index info to reconstruct a base tree...
Patch failed at 0001 rtw89: fix error function parameter

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211019035311.974706-1-lv.ruyi@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

