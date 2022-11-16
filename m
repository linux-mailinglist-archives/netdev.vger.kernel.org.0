Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9214F62BFC6
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 14:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiKPNlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 08:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237884AbiKPNll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 08:41:41 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACF81E3FC;
        Wed, 16 Nov 2022 05:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tdYQjrHuPTnZ+b2rbFm8ma7ka8KQeTwqY1MzgMyZJek=; b=eGp+bnP82D3YVfldKwUDMhxqhd
        KXuhDF/g7fPDia59s5hS5ObQl9hrwD80Z86dhKTO/h4XdtBXYuDSgoCAwXbefnV5NmiKKr/iVFvJe
        oN4SrJFs2DbHFqX9CoOCM6LsdUK6ZRhqFRnNy5rp5Zt3eZoXnBF6S11Tq1pRo1uiqdvU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovIfW-002ZUr-HD; Wed, 16 Nov 2022 14:41:34 +0100
Date:   Wed, 16 Nov 2022 14:41:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] net: dsa: use NET_NAME_PREDICTABLE for user ports
 with name given in DT
Message-ID: <Y3TojrwSOlDxl3Gc@lunn.ch>
References: <20221115074356.998747-1-linux@rasmusvillemoes.dk>
 <20221116105205.1127843-1-linux@rasmusvillemoes.dk>
 <20221116105205.1127843-3-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116105205.1127843-3-linux@rasmusvillemoes.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 11:52:03AM +0100, Rasmus Villemoes wrote:
> When a user port has a label in device tree, the corresponding
> netdevice is, to quote include/uapi/linux/netdevice.h, "predictably
> named by the kernel". This is also explicitly one of the intended use
> cases for NET_NAME_PREDICTABLE, quoting 685343fc3ba6 ("net: add
> name_assign_type netdev attribute"):
> 
>   NET_NAME_PREDICTABLE:
>     The ifname has been assigned by the kernel in a predictable way
>     [...] Examples include [...] and names deduced from hardware
>     properties (including being given explicitly by the firmware).
> 
> Expose that information properly for the benefit of userspace tools
> that make decisions based on the name_assign_type attribute,
> e.g. a systemd-udev rule with "kernel" in NamePolicy.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
