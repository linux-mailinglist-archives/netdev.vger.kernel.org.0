Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD992366F6D
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240975AbhDUPts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:49:48 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49119 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235162AbhDUPtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 11:49:40 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 13LFml82005907
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 11:48:47 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 021AA15C3B0D; Wed, 21 Apr 2021 11:48:46 -0400 (EDT)
Date:   Wed, 21 Apr 2021 11:48:46 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Anna Schumaker <anna.schumaker@netapp.com>,
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
Message-ID: <YIBJXjCbJ1ntH1RF@mit.edu>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <CAFX2JfnGCbanTaGurArBw-5F2MynPD=GpwkfU6wVoNKr9ffzRg@mail.gmail.com>
 <YIAzfsMx6bn5Twu8@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIAzfsMx6bn5Twu8@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 05:15:26PM +0300, Leon Romanovsky wrote:
> > This thread is the first I'm hearing about this. I wonder if there is
> > a good way of alerting the entire kernel community (including those
> > only subscribed to subsystem mailing lists) about what's going on? It
> > seems like useful information to have to push back against these
> > patches.
> 
> IMHO, kernel users ML is good enough for that.

The problem is that LKML is too high traffic for a lot of people to
want to follow.

There are some people who have used the kernel summit discuss list
(previously ksummit-discuss@lists.linux-foundation.org, now
ksummit@lists.linux.dev) as a place where most maintainers tend to be
subscribed, although that's not really a guarantee, either.  (Speaking
of which, how to handle groups who submit patches in bad faith a good
Maintainer Summit topic for someone to propose...)

To give the devil his due, Prof. Kangjie Lu has reported legitimate
security issues in the past (CVE-2016-4482, an information leak from
the kernel stack in the core USB layer, and CVE-2016-4485, an
information leak in the 802.2 networking code), and if one looks at
his CV, he has a quite a few papers in the security area to his name.

The problem is that Prof. Lu and his team seem to be unrepentant, and
has some very... skewed... ideas over what is considered ethical, and
acceptable behavior vis-a-vis the Kernel development community.  The
fact that the UMN IRB team believes that what Prof. Lu is doing isn't
considered in scope for human experimentation means that there isn't
any kind of institutional controls at UMN for this sort of behavior
--- which is why a University-wide Ban may be the only right answer,
unfortunately.

					- Ted
