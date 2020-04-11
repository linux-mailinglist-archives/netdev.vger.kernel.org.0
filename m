Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 775E21A4D31
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 03:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgDKBZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 21:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbgDKBZW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 21:25:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBE8E20769;
        Sat, 11 Apr 2020 01:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586568322;
        bh=TWbyE+EqwTe+jIEChvMLFpB3MlKo1Q4FXuxiYXJdQnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P+nnIvAMDAugH92UEBEDkfb05UWMCSONM0ZO5vry92MOslZ5TTC9Hp/JR4RtWOguL
         yvJxpgoQiaZPDYrysLlxP/7o1nLxJweFjtgVm+RNWzPLihBaQaQWiP/P0W/Qzs7GTq
         TNRwR9LpVqH2l4c5ExJrvrzKAv3n+778pQXAXg80=
Date:   Fri, 10 Apr 2020 18:25:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tal Gilboa <talgi@mellanox.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>
Subject: Re: [PATCH net v2 1/2] docs: networking: convert DIM to RST
Message-ID: <20200410182520.34157620@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4569455bbdd44f08e31d2206031f8fcc39702c9f.camel@mellanox.com>
References: <20200409212159.322775-1-kuba@kernel.org>
        <1210a28bfe1a67818f3f814e38f52923cbd201c0.camel@mellanox.com>
        <20200409160658.1b940fcf@kicinski-fedora-PC1C0HJN>
        <4569455bbdd44f08e31d2206031f8fcc39702c9f.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Apr 2020 21:59:56 +0000 Saeed Mahameed wrote:
> On Thu, 2020-04-09 at 16:06 -0700, Jakub Kicinski wrote:
> > On Thu, 9 Apr 2020 22:46:55 +0000 Saeed Mahameed wrote:  
> > > On Thu, 2020-04-09 at 14:21 -0700, Jakub Kicinski wrote:  
> > > > Convert the Dynamic Interrupt Moderation doc to RST and
> > > > use the RST features like syntax highlight, function and
> > > > structure documentation, enumerations, table of contents.
> > > > 
> > > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > > Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> > > > ---
> > > > v2:
> > > >  - remove the functions/type definition markup
> > > >  - change the contents definition (the :local: seem to
> > > >    not work too well with kdoc)
> > > > ---
> > > >  Documentation/networking/index.rst            |  1 +
> > > >  .../networking/{net_dim.txt => net_dim.rst}   | 90 +++++++++--
> > > > ----
> > > > ----
> > > >  MAINTAINERS                                   |  1 +
> > > >  3 files changed, 45 insertions(+), 47 deletions(-)
> > > >  rename Documentation/networking/{net_dim.txt => net_dim.rst}
> > > > (79%)
> > > > 
> > > > diff --git a/Documentation/networking/index.rst
> > > > b/Documentation/networking/index.rst
> > > > index 50133d9761c9..6538ede29661 100644
> > > > --- a/Documentation/networking/index.rst
> > > > +++ b/Documentation/networking/index.rst
> > > > @@ -22,6 +22,7 @@ Linux Networking Documentation
> > > >     z8530book
> > > >     msg_zerocopy
> > > >     failover
> > > > +   net_dim    
> > > 
> > > net_dim is a performance feature, i would move further down the
> > > list
> > > where the perf features such as scaling and offloads are ..   
> > 
> > I mean.. so is msg_zerocopy just above ;-)  I spotted slight
> > alphabetical ordering there, which may have not been intentional,
> > that's why I put it here. Marking with # things out of order, but 
> > based on just the first letter:
> >   
> 
> Oh i didn't see the alphabetical order :), then i guess your patch is
> ok.

Cool, applied.

> > #  netdev-FAQ
> >    af_xdp
> >    bareudp
> >    batman-adv
> >    can
> >    can_ucan_protocol
> >    device_drivers/index
> >    dsa/index
> >    devlink/index
> >    ethtool-netlink
> >    ieee802154
> >    j1939
> >    kapi
> > #  z8530book
> >    msg_zerocopy
> > #  failover
> >    net_dim
> >    net_failover
> >    phy
> >    sfp-phylink
> > #  alias
> > #  bridge
> >    snmp_counter
> > #  checksum-offloads
> >    segmentation-offloads
> >    scaling
> >    tls
> >    tls-offload
> > #  nfc
> >    6lowpan
> > 
> > My feeling is that we should start considering splitting kernel-only
> > docs and admin-only docs for networking, which I believe is the
> > direction Jon and folks want Documentation/ to go. But I wasn't brave
> > enough to be the first one. Then we can impose some more structure,
> > like putting all "performance" docs in one subdir..?
> > 
> > WDYT?  
> 
> That was my initial thought, but it seemed like a lot of work and
> really not related to your patch.
> 
> But yes, categorizing is the way to go.. alphabetical order doesn't
> really make any sense unless you know exactly what you are looking for,
> which is never the case :),
> For someone who want to learn about performance tuning or something
> specific like coalescing, what should they look for ? DIM, NET DIM,
> moderation or coalescing ? so if we categorize and keep the subdirs
> lists short and focused, it will be very easy for people to browse the
> networking docs..

Fully agree.

> Things can grow large very fast beyond our control.. We should really
> embrace the "Magic number 7" approach [1] :)
> 
> Helps keep things short, organized and focused.
> 
> [1] 
> https://www.i-programmer.info/babbages-bag/621-the-magic-number-seven.html

Here I thought the magic number was 3 :-P

https://queue.acm.org/detail.cfm?id=3387947
