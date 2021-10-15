Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CD342EF20
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 12:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238168AbhJOKw6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 15 Oct 2021 06:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238167AbhJOKwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 06:52:54 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2197C061570;
        Fri, 15 Oct 2021 03:50:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mbKnW-0000QY-AO; Fri, 15 Oct 2021 12:50:46 +0200
Date:   Fri, 15 Oct 2021 12:50:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH netfilter] netfilter: conntrack: udp: generate event on
 switch to stream timeout
Message-ID: <20211015105046.GI2942@breakpoint.cc>
References: <20211015090934.2870662-1-zenczykowski@gmail.com>
 <YWlKGFpHa5o5jFgJ@salvia>
 <CANP3RGdCBzjWuK8FfHOOKcFAbd_Zru=DkOBBpD3d_PYDR91P5g@mail.gmail.com>
 <20211015095716.GH2942@breakpoint.cc>
 <CAHo-OoxsN5d+ipbp0TQ=a+o=ynd3-w5RZ3S3F8Vg89ipT5=UHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAHo-OoxsN5d+ipbp0TQ=a+o=ynd3-w5RZ3S3F8Vg89ipT5=UHw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Żenczykowski <zenczykowski@gmail.com> wrote:
> On Fri, Oct 15, 2021 at 2:57 AM Florian Westphal <fw@strlen.de> wrote:
> > Do you think it makes sense to just delay setting the ASSURED bit
> > until after the 2s period?
> 
> That would work for this particular use case.... but I don't know if
> it's a good idea.
> I did of course think of it, but the commit message seemed to imply
> there's a good reason to set the assured bit earlier rather than
> later...
> 
> A udp flow becoming bidirectional seems like an important event to
> notify about...
> Afterall, the UDP flow might become a stream 29 seconds after it
> becomes bidirectional...

Oh right, never mind then.

Acked-by: Florian Westphal <fw@strlen.de>
