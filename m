Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A962941AD66
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 12:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240331AbhI1K5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 06:57:39 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:49298 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240320AbhI1K5h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 06:57:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632826558; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=z0OOqPlUIz2VSpoSabNQP0cl97JN4q8tbV7qWlpVx6w=;
 b=EzmYK2Y5qt9+IjS+U2SbWNPJoaCQY1r+32G9U8zAD2AQIxfd4ymctEOYaC5te3cXKmXiU832
 ELGNnXvV3wQGP3HdTXMWXFKXYUBkeHRY3dxtg1vZpO9KpD2gkROP88Kb5HZtVkLJY1KEm/6U
 g3O6PakNUq6k0NfYcBN80bV1Qa0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6152f4a1a5a9bab6e857497e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 28 Sep 2021 10:55:29
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9C23DC43619; Tue, 28 Sep 2021 10:55:29 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0C2B3C4338F;
        Tue, 28 Sep 2021 10:55:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 0C2B3C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: qmi: avoid error messages when dma allocation
 fails
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210823063258.37747-1-aaron.ma@canonical.com>
References: <20210823063258.37747-1-aaron.ma@canonical.com>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     aaron.ma@canonical.com, davem@davemloft.net, kuba@kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210928105529.9C23DC43619@smtp.codeaurora.org>
Date:   Tue, 28 Sep 2021 10:55:29 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aaron Ma <aaron.ma@canonical.com> wrote:

> qmi tries to allocate a large contiguous dma memory at first,
> on the AMD Ryzen platform it fails, then retries with small slices.
> So set flag GFP_NOWARN to avoid flooding dmesg.
> 
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

b9b5948cdd7b ath11k: qmi: avoid error messages when dma allocation fails

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210823063258.37747-1-aaron.ma@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

