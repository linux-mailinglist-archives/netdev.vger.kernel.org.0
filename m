Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964DD24E3AD
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 00:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgHUW57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 18:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgHUW56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 18:57:58 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E9EC061573;
        Fri, 21 Aug 2020 15:57:57 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id w14so2411228eds.0;
        Fri, 21 Aug 2020 15:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6Y3HAkrVgYNsW26WADT1OAHIAmh+irSetkJetEKSBLc=;
        b=LmYlBWlqAaYlLTQciRn3s+WD9MIprS0TReEVpc+Z7k5nC/Y9lKDewhsJ5SPjBKZTHp
         fAaXY21tnl1gT2vIqJDHE0um3m5jtvyiFgQj8j+OE0C1MHq7ufuDNktX7eKcr/wO4/Ax
         ksVjJtpmqtwqdVFeWvivOrBHE7DZQfOS/2/zyxu0tlgCCxNAkkVS3ifbVLRBbNdt9iVw
         b4T61UaWEp7wGexWNcLH0Tlid4kfULD7VqYpfsu2/J4q3ZMcysARnaBWiyqfWJaGALZN
         gZj0iri+5bEtsg7p+jzTxbOaFgJTIlIuR9HbPHLTSmmTV2HxX/hEy+QCQtH6z1KQOYOI
         XWRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6Y3HAkrVgYNsW26WADT1OAHIAmh+irSetkJetEKSBLc=;
        b=cPMD97LBCTzp0sufpKadCWAFTMRIKjp17cYUdjny1DJlR4ScS+CAIApn6SYtJfnl/t
         7mY822Ti/8jZwpxYdRYUSMQyn2kQEmPv8/L7CasBPJSD3AwhgFpuS66tdT1xo5tgO9MC
         PjdssnIRCugHAqXLeVmCbqRr6HN4wxnDqBnAJBD4KT2tNpBi1MFuhGOUOfgYJOafOZaf
         8wCIUJkTiIvq35Qpgd25TnCiu/jfSJnSICg4YFilOkxjrqUHEAzcdDsFUlpMpuIuhhjm
         44g3osJqerMRHp3MCk5b+GFI6GKcDRFJRz8iTrsuNDh5Sf1Tn83rj3gd+weJ9obSTmvh
         nw2w==
X-Gm-Message-State: AOAM532hmnL3yfLZgW85r//W24Nlxx3vOKzo7xf0OPJVZR2emzpDggqM
        J0g9i7xJ8bBIP57EXd1h6GYS1lA7xiM=
X-Google-Smtp-Source: ABdhPJwhHp67Go/OlpD5NAZYr8YW4SUI6BBSZAVRj7AR7dXUeoByYRDRzf456SX/p5xgAiEGesWZvg==
X-Received: by 2002:aa7:da04:: with SMTP id r4mr5032282eds.265.1598050675861;
        Fri, 21 Aug 2020 15:57:55 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id d9sm1839906edt.20.2020.08.21.15.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 15:57:55 -0700 (PDT)
Date:   Sat, 22 Aug 2020 01:57:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net: dsa: sja1105: Do not use address of compatible
 member in sja1105_check_device_id
Message-ID: <20200821225753.cfaclxay6zhq6swg@skbuf>
References: <20200821222515.414167-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821222515.414167-1-natechancellor@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 03:25:16PM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
> drivers/net/dsa/sja1105/sja1105_main.c:3418:38: warning: address of
> array 'match->compatible' will always evaluate to 'true'
> [-Wpointer-bool-conversion]
>         for (match = sja1105_dt_ids; match->compatible; match++) {
>         ~~~                          ~~~~~~~^~~~~~~~~~
> 1 warning generated.
> 
> We should check the value of the first character in compatible to see if
> it is empty or not. This matches how the rest of the tree iterates over
> IDs.
> 
> Fixes: 0b0e299720bb ("net: dsa: sja1105: use detected device id instead of DT one on mismatch")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1139
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index c3f6f124e5f0..5a28dfb36ec3 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -3415,7 +3415,7 @@ static int sja1105_check_device_id(struct sja1105_private *priv)
>  
>  	sja1105_unpack(prod_id, &part_no, 19, 4, SJA1105_SIZE_DEVICE_ID);
>  
> -	for (match = sja1105_dt_ids; match->compatible; match++) {
> +	for (match = sja1105_dt_ids; match->compatible[0]; match++) {
>  		const struct sja1105_info *info = match->data;
>  
>  		/* Is what's been probed in our match table at all? */
> 
> base-commit: 4af7b32f84aa4cd60e39b355bc8a1eab6cd8d8a4
> -- 
> 2.28.0
> 

Thanks, Nathan.

Acked-by: Vladimir Oltean <olteanv@gmail.com>

-Vladimir
