Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064A536A337
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 23:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237262AbhDXVfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 17:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbhDXVfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 17:35:34 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1357C061574;
        Sat, 24 Apr 2021 14:34:55 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 653C372A6; Sat, 24 Apr 2021 17:34:54 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 653C372A6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1619300094;
        bh=Vr7MaCqYmKYqCBGZEDlXxdj0PiivX/JD0v8BQH6csTc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zW7DwFqDn3bEjPetg6lFRmCCOxUVQ3wRKkwbuZcH5Gp+cmSowrce9F+y32Ze+u2AL
         C6XHzEKVWSVcuSW/lhwoqRmNCEX17Nhd3qvm02miP0sztAPIWrqTvrlFvcrYKvFkn7
         QIBBOrnPZV2U77dJAIhKp/0fXcGngu1nZCIKH1QA=
Date:   Sat, 24 Apr 2021 17:34:54 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "Shelat, Abhi" <a.shelat@northeastern.edu>,
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
Message-ID: <20210424213454.GA4239@fieldses.org>
References: <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
 <20210421133727.GA27929@fieldses.org>
 <YIAta3cRl8mk/RkH@unreal>
 <20210421135637.GB27929@fieldses.org>
 <20210422193950.GA25415@fieldses.org>
 <YIMDCNx4q6esHTYt@unreal>
 <20210423180727.GD10457@fieldses.org>
 <YIMgMHwYkVBdrICs@unreal>
 <20210423214850.GI10457@fieldses.org>
 <YIRkxQCVr6lFM3r3@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIRkxQCVr6lFM3r3@zeniv-ca.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 24, 2021 at 06:34:45PM +0000, Al Viro wrote:
> On Fri, Apr 23, 2021 at 05:48:50PM -0400, J. Bruce Fields wrote:
> > Have umn addresses been blocked from posting to kernel lists?
> 
> I don't see davem ever doing anything of that sort.  I've no information
> about what has really happened, but "Uni lawyers and/or HR telling them
> to stop making anything that might be considered public statements" sounds
> much more plausible...
> 
> Again, it's only a speculation and it might very well have been something
> else, but out of those two variants... I'd put high odds on the latter vs
> the former.

From private email: "Our UMN emails addresses are already banned from
the mailing list."

Also, I didn't get a copy of

	CA+EnHHSw4X+ubOUNYP2zXNpu70G74NN1Sct2Zin6pRgq--TqhA@mail.gmail.com

through vger for some reason, and it didn't make it to lore.kernel.org either.

In Greg's revert thread, Kangjie Lu's messages are also missing from the
archives:

	https://lore.kernel.org/lkml/20210421130105.1226686-1-gregkh@linuxfoundation.org/

??

--b.
