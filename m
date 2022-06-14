Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9024354BCEF
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345510AbiFNVpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 17:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbiFNVpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 17:45:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAF0396A2
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 14:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qjqVnXxoF4qKehisogHwZO+Dd4GvgnHXyR+LcmnbWlU=; b=n+EpnVIdNhxDYxahChcnv1X91T
        tv05RDQcdC9O6RjsUGJtbN4iUy/kYNemWPOa9kJlRrg4gaa+FmdXJhW4fzmiiKfhSDS9Acc5F/yU/
        C7BaQo7a6hcHq/EU2mdzkiSfC+hayKF2h93KeDA2uRDgX8BvmsrPdHuadHA4pk1L2c48=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1ELt-006vvm-U6; Tue, 14 Jun 2022 23:45:33 +0200
Date:   Tue, 14 Jun 2022 23:45:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 08/15] net: dsa: add support for mac_prepare()
 and mac_finish() calls
Message-ID: <YqkBfWUXpgp0809o@lunn.ch>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
 <E1o0jgj-000JYt-RI@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1o0jgj-000JYt-RI@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 13, 2022 at 02:01:01PM +0100, Russell King (Oracle) wrote:
> Add DSA support for the phylink mac_prepare() and mac_finish() calls.
> These were introduced as part of the PCS support to allow MACs to
> perform preparatory steps prior to configuration, and finalisation
> steps after the MAC and PCS has been configured.
> 
> Introducing phylink_pcs support to the mv88e6xxx DSA driver needs some
> code moved out of its mac_config() stage into the mac_prepare() and
> mac_finish() stages, and this commit facilitates such code in DSA
> drivers.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
