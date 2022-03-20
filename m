Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA9E4E192B
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 01:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244466AbiCTAnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 20:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236078AbiCTAnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 20:43:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A233234060;
        Sat, 19 Mar 2022 17:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JpMju6MwC4+pRriGxkXm9qJS6b6I3/IuPafCT8ynlIQ=; b=xGaFuiGJN8LffXxx89zmkfYeK2
        +4J/moAYt9KJ+zTJWVDe1zcMwb/oiy2L68CHZIl46LrPPOkBWux/Ll4arg4rKX66rXcKXVLSw0qQh
        KK51nQxZcL/1YW9RVv+WD46Yrjqzx6tO2KEAescXkHkSsgpONMJ5ADf+rJQSNDEJJ7Eo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nVjdT-00BlTR-09; Sun, 20 Mar 2022 01:41:31 +0100
Date:   Sun, 20 Mar 2022 01:41:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v9 net-next 02/11] dt-bindings: net: add mdio property
Message-ID: <YjZ4Oj5G2Ii0vNaB@lunn.ch>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
 <20220318085540.281721-3-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318085540.281721-3-prasanna.vengateshan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 02:25:31PM +0530, Prasanna Vengateshan wrote:
> mdio bus is applicable to any switch hence it is added as per the below request,
> https://lore.kernel.org/netdev/1300f84832ef1c43ecb9edb311fb817e3aab5420.camel@microchip.com/
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
