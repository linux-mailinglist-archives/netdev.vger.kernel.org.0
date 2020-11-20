Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F388B2BA50D
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 09:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbgKTIsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 03:48:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726896AbgKTIsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 03:48:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605862080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9kyanfqjEK3v09gPc0MvvYIMy7ftvIBiugYgleDApks=;
        b=iyQur7uKS6A5ZZiQQ+e+lL11PPnSYk/m1P/fA3gYJWUilaWJDB8MsHR4SW3Hf+7VORKF77
        CZjmXvSGvxNuuyBGolVsqHZ6mxJfJ2+g6YvJy7IKgCNsGVMrren/XfI0uvS1RGkUFTigRL
        Ea387MEUa7FUQtnpD+e9fFkDEFFWg8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-RCOzyPtgNGKQerkAPD6D2A-1; Fri, 20 Nov 2020 03:47:55 -0500
X-MC-Unique: RCOzyPtgNGKQerkAPD6D2A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 369741005D65;
        Fri, 20 Nov 2020 08:47:54 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63E2A5D9C6;
        Fri, 20 Nov 2020 08:47:48 +0000 (UTC)
Date:   Fri, 20 Nov 2020 09:47:46 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Joe Perches <joe@perches.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        brouer@redhat.com
Subject: Re: [PATCH net-next] MAINTAINERS: Update XDP and AF_XDP entries
Message-ID: <20201120094746.31e90c91@carbon>
In-Reply-To: <8eef085f2b4d565463d5251a4868c7aaa19bf6ab.camel@perches.com>
References: <160580680009.2806072.11680148233715741983.stgit@firesoul>
        <20201119100210.08374826@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201119215012.57d39102@carbon>
        <8eef085f2b4d565463d5251a4868c7aaa19bf6ab.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 14:16:20 -0800
Joe Perches <joe@perches.com> wrote:

> On Thu, 2020-11-19 at 21:50 +0100, Jesper Dangaard Brouer wrote:
> > On Thu, 19 Nov 2020 10:02:10 -0800
> > Jakub Kicinski <kuba@kernel.org> wrote:
> >   
> > > On Thu, 19 Nov 2020 18:26:40 +0100 Jesper Dangaard Brouer wrote:  
> > > > Getting too many false positive matches with current use
> > > > of the content regex K: and file regex N: patterns.
> > > > 
> > > > This patch drops file match N: and makes K: more restricted.
> > > > Some more normal F: file wildcards are added.
> > > > 
> > > > Notice that AF_XDP forgot to some F: files that is also
> > > > updated in this patch.
> > > > 
> > > > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>    
> > > 
> > > Ah! Sorry, I missed that you sent this before replying to Joe.
> > > 
> > > Would you mind respining with his regex?  
> > 
> > Sure, I just send it... with your adjusted '(\b|_)xdp(\b|_)' regex, as
> > it seems to do the same thing (and it works with egrep).  
> 
> The regexes in MAINTAINERS are perl not egrep and using (\b|_)
> creates unnecessary capture groups.
> 
> It _really_ should be (?:\b|_)xdp(?:\b|_)

Okay, I will send a V3 patch.

I was trying to write a perl oneliner to tests this, but I realized
that git-grep supports this directly via --perl-regexp.

$ time git grep --files-with-matches --perl-regexp '(\b|_)xdp(\b|_)' | wc -l
297

real	0m2,225s
user	0m0,832s
sys	0m2,762s

$ time git grep --files-with-matches --perl-regexp '(?:\b|_)xdp(?:\b|_)' | wc -l
297

real	0m2,261s
user	0m0,788s
sys	0m2,714s


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

