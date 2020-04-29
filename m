Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9381BD527
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgD2GyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:54:08 -0400
Received: from verein.lst.de ([213.95.11.211]:32872 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726355AbgD2GyI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 02:54:08 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C2BE968BEB; Wed, 29 Apr 2020 08:54:04 +0200 (CEST)
Date:   Wed, 29 Apr 2020 08:54:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 bpf-next tree
Message-ID: <20200429065404.GA32139@lst.de>
References: <20200429164507.35ac444b@canb.auug.org.au> <20200429064702.GA31928@lst.de> <CAADnVQJWLPpt6tEGo=KkLBaHLpwZFLBfZX7UB4Z6+hMf6g220w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJWLPpt6tEGo=KkLBaHLpwZFLBfZX7UB4Z6+hMf6g220w@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:49:34PM -0700, Alexei Starovoitov wrote:
> On Tue, Apr 28, 2020 at 11:47 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > On Wed, Apr 29, 2020 at 04:45:07PM +1000, Stephen Rothwell wrote:
> > > Hi all,
> > >
> > > Today's linux-next merge of the akpm-current tree got a conflict in:
> > >
> > >   kernel/sysctl.c
> > >
> > > between commit:
> > >
> > >   f461d2dcd511 ("sysctl: avoid forward declarations")
> > >
> > > from the bpf-next tree and commits:
> >
> > Hmm, the above should have gone in through Al..
> 
> Al pushed them into vfs tree and we pulled that tag into bpf-next.

Ok.  And Stephen pulled your tree first.
