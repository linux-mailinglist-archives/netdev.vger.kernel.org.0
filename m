Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F4A4EB2CE
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 19:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240283AbiC2RmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 13:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240273AbiC2Rl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 13:41:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B97E2A27A;
        Tue, 29 Mar 2022 10:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xVfXSyLgNQ7HxDS7GTCCer3mw54IDrDgWbh9XTFmtpg=; b=GxpSvzxgz6WHHuRdNOnejUwp3h
        YReNP7xUePy8MA1QwfR0swNzB+KPAm4Q2jL95hcyE6LM410HYOvkJ0tze1claptkZ0/Jvi+AVkvnk
        tqZR4olal9xD4Oc4jjakUwCbiV+I1RcKslxYAVSvSDyPjFq4acFUvJ9oLeQwIxwoq5+0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nZFor-00DCL2-G2; Tue, 29 Mar 2022 19:39:49 +0200
Date:   Tue, 29 Mar 2022 19:39:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Potin Lai <potin.lai@quantatw.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Patrick Williams <patrick@stwcx.xyz>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net: mdio: aspeed: Add Clause 45 support
Message-ID: <YkNEZRDw1bZuc/PP@lunn.ch>
References: <20220329161949.19762-1-potin.lai@quantatw.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329161949.19762-1-potin.lai@quantatw.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 12:19:49AM +0800, Potin Lai wrote:
> Add Clause 45 support for Aspeed mdio driver.

This looks O.K, but please set bus->probe_capabilities to indicate
both C22 and C45.

net-next is closed at the moment, so please wait until next week
before sending the next version.

     Andrew

