Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D28406B05
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 13:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhIJLxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 07:53:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35830 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232825AbhIJLxW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 07:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xz3EHqt1aNuCCfFgP4l7aFLLA09koIhgwoehEBHEMPo=; b=BaquWuYDdAmhM56vGNxCao7Jdo
        HTwm6MB/Nz1Pnzk/t5m1hnBtrsRf/oicCtVEuJFcUFdr4EvGAYix6ZTpPlA6t2JikxuiVqKWjq6Lw
        csAiQf20rpXoO1NqZeY+DiTXxhy3M6ra8EnxYdG2+hGQpek92yJcSDynODgoL/CoOTtE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mOf4W-0063Om-AS; Fri, 10 Sep 2021 13:51:56 +0200
Date:   Fri, 10 Sep 2021 13:51:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Saravana Kannan <saravanak@google.com>,
        p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <YTtG3NbYjUbu4jJE@lunn.ch>
References: <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <20210909154734.ujfnzu6omcjuch2a@skbuf>
 <8498b0ce-99bb-aef9-05e1-d359f1cad6cf@gmx.de>
 <2b316d9f-1249-9008-2901-4ab3128eed81@gmail.com>
 <5b899bb3-ed37-19ae-8856-3dabce534cc6@gmx.de>
 <20210909225457.figd5e5o3yw76mcs@skbuf>
 <35466c02-16da-0305-6d53-1c3bbf326418@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35466c02-16da-0305-6d53-1c3bbf326418@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It does not really scale but we also don't have that many DSA masters to
> support, I believe I can name them all: bcmgenet, stmmac, bcmsysport, enetc,
> mv643xx_eth, cpsw, macb.

fec, mvneta, mvpp2, i210/igb.

     Andrew
