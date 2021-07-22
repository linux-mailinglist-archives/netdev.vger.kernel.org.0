Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D967A3D2EB6
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 23:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhGVU1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 16:27:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41102 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230455AbhGVU1B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 16:27:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=O8g16kVSaHf9IcTALVmNRND8IutdSN4mf9kSt5vFuvE=; b=TbZca+Z9Un3X/HE0XRK0XRyj/5
        Cgz2KkOSc7m4oZGQj2eIm/rP3TEuROPU9g+vF0ZN7xwH0Be3A6AzhJNJf9C89l9jLTaNZ/Q3PEuQ4
        wD4UyPZC7PMkCA9MsYYJPfp6eNG+kJZgsDZK/ozSE6aFFfENziOu2KcmIBbXQDpbbctU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6fuY-00EOIp-8a; Thu, 22 Jul 2021 23:07:18 +0200
Date:   Thu, 22 Jul 2021 23:07:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: Re: [PATCH net-next 00/18] Add Gigabit Ethernet driver support
Message-ID: <YPneBpUk6z8iy94G@lunn.ch>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <b295ec23-f8b2-0432-83e6-16078754e5e3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b295ec23-f8b2-0432-83e6-16078754e5e3@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 11:53:59PM +0300, Sergei Shtylyov wrote:
> On 7/22/21 5:13 PM, Biju Das wrote:
> 
> > The DMAC and EMAC blocks of Gigabit Ethernet IP is almost similar to Ethernet AVB.
> > 
> > The Gigabit Etherner IP consists of Ethernet controller (E-MAC), Internal TCP/IP Offload Engine (TOE) and Dedicated Direct memory access controller (DMAC).
> > 
> > With few changes in driver, we can support Gigabit ethernet driver as well.
> > 
> > This patch series is aims to support the same
> > 
> > RFC->V1
> >   * Incorporated feedback from Andrew, Sergei, Geert and Prabhakar
> >   * https://patchwork.kernel.org/project/linux-renesas-soc/list/?series=515525
> > 
> > Biju Das (18):
> >   dt-bindings: net: renesas,etheravb: Document Gigabit Ethernet IP
> >   drivers: clk: renesas: rzg2l-cpg: Add support to handle MUX clocks
> >   drivers: clk: renesas: r9a07g044-cpg: Add ethernet clock sources
> >   drivers: clk: renesas: r9a07g044-cpg: Add GbEthernet clock/reset
> 
> 
>    It's not a good idea to have the patch to the defferent subsystems lumped
> all together in a single series...

Agreed.

Are these changes inseparable? If so, you need to be up front on this,
and you need an agreement with the subsystem maintainers how the
patches are going to be merged? Through which tree. And you need
Acked-by from the other tree maintainers.

Ideally you submit multiple patchsets. This assumes all sets will
compile independently.

	Andrew
