Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9325149A0B
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 11:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbgAZKZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 05:25:25 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:10293 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729107AbgAZKZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 05:25:25 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580034324; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=0ODxYEpthZoVUaWLihId/bFGPfX3PA2tr9ipVMmLvpw=;
 b=cyAyz/TRpKCRk13ltGKfgz5fYw7Op8cJ8Qf22a31lb6by2pZeo8TKOggbga3IuJgaeLGfc5+
 SHNuXbk0NQaGPLN2ilVqJIP2/emCXhEMepepBZnYgW6mIJUXfSkxAOkkB2od8tlHmtZambqG
 aA693RYt7N281iDyPQ/+WvTeXmU=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2d6912.7fe6e1c59d18-smtp-out-n02;
 Sun, 26 Jan 2020 10:25:22 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BFE7AC447A2; Sun, 26 Jan 2020 10:25:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C4CF4C433CB;
        Sun, 26 Jan 2020 10:25:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C4CF4C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] ath10k: Add optional qdss clk
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191223054855.3020665-2-bjorn.andersson@linaro.org>
References: <20191223054855.3020665-2-bjorn.andersson@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andy Gross <agross@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ath10k@lists.infradead.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126102521.BFE7AC447A2@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 10:25:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Andersson <bjorn.andersson@linaro.org> wrote:

> The WiFi firmware found on sm8150 requires that the QDSS clock is
> ticking in order to operate, so add an optional clock to the binding to
> allow this to be specified in the sm8150 dts and add the clock to the
> list of clocks in the driver.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Acked-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

57a3b60ddbfa ath10k: Add optional qdss clk

-- 
https://patchwork.kernel.org/patch/11307779/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
