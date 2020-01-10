Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC51A136F3F
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 15:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgAJOW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 09:22:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59604 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727803AbgAJOW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 09:22:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/LqUWTGBt5gIEmNEJ7QzFyPyiWRNbMxwiltxq0x8igc=; b=Gp+lCFbhq8KoEC210hcrrMI+wF
        0JmIiELjl9bsPWXOe+seRjm5/SPB27amgsTcYWk3K7slz6nTL7Ap4HOtQKZQxxSen6qMer/4I6JEo
        yAvQ+UulpPXYSX6w61WiKyIYOL/UICkN8rDzumQnp6aSzIjQp9ojDzMowUF4uRGZOLNk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ipvBa-0007bd-5w; Fri, 10 Jan 2020 15:22:50 +0100
Date:   Fri, 10 Jan 2020 15:22:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/14] net: axienet: Autodetect 64-bit DMA capability
Message-ID: <20200110142250.GH19739@lunn.ch>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-13-andre.przywara@arm.com>
 <20200110140852.GF19739@lunn.ch>
 <20200110141303.2e5863ab@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110141303.2e5863ab@donnerap.cambridge.arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 02:13:03PM +0000, Andre Przywara wrote:
> On Fri, 10 Jan 2020 15:08:52 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> Hi Andrew,
> 
> thanks for having a look!
> 
> > > To autodetect this configuration, at probe time we write all 1's to such
> > > an MSB register, and see if any bits stick.  
> > 
> > So there is no register you can read containing the IP version?
> 
> There is, and I actually read this before doing this check. But the 64-bit DMA capability is optional even in this revision. It depends on what you give it as the address width. If you say 32, the IP config tool disables the 64-bit capability completely, so it stays compatible with older revisions.
> Anything beyond 32 will enable the MSB register and will also require you to write to them.

So you are saying there is no way to enumerate the synthesised
configuration of the IP. Great :-(

Do Xilinx at least document you can discover the DMA size by writing
into these upper bits? Does Xilinx own 'vendor crap' driver do this?

Thanks
	Andrew
