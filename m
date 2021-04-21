Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2ED1366CFA
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 15:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241606AbhDUNiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 09:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhDUNiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 09:38:02 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E1FC06174A;
        Wed, 21 Apr 2021 06:37:29 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 3EAEB727A; Wed, 21 Apr 2021 09:37:27 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 3EAEB727A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1619012247;
        bh=tjOxuzcLacggqXWCTUNTvs2fobdJVc3yZMllyUvmCbM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M0UxqnsN9bqRqwQiu9nnZuah8FRUAHfjlm/Ki6GwkkXjskEFA4Lt6gDHc2BLTBvCM
         lxYsCyo0/lZ/wEe9vranLzQcBzJKSFsUC9D+1OjFf6KQBZoLl8B3WDAP0yqPKyVxjc
         jAsV/xHKqpQEBUJvlZcMoA6Y8/gUIWJvuXGEwitI=
Date:   Wed, 21 Apr 2021 09:37:27 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     "Shelat, Abhi" <a.shelat@northeastern.edu>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <20210421133727.GA27929@fieldses.org>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <YH+7ZydHv4+Y1hlx@kroah.com>
 <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
 <YH/8jcoC1ffuksrf@kroah.com>
 <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 11:58:08AM +0000, Shelat, Abhi wrote:
> Academic research should NOT waste the time of a community.
> 
> If you believe this behavior deserves an escalation, you can contact
> the Institutional Review Board (irb@umn.edu) at UMN to investigate
> whether this behavior was harmful; in particular, whether the research
> activity had an appropriate IRB review, and what safeguards prevent
> repeats in other communities.

For what it's worth, they do address security, IRB, and maintainer-time
questions in "Ethical Considerations", starting on p. 8:

	https://github.com/QiushiWu/QiushiWu.github.io/blob/main/papers/OpenSourceInsecurity.pdf

(Summary: in that experiment, they claim actual fixes were sent before
the original (incorrect) patches had a chance to be committed; that
their IRB reviewed the plan and determined it was not human research;
and that patches were all small and (after correction) fixed real (if
minor) bugs.)

This effort doesn't appear to be following similar protocols, if Leon
Romanvosky and Aditya Pakki are correct that security holes have already
reached stable.

Also, I still don't understand the explanation of the original SUNRPC
patch.  I don't know much about static analyzers, but it really doesn't
look like the kind of mistake I'd expect one to make.

--b.
