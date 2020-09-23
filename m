Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906602760DD
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 21:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgIWTRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 15:17:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51750 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgIWTRj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 15:17:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kLAGj-00FvC2-Ls; Wed, 23 Sep 2020 21:17:33 +0200
Date:   Wed, 23 Sep 2020 21:17:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Riedmueller <s.riedmueller@phytec.de>
Cc:     Fugang Duan <fugang.duan@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christian Hemp <c.hemp@phytec.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: fec: Keep device numbering consistent with datasheet
Message-ID: <20200923191733.GD3764123@lunn.ch>
References: <20200923142528.303730-1-s.riedmueller@phytec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923142528.303730-1-s.riedmueller@phytec.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 04:25:28PM +0200, Stefan Riedmueller wrote:
> From: Christian Hemp <c.hemp@phytec.de>
> 
> Make use of device tree alias for device enumeration to keep the device
> order consistent with the naming in the datasheet.
> 
> Otherwise for the i.MX 6UL/ULL the ENET1 interface is enumerated as eth1
> and ENET2 as eth0.

What is wrong with that?  Ethernet interface names have never been
guaranteed to be stable.

You have to be careful here. Have you reviewed all the DTS files to
make sure none already have aliases? You could be breaking boards
which currently 'work' because the alias is ignored.

udev is actually a better solution for giving the interfaces
dependable names.

      Andrew
