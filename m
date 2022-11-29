Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B0C63C761
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 19:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236155AbiK2Sug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 13:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235056AbiK2Suf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 13:50:35 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B722F3A4;
        Tue, 29 Nov 2022 10:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GQkqIEeWtoMcf+c1pfLWBY/tc9I80bqBBg812eggygw=; b=x9ZucUZkrvH6fL5slEzEPD7Kzc
        djqZfqkDYq1ARwE7edRnxwZbvDpme8OLOTbnUTcwlauKRXVA5U30++KzoVMiTau8XGlTHKEnXFKP3
        oKBHLvJPINLYxb+PDk5l0wH9B2MjB/WFfNLyWrZ9i44o5EspUWZyj4ClHj3c0Ae2Cm4o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p05gY-003u5M-36; Tue, 29 Nov 2022 19:50:26 +0100
Date:   Tue, 29 Nov 2022 19:50:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 02/12] net: dpaa2: replace
 dpaa2_mac_is_type_fixed() with dpaa2_mac_is_type_phy()
Message-ID: <Y4ZUcjLzZlkP3Pn7@lunn.ch>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
 <20221129141221.872653-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129141221.872653-3-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 04:12:11PM +0200, Vladimir Oltean wrote:
> dpaa2_mac_is_type_fixed() is a header with no implementation and no
> callers, which is referenced from the documentation though. It can be
> deleted.
> 
> On the other hand, it would be useful to reuse the code between
> dpaa2_eth_is_type_phy() and dpaa2_switch_port_is_type_phy(). That common
> code should be called dpaa2_mac_is_type_phy(), so let's create that.
> 
> The removal and the addition are merged into the same patch because,
> in fact, is_type_phy() is the logical opposite of is_type_fixed().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
