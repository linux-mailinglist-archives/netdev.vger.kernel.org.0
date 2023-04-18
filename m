Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC3B6E5ED0
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 12:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjDRKbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 06:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjDRKbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 06:31:48 -0400
Received: from sonata.ens-lyon.org (domu-toccata.ens-lyon.fr [140.77.166.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEB76E95;
        Tue, 18 Apr 2023 03:31:43 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by sonata.ens-lyon.org (Postfix) with ESMTP id 9FC492016C;
        Tue, 18 Apr 2023 12:31:40 +0200 (CEST)
Received: from sonata.ens-lyon.org ([127.0.0.1])
        by localhost (sonata.ens-lyon.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WlsvRcHiY9vx; Tue, 18 Apr 2023 12:31:40 +0200 (CEST)
Received: from begin.home (apoitiers-658-1-118-253.w92-162.abo.wanadoo.fr [92.162.65.253])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by sonata.ens-lyon.org (Postfix) with ESMTPSA id 3CF882016D;
        Tue, 18 Apr 2023 12:31:40 +0200 (CEST)
Received: from samy by begin.home with local (Exim 4.96)
        (envelope-from <samuel.thibault@ens-lyon.org>)
        id 1poice-00ByJF-1p;
        Tue, 18 Apr 2023 12:31:40 +0200
Date:   Tue, 18 Apr 2023 12:31:40 +0200
From:   Samuel Thibault <samuel.thibault@ens-lyon.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPPoL2TP: Add more code snippets
Message-ID: <20230418103140.cps6csryl2xhrazz@begin>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Guillaume Nault <gnault@redhat.com>,
        James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230416220704.xqk4q6uwjbujnqpv@begin>
 <ZD5V+z+cBaXvPbQa@debian>
 <20230418085323.h6xij7w6d2o4kxxi@begin>
 <ZD5dqwPblo4FOex1@debian>
 <20230418091148.hh3b52zceacduex6@begin>
 <ZD5uU8Wrz4cTSwqP@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD5uU8Wrz4cTSwqP@debian>
Organization: I am not organized
User-Agent: NeoMutt/20170609 (1.8.3)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guillaume Nault, le mar. 18 avril 2023 12:17:55 +0200, a ecrit:
> On Tue, Apr 18, 2023 at 11:11:48AM +0200, Samuel Thibault wrote:
> > Guillaume Nault, le mar. 18 avril 2023 11:06:51 +0200, a ecrit:
> > > On Tue, Apr 18, 2023 at 10:53:23AM +0200, Samuel Thibault wrote:
> > > > Guillaume Nault, le mar. 18 avril 2023 10:34:03 +0200, a ecrit:
> > > > > PPPIOCBRIDGECHAN's description
> > > > > belongs to Documentation/networking/ppp_generic.rst, where it's already
> > > > > documented.
> > > > 
> > > > Yes but that's hard to find out when you're looking from the L2TP end.
> > > 
> > > That's why I proposed linking to ppp_generic.rst.
> > 
> > Yes, but it's still not obvious to L2TP people that it's a ppp channel
> > that you have to bridge. Really, having that 20-line snippet available
> > would have saved me some head-scratching time.
> 
> But the reverse is also true: someone looking at the PPP documentation
> is probably not going to realise that PPP sample code have been put in
> the L2TP doc.

Yes, but for PPP people it is obvious that you'll want to bridge two
channels.

The point of the code is not really the bridging ioctl call, but the
fact that you have to use PPPIOCGCHAN over the two sessions, then open
a ppp channel, to be able to make the bridging ioctl call. *That*
is what is really not obvious, and will not actually fit in the PPP
documentation. Of course we could move the few ppp-only lines to the PPP
documentation, but I really don't see the point: that part is obvious in
the PPP context.

Samuel
