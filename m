Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB766598AE7
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243294AbiHRSMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238585AbiHRSMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:12:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45ACFC742B
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uKbNeLYFM4HlclZA9UPAjASKsw+qj+cCz5v+hqtJBts=; b=2f+OxI+rgsKha4D2/lPjwSqVpq
        L2w3kWK92rDB7Lq+blOyQJqusnxc6l72GdGnFZiBA0Z0NCt2y+FeYmDLdppDDGo/mtE9nlKSVONqG
        70lWu0ThvXCf4UyJ6KK2wvUsN7KCBZxxiayShHr8HNDQweLEHN3SAevN2W3bAewepN7I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOk0V-00Doxc-Cp; Thu, 18 Aug 2022 20:12:39 +0200
Date:   Thu, 18 Aug 2022 20:12:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH v2 net] net: dsa: microchip: make learning configurable
 and keep it off while standalone
Message-ID: <Yv6BF8dGM1hVSfEC@lunn.ch>
References: <20220818164809.3198039-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818164809.3198039-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
> Link: https://lore.kernel.org/netdev/CAFZh4h-JVWt80CrQWkFji7tZJahMfOToUJQgKS5s0_=9zzpvYQ@mail.gmail.com/
> Reported-by: Brian Hutchinson <b.hutchman@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2: targeting the 6.0 release candidates as opposed to the 5.19 rc's
>         from v1.
> 
> Again, this is compile-tested only, but the equivalent change was
> confirmed by Brian as working on a 5.10 kernel.
> 
> @maintainers: when should I submit the backports to "stable", for older
> trees?

Can Brian test it? Or at least cherry-pick it back to 5.10?

    Andrew
