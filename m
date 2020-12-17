Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8272DD29C
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 15:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgLQOKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 09:10:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59380 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgLQOKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 09:10:16 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kptyB-00CVnS-6L; Thu, 17 Dec 2020 15:09:27 +0100
Date:   Thu, 17 Dec 2020 15:09:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Stefan Chulski <stefanc@marvell.com>,
        netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, nadavh@marvell.com,
        Yan Markman <ymarkman@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net v2 2/2] net: mvpp2: disable force link UP during port
 init procedure
Message-ID: <20201217140927.GA2981994@lunn.ch>
References: <1608198007-10143-1-git-send-email-stefanc@marvell.com>
 <1608198007-10143-2-git-send-email-stefanc@marvell.com>
 <CAPv3WKcwT9F3w=Ua-ktE=eorp0a-HPvoF2U-CwsHVtFw6GKOzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPv3WKcwT9F3w=Ua-ktE=eorp0a-HPvoF2U-CwsHVtFw6GKOzQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Do you think it's a fix that should be backported to stable branches?
> If yes, please add 'Fixes: <commit ID> ("commit title")' and it may be
> good to add 'Cc: stable@vger.kernel.org' adjacent to the Signed-off-by
> tag.

netdev patches should not be Cc: stable@vger.kernel.org. David and
Jakub handle stable patches directly.

      Andrew
