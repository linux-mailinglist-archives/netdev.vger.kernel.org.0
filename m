Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D9836A2A3
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 20:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbhDXSfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 14:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbhDXSfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 14:35:52 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CAFC061574;
        Sat, 24 Apr 2021 11:35:13 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1laN77-007ybn-Hc; Sat, 24 Apr 2021 18:34:45 +0000
Date:   Sat, 24 Apr 2021 18:34:45 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "J. Bruce Fields" <bfields@fieldses.org>
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
Message-ID: <YIRkxQCVr6lFM3r3@zeniv-ca.linux.org.uk>
References: <YH/8jcoC1ffuksrf@kroah.com>
 <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
 <20210421133727.GA27929@fieldses.org>
 <YIAta3cRl8mk/RkH@unreal>
 <20210421135637.GB27929@fieldses.org>
 <20210422193950.GA25415@fieldses.org>
 <YIMDCNx4q6esHTYt@unreal>
 <20210423180727.GD10457@fieldses.org>
 <YIMgMHwYkVBdrICs@unreal>
 <20210423214850.GI10457@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423214850.GI10457@fieldses.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 05:48:50PM -0400, J. Bruce Fields wrote:
> Have umn addresses been blocked from posting to kernel lists?

I don't see davem ever doing anything of that sort.  I've no information
about what has really happened, but "Uni lawyers and/or HR telling them
to stop making anything that might be considered public statements" sounds
much more plausible...

Again, it's only a speculation and it might very well have been something
else, but out of those two variants... I'd put high odds on the latter vs
the former.
