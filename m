Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A275988C68
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 19:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfHJRPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 13:15:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50142 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbfHJRPZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 13:15:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Q0HfPCgaVgmdA5NxNGSmIqqGudcwFGIoTHe1/6IreXE=; b=3XhDSAbI2m8W/lADSBZhQBJ4yQ
        y5JHs/IjpCpc8dM/zp4C5EUGeXVsT70fxXsPgaEvpgK3oo1U89x6mysdYqVmJRNTplQIPZeoO9l8H
        IPFM4Ht64q14ZKQMb5biH4omtTywbUutR4+hd8z9KOOtVubP84GylXlzkhT9zsYFbWIg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwUxf-0000NF-2v; Sat, 10 Aug 2019 19:15:23 +0200
Date:   Sat, 10 Aug 2019 19:15:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next v5 2/6] Documentation/bindings: net: ocelot:
 document the PTP ready IRQ
Message-ID: <20190810171523.GF30120@lunn.ch>
References: <20190807092214.19936-1-antoine.tenart@bootlin.com>
 <20190807092214.19936-3-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807092214.19936-3-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 07, 2019 at 11:22:10AM +0200, Antoine Tenart wrote:
> One additional interrupt needs to be described within the Ocelot device
> tree node: the PTP ready one. This patch documents the binding needed to
> do so.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
