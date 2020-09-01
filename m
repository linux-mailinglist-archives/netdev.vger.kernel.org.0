Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65FD258B65
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 11:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgIAJXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 05:23:18 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:33689 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgIAJXR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 05:23:17 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598952196; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=+3+hIhGFV1JUt+MIA6bQuq1ot+biRaEdMkNDAHqT4rI=;
 b=lGHavipVT9j0U6z4Rd39A7TWgHXk/0IMqY2xT+76VRIG+kmzcoArmwXlLY3ix2GTP125h2bZ
 r4q48tyB8A49kKuhGIhrINESvBMLumbAsm1f6zzwt6ZKF3OvXcofjY6c1jElj1GboyQrJRJf
 eCjqFB1bd/O3J82n1/AUr5btGys=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5f4e13047f21d51b301062af (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Sep 2020 09:23:16
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D6178C43387; Tue,  1 Sep 2020 09:23:15 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 85CE9C433C6;
        Tue,  1 Sep 2020 09:23:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 85CE9C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [16/32] brcmfmac: btcoex: Update 'brcmf_btcoex_state' and demote
 others
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200821071644.109970-17-lee.jones@linaro.org>
References: <20200821071644.109970-17-lee.jones@linaro.org>
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
Message-Id: <20200901092315.D6178C43387@smtp.codeaurora.org>
Date:   Tue,  1 Sep 2020 09:23:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> The function headers are either very weakly documented or not at all.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c:94: warning: Function parameter or member 'reg50' not described in 'brcmf_btcoex_info'
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c:94: warning: Function parameter or member 'saved_regs_part2' not described in 'brcmf_btcoex_info'
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c:233: warning: Function parameter or member 'btci' not described in 'btcmf_btcoex_save_part1'
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c:253: warning: Function parameter or member 'btci' not described in 'brcmf_btcoex_restore_part1'
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c:273: warning: Function parameter or member 't' not described in 'brcmf_btcoex_timerfunc'
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c:453: warning: Function parameter or member 'vif' not described in 'brcmf_btcoex_set_mode'
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c:453: warning: Function parameter or member 'duration' not described in 'brcmf_btcoex_set_mode'
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c:453: warning: Excess function parameter 'cfg' description in 'brcmf_btcoex_set_mode'
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

7 patches applied to wireless-drivers-next.git, thanks.

9d16c3859012 brcmfmac: btcoex: Update 'brcmf_btcoex_state' and demote others
03a7c2ea609b b43: phy_ht: Remove 9 year old TODO
5316050efdde rsi: Source file headers are not suitable for kernel-doc
3ecf6a3d6f62 iwlegacy: 4965-rs: Demote non kernel-doc headers to standard comment blocks
fa5768d59c53 iwlegacy: 4965-calib: Demote seemingly accidental kernel-doc header
a940977aaf2a brcmfmac: fwsignal: Remove unused variable 'brcmf_fws_prio2fifo'
e9cf68ff4eff rtlwifi: rtl8192c: phy_common: Remove unused variable 'bbvalue'

-- 
https://patchwork.kernel.org/patch/11728347/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

