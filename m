Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB0D316F7B
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 20:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbhBJTDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 14:03:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33148 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232904AbhBJTCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 14:02:41 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9ukL-005NMX-Ou; Wed, 10 Feb 2021 20:01:53 +0100
Date:   Wed, 10 Feb 2021 20:01:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jason Gunthorpe <jgg@nvidia.com>, Arnd Bergmann <arnd@arndb.de>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH RFC/RFT 0/2] W=1 by default for Ethernet PHY subsystem
Message-ID: <YCQtoYFZzfNmGhd/@lunn.ch>
References: <20200919190258.3673246-1-andrew@lunn.ch>
 <CAK7LNASY6hTDo8cuH5H_ExciEybBPbAuB3OxsmHbUUgoES94EA@mail.gmail.com>
 <20200920145351.GB3689762@lunn.ch>
 <20210210183917.GA1471624@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210183917.GA1471624@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 02:39:17PM -0400, Jason Gunthorpe wrote:
> On Sun, Sep 20, 2020 at 04:53:51PM +0200, Andrew Lunn wrote:
> 
> > How often are new W=1 flags added? My patch exported
> > KBUILD_CFLAGS_WARN1. How about instead we export
> > KBUILD_CFLAGS_WARN1_20200920. A subsystem can then sign up to being
> > W=1 clean as for the 20200920 definition of W=1.
> 
> I think this is a reasonable idea.
> 
> I'm hitting exactly the issue this series is trying to solve, Lee
> invested a lot of effort to make drivers/infiniband/ W=1 clean, but
> as maintainer I can't sustain this since there is no easy way to have
> a warning free compile and get all extra warnings.  Also all my
> submitters are not running with W=1
> 
> I need kbuild to get everyone on the same page to be able to sustain
> the warning clean up. We've already had a regression and it has only
> been a few weeks :(
> 
> Andrew, would you consider respinning this series in the above form?

Arnd has worked on the core parts. But i lost track of if his patches
got merged.

    Andrew
