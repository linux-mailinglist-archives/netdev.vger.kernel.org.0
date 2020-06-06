Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE00E1F06E2
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 16:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgFFOEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 10:04:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38218 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbgFFOD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Jun 2020 10:03:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+GLDGkGSSXJ5sFh/B5qrHIUtFsI6eNlKq6JhHGjqvmk=; b=M025LXJ0AdmMNsbV76HS8Yi/WV
        ch9scZkObMebp6sTTIfeGYrMnpfZSVTcYiC6wbk/WnnNVGcNjI4qsLiYGQCg6Z5qnghpdISgzsgTY
        9WTu4OL/T+0U0/ViEjWNst8pfV0H1V2ebIE1l0gDMUosmoB1j/fAaTIkSsfoC53xS1uQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jhZQG-004HTo-J7; Sat, 06 Jun 2020 16:03:44 +0200
Date:   Sat, 6 Jun 2020 16:03:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: qca8k: introduce SGMII configuration
 options
Message-ID: <20200606140344.GA1013547@lunn.ch>
References: <cover.1591380105.git.noodles@earth.li>
 <8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li>
 <20200605183843.GB1006885@lunn.ch>
 <20200606074916.GM311@earth.li>
 <20200606083741.GK1551@shell.armlinux.org.uk>
 <20200606105909.GN311@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606105909.GN311@earth.li>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > Also, netdev is closed at the moment, so please post patches as RFC.
> > > 
> > > "closed"? If you mean this won't get into 5.8 then I wasn't expecting it
> > > to, I'm aware the merge window for that is already open.
> > 
> > See https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt
> > "How often do changes from these trees make it to the mainline Linus
> > tree?"
> 
> Ta. I'll hold off on a v2 until after -rc1 drops.

You can post at the moment, but you need to put RFC in the subject
line, just to make it clear you are only interested in comments.

      Andrew
