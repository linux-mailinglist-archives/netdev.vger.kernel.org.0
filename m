Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA8C5BD4D
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 15:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfGANwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 09:52:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45674 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbfGANwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 09:52:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Gy7BHpEetRb3LAkfcCTonD4AGiwEXRWuMkqqZtIxDsg=; b=CnAEaL4JE3T1/iiz6KP2QGlyKx
        wEtdmHcdpF8EByhDbf3vgLoxwYls3oatKJQnZb7I9xVCEgwPYjZ+SkxbByh98X8r33FEMKjVeSTsP
        jhdSsiSKFeqwmTzGQZM+f/MB7je2/XZ10zqTgaYfcyBs50S5KWior77JQ4SQBto6eoOs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hhwj8-0007KY-1m; Mon, 01 Jul 2019 15:52:14 +0200
Date:   Mon, 1 Jul 2019 15:52:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: Re: [PATCH net-next 1/8] Documentation/bindings: net: ocelot:
 document the PTP bank
Message-ID: <20190701135214.GD25795@lunn.ch>
References: <20190701100327.6425-1-antoine.tenart@bootlin.com>
 <20190701100327.6425-2-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701100327.6425-2-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 12:03:20PM +0200, Antoine Tenart wrote:
> One additional register range needs to be described within the Ocelot
> device tree node: the PTP. This patch documents the binding needed to do
> so.

Hi Antoine

Are there any more register banks? Maybe just add them all?

Also, you should probably add a comment that despite it being in the
Required part of the binding, it is actually optional.

	 Andrew
