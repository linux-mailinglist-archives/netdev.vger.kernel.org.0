Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53C522151F
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 21:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgGOT3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 15:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgGOT3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 15:29:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F72C061755;
        Wed, 15 Jul 2020 12:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Cs+ssoFPiLBwIp06S37VFrgawBn4e+6j6l0HBWQmAdY=; b=tar9bucyRxAn9AAKh1yN1PgZKq
        mvuXTee+3CtsvjN2QrZ6uAZUmKRp9r8l03IT3TBo9cKDfPsoGRs0TD6HI7kq5iSe9xtqSH3jFVEHt
        QPjSWH28IIADjliW3RqGwxb4pyh0M13eJxgI1QW8EQGUdLYg9bMoXYLjL1Vxob7OGs8GObMdYsVoV
        yHBDZp+Osrq711dqxAFMf0zlSvMAxrD/+lqnphy5UbDVlUEAP5EPqt9qv/sXw5IAIqYcQQkxoCvGL
        gDPHE+H9gLCCHNdLroOpJQX/WhGkXnoR+MA2WKDKBXO3usXCu7G1cwHKj3siXvCw4+UFSC4nmlBAO
        Tojpr0xA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvn5Q-0008M6-NV; Wed, 15 Jul 2020 19:29:00 +0000
Date:   Wed, 15 Jul 2020 20:29:00 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        davem@davemloft.net, richardcochran@gmail.com, sorganov@gmail.com,
        andrew@lunn.ch, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] docs: networking: timestamping: replace tabs
 with spaces in code blocks
Message-ID: <20200715192900.GH12769@casper.infradead.org>
References: <20200709202210.72985-1-olteanv@gmail.com>
 <20200715121717.41aaff49@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715121717.41aaff49@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 12:17:17PM -0700, Jakub Kicinski wrote:
> On Thu,  9 Jul 2020 23:22:10 +0300 Vladimir Oltean wrote:
> > Reading the document in vim is currently not a pleasant experience. Its
> > rst syntax highlighting is confused by the "*/" sequences which it's not
> > interpreting as part of the code blocks for some reason.
> > 
> > Replace the tabs with spaces, so that syntax highlighters (at least the
> > one in vim) have a better idea where code blocks start and where they
> > end.
> > 
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> 
> Dunno about this change, there seems to be plenty examples of using
> tabs for indentation of code block :(
> 
> Jon, any guidance? It seems to me the document renders correctly [1],
> so the onus is on the editor to fix the RST highlight..

vim's rst mode really really really wants to use spaces instead of tabs.
It's screwed me over a bunch of times, so I eventually just disabled it.
I think we should probably stop fighting it and use spaces in rst files
instead of tabs, but that's not my call to make.
