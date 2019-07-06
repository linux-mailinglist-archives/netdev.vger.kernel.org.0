Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2CAD611FB
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 17:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfGFPrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 11:47:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58048 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbfGFPrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Jul 2019 11:47:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1eI4tCmPmpE27U/r/gWKuKPvYgiN7t8Zw9O+A9SMlFk=; b=COKvlU7CIc90CEhoAhau31KFjj
        lVnmusI213K30YJwZsw5pIP85rSwiSNPdqa8OZrWQZFTKOzrqG4Gf+AdzyINhjry1rbT04eCUEq3r
        1W68XxtTEWpgRL7INzUPaz0JLLnELRG12wB0Cm6q55TsRyKb+fzoSkO9Ftah2cmjDjUw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hjmu2-0000MY-JY; Sat, 06 Jul 2019 17:47:06 +0200
Date:   Sat, 6 Jul 2019 17:47:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     josua@solid-run.com
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/4] dt-bindings: allow up to four clocks for orion-mdio
Message-ID: <20190706154706.GE4428@lunn.ch>
References: <20190706151900.14355-1-josua@solid-run.com>
 <20190706151900.14355-2-josua@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190706151900.14355-2-josua@solid-run.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 06, 2019 at 05:18:57PM +0200, josua@solid-run.com wrote:
> From: Josua Mayer <josua@solid-run.com>
> 
> Armada 8040 needs four clocks to be enabled for MDIO accesses to work.
> Update the binding to allow the extra clock to be specified.
> 
> Cc: stable@vger.kernel.org
> Fixes: 6d6a331f44a1 ("dt-bindings: allow up to three clocks for orion-mdio")
> Signed-off-by: Josua Mayer <josua@solid-run.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
