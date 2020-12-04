Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1DB2CF17F
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730731AbgLDQE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728355AbgLDQE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 11:04:29 -0500
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074A7C0613D1;
        Fri,  4 Dec 2020 08:03:49 -0800 (PST)
Received: by fieldses.org (Postfix, from userid 2815)
        id DF8FC6F73; Fri,  4 Dec 2020 11:03:47 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org DF8FC6F73
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1607097827;
        bh=ERIkl1BDXlF5O6syA29Bwhswr1FuTLeR381zvqC+rxM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b1JQi9U80NaedGr7RHRaQCnG5xEb1uwUKyGuRYMKooN+bXDIHFlQ/Cln4KMm+3YMB
         2RA6oh05GDlF4ZCKlCkKbUcS+97xKciT+0QrSFC4ldMYSkYip8ldKOr/vTiipIM9RZ
         eVl7dWRSgWW1tfpFPNJL17gbMtkai9ahTAXcshoQ=
Date:   Fri, 4 Dec 2020 11:03:47 -0500
From:   Bruce Fields <bfields@fieldses.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-afs@lists.infradead.org
Subject: Re: Why the auxiliary cipher in gss_krb5_crypto.c?
Message-ID: <20201204160347.GA26933@fieldses.org>
References: <20201204154626.GA26255@fieldses.org>
 <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <118876.1607093975@warthog.procyon.org.uk>
 <122997.1607097713@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <122997.1607097713@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 04:01:53PM +0000, David Howells wrote:
> Bruce Fields <bfields@fieldses.org> wrote:
> 
> > > Reading up on CTS, I'm guessing the reason it's like this is that CTS is the
> > > same as the non-CTS, except for the last two blocks, but the non-CTS one is
> > > more efficient.
> > 
> > CTS is cipher-text stealing, isn't it?  I think it was Kevin Coffman
> > that did that, and I don't remember the history.  I thought it was
> > required by some spec or peer implementation (maybe Windows?) but I
> > really don't remember.  It may predate git.  I'll dig around and see
> > what I can find.
> 
> rfc3961 and rfc3962 specify CTS-CBC with AES.

OK, I guess I don't understand the question.  I haven't thought about
this code in at least a decade.  What's an auxilary cipher?  Is this a
question about why we're implementing something, or how we're
implementing it?

--b.
