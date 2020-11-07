Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB6E2AA4A5
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 12:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgKGL3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 06:29:46 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:17449 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbgKGL3p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 06:29:45 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604748585; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=sFmbem9F+Bz5N7SLkV+Z80+ySGpiAl7SB5uFGiSBdGw=;
 b=he0BirRSgsGq+HdbxrhHm72fU60544yzEjGI9revz22mivClNu0ncdUkgLX55/txtlkCMU//
 ciRv00NS4smknWzCCWDdEgrlOxpk4m3naKENdhre6dA304dxLIBkfT5UiIxVRANlsmKZs6iy
 Yjf0PIhW5smOvioHu2okHDwxaZU=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fa6852123a1a2b32d60cf14 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 11:29:37
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 204C4C43387; Sat,  7 Nov 2020 11:29:37 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8A493C433C8;
        Sat,  7 Nov 2020 11:29:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8A493C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 2/3] wireless: mt7601u: convert tasklets to use new
 tasklet_setup() API
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201007103309.363737-3-allen.lkml@gmail.com>
References: <20201007103309.363737-3-allen.lkml@gmail.com>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     davem@davemloft.net, nbd@nbd.name, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, kuba@kernel.org, matthias.bgg@gmail.com,
        ath11k@lists.infradead.org, linux-mediatek@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107112937.204C4C43387@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 11:29:37 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allen Pais <allen.lkml@gmail.com> wrote:

> From: Allen Pais <apais@linux.microsoft.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <apais@linux.microsoft.com>

Patch applied to wireless-drivers-next.git, thanks.

7eae05184f3a wireless: mt7601u: convert tasklets to use new tasklet_setup() API

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201007103309.363737-3-allen.lkml@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

