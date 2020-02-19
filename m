Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B06FD164583
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 14:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbgBSN3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 08:29:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgBSN3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 08:29:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67BE824654;
        Wed, 19 Feb 2020 13:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582118939;
        bh=2Eok6QDwEYTXtMZn1ZUTzSuDcxAHDuGB/EMud+DtNVA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SDOquG1GvLtxm/+qKnQDLJtvjCuHprU5zHxrLLHPi9io2GUA4ex23J0n2NJ0n/lVy
         7RdP3jPNxPm569R+/Wv6Eq+A1JxOTUow5q6tUIME8BX0EsMqB6O/1vuTcOys+2BB3Y
         sTOjAecBi4r80oLBY38TAluXbBr8Rx6QOTKKRmGo=
Date:   Wed, 19 Feb 2020 14:28:56 +0100
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
Message-ID: <20200219132856.GA2836367@kroah.com>
References: <20200219133012.7cb6ac9e@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219133012.7cb6ac9e@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 01:30:12PM +0100, Jesper Dangaard Brouer wrote:
> Hi Andrii,
> 
> Downloaded tarball for kernel release 5.5.4, and I cannot compile
> tools/testing/selftests/bpf/ with latest LLVM release version 9.

Is this something that recently broke?  If so, what commit caused it?

And has llvm 9 always worked here?

> Looking closer at the build error messages, I can see that this is
> caused by using LLVM features that (I assume) will be avail in release
> 10. I find it very strange that we can release a kernel that have build
> dependencies on a unreleased version of LLVM.

Is this the first time you have tried using llvm to build a kernel?
This isn't a new thing :)

> I love the new LLVM BTF features, but we cannot break users/CI-systems
> that wants to run the BPF-selftests.

Is this a regression from older kernels?

And does gcc work?

thanks,

greg k-h
