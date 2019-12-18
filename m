Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2F23124FB3
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 18:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfLRRvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 12:51:48 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:22177 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727121AbfLRRvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 12:51:48 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576691507; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=qcFf0FyU4x5oudbQGnj/R9wZVmZ932V5KGDb3JkKqk8=;
 b=lpouyaLLSZsfgWlNhA63mcrG3Ui2+iW3LE1qtsF7JMN/AGZMZnW4er+lstY0baubQMHAeFir
 jcTNwbrZ2Bl2BYAMPjrQiGxsFht8Hufsx7BGfxcjjY/XGjxbqEa+y2R0eq7iPr/IsO0JzQCX
 ZCyTW1puly1ZU3fOV+m8btbur1M=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfa6732.7efbe1f66538-smtp-out-n01;
 Wed, 18 Dec 2019 17:51:46 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A215EC447A2; Wed, 18 Dec 2019 17:51:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 87E3DC43383;
        Wed, 18 Dec 2019 17:51:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 87E3DC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: Remove unnecessary enum scan_priority
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191211192252.35024-1-natechancellor@gmail.com>
References: <20191211192252.35024-1-natechancellor@gmail.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191218175145.A215EC447A2@smtp.codeaurora.org>
Date:   Wed, 18 Dec 2019 17:51:45 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> wrote:

> Clang warns:
> 
> drivers/net/wireless/ath/ath11k/wmi.c:1827:23: warning: implicit
> conversion from enumeration type 'enum wmi_scan_priority' to different
> enumeration type 'enum scan_priority' [-Wenum-conversion]
>         arg->scan_priority = WMI_SCAN_PRIORITY_LOW;
>                            ~ ^~~~~~~~~~~~~~~~~~~~~
> 1 warning generated.
> 
> wmi_scan_priority and scan_priority have the same values but the wmi one
> has WMI prefixed to the names. Since that enum is already being used,
> get rid of scan_priority and switch its one use to wmi_scan_priority to
> fix this warning.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Link: https://github.com/ClangBuiltLinux/linux/issues/808
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

509421acab69 ath11k: Remove unnecessary enum scan_priority

-- 
https://patchwork.kernel.org/patch/11286141/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
