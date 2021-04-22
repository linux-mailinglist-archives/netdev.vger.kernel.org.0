Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717963687C1
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 22:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhDVUOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 16:14:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236822AbhDVUOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 16:14:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZfhh-000XWu-Qi; Thu, 22 Apr 2021 22:13:37 +0200
Date:   Thu, 22 Apr 2021 22:13:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/3] net: ethernet: ixp4xx: Add DT bindings
Message-ID: <YIHY8W8+99C5IHHm@lunn.ch>
References: <20210419225133.2005360-1-linus.walleij@linaro.org>
 <YH4tsFtGJUMf2BFS@lunn.ch>
 <CACRpkdbppvaNUXE9GD_UXDrB8SJA5qv7wrQ1dj5E4ySU_6bG7w@mail.gmail.com>
 <YIGco30TpBiyZLgD@lunn.ch>
 <CACRpkdZXcT87KStxYuMr=-rOYwhqadVu45r0xMThLWfqG4ejtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZXcT87KStxYuMr=-rOYwhqadVu45r0xMThLWfqG4ejtA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It is a bit confusing :D not to mention that the term
> "phy" or "physical interface" as I suppose it is meant to
> be understood is a bit ambiguous to begin with.

Yes. For a long time, phy meant Ethernet PHY. And then the generic PHY
framework came along, and decided to reuse the phy prefix, rather than
genphy, or something unique. And now we have confusion.

	Andrew
