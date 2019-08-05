Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC55F81D2D
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbfHENU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:20:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34002 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730367AbfHENU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 09:20:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6daK9OLtTHHmYFQn2clC+oFUHMXZEy7xd2EJnCzCpfk=; b=2Xqlu4JNgn9D9OND3DH1g0VDsc
        2etmgO2ZFmrD7NXQqgtZ+pvFTXnEkT9iEwpvoIM6wdK7+AvMv5nhwfS78Ik5uWYTjN7YgzeosGDnk
        GYwzWro6J8XCQMOt1FR1Ebq6bJIDeOqhzONyX0uDirp4RGjcDK7JH8cEhgiGjcLe48OY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hucur-0006ZZ-Um; Mon, 05 Aug 2019 15:20:45 +0200
Date:   Mon, 5 Aug 2019 15:20:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Harini Katakam <harinik@xilinx.com>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        David Miller <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] dt-bindings: net: macb: Add new property for PS
 SGMII only
Message-ID: <20190805132045.GC24275@lunn.ch>
References: <1564566033-676-1-git-send-email-harini.katakam@xilinx.com>
 <1564566033-676-2-git-send-email-harini.katakam@xilinx.com>
 <20190804145633.GB6800@lunn.ch>
 <CAFcVECL6cvCjeo+fn1NDyMDZyZXDrWyhD9djvcVXiLVLiLgGeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFcVECL6cvCjeo+fn1NDyMDZyZXDrWyhD9djvcVXiLVLiLgGeA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 11:45:05AM +0530, Harini Katakam wrote:
> Hi Andrew,
> 
> On Sun, Aug 4, 2019 at 8:26 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Wed, Jul 31, 2019 at 03:10:32PM +0530, Harini Katakam wrote:
> > > Add a new property to indicate when PS SGMII is used with NO
> > > external PHY on board.
> >
> > Hi Harini
> >
> > What exactly is you use case? Are you connecting to a Ethernet switch?
> > To an SFP cage with a copper module?
> 
> Yes, an SFP cage is the common HW target for this patch.

Hi Harini

So you have a copper PHY in the SFP cage. It will talk SGMII
signalling to your PS SGMII. When that signalling is complete i would
expect the MAC to raise an interrupt, just as if the SGMII PHY was
soldered on the board. So i don't see why you need this polling?

       Andrew
