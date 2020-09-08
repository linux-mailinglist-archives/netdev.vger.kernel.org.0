Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4695260950
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 06:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgIHEVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 00:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbgIHEVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 00:21:17 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26C7C061573;
        Mon,  7 Sep 2020 21:21:16 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id v54so11045607qtj.7;
        Mon, 07 Sep 2020 21:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PRjmqyIAVtcu5hkVXVaG9tIjoQpLXmHVLf5oTMSHjVM=;
        b=Fzx0I67Sk7GzG3zMnQO/Ka9BChFZfHgeCA6tP6EipLiqFg/TAB0sSLCyLjBcmC5vat
         xzpbMxX5TusqVDSv/bafIDKQvIAVB7PmQzNXc5fjAH0iQRlJ7nZLdoHvLYMK1vXdY6tx
         m5crrVb3CHatA56ow4Ai1eqgFJLbDQazct5MUHNBbq6bzLgifQw+/TcbiA4rIeaUy91c
         vP4ICg63nEKL2AdVWeFkHf2WAmYsPqIciUndY5LN4JPyiy1Wu8HYSEvaAqfy3nDzOnVu
         Tt0rTIcQjZUBgueNvhOCW93CzjpjIpsZAezwKaL0ctP47JXyx+rizMUjXKOgkpxsnR8E
         lvYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PRjmqyIAVtcu5hkVXVaG9tIjoQpLXmHVLf5oTMSHjVM=;
        b=e+ROVSNA295LX6kOBrVSD5G44i8WjAQ51s2HX9ksjrbgMX1uE0ox72xCksdqd7TCkz
         frf5IjjX5HuD+S6k+SzKiB5nZzmGSXIWz8XmDFvMitWny2ylUWY+N8YgY10hc3UTz4FT
         OAMMJOwqpYPblk9IWb56x+sXpCaHeuYDBIWUL0TnWLNAhFFG2Zxsi4SPCb+OZRcD6+/b
         zAsQb1hYmO2tqH8his3UoPLjZL++DYQ2uTvu8JNika/EaoC3BR6trVeS4oeMfHJDDJqK
         6EQy607s49aJ3OYNpUxhiDSkDBUu/x88NWsDxMcSBGeW29e4xGr1GorZ0xLgTHyKRBwK
         +EHg==
X-Gm-Message-State: AOAM531Ly0seTbiBqNFSrRer9UV12OHAzN/45ipDsyWrrlYHiZeydo9u
        bRQNShKJ4dhrqXF0m+nQwqk=
X-Google-Smtp-Source: ABdhPJyJwmmPpz3QNBZFdyqDo/55XppPuPA7155t5Xx1SxK9l7aHNruT0BuOV/Y2p8M0Cp0si+AHYw==
X-Received: by 2002:ac8:5317:: with SMTP id t23mr24045948qtn.354.1599538875607;
        Mon, 07 Sep 2020 21:21:15 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id s20sm12829672qkg.65.2020.09.07.21.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 21:21:14 -0700 (PDT)
Date:   Mon, 7 Sep 2020 21:21:12 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     trix@redhat.com
Cc:     amitkarwar@gmail.com, ganapathi.bhat@nxp.com,
        huxinming820@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, ndesaulniers@google.com, bzhao@marvell.com,
        dkiran@marvell.com, frankh@marvell.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] mwifiex: remove function pointer check
Message-ID: <20200908042112.GA111690@ubuntu-n2-xlarge-x86>
References: <20200906200548.18053-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200906200548.18053-1-trix@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 06, 2020 at 01:05:48PM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> clang static analyzer reports this problem
> 
> init.c:739:8: warning: Called function pointer
>   is null (null dereference)
>         ret = adapter->if_ops.check_fw_status( ...
>               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> In mwifiex_dnld_fw, there is an earlier check for check_fw_status(),
> The check was introduced for usb support at the same time this
> check in _mwifiex_fw_dpc() was made
> 
> 	if (adapter->if_ops.dnld_fw) {
> 		ret = adapter->if_ops.dnld_fw(adapter, &fw);
> 	} else {
> 		ret = mwifiex_dnld_fw(adapter, &fw);
> 	}
> 
> And a dnld_fw function initialized as part the usb's
> mwifiex_if_ops.
> 
> The other instances of mwifiex_if_ops for pci and sdio
> both set check_fw_status.
> 
> So the first check is not needed and can be removed.
> 
> Fixes: 4daffe354366 ("mwifiex: add support for Marvell USB8797 chipset")
> Signed-off-by: Tom Rix <trix@redhat.com>

Indeed, on the surface, mwifiex_dnld_fw assumes that check_fw_status()
cannot be NULL because it will always be called at the end of the
function even if the first check is skipped.

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  drivers/net/wireless/marvell/mwifiex/init.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
> index 82d69bc3aaaf..f006a3d72b40 100644
> --- a/drivers/net/wireless/marvell/mwifiex/init.c
> +++ b/drivers/net/wireless/marvell/mwifiex/init.c
> @@ -695,14 +695,12 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
>  	int ret;
>  	u32 poll_num = 1;
>  
> -	if (adapter->if_ops.check_fw_status) {
> -		/* check if firmware is already running */
> -		ret = adapter->if_ops.check_fw_status(adapter, poll_num);
> -		if (!ret) {
> -			mwifiex_dbg(adapter, MSG,
> -				    "WLAN FW already running! Skip FW dnld\n");
> -			return 0;
> -		}
> +	/* check if firmware is already running */
> +	ret = adapter->if_ops.check_fw_status(adapter, poll_num);
> +	if (!ret) {
> +		mwifiex_dbg(adapter, MSG,
> +			    "WLAN FW already running! Skip FW dnld\n");
> +		return 0;
>  	}
>  
>  	/* check if we are the winner for downloading FW */
> -- 
> 2.18.1
> 
> -- 
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200906200548.18053-1-trix%40redhat.com.
