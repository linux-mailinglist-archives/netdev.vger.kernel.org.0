Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A79258FE5
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgIANyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 09:54:37 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:17550 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728142AbgIANRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 09:17:12 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598966225; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=YM9Qu8iaSg17vOiKOSEaiOrrZ7khXhVMHrg6aC0+lAE=;
 b=Qba4J2+2uhq9n+3nK6eWd1RdtuZIyZYHEedyuftHjdqR+6SSVPHKtV3027c8tQXa03wBYcuT
 Fk1yNT2RGVZrSx+jzWK4ulLeazs9ZgQKBzb+iZ5lgMpkkuQQQXlhsQMceKvb9+mjy+g7ClFD
 OlVFJvaKP0dWnMxuPGf+HBfMzq4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5f4e49c573afa3417edf4f2e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Sep 2020 13:16:53
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 546FEC43391; Tue,  1 Sep 2020 13:16:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7E87DC433C6;
        Tue,  1 Sep 2020 13:16:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7E87DC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [27/30] brcmsmac: phy_lcn: Remove a bunch of unused variables
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200826093401.1458456-28-lee.jones@linaro.org>
References: <20200826093401.1458456-28-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200901131652.546FEC43391@smtp.codeaurora.org>
Date:   Tue,  1 Sep 2020 13:16:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  In file included from drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:11:
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c: In function ‘wlc_lcnphy_rx_iq_cal’:
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:1366:29: warning: variable ‘RFOverride0_old’ set but not used [-Wunused-but-set-variable]
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c: In function ‘wlc_lcnphy_radio_2064_channel_tune_4313’:
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:1667:21: warning: variable ‘qFvco’ set but not used [-Wunused-but-set-variable]
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:1667:14: warning: variable ‘qFref’ set but not used [-Wunused-but-set-variable]
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:1667:6: warning: variable ‘qFxtal’ set but not used [-Wunused-but-set-variable]
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c: In function ‘wlc_lcnphy_idle_tssi_est’:
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:2856:6: warning: variable ‘idleTssi’ set but not used [-Wunused-but-set-variable]
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c: In function ‘wlc_lcnphy_tx_iqlo_soft_cal_full’:
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:3861:53: warning: variable ‘locc4’ set but not used [-Wunused-but-set-variable]
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:3861:46: warning: variable ‘locc3’ set but not used [-Wunused-but-set-variable]
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:3861:39: warning: variable ‘locc2’ set but not used [-Wunused-but-set-variable]
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:3861:32: warning: variable ‘iqcc0’ set but not used [-Wunused-but-set-variable]
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c: In function ‘wlc_lcnphy_periodic_cal’:
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:4196:6: warning: variable ‘rx_iqcomp_sz’ set but not used [-Wunused-but-set-variable]
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:4195:33: warning: variable ‘rx_iqcomp’ set but not used [-Wunused-but-set-variable]
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:4194:16: warning: variable ‘full_cal’ set but not used [-Wunused-but-set-variable]
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c: In function ‘wlc_phy_txpwr_srom_read_lcnphy’:
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:4919:7: warning: variable ‘opo’ set but not used [-Wunused-but-set-variable]
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

4 patches applied to wireless-drivers-next.git, thanks.

38c95e0258a0 brcmsmac: phy_lcn: Remove a bunch of unused variables
a36e4e4a898b brcmsmac: phy_n: Remove a bunch of unused variables
ebcfc66f56a4 brcmsmac: phytbl_lcn: Remove unused array 'dot11lcnphytbl_rx_gain_info_rev1'
e1920d6ae6bd brcmsmac: phytbl_n: Remove a few unused arrays

-- 
https://patchwork.kernel.org/patch/11737697/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

