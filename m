Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF9751C27F
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 16:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380602AbiEEO2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349409AbiEEO2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:28:37 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFDC5AA62;
        Thu,  5 May 2022 07:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aVV/FwrdQSe5VUKj28vMBhWJEvtyjJumJbTPBeKHAWg=; b=bhNRXf37ysGVvqgfPD0sDjMUPS
        VUNS4DWIxcWDP44WFABcP97dqKD5KopTf5I88KCOHIrH0i6i2wP3ILw7g44QY0PaLHkP6U72IS7sL
        83CmAhVe2pPvFviTDx2syFXOQc25/zWiOqxBjwr5CIBUWndZderzbAeDloAu0fapwJ9I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmcPS-001NF1-Nv; Thu, 05 May 2022 16:24:50 +0200
Date:   Thu, 5 May 2022 16:24:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v6 10/11] net: dsa: qca8k: add LEDs support
Message-ID: <YnPeMmioATk63DKZ@lunn.ch>
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-11-ansuelsmth@gmail.com>
 <YnMujjDHD5M9UdH0@lunn.ch>
 <6273d215.1c69fb81.b7a4a.4478@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6273d215.1c69fb81.b7a4a.4478@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 03:33:07PM +0200, Ansuel Smith wrote:
> On Thu, May 05, 2022 at 03:55:26AM +0200, Andrew Lunn wrote:
> > > +		ret = fwnode_property_read_string(led, "default-state", &state);
> > 
> > You should probably use led_default_state led_init_default_state_get()
> > 
> >     Andrew
> 
> Oh, didn't know it was a thing, is this new? Anyway thanks.

No idea. But my thinking was, you cannot be the first to implement the
binding, there probably exists some helpers somewhere...

General rule of thumb: Assume somebody has already been there and done
it, you just need to find it and reuse it.

    Andrew
