Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3068A20A6E9
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391032AbgFYUkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:40:31 -0400
Received: from fieldses.org ([173.255.197.46]:53300 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390477AbgFYUka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 16:40:30 -0400
Received: by fieldses.org (Postfix, from userid 2815)
        id 1C8E879A1; Thu, 25 Jun 2020 16:40:29 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 1C8E879A1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1593117629;
        bh=grAX8yggjJQZeEuTqT849+RECeUjWPrYL7L8CDwHWzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gj0MuGKTpqfBnugVSHAllzwtU32mbRNrz5LhpqXoB8FX/dI6FdoUiXA6zXnyorll9
         J8Wg0vYTe1AOKJQyhZwkkl/QiRqNB70nQBPja5EppPVNzeFep+Z8g/ySzPNxVjIaPi
         XVxnHn82AD79SvIa9xchcmtUWE/pnD9cata6TvZo=
Date:   Thu, 25 Jun 2020 16:40:29 -0400
From:   Bruce Fields <bfields@fieldses.org>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] SUNRPC: Add missing definition of
 ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
Message-ID: <20200625204029.GD6605@fieldses.org>
References: <9e9882a2fb57b6f9d98a0a5d8b6bf9cff9fcbd93.1592202173.git.christophe.leroy@csgroup.eu>
 <733E4CAF-A9E5-491F-B0C7-69CA84E5DFA5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <733E4CAF-A9E5-491F-B0C7-69CA84E5DFA5@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 08:33:40AM -0400, Chuck Lever wrote:
> 
> 
> > On Jun 15, 2020, at 2:25 AM, Christophe Leroy <christophe.leroy@csgroup.eu> wrote:
> > 
> > Even if that's only a warning, not including asm/cacheflush.h
> > leads to svc_flush_bvec() being empty allthough powerpc defines
> > ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE.
> > 
> >  CC      net/sunrpc/svcsock.o
> > net/sunrpc/svcsock.c:227:5: warning: "ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE" is not defined [-Wundef]
> > #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
> >     ^
> > 
> > Include linux/highmem.h so that asm/cacheflush.h will be included.
> > 
> > Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Cc: Chuck Lever <chuck.lever@oracle.com>
> > Fixes: ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()")
> > Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> 
> LGTM.
> 
> Acked-by: Chuck Lever <chuck.lever@oracle.com>

Thanks, applying for 5.8.--b.
