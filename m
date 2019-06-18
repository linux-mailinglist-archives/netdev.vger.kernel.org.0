Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E887D4A8A5
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbfFRRjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:39:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729477AbfFRRjJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:39:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06B5320863;
        Tue, 18 Jun 2019 17:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560879548;
        bh=PxrxA3UzfI7/MmrGvABpDnff3c4KY8ZcU8lFKr5WNAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1vxm1WDqA9x8AORz+Qlp8wyGuc3mE1KUmC1hFVAK2SdkShmEMzRzLW5hJuY35m0gA
         NQQ/1qsNgy3R6NydgzCcYgC2jMCEt4vBZh4/8irlxBc8hZh7m8nKCTLyIRCFNZvOam
         FMHO8jzttjGxjMrpfBw2WOJherwAhYNR1lvRPpqQ=
Date:   Tue, 18 Jun 2019 19:39:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Fred Klassen <fklassen@appneta.com>
Subject: Re: 4.19: udpgso_bench_tx: setsockopt zerocopy: Unknown error 524
Message-ID: <20190618173906.GB3649@kroah.com>
References: <CA+FuTSfBFqRViKfG5crEv8xLMgAkp3cZ+yeuELK5TVv61xT=Yw@mail.gmail.com>
 <20190618161036.GA28190@kroah.com>
 <CAF=yD-JnTHdDE8K-EaJM2fH9awvjAmOJkoZbtU+Wi58pPnyAxw@mail.gmail.com>
 <20190618.094759.539007481404905339.davem@davemloft.net>
 <20190618171516.GA17547@kroah.com>
 <CAF=yD-+pNrAo1wByHY6f5AZCq8xT0FDMKM-WzPkfZ36Jxj4mNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-+pNrAo1wByHY6f5AZCq8xT0FDMKM-WzPkfZ36Jxj4mNg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 01:27:14PM -0400, Willem de Bruijn wrote:
> On Tue, Jun 18, 2019 at 1:15 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jun 18, 2019 at 09:47:59AM -0700, David Miller wrote:
> > > From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > > Date: Tue, 18 Jun 2019 12:37:33 -0400
> > >
> > > > Specific to the above test, I can add a check command testing
> > > > setsockopt SO_ZEROCOPY  return value. AFAIK kselftest has no explicit
> > > > way to denote "skipped", so this would just return "pass". Sounds a
> > > > bit fragile, passing success when a feature is absent.
> > >
> > > Especially since the feature might be absent because the 'config'
> > > template forgot to include a necessary Kconfig option.
> >
> > That is what the "skip" response is for, don't return "pass" if the
> > feature just isn't present.  That lets people run tests on systems
> > without the config option enabled as you say, or on systems without the
> > needed userspace tools present.
> 
> I was not aware that kselftest had this feature.
> 
> But it appears that exit code KSFT_SKIP (4) will achieve this. Okay,
> I'll send a patch and will keep that in mind for future tests.

Wonderful, thanks for doing that!

greg k-h
