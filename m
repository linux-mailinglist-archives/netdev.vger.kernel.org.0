Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6001F602163
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 04:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJRCsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 22:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiJRCsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 22:48:20 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAACB7D8
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 19:48:19 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d10so12838209pfh.6
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 19:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2m+W1kqLYKWj47d8rKudawhChCLx+aYPrkX5YT6Q3Nw=;
        b=EXzYzPQotwOOM+i3BVk3k+FKuOo9FQSiz2GAfVddOqXYeDrB/7+3up8D87M8TjtW8K
         lVJLRselWmVkE77bosx/ZKhBwe04+MD1RXMnkOs48nxxN6fFL4yZZ1nZ8kcuJrIyg8aY
         u6YS7yaBLh/+kwehyRUvys2tW0Nb9+YDs4uQk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2m+W1kqLYKWj47d8rKudawhChCLx+aYPrkX5YT6Q3Nw=;
        b=lMo74xbRx+o6Bh+KBq65A23gMnAar6r0lPo5Ug1Oqxgy4Bz6W1MfySBc9ATXSI+V7G
         LoLaF2JIscWCO5/NMHuTNoYIWKs6YbcokZp4eplLo828RO6DFA126WPA8wJWmqom5+O+
         ZsdQu/NY5m6mw+YsyoOVvvHdqPFxww7mOS+6apvMmZyAKKWnlL6QOCy6CXSoVU5wtAcc
         /JVRVvdyIt5bpLAXKfLwQOtsqNKk/vESzQLHPa4De/eMkTKRQS7yjG84AMnnkKLox/r5
         aitMRJUyDc7tm3ThD5kkHeKIWlmr6sndwdtk/chs/eiPK7V9D1zyHmSWNKwOUlwcdTbC
         OUFw==
X-Gm-Message-State: ACrzQf2V0/b2o91cBjYkLjIJGUe2Ee24/K/IUgvdpi52bm4+8QAwyk4s
        hb4md8maoI3u3reTVrmrp7hIrg==
X-Google-Smtp-Source: AMsMyM7YqFUN1M87OCl/PU8dSw1rjjXEmfKRA7ssPALLgBB1H+ENuyBoicR0ozvddg3EfmsU90WjEQ==
X-Received: by 2002:a63:2d05:0:b0:460:55e3:df91 with SMTP id t5-20020a632d05000000b0046055e3df91mr770707pgt.177.1666061298527;
        Mon, 17 Oct 2022 19:48:18 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i4-20020a170902e48400b00176c6738d13sm7316581ple.169.2022.10.17.19.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 19:48:17 -0700 (PDT)
Date:   Mon, 17 Oct 2022 19:48:17 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 4/6][next] hostap: Avoid clashing function prototypes
Message-ID: <202210171944.27607BC@keescook>
References: <cover.1666038048.git.gustavoars@kernel.org>
 <099d191c65efdf2f5f7b40a87a7eb3aabcae3e04.1666038048.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <099d191c65efdf2f5f7b40a87a7eb3aabcae3e04.1666038048.git.gustavoars@kernel.org>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 17, 2022 at 03:35:33PM -0500, Gustavo A. R. Silva wrote:
> [...]
> @@ -2885,7 +2915,7 @@ static int prism2_ioctl_priv_monitor(struct net_device *dev, int *i)
>  	struct hostap_interface *iface;
>  	local_info_t *local;
>  	int ret = 0;
> -	u32 mode;
> +	union iwreq_data wrqu;
>  
>  	iface = netdev_priv(dev);
>  	local = iface->local;
> @@ -2899,8 +2929,8 @@ static int prism2_ioctl_priv_monitor(struct net_device *dev, int *i)
>  	if (*i == 0) {
>  		/* Disable monitor mode - old mode was not saved, so go to
>  		 * Master mode */
> -		mode = IW_MODE_MASTER;
> -		ret = prism2_ioctl_siwmode(dev, NULL, &mode, NULL);
> +		wrqu.mode = IW_MODE_MASTER;
> +		ret = prism2_ioctl_siwmode(dev, NULL, &wrqu, NULL);
>  	} else if (*i == 1) {
>  		/* netlink socket mode is not supported anymore since it did
>  		 * not separate different devices from each other and was not
> @@ -2916,8 +2946,8 @@ static int prism2_ioctl_priv_monitor(struct net_device *dev, int *i)
>  			local->monitor_type = PRISM2_MONITOR_PRISM;
>  			break;
>  		}
> -		mode = IW_MODE_MONITOR;
> -		ret = prism2_ioctl_siwmode(dev, NULL, &mode, NULL);
> +		wrqu.mode = IW_MODE_MONITOR;
> +		ret = prism2_ioctl_siwmode(dev, NULL, &wrqu, NULL);
>  		hostap_monitor_mode_enable(local);
>  	} else
>  		ret = -EINVAL;

Ah, nice! Casts in the callers! :)

> [...]
> -static const iw_handler prism2_private_handler[] =
> -{							/* SIOCIWFIRSTPRIV + */
> -	(iw_handler) prism2_ioctl_priv_prism2_param,	/* 0 */
> -	(iw_handler) prism2_ioctl_priv_get_prism2_param, /* 1 */
> -	(iw_handler) prism2_ioctl_priv_writemif,	/* 2 */
> -	(iw_handler) prism2_ioctl_priv_readmif,		/* 3 */
> +static const iw_handler prism2_private_handler[] = {
> +	IW_HANDLER(SIOCIWFIRSTPRIV + 0, prism2_ioctl_priv_prism2_param),
> +	IW_HANDLER(SIOCIWFIRSTPRIV + 1, prism2_ioctl_priv_get_prism2_param),
> +	IW_HANDLER(SIOCIWFIRSTPRIV + 2, prism2_ioctl_priv_writemif),
> +	IW_HANDLER(SIOCIWFIRSTPRIV + 3, prism2_ioctl_priv_readmif),
>  };

These should stay as they were. Check the size of the data segment. :)

(It'd be nice if IW_HANDLER() actually checked for >=SIOCIWFIRSTPRIV,
and dropped it back to zero-index, but there's only a handful of
these...)

I think we're so used to examining only the .text segment we didn't
double-check the arrays we touched in the .data segment.

-- 
Kees Cook
