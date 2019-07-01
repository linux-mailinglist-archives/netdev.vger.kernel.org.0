Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9675BD54
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 15:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbfGANyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 09:54:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45694 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727536AbfGANyo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 09:54:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Jbf0DtoEqHCQG8UCvUWZRrM3LBXShsCLbpTyT9HXBvE=; b=xJSckwQytbEAKOt4C5jKgdbkji
        T1yjtoeEBL/BCrw8essYCf9f8GXCn2ak7tIWPS2pquYGPFXsWJ0fxjnKwctIeYL2g9RBVH53tFRUp
        Ayg869SzfDWQgy/lT85yE/oAK01XPI1CgDzfReHdGDUxKnCO4pAdQc9q0jLI6HR8COQI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hhwlS-0007Ma-Kg; Mon, 01 Jul 2019 15:54:38 +0200
Date:   Mon, 1 Jul 2019 15:54:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: Re: [PATCH net-next 3/8] Documentation/bindings: net: ocelot:
 document the PTP ready IRQ
Message-ID: <20190701135438.GE25795@lunn.ch>
References: <20190701100327.6425-1-antoine.tenart@bootlin.com>
 <20190701100327.6425-4-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701100327.6425-4-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 12:03:22PM +0200, Antoine Tenart wrote:
> One additional interrupt needs to be described within the Ocelot device
> tree node: the PTP ready one. This patch documents the binding needed to
> do so.

Hi Antoine

Same questions/points as for the register bank :-)

	Andrew
