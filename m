Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AEC4583FD
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 15:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238307AbhKUOK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 09:10:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238093AbhKUOK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 09:10:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A46960295;
        Sun, 21 Nov 2021 14:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637503643;
        bh=AhFc63ztTwQ/MV9vSL2Ck4udv9QMgUPFlE375xhTE3U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BSmV4sG+lZRc6uRwWpmZJWKo7nZAylfsgsjF2Y7/ZKImoccV99qqLadlxOn66biKt
         yGZNfgEHDdNJ9XjClq9s5Bdqv4UlN6IYELlnJDGC083WhiMr/57yK51Ko4FRHpboqL
         rtNjZH+5ohQUIQtsapfNclSoq/INpMUIzfwEH7IoMgeRqBM4/igPpqXTQwt/OyKkmD
         3HyIOQCZDman4Ekt1zqVC28fryQSmI3oPNn7CcXvBcdGfh0UfiNuoMJOdiwf80sQNJ
         DByvyiNjemRiZogcoh+1exG/QjEqJIZVSU4wcd13CcaExYKBbeCVs3UgR+qdCIY9T1
         qnxiWHTKByh8g==
Date:   Sun, 21 Nov 2021 16:07:18 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        antony.antony@secunet.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] xfrm: rework default policy structure
Message-ID: <YZpSlpVuE9G+Ebh4@unreal>
References: <20211118142937.5425-1-nicolas.dichtel@6wind.com>
 <YZak297hPRh3Etun@unreal>
 <e724c80c-8b4f-4399-e716-1866d992a4f2@6wind.com>
 <YZfFnZIUsZnX1bu+@unreal>
 <81eadf5e-7d2b-b7f8-513f-2212272f5897@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81eadf5e-7d2b-b7f8-513f-2212272f5897@6wind.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 06:31:18PM +0100, Nicolas Dichtel wrote:
> Le 19/11/2021 à 16:41, Leon Romanovsky a écrit :
> [snip]
> >> What about:
> >>
> >> static inline bool __xfrm_check_nopolicy(struct net *net, struct sk_buff *skb,
> >>                                          int dir)
> >> {
> >>         if (!net->xfrm.policy_count[dir] && !secpath_exists(skb))
> >>                 return net->xfrm.policy_default[dir] == XFRM_USERPOLICY_ACCEPT;
> >>
> >>         return false;
> >> }
> > 
> > It is much better, just extra "!" is not in place.
> Ok, I will send a v2 with that.
> 
> > if (!net->xfrm.policy_count[dir] ... -> if (net->xfrm.policy_count[dir] ...
> Hmm, are you sure?

Not sure at all, maybe wrong.

Thanks
