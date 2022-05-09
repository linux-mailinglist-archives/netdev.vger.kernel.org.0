Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467AF51FEC5
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236512AbiEINyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236507AbiEINyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:54:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA6728B694
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 06:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=d2jQnnEK6E8cRiYzXCzctMkuWZYT2pov/CsdrBeTa/8=; b=PU2MgX9lOAPIPfzkt5BSOn52ZT
        U/rbgbKg1EQob5uSkSEdHcCmVU3CxAQhH4TKjDKUd6IPDbXGoDHQ6zfdxzdl4ZDU8vt7/NakqXYZQ
        Qhh1UsVwVlJAdjbFkmsFFdSyzCdT0Eu8rt7Uky8q36OehLB22oE+vhrGK21ka5uaXmm8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1no3mS-001x2a-09; Mon, 09 May 2022 15:50:32 +0200
Date:   Mon, 9 May 2022 15:50:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuiko.Oshino@microchip.com
Cc:     kuba@kernel.org, Woojung.Huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, Ravi.Hegde@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 2/2] net: phy: smsc: add LAN8742 phy support.
Message-ID: <YnkcJ73mhI2aoo2h@lunn.ch>
References: <20220505181252.32196-1-yuiko.oshino@microchip.com>
 <20220505181252.32196-3-yuiko.oshino@microchip.com>
 <YnQlicxRi3XXGhCG@lunn.ch>
 <20220506154513.48f16e24@kernel.org>
 <YnZ4uqB688uAeamL@lunn.ch>
 <CH0PR11MB5561FF8274E9D5771D472C0F8EC69@CH0PR11MB5561.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH0PR11MB5561FF8274E9D5771D472C0F8EC69@CH0PR11MB5561.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So should I create a new series with the missing comments only
> rather than doing v5?

Yes please.

    Andrew
