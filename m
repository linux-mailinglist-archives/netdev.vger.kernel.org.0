Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7983AC74B
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406732AbfIGPj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 11:39:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33170 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404320AbfIGPj3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Sep 2019 11:39:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gWTaws7GkIELveuO4J7ApUiFTvutTKwoQ1Dz9lf04WM=; b=vUfqz5WRISCI/AerICsyIMOSjM
        J4tbI2wRsu7cq/ogA968r+Vhb8sbg44nxZ1+othZEIspgWYrZC4AnvX+VB6Pk0Ym5r6bHagxJUOXc
        d1z9Wr1ZETu+7dbX68cYy1t/Vbbi2XWbjgFtQJ5IPA33PZpSGmlGYDgMoAw9pww6tBZg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i6co3-00062t-6Q; Sat, 07 Sep 2019 17:39:19 +0200
Date:   Sat, 7 Sep 2019 17:39:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
Cc:     davem@davemloft.net, robh+dt@kernel.org, f.fainelli@gmail.com,
        Mark Rutland <mark.rutland@arm.com>,
        Trent Piepho <tpiepho@impinj.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: phy: dp83867: Add documentation for SGMII mode
 type
Message-ID: <20190907153919.GC21922@lunn.ch>
References: <1567700761-14195-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
 <1567700761-14195-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567700761-14195-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 05, 2019 at 07:26:00PM +0300, Vitaly Gaiduk wrote:
> Add documentation of ti,sgmii-type which can be used to select
> SGMII mode type (4 or 6-wire).
> 
> Signed-off-by: Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
> ---
>  Documentation/devicetree/bindings/net/ti,dp83867.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.txt b/Documentation/devicetree/bindings/net/ti,dp83867.txt
> index db6aa3f2215b..18e7fd52897f 100644
> --- a/Documentation/devicetree/bindings/net/ti,dp83867.txt
> +++ b/Documentation/devicetree/bindings/net/ti,dp83867.txt
> @@ -37,6 +37,7 @@ Optional property:
>  			      for applicable values.  The CLK_OUT pin can also
>  			      be disabled by this property.  When omitted, the
>  			      PHY's default will be left as is.
> +	- ti,sgmii-type - This denotes the fact which SGMII mode is used (4 or 6-wire).

Hi Vitaly

You probably want to make this a Boolean. I don't think SGMII type is
a good idea. This is about enabling the receive clock to be passed to
the MAC. So how about ti,sgmii-ref-clock-output-enable.

    Andrew
