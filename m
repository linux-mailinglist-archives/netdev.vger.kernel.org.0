Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054A5B4FDE
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 16:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfIQOEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 10:04:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46396 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfIQOEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 10:04:46 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 702E36021C; Tue, 17 Sep 2019 14:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568729085;
        bh=rAaMYvqbeLheWv8CIxiDyX/e12oeMdBVoUmnUwywv5Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nV2umR6R289up963IQf51z4elD/8hSfUfS7xrdnSVc8eic0ZFzWYNRHiHiC1zVyno
         i9iXTtZEOsP45lU5RnXEhyhq5pMNIIW/uxBtWWNvzoqsomYIkZVxX6d1Fvfa8bqOaR
         LHBMs0BVnAgGxRARt6Vdh4c53Jwxm30DPn/hdccc=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 24BF36016D;
        Tue, 17 Sep 2019 14:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568729084;
        bh=rAaMYvqbeLheWv8CIxiDyX/e12oeMdBVoUmnUwywv5Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=HXDHo5T2HJtx2ogcRKuCOwqk+wlVKzcov6Qhn/RIBADhCetuRZIt2f8kOYCBGWsFy
         FhKPiZcsSsRMJTti+2r6vWZYRkLOGYHiK03XQvksaTVvclmN2vxtjTncFjF2jCoj71
         qYCeRk2Wcljgm7Pyx2QtZq1kBDDoZJRAsbD8ckvI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 24BF36016D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] ath10k: snoc: skip regulator operations
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190725174755.23432-2-bjorn.andersson@linaro.org>
References: <20190725174755.23432-2-bjorn.andersson@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Govind Singh <govinds@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190917140445.702E36021C@smtp.codeaurora.org>
Date:   Tue, 17 Sep 2019 14:04:45 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Andersson <bjorn.andersson@linaro.org> wrote:

> The regulator operations is trying to set a voltage to a fixed value, by
> giving some wiggle room. But some board designs specifies regulator
> voltages outside this limited range. One such example is the Lenovo Yoga
> C630, with vdd-3.3-ch0 in particular specified at 3.1V.
> 
> But consumers with fixed voltage requirements should just rely on the
> board configuration to provide the power at the required level, so this
> code should be removed.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

3 patches applied to ath-next branch of ath.git, thanks.

b003e7f1974e ath10k: snoc: skip regulator operations
c56c7f24d7f8 ath10k: Use standard regulator bulk API in snoc
f93bcf0ce6a1 ath10k: Use standard bulk clock API in snoc

-- 
https://patchwork.kernel.org/patch/11059507/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

