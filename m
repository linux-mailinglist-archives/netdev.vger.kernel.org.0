Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A77598F92
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 23:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344519AbiHRVc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 17:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiHRVc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 17:32:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBB11144;
        Thu, 18 Aug 2022 14:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=j8uBKWetBFUoKG9XjcCgGD+nxkNDFBzdOP9TSgJLkUw=; b=xk4fxfgkbPKpndi7N7eaJosIS7
        dkBolJwkTlk648rWKpPOeeIfAMEC4niyjTbJvbA1GdoDsRvoc1vlXyJNbCaYYdVGzdzbVjXimYqs9
        QMQmhbbka7dxp7c7Hg8yPApALQH6n8wrr5AAU3JA1EtPKbOspj0PhBsTwtFqgr4dgFAg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOn84-00DqYo-AJ; Thu, 18 Aug 2022 23:32:40 +0200
Date:   Thu, 18 Aug 2022 23:32:40 +0200
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
Message-ID: <Yv6v+L+/KyJrLtFk@lunn.ch>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
 <f6707ee4-b735-52ad-4f02-be2f58eb3f9b@seco.com>
 <Yv5dt1Scht2Tmdfg@lunn.ch>
 <14d72a66-b202-f7b6-e690-e119368bf1b6@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14d72a66-b202-f7b6-e690-e119368bf1b6@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I have some other series [1,2] which have also received little-to-no feedback. Should
> I resend those as well? I didn't ping about these earlier because there was a merge
> window open, and e.g. gregkh has told me not to ping at that time (since series will
> be reviewed afterwards). Should I be pinging sooner on netdev?

For netdev, you need to resend after the merge window. Other
subsystems might look at older patch, and if they apply cleanly might
merge them. But not netdev.

      Andrew
