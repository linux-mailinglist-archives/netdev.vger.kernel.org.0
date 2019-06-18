Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A70EA4ABCE
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 22:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730649AbfFRU2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 16:28:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:52652 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730176AbfFRU2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 16:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/yuq+528Ge2GyeWg6aQYCOiRFdbu/e3xfN3FdxpcEzY=; b=aB7KTV5ZzmCoj1Qxm3dVaqBytG
        6+FKmt7R881qAHMbcleBouaKC3kmFz2LA9Gvif95NyyHzZYpT55h4RDehfIKQQY69CVa8wVC9pTSV
        lM5saykAhFfav4/jsmfkmbjCMOcfAFWTC4XcOhZRfq2M8BexwvZFvq+n1RO+Q6bUZMKIXOAKqgS/z
        Z0xhg86h0mjM6gWv9dljQS4maac4BmrXdCgsk5P5Rrbmx/H/nT9JqF0GEKhiNMUUO+RcYwIj4hQKr
        S+oRAMGCViKI189iZwgPRWHso0mZugDsGCk+ehRnbRbif4s1O9+a3pZMmiNVfSY4BbgNtTHNIW9P3
        VhKuGzng==;
Received: from 177.133.86.196.dynamic.adsl.gvt.net.br ([177.133.86.196] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hdKi3-0001wm-Jm; Tue, 18 Jun 2019 20:28:04 +0000
Date:   Tue, 18 Jun 2019 11:14:47 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v4 00/28] Convert files to ReST - part 1
Message-ID: <20190618111122.64cdeb59@coco.lan>
In-Reply-To: <20190614143640.40ee353a@lwn.net>
References: <cover.1560361364.git.mchehab+samsung@kernel.org>
        <20190614143640.40ee353a@lwn.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, 14 Jun 2019 14:36:40 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Wed, 12 Jun 2019 14:52:36 -0300
> Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:
> 
> > This is mostly a rebase of the /33 series v3 I sent, on the top of the latest
> > linux-next  (next-20190612).
> > 
> > Changes from v3:
> > 
> > - dropped cpufreq conversion - documents are too outdated;
> > - infiniband patch is not here anymore - as it should be merged via RDMA;
> > - s390 patches were already merged;
> > - Dropped Geert as Maintainer from fb/framebuffer.rst, as per his request;
> > - Did a minor editorial change at popwerpc/cxl.rst per Andrew Donellan
> >   request;
> > - Added acks/reviews;
> > - trivial rebase fixups.  
> 
> So I had to pull docs-next forward to -rc4, but then I was able to apply
> this set except for parts 5, 6, 14, 18, and 19.  

Patch 5 went via Cgroups tree;
Patch 18 went via power tree;
Patch 6 is obsolete, as the cgroups-v1 CBQ chapter was removed;

So, what's left from this series are patches 14 and 19.

I have a rebased version of them on the top of linux-next
on my working tree. Perhaps we should try to push those two late
during the merge window.

> Some progress made, but
> this is somewhat painful work...

Yeah, a change like that is not easy.

Thanks,
Mauro
