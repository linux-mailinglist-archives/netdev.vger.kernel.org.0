Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1148328E764
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 21:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390763AbgJNTf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 15:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390744AbgJNTf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 15:35:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC90C061755;
        Wed, 14 Oct 2020 12:35:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kSmYx-0003tJ-Cz; Wed, 14 Oct 2020 21:35:51 +0200
Date:   Wed, 14 Oct 2020 21:35:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf v2] netfilter: conntrack: connection timeout after
 re-register
Message-ID: <20201014193551.GD16895@breakpoint.cc>
References: <CA+HUmGhBxBHU85oFfvoAyP=hG17DG2kgO67eawk1aXmSjehOWQ@mail.gmail.com>
 <alpine.DEB.2.23.453.2010090838430.19307@blackhole.kfki.hu>
 <20201009110323.GC5723@breakpoint.cc>
 <alpine.DEB.2.23.453.2010092035550.19307@blackhole.kfki.hu>
 <20201009185552.GF5723@breakpoint.cc>
 <alpine.DEB.2.23.453.2010092132220.19307@blackhole.kfki.hu>
 <20201009200548.GG5723@breakpoint.cc>
 <20201014000628.GA15290@salvia>
 <20201014082341.GA16895@breakpoint.cc>
 <CA+HUmGij2kddxovowfK=Wt=SB6N2sTLTb1Hs+65MfrZGpv=YWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+HUmGij2kddxovowfK=Wt=SB6N2sTLTb1Hs+65MfrZGpv=YWg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Francesco Ruggeri <fruggeri@arista.com> wrote:
> On Wed, Oct 14, 2020 at 1:23 AM Florian Westphal <fw@strlen.de> wrote:
> >
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Legacy would still be flawed though.
> >
> > Its fine too, new rule blob gets handled (and match/target checkentry
> > called) before old one is dismantled.
> >
> > We only have a 0 refcount + hook unregister when rules get
> > flushed/removed explicitly.
> 
> Should the patch be used in the meantime while this gets
> worked out?

I think the patch is correct, and I do NOT see a better solution.
