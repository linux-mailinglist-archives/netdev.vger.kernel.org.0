Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B27B316F1C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbhBJSqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:46:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:54112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234318AbhBJSoL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 13:44:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21D1A64E0D;
        Wed, 10 Feb 2021 18:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612982610;
        bh=WO0fs6p0dwao0E+r/M0bwkcWzz+fR+hDGQs/UYx+WpA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GST2UoPevzobYunaUrJYRE2jPH08FmtcgIFz+JEExYC1nmBc8kDS/GMV2dHXD9b05
         YXu0C9WOUSP4WsgvFYNGmu0oIwYYi9rsDOMCb3CRAzpJ0fQsjLYymcll0RBoJSXCue
         F42pkGL6pDrbrWMiS6Zdpddete5moxdZp+nyoogFmGyGBPmPHDLqF72ZfNCnZ5iLeF
         y2rihF3Gx/mL25KlScJCmbLYqM1uE1SbIH/qKvtuleuz9dNRr6nkl9zkzb4BjBNFkv
         2XQhTv7rFMGL1jxjzEqYdmFFC8Wjf+YvU32AQs11m4U8Bok3BnDIW8MDsQsNSz9bat
         Zh0RFuTt7YUiQ==
Date:   Wed, 10 Feb 2021 10:43:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Nathan Chancellor <nathan@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Michal Marek" <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH RFC/RFT 0/2] W=1 by default for Ethernet PHY subsystem
Message-ID: <20210210104329.3ecf3dd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210210183917.GA1471624@nvidia.com>
References: <20200919190258.3673246-1-andrew@lunn.ch>
        <CAK7LNASY6hTDo8cuH5H_ExciEybBPbAuB3OxsmHbUUgoES94EA@mail.gmail.com>
        <20200920145351.GB3689762@lunn.ch>
        <20210210183917.GA1471624@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Feb 2021 14:39:17 -0400 Jason Gunthorpe wrote:
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

Do you use patchwork? A little bit of automation is all you need,
really. kbuild bot is too slow, anyway.

> Andrew, would you consider respinning this series in the above form?
