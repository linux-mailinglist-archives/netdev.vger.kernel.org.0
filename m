Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505E136652F
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 08:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbhDUGI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 02:08:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234510AbhDUGI6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 02:08:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8E29613F0;
        Wed, 21 Apr 2021 06:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618985305;
        bh=WIwPEMJ2n2GN6Jt5ndPkfj7Jm7o9UsjQNTF/6yR/MTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=InOtHgCHHyr+UD/fD4781eHlCauiwID5+l3E/0C87fRACgeHv7qNSuJDe/h9kBnd7
         4A2TQg8JZfNjlxd7hN5LuE5oDORFNqmcxXE/vF13CMQuBRSiqrncI/77a1pnCs8hN2
         EquWx2/oCxBJBDrwi690LLrmqPDyNZjyaAQqrH4DCWJbHVXj+z8sX48UCYp4ImdS4+
         UL8ctNm7RtjL3P7T7ve6B3okuJVP704lPWxbIHecjZrXJXiKIq6Us/1tuuSgEMFzHs
         GdBHDxWMwfB7OrgLZt3JDEJ1rvwYOuIt5V7yK+lcvvIreWLEPPe9X5DIk3SAZNhS2Z
         G7urCY6QYfu2g==
Date:   Wed, 21 Apr 2021 09:08:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "J. Bruce Fields" <bfields@fieldses.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <YH/BVW9Kdr9nY5Bs@unreal>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <YH+7ZydHv4+Y1hlx@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH+7ZydHv4+Y1hlx@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 07:43:03AM +0200, Greg KH wrote:
> On Wed, Apr 21, 2021 at 08:10:25AM +0300, Leon Romanovsky wrote:
> > On Tue, Apr 20, 2021 at 01:10:08PM -0400, J. Bruce Fields wrote:
> > > On Tue, Apr 20, 2021 at 09:15:23AM +0200, Greg KH wrote:
> > > > If you look at the code, this is impossible to have happen.
> > > > 
> > > > Please stop submitting known-invalid patches.  Your professor is playing
> > > > around with the review process in order to achieve a paper in some
> > > > strange and bizarre way.
> > > > 
> > > > This is not ok, it is wasting our time, and we will have to report this,
> > > > AGAIN, to your university...
> > > 
> > > What's the story here?
> > 
> > Those commits are part of the following research:
> > https://github.com/QiushiWu/QiushiWu.github.io/blob/main/papers/OpenSourceInsecurity.pdf
> > 
> > They introduce kernel bugs on purpose. Yesterday, I took a look on 4
> > accepted patches from Aditya and 3 of them added various severity security
> > "holes".
> 
> All contributions by this group of people need to be reverted, if they
> have not been done so already, as what they are doing is intentional
> malicious behavior and is not acceptable and totally unethical.  I'll
> look at it after lunch unless someone else wants to do it...

It looks like the best possible scenario.
I asked to revert the bad patch, but didn't get any response yet.
https://lore.kernel.org/lkml/YH6aMsbqruMZiWFe@unreal/

> 
> greg k-h
