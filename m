Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBFE280937
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733022AbgJAVJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:09:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbgJAVJN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 17:09:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07153206FA;
        Thu,  1 Oct 2020 21:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601586553;
        bh=3b7emTpmMUYQews86W+Nuq8ZPrBdUaGVxtUAnAGdsvM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ylFX+G6EI/znbQzPDv0P2Z1QxGOGwboMPkz6oCyuRe/WaFsLO2OHvHIc+7GPyaMRw
         SDrsQ/rqbvEuRv31mz5YqYDhbywxRDok5v0okIe+1SZrb28KGvKTMbbjId7eUKlIdZ
         ruEzBdb1FsFNlnm5HOxYCt+r7J7lG5J9YYTy0SWs=
Date:   Thu, 1 Oct 2020 14:09:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Subject: Re: [PATCH net-next 8/9] genetlink: use per-op policy for
 CTRL_CMD_GETPOLICY
Message-ID: <20201001140911.795b7662@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b9be586bd097f76c554d3e404e0344ae817a12f1.camel@sipsolutions.net>
References: <20201001183016.1259870-1-kuba@kernel.org>
        <20201001183016.1259870-9-kuba@kernel.org>
        <b9be586bd097f76c554d3e404e0344ae817a12f1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 01 Oct 2020 22:55:09 +0200 Johannes Berg wrote:
> On Thu, 2020-10-01 at 11:30 -0700, Jakub Kicinski wrote:
> > Wire up per-op policy for CTRL_CMD_GETPOLICY.
> > This saves us a call to genlmsg_parse() and will soon allow
> > dumping this policy.  
> 
> Hmm. Probably should've asked this before - I think the code makes
> perfect sense, but I'm not sure how "this" follows?
> 
> I mean, we could've saved the genlmsg_parse() call before, with much the
> same patch, having the per-op policy doesn't really have any bearing for
> that? It was just using a different policy - the family one - instead of
> the per-op one, but ...
> 
> Am I missing something?

Hm, not as far as I can tell, I was probably typing out the message
fast cause the commit is kinda obivious.

Looking at the code again now I can't tell why it was calling
genlmsg_parse() in the first place. LMK if you remember if there 
was a reason.

Otherwise I'll just reword.
