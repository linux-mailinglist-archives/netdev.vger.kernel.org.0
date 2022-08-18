Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DDE5987A5
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343569AbiHRPl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245389AbiHRPl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:41:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EB0B8F18;
        Thu, 18 Aug 2022 08:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TCONSFUsRiagPq8Y40nHQ8cdEkcQObBuoVvqxp3VPVI=; b=XTdRIFx7hhK+o9Af9S2VM8waHw
        Z94lt+y/o42hKc3JZfKXkuz+9X6tzBKTxATr1wZY4NMlSWHsuKlx0CylpmcA2Gqet2WcfpY3p+Iau
        L4bQF8cG8/cscxcO+nge6zaM9n34xUJY+p/PL2gDs/14zidYwznu9IcAZFIxBUeq4g/M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOheR-00Dldv-Kj; Thu, 18 Aug 2022 17:41:43 +0200
Date:   Thu, 18 Aug 2022 17:41:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Bhadram Varka <vbhadram@nvidia.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 00/11] net: phy: Add support for rate adaptation
Message-ID: <Yv5dt1Scht2Tmdfg@lunn.ch>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
 <f6707ee4-b735-52ad-4f02-be2f58eb3f9b@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6707ee4-b735-52ad-4f02-be2f58eb3f9b@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 11:21:10AM -0400, Sean Anderson wrote:
> 
> 
> On 7/25/22 11:37 AM, Sean Anderson wrote:
> > This adds support for phy rate adaptation: when a phy adapts between
> > differing phy interface and link speeds. It was originally submitted as
> > part of [1], which is considered "v1" of this series.
 
> ping?
> 
> Are there any comments on this series other than about the tags for patch 6?

Anything that old is going to need a rebase. So you may as well repost
rather than ping.

       Andrew
