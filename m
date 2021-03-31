Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC7E350A7E
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhCaW4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhCaWzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 18:55:47 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5DEC061574;
        Wed, 31 Mar 2021 15:55:46 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id b7so59836ejv.1;
        Wed, 31 Mar 2021 15:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JEOeMKRwGWWTQjFkBxXub83+/4v8CmWsFhqUyBwrEtE=;
        b=j5g7gNpN7tOChv6MGBQ0+loGKbi88IDmOacyrg+HT9rSRjIGj+qj98UWrT3u6BUTwS
         a13H+Zhov80YV88Zc0sk4pS/KlXQ0p4Gw5oKoaIj6WBX97MfnxG/T1bt+7KXJHKaSodz
         6Yqw6Yc7xucvEdIpb/j+sdUSDiehBLDOPstBujZB7uQQ7JCyPnweDvkiVhpmYopvOSkt
         w5gLOhWd5rYicbeKyxZ9+WC2amB8WT9r6pPLtpUki/CZBFYFZibPjK+nbMLUTG6rRHIK
         fuSK5vXNTCS43FYl5s+wHLq9chQO/VdoNk6rvLNiVyeIQHa+wSTAEY/oSKRvSDpkoHYt
         nZug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JEOeMKRwGWWTQjFkBxXub83+/4v8CmWsFhqUyBwrEtE=;
        b=EQK1t0v18LKIQrPvdcTCBUpgDMC2W5R65XgHg97H1pAAosSj8eXcitlv3oq5BGROLQ
         rnuVagDgkXDalndwB42z+7l3yO2F1VM/srMD1N5+bdchtA/9hm05hHkQrEPeG+ZbKiy2
         Bw0LWpvmjA5/lUulJIqTLnf3G3t4ZMnGqkunK8UYnnPd8eSrGzKGEcEED1xOnNeZ1vMO
         h3SgSnutwP3wbZ/wn91vUM1Vw67oOEQyhQgmT2UUQfFAh4N58UzGEJLumR7k412OEy1v
         85pj79/+XOSItpJBxuwwiZecjJsH5ZrtgJkcVBlNEliZE4mjJ4nySengRv1eJZr6GLR+
         E7Lg==
X-Gm-Message-State: AOAM532GiANZCJoWUTEBeXOqTK+lM8o6X3WAg9Zsbri1trXU9ZS2Itgu
        srMXgrIJCD0MnX0GcQcyL7vjTT+nx6I=
X-Google-Smtp-Source: ABdhPJxUgrFpexFyMrrmP1kjp/LnQZjCnP9jHnTrVfv3XdqwRdcuxA1bx7PFIogmhDvfkikNopQBzg==
X-Received: by 2002:a17:906:16ca:: with SMTP id t10mr6268900ejd.85.1617231345464;
        Wed, 31 Mar 2021 15:55:45 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id f9sm2504556edq.43.2021.03.31.15.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 15:55:45 -0700 (PDT)
Date:   Thu, 1 Apr 2021 01:55:43 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, alexander.duyck@gmail.com,
        ioana.ciornei@nxp.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, ilias.apalodimas@linaro.org,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next 0/9] XDP for NXP ENETC
Message-ID: <20210331225543.oelvapw3pli45k5q@skbuf>
References: <20210331200857.3274425-1-olteanv@gmail.com>
 <161722921847.2890.11454275035323776176.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161722921847.2890.11454275035323776176.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 10:20:18PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
>
> This series was applied to netdev/net-next.git (refs/heads/master):
>
> On Wed, 31 Mar 2021 23:08:48 +0300 you wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > This series adds support to the enetc driver for the basic XDP primitives.
> > The ENETC is a network controller found inside the NXP LS1028A SoC,
> > which is a dual-core Cortex A72 device for industrial networking,
> > with the CPUs clocked at up to 1.3 GHz. On this platform, there are 4
> > ENETC ports and a 6-port embedded DSA switch, in a topology that looks
> > like this:
> >
> > [...]
>
> Here is the summary with links:
>   - [net-next,1/9] net: enetc: consume the error RX buffer descriptors in a dedicated function
>     https://git.kernel.org/netdev/net-next/c/2fa423f5f0c6
>   - [net-next,2/9] net: enetc: move skb creation into enetc_build_skb
>     https://git.kernel.org/netdev/net-next/c/a800abd3ecb9
>   - [net-next,3/9] net: enetc: add a dedicated is_eof bit in the TX software BD
>     https://git.kernel.org/netdev/net-next/c/d504498d2eb3
>   - [net-next,4/9] net: enetc: clean the TX software BD on the TX confirmation path
>     https://git.kernel.org/netdev/net-next/c/1ee8d6f3bebb
>   - [net-next,5/9] net: enetc: move up enetc_reuse_page and enetc_page_reusable
>     https://git.kernel.org/netdev/net-next/c/65d0cbb414ce
>   - [net-next,6/9] net: enetc: add support for XDP_DROP and XDP_PASS
>     https://git.kernel.org/netdev/net-next/c/d1b15102dd16
>   - [net-next,7/9] net: enetc: add support for XDP_TX
>     https://git.kernel.org/netdev/net-next/c/7ed2bc80074e
>   - [net-next,8/9] net: enetc: increase RX ring default size
>     https://git.kernel.org/netdev/net-next/c/d6a2829e82cf
>   - [net-next,9/9] net: enetc: add support for XDP_REDIRECT
>     https://git.kernel.org/netdev/net-next/c/9d2b68cc108d
>
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html

Let's play a drinking game, the winner is who doesn't get drunk every
time Dave merges a 9-patch series with no review in less than two hours
after it was posted :D

Now in all seriousness, I'm very much open to receiving feedback still.
In a way, I appreciate seeing the patches merged as is, since further
fixups made based on review will add more nuance and color to the git
log, and it will be easier to understand why things were done or
modified in a certain way, etc, as opposed to the alternative which is
to keep amending the same blank 'add support for XDP_TX / XDP_REDIRECT /
whatever', with never enough attention given to the finer points.
