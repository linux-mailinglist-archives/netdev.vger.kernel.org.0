Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB92367169
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244697AbhDURfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242842AbhDURfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F35A461459;
        Wed, 21 Apr 2021 17:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619026509;
        bh=jsF90jMAoP9rK5ubz9IvKkVCBAZVLs25dg+tP0TLXVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CI/LM0CuFrIxtemc7ItH2CTT5rer1JL8jQlmFFw0zQO98sG1dSJAHsiOCoi0fgmgP
         lRH2hvNnMgiD9yohzQHoR+PQQRvICsZcNQ/GjE50SdDeyzpBqouFisnzs1e97adR9l
         cRZFSIlL7+FCibqyAziu+I+IBU/btp5XJpAQPhL5v2IAw88co9nhh+CucTualNI1rL
         j1aVfUqIP+FEy7kc1TZAR/4rw/GvCNUZ6X0Br6y3Znde9OZyK0Ljza2CBq4gCwYjLh
         D4llnQ2T7kbGNqy9HYKO8+sEmU3tY3LNXrmy6OsfN3LRMRnkmSKBrS1aERhseka/oo
         etulTyRUw7+Og==
Date:   Wed, 21 Apr 2021 20:34:59 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <YIBiQ3p9z7y6PeqT@kernel.org>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <CAFX2JfnGCbanTaGurArBw-5F2MynPD=GpwkfU6wVoNKr9ffzRg@mail.gmail.com>
 <YIAzfsMx6bn5Twu8@unreal>
 <YIBJXjCbJ1ntH1RF@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIBJXjCbJ1ntH1RF@mit.edu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 11:48:46AM -0400, Theodore Ts'o wrote:
> On Wed, Apr 21, 2021 at 05:15:26PM +0300, Leon Romanovsky wrote:
> > > This thread is the first I'm hearing about this. I wonder if there is
> > > a good way of alerting the entire kernel community (including those
> > > only subscribed to subsystem mailing lists) about what's going on? It
> > > seems like useful information to have to push back against these
> > > patches.

Heh, I've got this information from google news feed on my phone :)
 
> > IMHO, kernel users ML is good enough for that.
> 
> The problem is that LKML is too high traffic for a lot of people to
> want to follow.

I think Leon meant kernel.org users ML (users@linux.kernel.org). Along with
ksummut-discuss it'll reach most maintainers, IMHO.
 
> There are some people who have used the kernel summit discuss list
> (previously ksummit-discuss@lists.linux-foundation.org, now
> ksummit@lists.linux.dev) as a place where most maintainers tend to be
> subscribed, although that's not really a guarantee, either.  (Speaking
> of which, how to handle groups who submit patches in bad faith a good
> Maintainer Summit topic for someone to propose...)

-- 
Sincerely yours,
Mike.
