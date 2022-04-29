Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26770514CBB
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377246AbiD2O2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377236AbiD2O2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:28:17 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE4B9136D;
        Fri, 29 Apr 2022 07:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bA3vg0ooQEtyAIyTeCEDpBhanFNnSZTX5oaouEaZmZs=; b=NuEkKy9uDLq5jPN4tellTEsX3v
        0Hmt0QvmByoVp+7p7CU5Uf6vlJUXkZKw83yTlp8xpNEKAdlHKXo7FKKRStR8Io7YcZhrf47bBHrpA
        exaUx8LHd0OTrUOnN9V1Xoihv3Dp6qFNPKg/8RzVgy2QW3JTbEalu9FrQ5bXYyYk2Vqk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkRYD-000Uez-TL; Fri, 29 Apr 2022 16:24:53 +0200
Date:   Fri, 29 Apr 2022 16:24:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piyush Malgujar <pmalgujar@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chandrakala Chavva <cchavva@marvell.com>,
        Damian Eppel <deppel@marvell.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] Marvell MDIO clock related changes.
Message-ID: <Ymv1NU6hvCpAo5+F@lunn.ch>
References: <CH0PR18MB4193CF9786F80101D08A2431A3FC9@CH0PR18MB4193.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH0PR18MB4193CF9786F80101D08A2431A3FC9@CH0PR18MB4193.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > 2) Marvell MDIO clock frequency attribute change:
> > > This MDIO change provides an option for user to have the bus speed set
> > > to their needs which is otherwise set to default(3.125 MHz).
> > 
> > Please read 802.3 Clause 22. The default should be 2.5MHz.
> > 
> 
> These changes are only specific to Marvell Octeon family.

Are you saying the Marvell Octeon family decide to ignore 802.3?  Have
you tested every possible PHY that could be connected to this MDIO bus
and they all work for 3.125MHz, even though 802.3 says they only need
to support up to 2.5Mhz?

     Andrew
