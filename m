Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931883B9FF3
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 13:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhGBLnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 07:43:19 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:40380 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbhGBLnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 07:43:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1625226047; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Avzvx99wwDIP2UbQgBX/dKZfsj1Y5q+1YnQq3u4uMgQ=;
 b=jwI/JIhuZ+0PSOXKh+pqnxs3mL8/dYp9E8g8tC5y0yOw82PS+WcnaWUmJv717zuo4Mtj3Y7V
 JGEl1OeALsQjrK50auf+QOlvVA0KYVZMcjYUNOhANfy8y40vP/wEh81j2KFGUpY5tku4G6bI
 MXFgEnWSR3oWGxlx4YFoZ+QspyE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 60defb355e3e57240b7cba65 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 02 Jul 2021 11:40:37
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5D187C433F1; Fri,  2 Jul 2021 11:40:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A5C19C433D3;
        Fri,  2 Jul 2021 11:40:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A5C19C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: Remove some duplicate code
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <a65952db7f4eb8aaaa654b77dcd4930482f5c49b.1624483438.git.christophe.jaillet@wanadoo.fr>
References: <a65952db7f4eb8aaaa654b77dcd4930482f5c49b.1624483438.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210702114036.5D187C433F1@smtp.codeaurora.org>
Date:   Fri,  2 Jul 2021 11:40:36 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> 'ATH11K_HE_MCS_MAX' is 11, so these 2 blocks of code are exactly the same.
> Remove the one that uses a hard-coded constant.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

0791ba2bc7d3 ath11k: Remove some duplicate code

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/a65952db7f4eb8aaaa654b77dcd4930482f5c49b.1624483438.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

