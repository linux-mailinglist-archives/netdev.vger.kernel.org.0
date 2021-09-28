Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F97E41B231
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241309AbhI1Ohu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:37:50 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:62325 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241290AbhI1Ohu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 10:37:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632839770; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Y5/CZir+NW6I0L7/vstxOHye/LlSBf5Sqm1ovcOBnaM=;
 b=fjPZghaivoXPCWYjevIOSwP+45vt77Ju4zicJbbS5+RXStWbjx+ViztFarcE7UpyeDFM1YkF
 5KhjOr3LuKhvJSPTr638e4fNHRaWjldz+rUrTkLnRPWtNZutIGznQQJlngAa6Ci5VE/VW3Xa
 VrRG/Vn0WTF0Zzhll/VDK/LUDbY=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 6153282a8578ef11edb4182d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 28 Sep 2021 14:35:22
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F25E6C4338F; Tue, 28 Sep 2021 14:35:21 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8BB78C4338F;
        Tue, 28 Sep 2021 14:35:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 8BB78C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix missing frame timestamp for beacon/probe-resp
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1629811733-7927-1-git-send-email-loic.poulain@linaro.org>
References: <1629811733-7927-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210928143521.F25E6C4338F@smtp.codeaurora.org>
Date:   Tue, 28 Sep 2021 14:35:21 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Loic Poulain <loic.poulain@linaro.org> wrote:

> When receiving a beacon or probe response, we should update the
> boottime_ns field which is the timestamp the frame was received at.
> (cf mac80211.h)
> 
> This fixes a scanning issue with Android since it relies on this
> timestamp to determine when the AP has been seen for the last time
> (via the nl80211 BSS_LAST_SEEN_BOOTTIME parameter).
> 
> Fixes: 5e3dd157d7e7 ("ath10k: mac80211 driver for Qualcomm Atheros 802.11ac CQA98xx devices")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

e6dfbc3ba90c ath10k: Fix missing frame timestamp for beacon/probe-resp

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1629811733-7927-1-git-send-email-loic.poulain@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

