Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D12636A51D
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 08:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhDYGak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 02:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhDYGaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 02:30:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B51706147F;
        Sun, 25 Apr 2021 06:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619332198;
        bh=XpYhucM6z3qhvkS1BQ76ZyjHypzTB3CNG91CD9wFHK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g8VMoCLTfgJlmlKtaI9opdSQGRmtNOMzGO6XvoNBhvHmHnn3ox6PoAYv5Y+cE3i1T
         sg2+VoR4ZZYPr+75nHqjWLi9mCuaUck3ZSEnJDfnALXrNH7ZITvfDu7uTc5TWAK353
         /YG/RZRlGuaBsQ6ppAaWJug1IYWxtn4Enhb8uwJA=
Date:   Sun, 25 Apr 2021 08:29:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Leon Romanovsky <leon@kernel.org>,
        "Shelat, Abhi" <a.shelat@northeastern.edu>,
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
Message-ID: <YIUMYYcf/VW4a28k@kroah.com>
References: <YIAta3cRl8mk/RkH@unreal>
 <20210421135637.GB27929@fieldses.org>
 <20210422193950.GA25415@fieldses.org>
 <YIMDCNx4q6esHTYt@unreal>
 <20210423180727.GD10457@fieldses.org>
 <YIMgMHwYkVBdrICs@unreal>
 <20210423214850.GI10457@fieldses.org>
 <YIRkxQCVr6lFM3r3@zeniv-ca.linux.org.uk>
 <20210424213454.GA4239@fieldses.org>
 <YIS6t+X1DOKlB+Z/@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIS6t+X1DOKlB+Z/@mit.edu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 24, 2021 at 08:41:27PM -0400, Theodore Ts'o wrote:
> On Sat, Apr 24, 2021 at 05:34:54PM -0400, J. Bruce Fields wrote:
> > In Greg's revert thread, Kangjie Lu's messages are also missing from the
> > archives:
> > 
> > 	https://lore.kernel.org/lkml/20210421130105.1226686-1-gregkh@linuxfoundation.org/
> >
> 
> I'm going to guess it's one of two things.  The first is that they are
> sending mail messages with HTML which is getting bounced; the other
> possibility is that some of the messages were sent only to Greg, and
> he added the mailing list back to the cc.
> 
> So for exampple, message-id
> CA+EnHHSw4X+ubOUNYP2zXNpu70G74NN1Sct2Zin6pRgq--TqhA@mail.gmail.com
> isn't in lore, but Greg's reply:
> 
> https://lore.kernel.org/linux-nfs/YH%2FfM%2FTsbmcZzwnX@kroah.com/
> 
> can be found in lore.kernel.org was presumably because the message
> where Aditya accused "wild accusations bordering on slander" and his
> claim that his patches were the fault of a "new static code analyzer"
> was sent only to Greg?  Either that, or it was bounced because he sent
> it from gmail without suppressing HTML.

I did not "add back" the mailing list, it looks like they sent email in
html format which prevented it from hitting the public lists.  I have
the originals sent to me that shows the author intended it to be public.

thanks,

greg k-h
