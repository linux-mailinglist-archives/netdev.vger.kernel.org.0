Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDEC3B1FD3
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 19:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFWRsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 13:48:38 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:13108 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhFWRsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 13:48:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624470380; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=h/A2TDLPS6fTgNsh3N4g2y4DoKUtcjOH2pYEp4E6Gw8=;
 b=PuSIjABYVSLiGJPDZ6brJ3NBtJxs4UOGDeVu5TkJfdYE5ZdK9KcOCm2ZjYiGts8eJ/SI6W+8
 hqif6ZsMXaJkqQGPlwnoCykQghjdpl3xarl3waWVVk2oFJ88YOrqK3yvCBbfEtdCfeCJUO2a
 qGsqcl03xgE0zBDXTw7NqkE9Vp4=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60d373582a2a9a976156729e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 23 Jun 2021 17:46:00
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 30CBAC43143; Wed, 23 Jun 2021 17:46:00 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 716CBC433D3;
        Wed, 23 Jun 2021 17:45:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 716CBC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] cfg80211: Add wiphy_info_once()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210511211549.30571-1-digetx@gmail.com>
References: <20210511211549.30571-1-digetx@gmail.com>
To:     Dmitry Osipenko <digetx@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210623174600.30CBAC43143@smtp.codeaurora.org>
Date:   Wed, 23 Jun 2021 17:46:00 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Osipenko <digetx@gmail.com> wrote:

> Add wiphy_info_once() helper that prints info message only once.
> 
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

2 patches applied to wireless-drivers-next.git, thanks.

761025b51c54 cfg80211: Add wiphy_info_once()
78f0a64f66d4 brcmfmac: Silence error messages about unsupported firmware features

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210511211549.30571-1-digetx@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

