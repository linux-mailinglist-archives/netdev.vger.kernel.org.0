Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CAA428222
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 17:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhJJPJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 11:09:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59540 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231842AbhJJPJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 11:09:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oSEC+2pNGXb0zXkZliC2hv8mrA0BDtnrgquBa5rePM0=; b=JiXChuZbeaTtTBbVjVM02VcHWV
        VrCCz+BY1nDirPzPJWrm3vX09y+H4r4JarRCwchs5TCLVefX5lLSFka50QcBmJFyh6H9QPUnK+aci
        uHT7NCaPEYKJv/yW8pYjXOP0vm84fV6LO+S1ynQBINkYCp377MQxSEM3hPMNVPVIFkI4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mZaPX-00AExd-Fn; Sun, 10 Oct 2021 17:06:47 +0200
Date:   Sun, 10 Oct 2021 17:06:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: Re: [PATCH net-next v2 13/14] ravb: Update EMAC configuration mode
 comment
Message-ID: <YWMBh33gBnAlHI1N@lunn.ch>
References: <20211010072920.20706-1-biju.das.jz@bp.renesas.com>
 <20211010072920.20706-14-biju.das.jz@bp.renesas.com>
 <8c6496db-8b91-8fb8-eb01-d35807694149@gmail.com>
 <OS0PR01MB5922109B263B7FDBB02E33B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <57dbab90-6f2c-40f5-2b73-43c1ee2c6e06@gmail.com>
 <OS0PR01MB592229224714550A4BFC10B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS0PR01MB592229224714550A4BFC10B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> by looking at the RJ LED's there is not much activity and packet
> statistics also show not much activity by default.

> How can we check, it is overloading the controller? So that I can
> compare with and without this setting

What is you link peer? A switch? That will be doing some filtering, so
you probably don't see unicast traffic from other devices. So you need
to flood your link with traffic the switch does not filter. Try
multicast traffic for a group you are not a member off. You might need
to disable IGMP snooping on the switch.

Or use a traffic generator as a link peer and have it generate streams
with mixed sources and destinations.

     Andrew
