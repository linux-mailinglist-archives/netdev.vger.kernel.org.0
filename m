Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F6E431924
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhJRMeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:34:06 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:49986 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhJRMeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:34:06 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634560315; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=JR9U6T89OgvtMGdfLytY6B9PP5hNdlPtQz41jb6E9Zc=;
 b=lcnW+To4/8HzTEyjku2g49NHAUY4FotQ54zZZYcvUes/DXtDIeBg7nSa0V4EHd2P42P7QL88
 Cg5MDHLeDU0+FHQJvhajVn1A+eezbtugQJzvGIqvOsZu0g+0kONMppYmgko87M6Af+xD3sJg
 Q4RA0Y0mL2uqG+PnqWpYEbnGJ6c=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 616d6933f3e5b80f1f0ed6d4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 12:31:47
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 70F44C43460; Mon, 18 Oct 2021 12:31:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 055FCC4338F;
        Mon, 18 Oct 2021 12:31:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 055FCC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] rtw89: Remove redundant check of ret after call to
 rtw89_mac_enable_bb_rf
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211015152113.33179-1-colin.king@canonical.com>
References: <20211015152113.33179-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163456030329.5790.17899781504247161319.kvalo@codeaurora.org>
Date:   Mon, 18 Oct 2021 12:31:47 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The function rtw89_mac_enable_bb_rf is a void return type, so there is
> no return error code to ret, so the following check for an error in ret
> is redundant dead code and can be removed.
> 
> Addresses-Coverity: ("Logically dead code")
> Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

f7e7e440550b rtw89: Remove redundant check of ret after call to rtw89_mac_enable_bb_rf

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211015152113.33179-1-colin.king@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

