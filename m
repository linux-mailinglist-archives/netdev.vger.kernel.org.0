Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7592FD6A6
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 07:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfKOG7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 01:59:04 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57008 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbfKOG7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 01:59:03 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D8ACB60FCE; Fri, 15 Nov 2019 06:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573801142;
        bh=z5KxkEjc5934okYiimYZ65jjTiQWO34Ga0VC5decT1U=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ow2MkMlRCBluA/rOacNYhpM2TDxIqBA+BXB8VEzBRVFx5mBR3kkRoMOBkK7X+Hzqr
         s2kH1aiveG5VLN9a3ksA7aLPE1ALophRnCcPULJ7QGie9VUXxnv2B5cPuLlsPF9ixA
         g2aVo2HU8PAN0nN2aAbibsgwiCAN2NfI++T/DAkc=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D9376013C;
        Fri, 15 Nov 2019 06:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573801142;
        bh=z5KxkEjc5934okYiimYZ65jjTiQWO34Ga0VC5decT1U=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=oYPi8lrU4ttup+FzvAoFqZG/KLYQBO7lzQKThBLCVv1mL6uNpQ6IIdDU1WCP40b4K
         5cP9ZmE+2ZYHoWv8mNtvSWua+Nk3dEamDEZo8W4+oGg62N4sKEfwWym80sTo+LzwXq
         O7QtZCc9R/RUVmEXjhW6GTfOOmVfMGD76PFbAc+8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8D9376013C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: qmi: Sleep for a while before assigning MSA memory
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191113233558.4040259-1-bjorn.andersson@linaro.org>
References: <20191113233558.4040259-1-bjorn.andersson@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, govinds@codeaurora.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191115065902.D8ACB60FCE@smtp.codeaurora.org>
Date:   Fri, 15 Nov 2019 06:59:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Andersson <bjorn.andersson@linaro.org> wrote:

> Unless we sleep for a while before transitioning the MSA memory to WLAN
> the MPSS.AT.4.0.c2-01184-SDM845_GEN_PACK-1 firmware triggers a security
> violation fairly reliably. Unforutnately recovering from this failure
> always results in the entire system freezing.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

b70b3a36ec33 ath10k: qmi: Sleep for a while before assigning MSA memory

-- 
https://patchwork.kernel.org/patch/11242883/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

