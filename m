Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16F56F90E8
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfKLNoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:44:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35826 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbfKLNoy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 08:44:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MV3cj6nhezWpTUxJkb0VGotbUmCUoYWfEaZdrcgaYbY=; b=aGp8OKOT6G+VGBbzK+uDpmED7T
        UEzxUl90o0fgYy2XPZQXTODljgG7+ep+FzJvGRtyfmPhFtBhtpesJalVGrMb7A8nfclRtZFh/5H0R
        ggsgdRpSm6h6RBx371Xm1rs+bpwnU6mboQxEZXF/U2Qzc40WikhTOPX/DHltPaJrPO44=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUWTS-0001ex-PY; Tue, 12 Nov 2019 14:44:50 +0100
Date:   Tue, 12 Nov 2019 14:44:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 05/12] net: mscc: ocelot: export a constant for
 the tag length in bytes
Message-ID: <20191112134450.GG5090@lunn.ch>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-6-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112124420.6225-6-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 02:44:13PM +0200, Vladimir Oltean wrote:
65;5800;1c> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This constant will be used in a future patch to increase the MTU on NPI
> ports, and will also be used in the tagger driver for Felix.

Another example of the next patch explaining the previous patch :-)

Maybe this indicates the 'why' is missing from the commit messages?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
