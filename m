Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D5B3A81CA
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhFOOH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:07:28 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:43791 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbhFOOHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:07:17 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623765912; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=taXBYyfoEZsgbWtAduieW5mkQkokeO4e0zurDPuaqE4=;
 b=DiWpjaSXA73dS5koSPCBXzfnwAGvMUqNDphXW4rHITml+nijlhxGmWgmbO5+TgxORNYsVC+3
 8TVwqoqe2tC1DOx1FGSVu8h44iJaUOAgPiZILEy/jgNepITXPkyBuFmGj6v4MMdBlcf5f6WT
 SrJq0sPsJCV+Hx2mzJgp7WKaOv4=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60c8b38ded59bf69cc1ceffe (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 14:05:01
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 05B31C4323A; Tue, 15 Jun 2021 14:05:01 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 78BD9C43460;
        Tue, 15 Jun 2021 14:04:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 78BD9C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] ath10k: Use
 devm_platform_get_and_ioremap_resource()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210605110227.2429420-1-yangyingliang@huawei.com>
References: <20210605110227.2429420-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615140501.05B31C4323A@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 14:05:01 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Yingliang <yangyingliang@huawei.com> wrote:

> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

ea1c2023efbc ath10k: Use devm_platform_get_and_ioremap_resource()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210605110227.2429420-1-yangyingliang@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

