Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243211A8198
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437210AbgDNPK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:10:29 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:48379 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440356AbgDNPKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 11:10:17 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586877016; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=tepjwD/hNWYLeoWHiPRU+tsDl8hByguPwDYoURmg1YI=;
 b=LOUwHo16ExQdck1GaRJdxF6zua4qYzUpFkqz6tDpPctkidTbp1g8eQ8HNpztbtMzFNmBC8QO
 +xe7SKdSNC5tRvTkScdL3WR8J8Lr3MnOeoU99mtFlBPcOkyUtCH4fsF+A9mYQctWkIgo7O0e
 Rmi1Hx4ZptaSRMG16LTEzj27p58=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e95d252.7fe345cd90a0-smtp-out-n02;
 Tue, 14 Apr 2020 15:10:10 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 966EFC4478C; Tue, 14 Apr 2020 15:10:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D1A4C432C2;
        Tue, 14 Apr 2020 15:10:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8D1A4C432C2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: make brcms_c_set_mac() void
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200410090817.26883-1-yanaijie@huawei.com>
References: <20200410090817.26883-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <davem@davemloft.net>,
        <eduardoabinader@gmail.com>, <christophe.jaillet@wanadoo.fr>,
        <yanaijie@huawei.com>, <austindh.kim@gmail.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200414151010.966EFC4478C@smtp.codeaurora.org>
Date:   Tue, 14 Apr 2020 15:10:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> Fix the following coccicheck warning:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:3773:5-8:
> Unneeded variable: "err". Return "0" on line 3781
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

fd7fb0253cdf brcmsmac: make brcms_c_set_mac() void

-- 
https://patchwork.kernel.org/patch/11483033/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
