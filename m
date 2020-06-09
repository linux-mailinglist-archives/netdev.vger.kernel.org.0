Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D408D1F4827
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 22:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388304AbgFIUbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 16:31:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:51420 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387862AbgFIUbf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 16:31:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9D2DBAC51;
        Tue,  9 Jun 2020 20:31:34 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 548EC60485; Tue,  9 Jun 2020 22:31:27 +0200 (CEST)
Date:   Tue, 9 Jun 2020 22:31:27 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>, o.rempel@pengutronix.de,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, corbet@lwn.net, linville@tuxdriver.com,
        david@protonic.nl, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        mkl@pengutronix.de, marex@denx.de, christian.herber@nxp.com,
        amitc@mellanox.com, petrm@mellanox.com
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration
 support
Message-ID: <20200609203127.aivc3tq4lq4bh6dt@lion.mk-sys.cz>
References: <20200526091025.25243-1-o.rempel@pengutronix.de>
 <20200607153019.3c8d6650@hermes.lan>
 <20200607.164532.964293508393444353.davem@davemloft.net>
 <20200609101935.5716b3bd@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609101935.5716b3bd@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 10:19:35AM -0700, Stephen Hemminger wrote:
> On Sun, 07 Jun 2020 16:45:32 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Stephen Hemminger <stephen@networkplumber.org>
> > Date: Sun, 7 Jun 2020 15:30:19 -0700
> > 
> > > Open source projects have been working hard to remove the terms master and slave
> > > in API's and documentation. Apparently, Linux hasn't gotten the message.
> > > It would make sense not to introduce new instances.  
> > 
> > Would you also be against, for example, the use of the terminology
> > expressing the "death" of allocated registers in a compiler backend,
> > for example?
> > 
> > How far do you plan take this resistence of terminology when it
> > clearly has a well defined usage and meaning in a specific technical
> > realm which is entirely disconnected to what the terms might imply,
> > meaning wise, in other realms?
> > 
> > And if you are going to say not to use this terminology, you must
> > suggest a reasonable (and I do mean _reasonable_) well understood
> > and _specific_ replacement.
> > 
> > Thank you.
> 
> How many times have you or Linus argued about variable naming.
> Yes, words do matter and convey a lot of implied connotation and meaning.
> 
> Most projects and standards bodies are taking a stance on fixing the
> language. The IETF is has proposed making changes as well.
> 
> There are a very specific set of trigger words and terms that
> should be fixed. Most of these terms do have better alternatives.

Where can this list be found and who is the authority to determine what
should be on this list? I could think of a long list of technical terms
which could be seen as offensive in certain context. Some would feel
just as obvious as master/slave, some would be borderline absurd, most
somewhere between. Who has the authority to define what is acceptable
and what not?

Words can have very different meaning and raise different emotions,
depending on context. Even an innocuous word like "black" can be
offensive in certain context; is it a reason to stop talking about this
color or to invent a new name for it? I don't think so - and for obvious
reasons, it wouldn't help anyway. Should we rename rbtrees because of
that? I don't think so either.

The primary purpose of technical terms is to allow people to communicate
and to express themselves in a way that will be easy to understand for
others working in the field. Inventing our own terms which would differ
both from existing relevant standards and from what people in the
industry have been using for decades would not help anything; it would
only make life of ethtool users harder.

> A common example is that master/slave is unclear and would be clearer
> as primary/secondary or active/backup or controller/worker.
> 
> Most of networking is based on standards. When the standards wording changes
> (and it will happen soon); then Linux should also change the wording in the
> source, api and documentation.

Even if you are right about the upcoming change of IEEE standards (and
I can't say I'm convinced), it would make little sense to invent some
replacement terms now and risk that IEEE chooses something else. Waiting
for the standard change (which might take years - or might not even
happen at all) and not providing support for the feature doesn't seem
like a good solution either.

So what exactly would you like us to do?

Michal
