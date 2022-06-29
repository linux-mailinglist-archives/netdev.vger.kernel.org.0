Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488065606DE
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiF2RBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbiF2RB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:01:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0A338D8E;
        Wed, 29 Jun 2022 10:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TOrOdK/kM8JgnYoofm5Ds5kWRQVMJdq/dybV2/q0OTk=; b=Ey0WqmkLQSWxxDxJVbg9oIZboy
        9AFlaPEM/7o6pnGF24CQvbkDxS4S28hEE99HizhvqvWxoaA7Fuh61bCTpzmvt4hwxahxCdOcD6EeQ
        zGMyF2zFhSv8glHWqHcxQWHq7mNLVWinYOpammeq/rMVucTt6xPV+WAP1j3ZSvr6V5vE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o6b3u-008je8-GO; Wed, 29 Jun 2022 19:01:10 +0200
Date:   Wed, 29 Jun 2022 19:01:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Divya Koppera <Divya.Koppera@microchip.com>, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com
Subject: Re: [PATCH net-next] net: phy: micrel: Adding LED feature for
 LAN8814 PHY
Message-ID: <YryFVpFTrQ1GAXhl@lunn.ch>
References: <20220628054925.14198-1-Divya.Koppera@microchip.com>
 <YrsRUd6GPG0qCJsw@lunn.ch>
 <YrxXL/p3q35SsXmk@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrxXL/p3q35SsXmk@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 02:44:15PM +0100, Russell King (Oracle) wrote:
> On Tue, Jun 28, 2022 at 04:33:53PM +0200, Andrew Lunn wrote:
> > On Tue, Jun 28, 2022 at 11:19:25AM +0530, Divya Koppera wrote:
> > > LED support for extended mode where
> > > LED 1: Enhanced Mode 5 (10M/1000M/Activity)
> > > LED 2: Enhanced Mode 4 (100M/1000M/Activity)
> > > 
> > > By default it supports KSZ9031 LED mode
> > 
> > You need to update the binding documentation.
> 
> What happened to "use the LEDs interface, don't invent private bindings
> for PHY LEDs" ?
> 
> Does this mean the private bindings are now acceptable and I can
> resubmit my 88x3310 LED support code?

I hummed and harded about this case. The binding is there, documented
and in use. It comes from the times before we started pushing back on
vendor LED configuration methods. All this patch does is extend the
existing binding to another device of the same family. It seemed
unfair to reject it. The mess of a vendor proprietary binding exists,
and this does not make it worse.

For 88x3310 there is no president set, it should be done via Linux
LEDs.

	Andrew

