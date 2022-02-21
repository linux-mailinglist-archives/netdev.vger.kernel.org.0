Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4734BEAB2
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiBUS1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:27:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbiBUS0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:26:14 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D540CC0
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:25:36 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id F0489643A0;
        Mon, 21 Feb 2022 19:24:37 +0100 (CET)
Date:   Mon, 21 Feb 2022 19:25:31 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Woody Suwalski <wsuwalski@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: Linux 5.17-rc5
Message-ID: <YhPZGwix0c8s0wN4@salvia>
References: <CAHk-=wgsMMuMP9_dWps7f25e6G628Hf7-B3hvSDvjhRXqVQvpg@mail.gmail.com>
 <8f331927-69d4-e4e7-22bc-c2a2a098dc1e@gmail.com>
 <CAHk-=wiAgNCLq2Lv4qu08P1SRv0D3mXLCqPq-XGJiTbGrP=omg@mail.gmail.com>
 <CANn89iJkTmDYb5h+ZwSyYEhEfr=jWmbPaVoLAnKkqW5VE47DXA@mail.gmail.com>
 <CAHk-=wigDNpiLAAS8M=1BUt3FCjWNA8RJr1KRQ=Jm_Q8xWBn-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wigDNpiLAAS8M=1BUt3FCjWNA8RJr1KRQ=Jm_Q8xWBn-g@mail.gmail.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 10:07:57AM -0800, Linus Torvalds wrote:
> On Mon, Feb 21, 2022 at 10:02 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > I am pretty sure Pablo fixed this one week ago.
> 
> .. looks about right. Apart from the "it was never sent to me, so -rc5
> ended up showing the problem" part.

That's my fault, I did not catch up to reach -rc5, I am sorry about that.
