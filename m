Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FF44612E4
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 11:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354283AbhK2Kws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 05:52:48 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:52643 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354487AbhK2Kur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 05:50:47 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1638182850; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=2nMJDBN+GqX/wV54zDjXZRK0qNCinY9dlxw2kEJR8mI=;
 b=DErlvBTBSfkES5bHAnMvjhq9QY/244kSZfNRyKxbCYxAC5OeOz1FPRYDrzFWAJqjqLXTjUZe
 xD0LNhpjLBD8kKXmtxGTukiwvvUHqcA6f5QgfzmjN1Rt80tOZs0P71mDjeyjKHb27i+p0QmG
 pXRSF8FZyuaySjQp5Nx9yMavRqM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 61a4afc2135a8a9d0e535b43 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 29 Nov 2021 10:47:30
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 55F26C43617; Mon, 29 Nov 2021 10:47:29 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 99612C4338F;
        Mon, 29 Nov 2021 10:47:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 99612C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] rtlwifi: rtl8192de: Style clean-ups
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211119192233.1021063-1-keescook@chromium.org>
References: <20211119192233.1021063-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Colin Ian King <colin.king@canonical.com>,
        Colin Ian King <colin.king@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163818284377.17830.14790047082768302984.kvalo@codeaurora.org>
Date:   Mon, 29 Nov 2021 10:47:29 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> Clean up some style issues:
> - Use ARRAY_SIZE() even though it's a u8 array.
> - Remove redundant CHANNEL_MAX_NUMBER_2G define.
> Additionally fix some dead code WARNs.
> 
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> Link: https://lore.kernel.org/lkml/57d0d1b6064342309f680f692192556c@realtek.com/
> Signed-off-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

69831173fcbb rtlwifi: rtl8192de: Style clean-ups

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211119192233.1021063-1-keescook@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

