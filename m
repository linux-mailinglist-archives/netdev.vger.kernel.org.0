Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3613C3FA9DC
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 09:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbhH2HMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 03:12:41 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:57245 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234786AbhH2HMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 03:12:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630221107; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=rdw9/8bHnwwsoVbf42Ulsr5RJ2mcNDZEWjAyuAJbV0c=;
 b=SZvSWEjYZkD16OL+yoddsAIN6uKSA8TLc4ppYZcOe4VYs3ma7BLW+WN0IMSeKkvm/MUzUNW6
 9lMs/7lNm7bURDQekTjzgw5X6IJn+Y/08RlGDKUnZaaZSmk0/n2c25r0cp4x3efmm7CTlZ4u
 jWFEsrqVsyxkxlnXlW3JNyk6mo8=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 612b333040d2129ac19ea286 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 29 Aug 2021 07:11:44
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B4372C43617; Sun, 29 Aug 2021 07:11:44 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3E586C4360D;
        Sun, 29 Aug 2021 07:11:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 3E586C4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wcn36xx: Fix missing frame timestamp for
 beacon/probe-resp
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1629992768-23785-1-git-send-email-loic.poulain@linaro.org>
References: <1629992768-23785-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210829071144.B4372C43617@smtp.codeaurora.org>
Date:   Sun, 29 Aug 2021 07:11:44 +0000 (UTC)
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
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

8678fd31f2d3 wcn36xx: Fix missing frame timestamp for beacon/probe-resp

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1629992768-23785-1-git-send-email-loic.poulain@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

