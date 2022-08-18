Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA239597AF8
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 03:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242506AbiHRBWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 21:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiHRBWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 21:22:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED8B9D8EB;
        Wed, 17 Aug 2022 18:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=i72VD66WgCVZTQVjy1dTMukabastibOoJBga/T4/dVA=; b=DXp1IR7Ibis2k80vTHqcm89YA7
        PAe0aWbJlixIOkObm3miN5MB0v3xlidMdQdMpaLNc7pmmsr0HXh9/4dS0pW7yr9HVL0LuUFsEp3pt
        ZBEbgdH7adSKbK/MIUZ+w66a9VuqMnjU16tTKcuutJtbLkcc77JMudSYvpJXqTerwTiU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOUEL-00DgZu-Ks; Thu, 18 Aug 2022 03:21:53 +0200
Date:   Thu, 18 Aug 2022 03:21:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Beniamin Sandu <beniaminsandu@gmail.com>, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sfp: use simplified HWMON_CHANNEL_INFO macro
Message-ID: <Yv2UMcVUSwiaFyH6@lunn.ch>
References: <20220813204658.848372-1-beniaminsandu@gmail.com>
 <20220817085429.4f7e4aac@kernel.org>
 <Yv0TaF+So0euV0DR@shell.armlinux.org.uk>
 <20220817101916.10dec387@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817101916.10dec387@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 10:19:16AM -0700, Jakub Kicinski wrote:
> On Wed, 17 Aug 2022 17:12:24 +0100 Russell King (Oracle) wrote:
> > On Wed, Aug 17, 2022 at 08:54:29AM -0700, Jakub Kicinski wrote:
> > > On Sat, 13 Aug 2022 23:46:58 +0300 Beniamin Sandu wrote:  
> > > > This makes the code look cleaner and easier to read.  
> > > 
> > > Last call for reviews..  
> > 
> > I had a quick look and couldn't see anything obviously wrong, but then
> > I'm no expert with the hwmon code.
> 
> That makes two of us, good enough! :) Thanks for taking a look.

It would of been nice to Cc: the HWMON maintainer. His input would of
been just as valuable as a PHY Maintainer.

     Andrew
