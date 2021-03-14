Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEA433A417
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 11:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbhCNKE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 06:04:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235029AbhCNKEW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 06:04:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72A5B64EC6;
        Sun, 14 Mar 2021 10:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615716262;
        bh=YaBvDkHUpVHgz7IeG1nFxa4iaw8l+effxELbw6xjnSE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f9YaaxkaUJC+S1azF/+EVhOe/Lsd3o7jbq4JOjr3/2DQ6MhgN9b59MDqcefZZsdKg
         6jP871VcuNH1rT616IsxvMjOXZbZC6tFGVQB7r9KoIyJusI40pMgHxlaHBROWaZkBt
         cXn7MylmRqRpBsgDR40EfziTbjSNq4a+kNLjoZsEYGUn1KqLLj8YGINoZ6QPQpSng0
         xCvyfxE2aTO2draiJuQtp2Qo08K303pVPUmIOsKjqaL953lovzlHLAc+poc6yHQz96
         PnQ+52gWBxkJ+p7IoX8p1gGCUelyP2/7a2SsDQFdStJ2v+mIkD0Eip6flduJgjCcRz
         DY4pge6ieA9cQ==
Date:   Sun, 14 Mar 2021 12:04:18 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Hsu, Chiahao" <andyhsu@amazon.com>, netdev@vger.kernel.org,
        wei.liu@kernel.org, paul@xen.org, davem@davemloft.net,
        kuba@kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable
 ctrl-ring
Message-ID: <YE3foiFJ4sfiFex2@unreal>
References: <20210311225944.24198-1-andyhsu@amazon.com>
 <YEuAKNyU6Hma39dN@lunn.ch>
 <ec5baac1-1410-86e4-a0d1-7c7f982a0810@amazon.com>
 <YEvQ6z5WFf+F4mdc@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YEvQ6z5WFf+F4mdc@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 09:36:59PM +0100, Andrew Lunn wrote:
> On Fri, Mar 12, 2021 at 04:18:02PM +0100, Hsu, Chiahao wrote:
> >
> > Andrew Lunn 於 2021/3/12 15:52 寫道:
> > > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > >
> > >
> > >
> > > On Thu, Mar 11, 2021 at 10:59:44PM +0000, ChiaHao Hsu wrote:
> > > > In order to support live migration of guests between kernels
> > > > that do and do not support 'feature-ctrl-ring', we add a
> > > > module parameter that allows the feature to be disabled
> > > > at run time, instead of using hardcode value.
> > > > The default value is enable.
> > > Hi ChiaHao
> > >
> > > There is a general dislike for module parameters. What other mechanisms
> > > have you looked at? Would an ethtool private flag work?
> > >
> > >       Andrew
> >
> >
> > Hi Andrew,
> >
> > I can survey other mechanisms, however before I start doing that,
> >
> > could you share more details about what the problem is with using module
> > parameters? thanks.
>
> It is not very user friendly. No two kernel modules use the same
> module parameters. Often you see the same name, but different
> meaning. There is poor documentation, you often need to read the
> kernel sources it figure out what it does, etc.

+1, It is also global parameter to whole system/devices that use this
module, which is rarely what users want.

Thanks
