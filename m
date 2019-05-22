Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4DFD26AA5
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbfEVTLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:11:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43696 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728734AbfEVTLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:11:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=y0LA43/Ym0rPPmS7Rdn9WeZqm0e12P7MnLkDLcDEtj4=; b=VOXgbh/7/uyGdAUefojqG0RzRf
        jwnDgZ6gtKnly9Nt6IynKwnc5VJhFricQzFrX3pmXsUeH39VKStW5MZpP30ux+RWBVe1Yk4l0ocHW
        0VXRzQx2wG8hMo9AwoZ7T/miZgI3Nf0Cg6gLFSxpDtwgjq15N0hPNJZWGT28gwDigQYI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTWeS-0002Y9-8S; Wed, 22 May 2019 21:11:48 +0200
Date:   Wed, 22 May 2019 21:11:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Trent Piepho <tpiepho@impinj.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH net-next v2 2/8] dt-bindings: phy: dp83867: Add
 documentation for disabling clock output
Message-ID: <20190522191148.GH7281@lunn.ch>
References: <20190522184255.16323-1-tpiepho@impinj.com>
 <20190522184255.16323-2-tpiepho@impinj.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522184255.16323-2-tpiepho@impinj.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 06:43:21PM +0000, Trent Piepho wrote:
> The clock output is generally only used for testing and development and
> not used to daisy-chain PHYs.  It's just a source of RF noise afterward.
> 
> Add a mux value for "off".  I've added it as another enumeration to the
> output property.  In the actual PHY, the mux and the output enable are
> independently controllable.  However, it doesn't seem useful to be able
> to describe the mux setting when the output is disabled.
> 
> Document that PHY's default setting will be left as is if the property
> is omitted.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Trent Piepho <tpiepho@impinj.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
