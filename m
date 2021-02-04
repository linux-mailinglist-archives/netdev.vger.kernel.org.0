Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350EB30ED8B
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 08:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbhBDHkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 02:40:18 -0500
Received: from so15.mailgun.net ([198.61.254.15]:59119 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234694AbhBDHj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 02:39:57 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612424371; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=PNaFuQrq1FOPPvy1zsUBLo97crEnYUTCs9GUaPLmKcw=;
 b=LcOmEUTEVCJyFU1AikWPXiQ+K+Zsop6/iq4Juq62qO4hBAFLB1hpMc3rj6QMwrsHKuJlYbg7
 GMQm8MVv7jcyDNZAckFOF2LdkoeaUMzv9QHFrA7JsyV+ZsGlWXW1V0/G+LvJYrO+arRazGnR
 a/daDe7UR+mQVWbDZ9yLbhfNqKU=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 601ba49087f205364e832d07 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 04 Feb 2021 07:38:56
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D284BC43463; Thu,  4 Feb 2021 07:38:55 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 53D36C433C6;
        Thu,  4 Feb 2021 07:38:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 53D36C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: remove h from printk format specifier
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210127222344.2445641-1-trix@redhat.com>
References: <20210127222344.2445641-1-trix@redhat.com>
To:     trix@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210204073855.D284BC43463@smtp.codeaurora.org>
Date:   Thu,  4 Feb 2021 07:38:55 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trix@redhat.com wrote:

> This change fixes the checkpatch warning described in this commit
> commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of
>   unnecessary %h[xudi] and %hh[xudi]")
> 
> Standard integer promotion is already done and %hx and %hhx is useless
> so do not encourage the use of %hh[xudi] or %h[xudi].
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

779750bb153d ath10k: remove h from printk format specifier

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210127222344.2445641-1-trix@redhat.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

