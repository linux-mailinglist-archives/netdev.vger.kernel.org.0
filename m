Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C033F88C67
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 19:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfHJROQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 13:14:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50128 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbfHJROQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 13:14:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iGxduEd6ftlLieQ2jL43AOafhhqXJQi4YCakcOH25ao=; b=o20a7g9yK4Gcftmy+avz/FvCcd
        ba3glRuv3no3ixxq/Sjgy1GwFD5mAvxqhMMwGmnPkKtxXEauhyn7rN8yQq8LXZ0Uwi5TuinD3Z9S1
        xzZiCGY/pD+tPlI6gnX1A5TuVeE3KpLjW8JeV0PIDfFOrO2VumXNG9kIIQjk42pvf4Vc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwUwX-0000Lg-0p; Sat, 10 Aug 2019 19:14:13 +0200
Date:   Sat, 10 Aug 2019 19:14:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next v5 1/6] Documentation/bindings: net: ocelot:
 document the PTP bank
Message-ID: <20190810171413.GE30120@lunn.ch>
References: <20190807092214.19936-1-antoine.tenart@bootlin.com>
 <20190807092214.19936-2-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807092214.19936-2-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 07, 2019 at 11:22:09AM +0200, Antoine Tenart wrote:
> One additional register range needs to be described within the Ocelot
> device tree node: the PTP. This patch documents the binding needed to do
> so.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
