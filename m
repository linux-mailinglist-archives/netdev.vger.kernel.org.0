Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B966B164FB3
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 21:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgBSUUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 15:20:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgBSUUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 15:20:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07A6A24654;
        Wed, 19 Feb 2020 20:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582143605;
        bh=uIBm1dGD7YzjetMlfl+s7x73fGRtf+jKsTUZT2posg0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ev6C+hKaxC3x5s1Xz8uy3r2XIJQHV4AwCZlCb54jWfF7+HbqSCtTkFLxdEetdlDma
         ZMyf1jvm7jxHkToPTk58MIMS9OWg8ntwsXE+dV5iveXxNx2eqw+FdQGzpG1h7gu/lA
         oGrEuV3HnEqbxHpxAUadW3WPYdTpDY18tShsPrDM=
Date:   Wed, 19 Feb 2020 21:20:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
Message-ID: <20200219202003.GB2882443@kroah.com>
References: <20200219133012.7cb6ac9e@carbon>
 <20200219132856.GA2836367@kroah.com>
 <20200219144254.36c3921b@carbon>
 <20200219181250.GA2852230@kroah.com>
 <20200219204039.121f10d2@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219204039.121f10d2@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 08:40:39PM +0100, Jesper Dangaard Brouer wrote:
> On Wed, 19 Feb 2020 19:12:50 +0100
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Wed, Feb 19, 2020 at 02:42:54PM +0100, Jesper Dangaard Brouer wrote:
> > > On Wed, 19 Feb 2020 14:28:56 +0100
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > >   
> > > > On Wed, Feb 19, 2020 at 01:30:12PM +0100, Jesper Dangaard Brouer wrote:  
> > > > > Hi Andrii,
> > > > > 
> > > > > Downloaded tarball for kernel release 5.5.4, and I cannot compile
> > > > > tools/testing/selftests/bpf/ with latest LLVM release version 9.    
> > > > 
> [...]
> > > > And has llvm 9 always worked here?  
> > > 
> > > Yes, llvm-9 used to work for tools/testing/selftests/bpf/.  
> > 
> > As of when?
> 
> Kernel v5.4 works when compiling BPF-selftests with LLVM 9.0.1.

Bisection can help us here :)

thanks,

greg k-h
