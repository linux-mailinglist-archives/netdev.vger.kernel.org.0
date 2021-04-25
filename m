Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F8A36A3B9
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 02:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhDYAmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 20:42:39 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41979 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229687AbhDYAmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 20:42:38 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 13P0fRtY031168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 24 Apr 2021 20:41:28 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 3884F15C3BC5; Sat, 24 Apr 2021 20:41:27 -0400 (EDT)
Date:   Sat, 24 Apr 2021 20:41:27 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "J. Bruce Fields" <bfields@fieldses.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Leon Romanovsky <leon@kernel.org>,
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
Message-ID: <YIS6t+X1DOKlB+Z/@mit.edu>
References: <20210421133727.GA27929@fieldses.org>
 <YIAta3cRl8mk/RkH@unreal>
 <20210421135637.GB27929@fieldses.org>
 <20210422193950.GA25415@fieldses.org>
 <YIMDCNx4q6esHTYt@unreal>
 <20210423180727.GD10457@fieldses.org>
 <YIMgMHwYkVBdrICs@unreal>
 <20210423214850.GI10457@fieldses.org>
 <YIRkxQCVr6lFM3r3@zeniv-ca.linux.org.uk>
 <20210424213454.GA4239@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210424213454.GA4239@fieldses.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 24, 2021 at 05:34:54PM -0400, J. Bruce Fields wrote:
> In Greg's revert thread, Kangjie Lu's messages are also missing from the
> archives:
> 
> 	https://lore.kernel.org/lkml/20210421130105.1226686-1-gregkh@linuxfoundation.org/
>

I'm going to guess it's one of two things.  The first is that they are
sending mail messages with HTML which is getting bounced; the other
possibility is that some of the messages were sent only to Greg, and
he added the mailing list back to the cc.

So for exampple, message-id
CA+EnHHSw4X+ubOUNYP2zXNpu70G74NN1Sct2Zin6pRgq--TqhA@mail.gmail.com
isn't in lore, but Greg's reply:

https://lore.kernel.org/linux-nfs/YH%2FfM%2FTsbmcZzwnX@kroah.com/

can be found in lore.kernel.org was presumably because the message
where Aditya accused "wild accusations bordering on slander" and his
claim that his patches were the fault of a "new static code analyzer"
was sent only to Greg?  Either that, or it was bounced because he sent
it from gmail without suppressing HTML.

						- Ted
