Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCDE5B0F34
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 23:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiIGVeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 17:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiIGVeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 17:34:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A126C123C
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 14:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=L2NejAEe7wjS6RlDQ2L7Pty/v+Di1lYiSSuFIH9h8VM=; b=iFvhBbMUNk2xK6z351MqvLWScr
        37cMKxeZAS3Yrsws4CM+fayTyXPfOSwA9V2NGUFC2jUHDnih0MEUoODrVs+g0LY0+BfvC3oZEQtJ9
        +kbK495XypMQz3HxmAY5r2tOl2KwXSyCmCTceyz4JGRT2XBLeDb5Unjz8p5eyOvU3A7s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oW2gN-00Fu4w-VH; Wed, 07 Sep 2022 23:34:03 +0200
Date:   Wed, 7 Sep 2022 23:34:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v5 1/6] net: dsa: mv88e6xxx: Add RMU enable for
 select switches.
Message-ID: <YxkOSwhaEns/Q6Nv@lunn.ch>
References: <20220907072950.2329571-1-mattias.forsblad@gmail.com>
 <20220907072950.2329571-2-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907072950.2329571-2-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 09:29:45AM +0200, Mattias Forsblad wrote:
> Add RMU enable functionality for some Marvell SOHO switches.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
