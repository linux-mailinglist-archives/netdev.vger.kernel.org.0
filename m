Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4C5343082
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 02:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCUBiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 21:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhCUBht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 21:37:49 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5932C061574;
        Sat, 20 Mar 2021 18:37:48 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t20so4747000plr.13;
        Sat, 20 Mar 2021 18:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+NrUwEQ+bsoIs8jVM+ts0cRMowyDewcITmqnPWt/Y4Y=;
        b=tOitYwU4FwouPApfi+54lpDK8KVwEYlJZCxj/X9jllVPWNJkYYuJZilOh29WCps1FQ
         WvnWpEaSG6sCWmtZwEpoCRfAk7hIUZPYvRJIORZ4UMy/KMCHJg7uViBTwZAZH7dQhrp3
         S3B5PZkeQ+JBokP2ww8QJMNWoLDvUkKCKsvNJWKt1JdgDxAlnfJJWQneyplolEGv9yas
         VF4T8G8e2htiZQB7IsQhZEvBwz2QBiOftnOOBnySUCxnFj2C23SjzzWevWeD+IpDs6H6
         HFRhFr3A7GUm74M8D/cdGaNf9/oce5465NRjmV3B1+BDhbsYB9G9P38BVCzqqz7BgsCL
         wuvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+NrUwEQ+bsoIs8jVM+ts0cRMowyDewcITmqnPWt/Y4Y=;
        b=Rc9XnTZS0keebxw0yW+89QFGPiTDAZoyqNmPcZoHc1iY8RBZ6VUSbPfBK3eDe1vSDS
         LAtjdNxg9QinxaBbrulvJz+J7rs6lUQN9w8k8r0IZ9E1zafDM1yC/ohjQ+6HBu/BgYtQ
         Zf5Fpv9FOE1/ZmUYG0lLHhrjf7AZ/sCCCk3arL9Atlq/20NhzGmCL3chFqlge84KJdYb
         hvmXIjKd/k69SbJ+qJ+EQpizuTES8BWi40DoOPVY0dMEAHY2C8pczd+hVuUMLKxJgUzA
         FcJcYfk6A7io2FkTQk/vADh6/Xsq28+UTGEAMKOkJoMrcZwzTJgqXP8dGCa+bTtFHmWm
         2IIQ==
X-Gm-Message-State: AOAM532Xr5uznlYu+FNh923VY2SGoyOTYgsbFXuUVQB/lxNDEM3ZLMe3
        E78oDEbB5++nqDUMIgj8yfleGLkN0JM=
X-Google-Smtp-Source: ABdhPJww7xF7N21im+Enw3eLfpYtACF+f9CpIrNFHlwPCdfjhq4FuJmm6pFTUtUVaWjxUIbSSWA//A==
X-Received: by 2002:a17:90a:458b:: with SMTP id v11mr5722369pjg.189.1616290667226;
        Sat, 20 Mar 2021 18:37:47 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i1sm9650016pfo.160.2021.03.20.18.37.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 18:37:46 -0700 (PDT)
Subject: Re: [PATCH net-next] dsa: simplify Kconfig symbols and dependencies
To:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210319154617.187222-1-alobakin@pm.me>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f0114c48-7bfe-1d08-e8c6-ef7f1a60d313@gmail.com>
Date:   Sat, 20 Mar 2021 18:37:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210319154617.187222-1-alobakin@pm.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/19/2021 8:46 AM, Alexander Lobakin wrote:
> 1. Remove CONFIG_HAVE_NET_DSA.
> 
> CONFIG_HAVE_NET_DSA is a legacy leftover from the times when drivers
> should have selected CONFIG_NET_DSA manually.
> Currently, all drivers has explicit 'depends on NET_DSA', so this is
> no more needed.
> 
> 2. CONFIG_HAVE_NET_DSA dependencies became CONFIG_NET_DSA's ones.
> 
>  - dropped !S390 dependency which was introduced to be sure NET_DSA
>    can select CONFIG_PHYLIB. DSA migrated to Phylink almost 3 years
>    ago and the PHY library itself doesn't depend on !S390 since
>    commit 870a2b5e4fcd ("phylib: remove !S390 dependeny from Kconfig");
>  - INET dependency is kept to be sure we can select NET_SWITCHDEV;
>  - NETDEVICES dependency is kept to be sure we can select PHYLINK.
> 
> 3. DSA drivers menu now depends on NET_DSA.
> 
> Instead on 'depends on NET_DSA' on every single driver, the entire
> menu now depends on it. This eliminates a lot of duplicated lines
> from Kconfig with no loss (when CONFIG_NET_DSA=m, drivers also can
> be only m or n).
> This also has a nice side effect that there's no more empty menu on
> configurations without DSA.
> 
> 4. Kbuild will now descend into 'drivers/net/dsa' only when
>    CONFIG_NET_DSA is y or m.
> 
> This is safe since no objects inside this folder can be built without
> DSA core, as well as when CONFIG_NET_DSA=m, no objects can be
> built-in.
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
