Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD79629CDD
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiKOPCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiKOPCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:02:49 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9911823BEA;
        Tue, 15 Nov 2022 07:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zRHf7uNPeh2kBVdWmKW0GFypLXCUl8jRA2VU7wkOlI4=; b=acgzf5ty3KyM8r6dyR61ocZrOX
        NHdcRgTGYkYBr4L+p64UKkRDLvbLn3TI1QCmJCU3QFIlOHMEOTtrCL0wNftbU5j8XfGpJa1H3flUb
        kvGiAfonWM8y38LmAj4pSE+e03SVm0m8PSfw6UGvg3M+K4TX39Ohx6lIILhKNba9mP18=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ouxSD-002TAZ-Q8; Tue, 15 Nov 2022 16:02:25 +0100
Date:   Tue, 15 Nov 2022 16:02:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: use NET_NAME_PREDICTABLE for user ports with
 name given in DT
Message-ID: <Y3OqAfLZltb9OOmD@lunn.ch>
References: <20221111161729.915233-1-linux@rasmusvillemoes.dk>
 <Y26B8NL3Rv2u/otG@lunn.ch>
 <26d3b005-aa4e-66d3-32eb-568d3dfe6379@rasmusvillemoes.dk>
 <20221114181712.51856dd4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114181712.51856dd4@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Apparently there may be a reason, see commit e9f656b7a214 ("net:
> ethernet: set default assignment identifier to NET_NAME_ENUM")
> so let's switch to ENUM while at it.

I would recommend two patches, making it easier to revert if we find
something in userspace breaks.

	  Andrew
