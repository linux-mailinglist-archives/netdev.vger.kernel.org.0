Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBC73F7645
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 15:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240582AbhHYNsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 09:48:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41230 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240410AbhHYNsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 09:48:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MSSMxTNVu1ncQk0D7qxQZDD78MpoYRGBeEaljDehOBg=; b=4xAfiQJLXA/x0mO6KWrkjvFGWS
        tpUqUSLQh6jy6m0WW7msdsPZNRwrt4EHco5TYf6XXiUzw/nnvTreAbovw+nwQJjfxp5/OXAPIHO0T
        ZQ/AbKhxvt1aM17pxBEOTbWL3jYDGb7VjAEBqYLdIuL5he3hhNnzCG+319+z1Zece24M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mItEr-003nNE-Vv; Wed, 25 Aug 2021 15:46:45 +0200
Date:   Wed, 25 Aug 2021 15:46:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Biju Das <biju.das.jz@bp.renesas.com>, davem@davemloft.net,
        kuba@kernel.org, prabhakar.mahadev-lad.rj@bp.renesas.com,
        sergei.shtylyov@gmail.com, geert+renesas@glider.be,
        aford173@gmail.com, yoshihiro.shimoda.uh@renesas.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris.Paterson2@renesas.com, biju.das@bp.renesas.com
Subject: Re: [PATCH net-next 00/13] Add Factorisation code to support Gigabit
 Ethernet driver
Message-ID: <YSZJxdN/hkcz5Zmw@lunn.ch>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <162988740967.13655.14613353702366041003.git-patchwork-notify@kernel.org>
 <02fc27c2-a816-d60d-6611-162f3b70444a@omp.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02fc27c2-a816-d60d-6611-162f3b70444a@omp.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 01:57:55PM +0300, Sergey Shtylyov wrote:
> Hello!
> 
> On 25.08.2021 13:30, patchwork-bot+netdevbpf@kernel.org wrote:
> 
> > This series was applied to netdev/net-next.git (refs/heads/master):
> >
> > On Wed, 25 Aug 2021 08:01:41 +0100 you wrote:
>    Now this is super fast -- I didn't even have the time to promise
> reviewing... :-/

2 hours 30 minutes, i think.

Seems like reviews are no longer wanted in netdev.

      Andrew
