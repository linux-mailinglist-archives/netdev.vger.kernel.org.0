Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8201010B61A
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 19:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfK0Svj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 13:51:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58478 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbfK0Svj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 13:51:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XSKKVUPKZ3rsp1iAxeHXZOxHiZxYRg6StJOPPccU3D8=; b=W7VStLqvxdVf/jbuoXVgb5b2sK
        r5i2VA//OJpMVGmQ+CMFbFkwpPvT2xDgBcjCV61Yn5ZzVmuFppVW4//gM6F45bV0lg48kRtzMiqhi
        jAi5QSp+EVFiB7e8cQG6EHPpgExnf1mUVftHFAq8FiZtLddIdDLVnSiXXlDTftH0dHuM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ia2PR-0000Mv-4k; Wed, 27 Nov 2019 19:51:29 +0100
Date:   Wed, 27 Nov 2019 19:51:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nicolas.Ferre@microchip.com
Cc:     mparab@cadence.com, antoine.tenart@bootlin.com,
        davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux-kernel@vger.kernel.org,
        dkangude@cadence.com, pthombar@cadence.com,
        rmk+kernel@arm.linux.org.uk
Subject: Re: [PATCH 2/3] net: macb: add support for C45 MDIO read/write
Message-ID: <20191127185129.GU6602@lunn.ch>
References: <1574759354-102696-1-git-send-email-mparab@cadence.com>
 <1574759389-103118-1-git-send-email-mparab@cadence.com>
 <20191126143717.GP6602@lunn.ch>
 <19694e5a-17df-608f-5db7-5da288e5e7cd@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19694e5a-17df-608f-5db7-5da288e5e7cd@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 06:31:54PM +0000, Nicolas.Ferre@microchip.com wrote:
> On 26/11/2019 at 15:37, Andrew Lunn wrote:
> > On Tue, Nov 26, 2019 at 09:09:49AM +0000, Milind Parab wrote:
> >> This patch modify MDIO read/write functions to support
> >> communication with C45 PHY.
> > 
> > I think i've asked this before, at least once, but you have not added
> > it to the commit messages. Do all generations of the macb support C45?
> 
> For what I can tell from the different IP revisions that we implemented 
> throughout the years in Atmel then Microchip products (back to 
> at91rm9200 and at91sam9263), it seems yes.
> 
> The "PHY Maintenance Register" "MACB_MAN_*" was always present with the 
> same bits 32-28 layout (with somehow different names).
> 
> But definitively we would need to hear that from Cadence itself which 
> would be far better.

Hi Nicolas

Thanks, that is useful.

I'm just trying to avoid backward compatibility issues, somebody
issues a C45 request on old silicon and it all goes horribly wrong.

       Andrew
