Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C310A2FCDAF
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 10:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730960AbhATJQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 04:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729997AbhATJJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 04:09:16 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F76C061575;
        Wed, 20 Jan 2021 01:08:35 -0800 (PST)
Date:   Wed, 20 Jan 2021 10:08:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611133713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HDlaTP4HiR73CiOBJBp2jl7j7+FC5G0dQd8NMjFKNWc=;
        b=ckascHNA8+O5wDLv+8y8JbSaDJJtV8c/hb2AEqEsCB8k1Ecx986uG38dNvj1mMR9ZOcmpc
        KFOtIQkAMTSLr+t6MxIdG3zkB6LiE+zFybmiitBDkWnjLKSSnB7DJOH3tZXVRMwbC5+DdS
        fBba77/rIbLEmiDZYNbr/BvXLHnLp6QBmNsX6dwmH2cDBijhkn6k7y4VKD4X+4TLoL8ZPp
        s8vqYyyYyPirl3uHHyT4dhtJReqw77Uwev1dscp4vDPDF0B4hp40cPjKT8lrHEtPvIxE4z
        1CAqjhLgaAns22LsbsJM4LtZ5+57qzWle9VR5Fqb0+a2vFEjYmEGcNUCRbh88Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611133713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HDlaTP4HiR73CiOBJBp2jl7j7+FC5G0dQd8NMjFKNWc=;
        b=VubDNdSxrWMJ3ilgkp6KWIa2awyA6D1x9HaK/inoxyg/WIhd4qhx/eaA/CCsBxOKdlIWyT
        GN8BovqKMHORzLCQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Cc:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, colin.king@canonical.com,
        Larry.Finger@lwfinger.net, andriy.shevchenko@linux.intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Assign boolean values to a bool variable
Message-ID: <20210120090833.loukh7x72dk5jhox@linutronix.de>
References: <1611127628-50504-1-git-send-email-abaci-bugfix@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1611127628-50504-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-20 15:27:08 [+0800], Jiapeng Zhong wrote:
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> index be4c0e6..c198222 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> @@ -873,7 +873,7 @@ static void halbtc_display_wifi_status(struct btc_coexist *btcoexist,
>  	dc_mode = true;	/*TODO*/
>  	under_ips = rtlpriv->psc.inactive_pwrstate == ERFOFF ? 1 : 0;
>  	under_lps = rtlpriv->psc.dot11_psmode == EACTIVE ? 0 : 1;
> -	low_power = 0; /*TODO*/
> +	low_power = false; /*TODO*/

you could drop that assignment as it is already initialized to false at
the top.

>  	seq_printf(m, "\n %-35s = %s%s%s%s",
>  		   "Power Status",
>  		   (dc_mode ? "DC mode" : "AC mode"),

Sebastian
