Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A814E342F66
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 20:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhCTT5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 15:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbhCTT44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 15:56:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED101C061574;
        Sat, 20 Mar 2021 12:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
        References:Message-ID:In-Reply-To:Subject:cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=unEOJs7g8dhW9JIfGxFXXYni7VdACtVUH0Kopjl/EDs=; b=tPreKU2v7a6RrC/dWNNA1P41i7
        8P0BNRy0JJR9Fej9w+5FJG9NbdxqQgLifsM/7Y9KsGXZ595vKnwPud791fOUUICxwPjLN0MTzLaLn
        jSthX+OISLi9L68ZWtYqwFQ2FLmOZl3vHnt1MUOoiiSFM2F/OswVRS4vT2OC/qcf02LOaFYsEF1mj
        XHm+7YDnlEHdvCMf4ka3V8N5EDdGNdHbqnnSiPJ7LS6ptFBpmGyUrWMwwg56hgR2lEKz56feyGLfH
        btEMsxD2l/FCqcc7RtXt4lgkB65cG3fZzOgSOktChQ+pNGX7RJv8XG2XI15qWxKNLQiGdKZz2u3ge
        +zLQdPaw==;
Received: from rdunlap (helo=localhost)
        by bombadil.infradead.org with local-esmtp (Exim 4.94 #2 (Red Hat Linux))
        id 1lNhiK-0020s7-TF; Sat, 20 Mar 2021 19:56:50 +0000
Date:   Sat, 20 Mar 2021 12:56:48 -0700 (PDT)
From:   Randy Dunlap <rdunlap@bombadil.infradead.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
cc:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Few mundane typo fixes
In-Reply-To: <20210320194426.21621-1-unixbhaskar@gmail.com>
Message-ID: <1b2d2cc5-5a6c-2552-65d8-9232240e16c@bombadil.infradead.org>
References: <20210320194426.21621-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: Randy Dunlap <rdunlap@infradead.org>
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3 
X-CRM114-CacheID: sfid-20210320_125648_968664_0136FA4B 
X-CRM114-Status: GOOD (  12.50  )
X-Spam-Score: -0.0 (/)
X-Spam-Report: Spam detection software, running on the system "bombadil.infradead.org",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On Sun, 21 Mar 2021, Bhaskar Chowdhury wrote: > > s/resovle/resolve/
    > s/broadcase/broadcast/ > s/sytem/system/ > > Signed-off-by: Bhaskar Chowdhury
    <unixbhaskar@gmail.com> Acked-by: Randy Dunlap <rdunlap@infradead.org> 
 Content analysis details:   (-0.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -0.0 NO_RELAYS              Informational: message was not relayed via SMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Sun, 21 Mar 2021, Bhaskar Chowdhury wrote:

>
> s/resovle/resolve/
> s/broadcase/broadcast/
> s/sytem/system/
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
> drivers/net/wireless/realtek/rtlwifi/core.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
> index 965bd9589045..c9b6ee81dcb9 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
> @@ -564,7 +564,7 @@ static int rtl_op_resume(struct ieee80211_hw *hw)
> 	rtlhal->enter_pnp_sleep = false;
> 	rtlhal->wake_from_pnp_sleep = true;
>
> -	/* to resovle s4 can not wake up*/
> +	/* to resolve s4 can not wake up*/
> 	now = ktime_get_real_seconds();
> 	if (now - rtlhal->last_suspend_sec < 5)
> 		return -1;
> @@ -806,7 +806,7 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
> 	if (0 == changed_flags)
> 		return;
>
> -	/*TODO: we disable broadcase now, so enable here */
> +	/*TODO: we disable broadcast now, so enable here */
> 	if (changed_flags & FIF_ALLMULTI) {
> 		if (*new_flags & FIF_ALLMULTI) {
> 			mac->rx_conf |= rtlpriv->cfg->maps[MAC_RCR_AM] |
> @@ -1796,7 +1796,7 @@ bool rtl_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
> 				value |= (GET_PWR_CFG_VALUE(cfg_cmd) &
> 					  GET_PWR_CFG_MASK(cfg_cmd));
>
> -				/*Write the value back to sytem register*/
> +				/*Write the value back to system register*/
> 				rtl_write_byte(rtlpriv, offset, value);
> 				break;
> 			case PWR_CMD_POLLING:
> --
> 2.26.2
>
>
