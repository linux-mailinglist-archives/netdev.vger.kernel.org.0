Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D02F5E61E4
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 14:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbiIVMAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 08:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiIVMAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 08:00:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3940C88B8;
        Thu, 22 Sep 2022 05:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KR9CO/r+Bld8ABx+wrKc5lM1IMc5XbXdJo+8qkb2UfY=; b=r2zcc9GrWQ+/McK8zmT+G9R6qz
        fe3tbyu8k9FSo3Qneu0G4AovXW6DA/29UXHicLoAjPqf3WPjZfQKYdBdB1+4TaWgg3tsYk7cX25KS
        YNm6ry+TRYZdLHxtxScgxdZdzcxmbDD3WGgU3PZgV8STaIM1imHanGK22MC3Xk99lV+w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obKsG-00HWnd-5T; Thu, 22 Sep 2022 14:00:12 +0200
Date:   Thu, 22 Sep 2022 14:00:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     marcus.carlberg@axis.com, davem@davemloft.net,
        devicetree@vger.kernel.org, edumazet@google.com,
        hkallweit1@gmail.com, kernel@axis.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        lxu@maxlinear.com, netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next 0/2] net: phy: mxl-gpy: Add mode for 2 leds
Message-ID: <YyxOTKJ8OTxXgWcA@lunn.ch>
References: <20220920151411.12523-1-marcus.carlberg@axis.com>
 <20220922080529.928823-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922080529.928823-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 10:05:29AM +0200, Michael Walle wrote:
> Hi,
> 
> > GPY211 phy default to using all four led pins.
> > Hardwares using only two leds where led0 is used as the high
> > network speed led and led1 the low network speed led will not
> > get the correct behaviour since 1Gbit and 2.5Gbit will not be
> > represented at all in the existing leds.
> 
> I might be wrong, but PHY LED bindings should be integrated with/using
> the LED subsystem. Although I didn't see any development regarding this
> for a long time.
> 
> That being said, it seems you are adding a new (DT) property which
> just matches your particular hardware design, no?

Thanks Michael

Replying to this was on my TODO list. We have NACKed patches like this
for a few years now, wanting the Linux LED subsystem be used to
configure PHY LEDs. The patches to implement the core of that
sometimes makes some progress, then goes dormant for a while. The last
effort was getting close to being ready. Maybe the needs for this
driver can help get them finished?

       Andrew
