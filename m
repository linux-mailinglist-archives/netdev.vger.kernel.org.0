Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56B04BEA6B
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiBUSn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:43:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiBUSmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:42:38 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B74D9D97;
        Mon, 21 Feb 2022 10:42:12 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 25BF663580;
        Mon, 21 Feb 2022 19:41:15 +0100 (CET)
Date:   Mon, 21 Feb 2022 19:42:09 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Woody Suwalski <wsuwalski@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: Linux 5.17-rc5
Message-ID: <YhPdAeNwgffXqvfO@salvia>
References: <CAHk-=wgsMMuMP9_dWps7f25e6G628Hf7-B3hvSDvjhRXqVQvpg@mail.gmail.com>
 <8f331927-69d4-e4e7-22bc-c2a2a098dc1e@gmail.com>
 <CAHk-=wiAgNCLq2Lv4qu08P1SRv0D3mXLCqPq-XGJiTbGrP=omg@mail.gmail.com>
 <CANn89iJkTmDYb5h+ZwSyYEhEfr=jWmbPaVoLAnKkqW5VE47DXA@mail.gmail.com>
 <CAHk-=wigDNpiLAAS8M=1BUt3FCjWNA8RJr1KRQ=Jm_Q8xWBn-g@mail.gmail.com>
 <CANn89iJ2tmou5RNqmL22EHf+D2dptJPgpOVufSFEyoeJujw1cw@mail.gmail.com>
 <YhPZNLWkxH21uDAq@salvia>
 <CANn89i+72dv1AaeE1ThkceMVBHGCh3P49hOwuCkMSb1Y6U=hmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANn89i+72dv1AaeE1ThkceMVBHGCh3P49hOwuCkMSb1Y6U=hmg@mail.gmail.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 10:28:46AM -0800, Eric Dumazet wrote:
> On Mon, Feb 21, 2022 at 10:25 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Mon, Feb 21, 2022 at 10:21:16AM -0800, Eric Dumazet wrote:
> > > On Mon, Feb 21, 2022 at 10:08 AM Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:
> > > >
> > > > On Mon, Feb 21, 2022 at 10:02 AM Eric Dumazet <edumazet@google.com> wrote:
> > > > >
> > > > > I am pretty sure Pablo fixed this one week ago.
> > > >
> > > > .. looks about right. Apart from the "it was never sent to me, so -rc5
> > > > ended up showing the problem" part.
> > > >
> > >
> > > Indeed, I personally these kinds of trivial fixes should be sent right away,
> > > especially considering two bots complained about it.
> >
> > I did not consider this so important, that was my fault.
> 
> Well, I was the one adding this compile error ;)

I poorly performed as a duly reviewer :)

> Testing CONFIG_IPV6=n builds is not my top priority.

For the record, this patch is now flying to the netdev tree via pull request:

https://patchwork.kernel.org/project/netdevbpf/patch/20220221161757.250801-1-pablo@netfilter.org/

Thanks.
