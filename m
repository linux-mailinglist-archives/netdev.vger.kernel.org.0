Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E9F31AA3
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 10:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfFAIxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 04:53:38 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35842 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726210AbfFAIxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 04:53:38 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hWzlf-0001Va-Q3; Sat, 01 Jun 2019 10:53:36 +0200
Date:   Sat, 1 Jun 2019 10:53:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: add support for matching IPv4 options
Message-ID: <20190601085335.axjlmtl23py6i4jo@breakpoint.cc>
References: <20190523093801.3747-1-ssuryaextr@gmail.com>
 <20190531171101.5pttvxlbernhmlra@salvia>
 <20190531193558.GB4276@ubuntu>
 <20190601002230.bo6dhdf3lhlkknqq@salvia>
 <20190601082732.fpgrqtcj7i7g6wek@breakpoint.cc>
 <20190601084025.rheeejbn3clpgsmu@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601084025.rheeejbn3clpgsmu@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >         if (skb->protocol != htons(ETH_P_IP))
> > >                 goto err;
> > 
> > Wouldn't it be preferable to just use nft_pf() != NFPROTO_IPV4?
> 
> Then IPv4 options extension won't work from bridge and netdev families
> too, right?

Ah, right.
