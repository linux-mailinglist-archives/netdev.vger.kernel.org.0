Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5311F6AFB99
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 01:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCHAyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 19:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCHAyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 19:54:19 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4BA99C23;
        Tue,  7 Mar 2023 16:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=cdR/zhGArV001gA/NHNMrqNDJzD9mb9k2pDnumscUW4=; b=aT
        HVWT1+AEl4wMgLnJCvk3lH1RC+bvTh4aYYtP8nHe96J7/q6x/JZHtxB3TUb0btfDARnPthpJyucnf
        O6TzzyPEg0iMSsdXl0fcJI+kn1KUin+pbe2TI8YQSg8c++2LlQErdVsEpunC3AfsN/zW06zMxWw4B
        ML1pX+fUKeRmDH8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pZi4G-006is1-9h; Wed, 08 Mar 2023 01:54:08 +0100
Date:   Wed, 8 Mar 2023 01:54:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH 03/11] net: phy: Add a binding for PHY LEDs
Message-ID: <4bc6c23a-0dc8-443b-8e19-bdae07d6f452@lunn.ch>
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-4-ansuelsmth@gmail.com>
 <7c83540c-ec29-4a2e-b50b-098182b4b68a@lunn.ch>
 <6407c78e.5d0a0220.98d00.4d95@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6407c78e.5d0a0220.98d00.4d95@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 07:00:08PM +0100, Christian Marangi wrote:
> On Wed, Mar 08, 2023 at 12:17:51AM +0100, Andrew Lunn wrote:
> > On Tue, Mar 07, 2023 at 06:00:38PM +0100, Christian Marangi wrote:
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > 
> > > Define common binding parsing for all PHY drivers with LEDs using
> > > phylib. Parse the DT as part of the phy_probe and add LEDs to the
> > > linux LED class infrastructure. For the moment, provide a dummy
> > > brightness function, which will later be replaced with a call into the
> > > PHY driver.
> > > 
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > 
> > Hi Christian
> > 
> > Since you are submitting this, you need to add your own Signed-off-by:
> > after mine.
> > 
> 
> Tought it was needed only for patch where I have put any change. (case
> of 2 patch in this series where there was a whitespace error and had to
> change a binding)
> 
> Think I need do to this for every other patch right?

https://www.kernel.org/doc/html/latest/process/submitting-patches.html

says:

   Any further SoBs (Signed-off-by:’s) following the author’s SoB are
   from people handling and transporting the patch, but were not
   involved in its development. SoB chains should reflect the real
   route a patch took as it was propagated to the maintainers and
   ultimately to Linus, with the first SoB entry signalling primary
   authorship of a single author.

So yes, you need to add your Signed-off-by to all my patches,
independent of if you make changes or not.

	    Andrew
