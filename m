Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3AF366D28
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 15:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242826AbhDUNuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 09:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242814AbhDUNuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 09:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 199C161439;
        Wed, 21 Apr 2021 13:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619012975;
        bh=DfvW4thW35pyhxnz0Xb3KHpopcscliALtkpJSIRX4gA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VBmtKNXEDbDJq2+QztTmG9r2Vg8OCWs/gZ/nFZKANBM8qtEdKgo9G//Ro21DlXotR
         IyXp/TqMMa9NHAvp97bjZZfR4Jq/F8M94GEPqrN1y8J+oRa7rP8GSFpGhJCiT3NVeU
         RUZX2Jpw9ukIK/qRqzWgHmdc90tyBKE1iWhBc2ukukB1ynT8UMy0fMsReZkvAZkqib
         pM80DJ6mFWv32EUkoX710SR++2fUXyhAeJowWiFEQx4gYfQlxsSBLDReakV3r52v4e
         mnbLdxAoaiK7rk5LYFACLm0A7nZj5Cl82yCQCXDeYX8E0SCpasBx3qn409RmTNcVfF
         a5VeukcK1eFZQ==
Date:   Wed, 21 Apr 2021 16:49:31 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "J. Bruce Fields" <bfields@fieldses.org>
Cc:     "Shelat, Abhi" <a.shelat@northeastern.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
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
Message-ID: <YIAta3cRl8mk/RkH@unreal>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <YH+7ZydHv4+Y1hlx@kroah.com>
 <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
 <YH/8jcoC1ffuksrf@kroah.com>
 <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
 <20210421133727.GA27929@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421133727.GA27929@fieldses.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 09:37:27AM -0400, J. Bruce Fields wrote:
> On Wed, Apr 21, 2021 at 11:58:08AM +0000, Shelat, Abhi wrote:
> > Academic research should NOT waste the time of a community.
> > 
> > If you believe this behavior deserves an escalation, you can contact
> > the Institutional Review Board (irb@umn.edu) at UMN to investigate
> > whether this behavior was harmful; in particular, whether the research
> > activity had an appropriate IRB review, and what safeguards prevent
> > repeats in other communities.
> 
> For what it's worth, they do address security, IRB, and maintainer-time
> questions in "Ethical Considerations", starting on p. 8:
> 
> 	https://github.com/QiushiWu/QiushiWu.github.io/blob/main/papers/OpenSourceInsecurity.pdf
> 
> (Summary: in that experiment, they claim actual fixes were sent before
> the original (incorrect) patches had a chance to be committed; that
> their IRB reviewed the plan and determined it was not human research;
> and that patches were all small and (after correction) fixed real (if
> minor) bugs.)
> 
> This effort doesn't appear to be following similar protocols, if Leon
> Romanvosky and Aditya Pakki are correct that security holes have already
> reached stable.

Aditya Pakki is the one who is sending those patches.

If you want to see another accepted patch that is already part of
stable@, you are invited to take a look on this patch that has "built-in bug":
8e949363f017 ("net: mlx5: Add a missing check on idr_find, free buf")

Thanks
