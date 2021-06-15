Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738743A8075
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhFONkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:40:31 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:33180 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231774AbhFONkB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 09:40:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623764276; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=snmCX2EFlFgmWR8J4rbq8J/CpFX74I3NDeCVNzQn58Y=;
 b=UcMx5zVXbUosxptmjRTiF+MZFB3GQWTDG3HppXLs3klieT2H8Fu4hyxYUJWoVml8pPLRpHL7
 hcxnqnVif98SRlpSkArdnfyAGLh7gzByJCqM9PwufSByO0NUuCrP8cfBM1mhelIpE42/fPbf
 +KVd10F78zndlE2PGAZcMP1fzgA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 60c8ad30e570c05619e1bd80 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 13:37:52
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1037AC4338A; Tue, 15 Jun 2021 13:37:52 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 89AC1C433F1;
        Tue, 15 Jun 2021 13:37:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 89AC1C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: Add support for changing beacon interval
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210507213149.140192-1-marex@denx.de>
References: <20210507213149.140192-1-marex@denx.de>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Karun Eagalapati <karun256@gmail.com>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615133752.1037AC4338A@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 13:37:52 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marek Vasut <marex@denx.de> wrote:

> Pick code for changing the beacon interval (e.g. using beacon_int in
> hostap config) from the downstream RSI driver.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> Cc: Angus Ainslie <angus@akkea.ca>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Karun Eagalapati <karun256@gmail.com>
> Cc: Martin Kepplinger <martink@posteo.de>
> Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> Cc: Siva Rebbagondla <siva8118@gmail.com>
> Cc: netdev@vger.kernel.org

Patch applied to wireless-drivers-next.git, thanks.

29ca9e6ca5a5 rsi: Add support for changing beacon interval

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210507213149.140192-1-marex@denx.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

