Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA1B2AA68B
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 17:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgKGQEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 11:04:31 -0500
Received: from z5.mailgun.us ([104.130.96.5]:51236 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgKGQEa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 11:04:30 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604765070; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=fzwGxVRJ5Nwqqk27eo+G4LGQ2HkK8Wttic1jWxYKRn0=;
 b=GP+NjtSzqMgxPQvHKKtej3L6vlehRj2IrUKteVCPiqgUN7+xllQuWJWGSrGWGFzVdDU+yBbC
 F2DtzzGIRPDNZlkCitbXEFErrGuL5vfj3Qf4V/1tdbEY+PTxrNn3e0vJ89xcPNY4AjsVJWc9
 UvsQfzZQ+mRaUtNAtA+E0Lm8bac=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5fa6c58c1d3980f7d6c40189 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 16:04:28
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8B823C433F0; Sat,  7 Nov 2020 16:04:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AEBCDC433C8;
        Sat,  7 Nov 2020 16:04:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AEBCDC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 06/41] brcmfmac: bcmsdh: Fix description for function
 parameter 'pktlist'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201102112410.1049272-7-lee.jones@linaro.org>
References: <20201102112410.1049272-7-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107160428.8B823C433F0@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 16:04:28 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c:380: warning: Function parameter or member 'pktlist' not described in 'brcmf_sdiod_sglist_rw'
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c:380: warning: Excess function parameter 'pkt' description in 'brcmf_sdiod_sglist_rw'
> 
> Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
> Cc: Franky Lin <franky.lin@broadcom.com>
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
> Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> Cc: Wright Feng <wright.feng@cypress.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: brcm80211-dev-list.pdl@broadcom.com
> Cc: brcm80211-dev-list@cypress.com
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

3 patches applied to wireless-drivers-next.git, thanks.

6f0d044fc82e brcmfmac: bcmsdh: Fix description for function parameter 'pktlist'
05cefa989e8b brcmfmac: pcie: Provide description for missing function parameter 'devinfo'
9bd28c6607ba brcmfmac: fweh: Add missing description for 'gfp'

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201102112410.1049272-7-lee.jones@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

