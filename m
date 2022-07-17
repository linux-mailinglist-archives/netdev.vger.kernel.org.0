Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1041D577710
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 17:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiGQP03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 11:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiGQP02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 11:26:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AB021AA
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 08:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iPYc44NGHgPwEgn3AL6ImKv464DrkVgdUex63zLkn98=; b=TBedZJBTln1dg8e5adkx/ffmTi
        k/qGCsrdno1wXTTnFIuTGdaZQekrlaR1AK/zt5vc9AAzQqqEkHScdXP2owESOxHV35Fjyeh8v0xLT
        XcJhDnimMfSyVUy8lbndvNh+aCjCfxyKKVLgMvoK6sktbsvGBgQqBQJl1LEmad2qzsoA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oD6A5-00Ad0b-QW; Sun, 17 Jul 2022 17:26:25 +0200
Date:   Sun, 17 Jul 2022 17:26:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net 06/15] docs: net: dsa: document the teardown method
Message-ID: <YtQqIT3W1BfTuJR5@lunn.ch>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-7-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716185344.1212091-7-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 09:53:35PM +0300, Vladimir Oltean wrote:
> A teardown method was added to dsa_switch_ops without being documented.
> Do so now.
> 
> Fixes: 5e3f847a02aa ("net: dsa: Add teardown callback for drivers")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
