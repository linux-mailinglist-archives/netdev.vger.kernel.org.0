Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8DD28162A
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388301AbgJBPJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388297AbgJBPJr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 11:09:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 763BD206CA;
        Fri,  2 Oct 2020 15:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601651386;
        bh=WmJAStJoHQbnv/9CNpbfA1eIjGOEEMN9AvILqwRC6w4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IhZDs7HYtqtoOCTFmXlsQKr5Gu0tWf5vzZ+7lDCTa8DY6MQlxZmlYeEF9GraFlkor
         0ZhxyYkXpjnma0KlyVaco2jXAqY4bVf3ybmOjF3ezScFrGjqRJCmEY3CyT2TVFC800
         pJ2WWXxtyUoIdwhMi+ZQsAdBx5IZOAlqv3TOzLDk=
Date:   Fri, 2 Oct 2020 08:09:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
Message-ID: <20201002080944.2f63ccf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a69c92aac65c718b1bd80c8dc0cbb471cdd17d9b.camel@sipsolutions.net>
References: <20201001225933.1373426-1-kuba@kernel.org>
        <20201001173644.74ed67da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d26ccd875ebac452321343cc9f6a9e8ef990efbf.camel@sipsolutions.net>
        <20201002074001.3484568a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1dacbe07dc89cd69342199e61aeead4475f3621c.camel@sipsolutions.net>
        <20201002075538.2a52dccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e350fbdadd8dfa07bef8a76631d8ec6a6c6e8fdf.camel@sipsolutions.net>
        <20201002080308.7832bcc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a69c92aac65c718b1bd80c8dc0cbb471cdd17d9b.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 02 Oct 2020 17:04:11 +0200 Johannes Berg wrote:
> > > Yeah, that'd work. I'd probably wonder if we shouldn't do
> > > 
> > > [OP_POLICY]
> > >   [OP] -> (u32, u32)
> > > 
> > > in a struct with two u32's, since that's quite a bit more compact.  
> > 
> > What do we do if the op doesn't have a dump or do callback?
> > 0 is a valid policy ID, sadly :(  
> 
> Hm, good point. We could do -1 since that can't ever be reached though.
> 
> But compactness isn't really that necessary here anyway, so ...

Cool, sounds like a plan.

This series should be good to merge, then.
