Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5869061FC59
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 18:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbiKGR53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 12:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbiKGR5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 12:57:05 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367AE26ACC
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 09:54:51 -0800 (PST)
Received: from gmx.fr ([181.118.49.178]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MOzOw-1odkpd3aG4-00PLPE; Mon, 07
 Nov 2022 18:54:38 +0100
Date:   Mon, 7 Nov 2022 13:54:32 -0400
From:   Jamie Gloudon <jamie.gloudon@gmx.fr>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Subject: Re: [PATCH net v3 1/1] ip6_tunnel: Correct mistake in if statement.
Message-ID: <Y2lGWJlJdFsbLWHv@gmx.fr>
References: <Y2jCWvICWQ8AiQyR@gmx.fr>
 <Y2jIpSCdti8lv73X@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2jIpSCdti8lv73X@unreal>
X-Provags-ID: V03:K1:3mVpxKZhzLPc8qRHNmMOMx5hPVSEwYGMKEQKa2lXu+iOo91d6FE
 HAwnevTyn6QuzeoPVNe06REvMDLDSMqVxzjIVuvJ/66mygHZg6yzfzF/9Sn1apdVwEzqVby
 1lXwrCNqQZPRLUmHwuFi8L7+zuVzKs7/QHAVwCTXeNjCo2dLKPIjVqdtIr6DUqL3SJ6Kh00
 hC891rZx8V770/N/X6fPg==
UI-OutboundReport: notjunk:1;M01:P0:KVKio7+hHGU=;WWJO5wOu8ud9B06lw6MGomvNPg+
 PlQtGw4Y9kJW3qL5dryr7VaNj8j/z0se49riHj5HIKqcJZc68xR+DJKYre9DGvLxEt9MlKEN3
 1t5ngPYWogd1felwQuqWX5tuOrp/iWpeXcZ9E189lZDREQw8tjvaWtONDDSvMU+jG/GapLFqK
 dA5CVidp7iy389ja39illTl8RkJnvDNgnyj9yKDGGHbUmZttfep8mUsTiOL7Nkd/05/MaNX/4
 y7agJSItQnQ73+OdbZU8TXmQJ0cDastfautJGt43gkEDuaBVf6oxHghUYp377h+Xn0d4LKxxR
 1vNYOZL4SI9fe1MBr6yO27P4gP6mnDuzsY/9OZmmrXTg6Nk2fx+cA58bZVC0MkYhJkC9jUpce
 SERT4zaJkrqqJ6po65yJT/7nMDrvpMTGjIR1RBrSBgu/BetaWeiW813kNmxtaWS4xQnfer4ZN
 fApX4JUnQotp4M4AhvhjdEdXSmzpi8wyejBKvGsjmhMJFcFVa0dqNwUomVKJ7l/+AKcKyxPyU
 Ue7ZsGhZTGJmZaJhod0G4PSGoKGYOtjfDROWDvbHbHwhYjLUcJhxhAVoQGWtkGw3q2pwWBgCI
 38+WvGhyY3SVYnrH0iTfFBi+MMKQ8+XHwNkNVUOXHKsi8jcwztBcnduoTiNddhtCCABMtsNZv
 CsQjLLjsT+iqSWWNx6jVXLlK88XRiKvHXwWxfvtyQD3A/A2ix2HCqF3s/jheVLhHj+4xfA/tz
 +YVSZnUNCT4ne0jalfTXib3d2crd4ZIkV9kFkdp8DopnintlDTgj1aXpOC37r+wU4SpvrxXvk
 qjW3DIB/kI2dvq/UUO8HQNW8IjKb0o8TGOsCyXfuaANcZIV0XdHVpHH9HAIPujmDcNjcMnm+X
 Q6plefCUafdrt+lyfW5PeQyoijFlkdodrj/+LF1OxCMT+C/oXpFQIAboD2lTbONQbNANc5AY9
 0jAO0w==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 10:58:13AM +0200, Leon Romanovsky wrote:
> On Mon, Nov 07, 2022 at 04:31:22AM -0400, Jamie Gloudon wrote:
> > Make sure t->dev->flags & IFF_UP is check first for logical reason.
> > 
> > Fixes: 6c1cb4393cc7 ("ip6_tunnel: fix ip6 tunnel lookup in collect_md
> > mode")
> > Signed-off-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
> > ---
> >  net/ipv6/ip6_tunnel.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> > index 2fb4c6ad7243..22c71f991bb7 100644
> > --- a/net/ipv6/ip6_tunnel.c
> > +++ b/net/ipv6/ip6_tunnel.c
> > @@ -162,7 +162,7 @@ ip6_tnl_lookup(struct net *net, int link,
> >  		return cand;
> >  
> >  	t = rcu_dereference(ip6n->collect_md_tun);
> > -	if (t && t->dev->flags & IFF_UP)
> > +	if (t && (t->dev->flags & IFF_UP))
> 
> While this change makes is less ambiguous for reader, the C precedence
> rules are clear and & evaluated before &&.
> https://en.cppreference.com/w/c/language/operator_precedence
> 
> There is nothing to fix here.
> 
> Thanks
> 
> >  		return t;
> >  
> >  	t = rcu_dereference(ip6n->tnls_wc[0]);
> > -- 
> > 2.28.0
> >
Thanks for taking the time to review the patch.
