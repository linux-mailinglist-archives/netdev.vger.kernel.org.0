Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25105B0F36
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 23:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiIGVfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 17:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiIGVfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 17:35:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8013AB29
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 14:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jQYJsFJJW3h5QQhNgEcMqMeJ+sRh1CmZAXYhZlhTOI4=; b=bMiNXALzYDI/q1alxPLHyNlzts
        tpAGMXSHW553dfNjDRc//V/BWDo4mcRWZeN0xr1fhk+IHc09qI0tCjWkwCF4j0H/R9NO0a8efmcF1
        29+apWi91+EwGoCMxbwXXmyDMCF+59SePQbMBR2uPj+O1tMtyHhcljcQ64KGfmHqgmd4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oW2hK-00Fu5b-Jk; Wed, 07 Sep 2022 23:35:02 +0200
Date:   Wed, 7 Sep 2022 23:35:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v5 3/6] net: dsa: Introduce dsa tagger data
 operation.
Message-ID: <YxkOhs+YAl9sXy0h@lunn.ch>
References: <20220907072950.2329571-1-mattias.forsblad@gmail.com>
 <20220907072950.2329571-4-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907072950.2329571-4-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 09:29:47AM +0200, Mattias Forsblad wrote:
> Support connecting dsa tagger for frame2reg decoding
> with it's associated hookup functions.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
