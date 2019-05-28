Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D60D2C669
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfE1MZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:25:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33284 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfE1MZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:25:24 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DF3AF601D4; Tue, 28 May 2019 12:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559046323;
        bh=AI20FMSNCMoT+7BIugoyP/HWgsbE34P8Gvcfdx+kBm8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AVgCSGUsuZtpSO5eqj6pCwcNAjF4ueGf8qXUgJVduZZHHW3ZDWRs/jVYDVa16hAfo
         aq2Lms1V8hnQRyDGDpjb5UnXYTDXbkL1HUlW2rVG0BBc/gCFT/GD+CoIdyMhzXqwSl
         KTMV5Cq69VkFUA0UTZ9ZIVYFi6ujnxCOKEe4MW7Q=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7AC39601D4;
        Tue, 28 May 2019 12:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559046323;
        bh=AI20FMSNCMoT+7BIugoyP/HWgsbE34P8Gvcfdx+kBm8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=P1pv4LSaJNbCFuRRT7xH+xrkJlJHNz9JT5LVnHBYSJmJ5+ChNtfulkgT5jp/W7rvO
         bCI+oRHyK/gzJEQsxUUvGcvjCedtTacbsiej+zBKLvah3n+0eU7ZFiUAuev1QzUDbP
         n6wtT0VuEKTn4LbKOTG33GiiLEQ2Zpy146H6/Ufo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7AC39601D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] brcmfmac: fix typos in code comments
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190520122825.981-1-houweitaoo@gmail.com>
References: <20190520122825.981-1-houweitaoo@gmail.com>
To:     Weitao Hou <houweitaoo@gmail.com>
Cc:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, davem@davemloft.net, houweitaoo@gmail.com,
        rafal@milecki.pl, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190528122523.DF3AF601D4@smtp.codeaurora.org>
Date:   Tue, 28 May 2019 12:25:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Weitao Hou <houweitaoo@gmail.com> wrote:

> fix lengh to length
> 
> Signed-off-by: Weitao Hou <houweitaoo@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

b07e1ae2ce53 brcmfmac: fix typos in code comments

-- 
https://patchwork.kernel.org/patch/10950995/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

