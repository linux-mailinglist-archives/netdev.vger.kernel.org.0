Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31BA1C0CFC
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 06:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgEAEAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 00:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgEAEAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 00:00:43 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF97C035494;
        Thu, 30 Apr 2020 21:00:43 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUMqj-00FaZY-JM; Fri, 01 May 2020 04:00:29 +0000
Date:   Fri, 1 May 2020 05:00:29 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 bpf-next tree
Message-ID: <20200501040029.GI23230@ZenIV.linux.org.uk>
References: <20200429164507.35ac444b@canb.auug.org.au>
 <20200429064702.GA31928@lst.de>
 <CAADnVQJWLPpt6tEGo=KkLBaHLpwZFLBfZX7UB4Z6+hMf6g220w@mail.gmail.com>
 <20200429065404.GA32139@lst.de>
 <20200429182406.67582a6a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429182406.67582a6a@canb.auug.org.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 06:24:06PM +1000, Stephen Rothwell wrote:
> Hi Christoph,
> 
> On Wed, 29 Apr 2020 08:54:04 +0200 Christoph Hellwig <hch@lst.de> wrote:
> >
> > On Tue, Apr 28, 2020 at 11:49:34PM -0700, Alexei Starovoitov wrote:
> > > On Tue, Apr 28, 2020 at 11:47 PM Christoph Hellwig <hch@lst.de> wrote:  
> > > >
> > > > On Wed, Apr 29, 2020 at 04:45:07PM +1000, Stephen Rothwell wrote:  
> > > > >
> > > > > Today's linux-next merge of the akpm-current tree got a conflict in:
> > > > >
> > > > >   kernel/sysctl.c
> > > > >
> > > > > between commit:
> > > > >
> > > > >   f461d2dcd511 ("sysctl: avoid forward declarations")
> > > > >
> > > > > from the bpf-next tree and commits:  
> > > >
> > > > Hmm, the above should have gone in through Al..  
> > > 
> > > Al pushed them into vfs tree and we pulled that tag into bpf-next.  
> > 
> > Ok.  And Stephen pulled your tree first.
> 
> No, it is not in the branch I fetch from Al yet.

Now it is...
