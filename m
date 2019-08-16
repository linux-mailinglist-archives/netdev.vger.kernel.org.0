Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B72690690
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 19:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfHPRPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 13:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbfHPRPd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 13:15:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 923C920665;
        Fri, 16 Aug 2019 17:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565975732;
        bh=M1HPqEjQ5iY1O4jlhtl0AhZEZAd5ZbMzIi4yCsQSr+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cvrz9I5+7Cfy3unc5s0RaHJd/+9FfTidk2w5dgIGk9gTrjwatqDhx/A6QwtqRx5qO
         qxkYIv05xU4YRigF54YElHMsnkG7MDSNshUTtpesEhWnrZHZDI/hrwEBjxeV9G937X
         qR1j5+/hDNVXWO17fokOJn4d0ILe8mipOKrBFqUo=
Date:   Fri, 16 Aug 2019 19:15:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Rostecki <mrostecki@opensuse.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sargun Dhillon <sargun@sargun.me>
Subject: Re: [PATCH bpf-next] libbpf: relicense bpf_helpers.h and bpf_endian.h
Message-ID: <20190816171529.GA20099@kroah.com>
References: <20190816054543.2215626-1-andriin@fb.com>
 <20190816141001.4a879101@carbon>
 <23a87525-acf5-7a7e-b7b6-3c47b9760eeb@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23a87525-acf5-7a7e-b7b6-3c47b9760eeb@iogearbox.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 05:29:27PM +0200, Daniel Borkmann wrote:
> On 8/16/19 2:10 PM, Jesper Dangaard Brouer wrote:
> > On Thu, 15 Aug 2019 22:45:43 -0700
> > Andrii Nakryiko <andriin@fb.com> wrote:
> > 
> > > bpf_helpers.h and bpf_endian.h contain useful macros and BPF helper
> > > definitions essential to almost every BPF program. Which makes them
> > > useful not just for selftests. To be able to expose them as part of
> > > libbpf, though, we need them to be dual-licensed as LGPL-2.1 OR
> > > BSD-2-Clause. This patch updates licensing of those two files.
> > 
> > I've already ACKed this, and is fine with (LGPL-2.1 OR BSD-2-Clause).
> > 
> > I just want to understand, why "BSD-2-Clause" and not "Apache-2.0" ?
> > 
> > The original argument was that this needed to be compatible with
> > "Apache-2.0", then why not simply add this in the "OR" ?
> 
> It's use is discouraged in the kernel tree, see also LICENSES/dual/Apache-2.0 (below) and
> statement wrt compatibility from https://www.apache.org/licenses/GPL-compatibility.html:
> 
>   Valid-License-Identifier: Apache-2.0
>   SPDX-URL: https://spdx.org/licenses/Apache-2.0.html
>   Usage-Guide:
>     Do NOT use. The Apache-2.0 is not GPL2 compatible. [...]

That is correct, don't use Apache-2 code in the kernel please.  Even as
a dual-license, it's a total mess.

Having this be BSD-2 is actually better, as it should be fine to use
with Apache 2 code, right?

Jesper, do you know of any license that BSD-2 is not compatible with
that is needed?

thanks,

greg k-h
