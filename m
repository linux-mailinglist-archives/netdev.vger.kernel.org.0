Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EF43FA9EF
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 09:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234814AbhH2Hbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 03:31:34 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:11599 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbhH2Hbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 03:31:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630222242; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=DHvXwT1LctpTZp4W8bTzih3oWrD/e7ln1sSyPPM0QXc=;
 b=jwbFF8HAntSGaneavgDdtg2727B8qDA84QKRXVxv9S9YxO3q9rONTW+b91kMH6uV+5moiEc7
 VRbHCwwvpnUAebR1Ha+3sieAfkI8I2GyWcE8laN62Ua2gCla4T4hGd1myNvPI4KBDcuGlUc5
 ccRMMX8NEOYAjswptos1UEupZQQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 612b37944cd90150371dde68 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 29 Aug 2021 07:30:28
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 69AECC43460; Sun, 29 Aug 2021 07:30:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 45C3FC4338F;
        Sun, 29 Aug 2021 07:30:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 45C3FC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtlwifi: rtl8192de: Style clean-ups
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210826023230.1148924-1-keescook@chromium.org>
References: <20210826023230.1148924-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Colin Ian King <colin.king@canonical.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Kaixu Xia <kaixuxia@tencent.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210829073028.69AECC43460@smtp.codeaurora.org>
Date:   Sun, 29 Aug 2021 07:30:28 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> Clean up some style issues:
> - Use ARRAY_SIZE() for arrays (even when u8 sized)
> - Remove redundant CHANNEL_MAX_NUMBER_2G define.
> Additionally fix some dead code WARNs.
> 
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Colin Ian King <colin.king@canonical.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Failed to apply, please rebase over wireless-drivers-next.

error: sha1 information is lacking or useless (drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c).
error: could not build fake ancestor
hint: Use 'git am --show-current-patch' to see the failed patch
Applying: rtlwifi: rtl8192de: Style clean-ups
Patch failed at 0001 rtlwifi: rtl8192de: Style clean-ups

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210826023230.1148924-1-keescook@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

