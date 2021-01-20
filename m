Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5032FC5D8
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 01:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbhATAcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 19:32:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbhATAcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 19:32:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18CC322D08;
        Wed, 20 Jan 2021 00:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611102714;
        bh=aFF9UI/rsM5GSTILTWDshvBqpGbrsLyj6qOE8+isKmA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X9xjczYhWeEpi2AgDfIKnRsra/KPFiOl2/zC8LV8SuOv6zxKzSXqC0FttHfoNueUD
         gdJOqjQVKAjQIM89QTtq+uwSzQCGEMubIXo4XYMa0xqoHJTaTZvRi/l7+6AYUUDuTw
         fUHNBGYb451dBq8NEdhqf9jycu9DPooMGqgjxQMocZMiF6ecS+duXsq2mI87f81l5u
         UvbyxrrCnmDPo5r6TiCGTVkrFQvvV0cUbN03H92Qk+uv6hFi4KtnBTfFMrjXF0/KcV
         9TjI1VxaUeJiSRHlroMfSQgQ9Z0c4/pMl7R2ojasa1Jl2LNkAaarATqTqUZBwlHOEv
         DJwiyQ///xusQ==
Date:   Tue, 19 Jan 2021 16:31:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next] sfc: reduce the number of requested xdp ev
 queues
Message-ID: <20210119163153.025d4e44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CABWYdi21ntZzrfchif1XEjDZK-RiQKttxu8oT_yRTakNhYYciw@mail.gmail.com>
References: <20201215012907.3062-1-ivan@cloudflare.com>
        <20201217101441.3d5085f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CABWYdi21ntZzrfchif1XEjDZK-RiQKttxu8oT_yRTakNhYYciw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 15:43:43 -0800 Ivan Babrou wrote:
> On Thu, Dec 17, 2020 at 10:14 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 14 Dec 2020 17:29:06 -0800 Ivan Babrou wrote:  
> > > Without this change the driver tries to allocate too many queues,
> > > breaching the number of available msi-x interrupts on machines
> > > with many logical cpus and default adapter settings:
> > >
> > > Insufficient resources for 12 XDP event queues (24 other channels, max 32)
> > >
> > > Which in turn triggers EINVAL on XDP processing:
> > >
> > > sfc 0000:86:00.0 ext0: XDP TX failed (-22)
> > >
> > > Signed-off-by: Ivan Babrou <ivan@cloudflare.com>  
> >
> > Looks like the discussion may have concluded, but we don't take -next
> > patches during the merge window, so please repost when net-next reopens.
> >
> > Thanks!
> > --
> > # Form letter - net-next is closed
> >
> > We have already sent the networking pull request for 5.11 and therefore
> > net-next is closed for new drivers, features, code refactoring and
> > optimizations. We are currently accepting bug fixes only.
> >
> > Please repost when net-next reopens after 5.11-rc1 is cut.  
> 
> Should I resend my patch now that the window is open or is bumping
> this thread enough?

You need to resend, thanks!
