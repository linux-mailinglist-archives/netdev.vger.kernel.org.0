Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162393DCB22
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 12:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbhHAK3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 06:29:41 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:27951 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbhHAK3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 06:29:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627813773; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=kI8QKN3K1BBYtKBZNl9UungW8huvoQTqjpmtT8Qyby4=;
 b=TXGSH+KLRca42q+n7f/CAWEEUjmoFzz0zmYae96dpGDquC40ARASQtGQQEVYCINGAsbfpNOx
 +jeJi74yvTnkin5ZqpjsNGSDRJWXaNCK7Oo7lAA8sx4Z1bPgfSX8Nmcf2Dndv/f4S+g8E0fG
 rQwCVEbelx8+nrPcNiSt4dl0kHQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 6106777de81205dd0a72ab1b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 01 Aug 2021 10:29:17
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7473EC43460; Sun,  1 Aug 2021 10:29:17 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AA05DC433F1;
        Sun,  1 Aug 2021 10:29:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AA05DC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: libertas: Remove unnecessary label of lbs_ethtool_get_eeprom
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210625121108.162868-1-dingsenjie@163.com>
References: <20210625121108.162868-1-dingsenjie@163.com>
To:     dingsenjie@163.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210801102917.7473EC43460@smtp.codeaurora.org>
Date:   Sun,  1 Aug 2021 10:29:17 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dingsenjie@163.com wrote:

> From: dingsenjie <dingsenjie@yulong.com>
> 
> The label is only used once, so we delete it and use the
> return statement instead of the goto statement.
> 
> Signed-off-by: dingsenjie <dingsenjie@yulong.com>

Patch applied to wireless-drivers-next.git, thanks.

18cb62367a8f libertas: Remove unnecessary label of lbs_ethtool_get_eeprom

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210625121108.162868-1-dingsenjie@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

