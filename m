Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD506407AF
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 14:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbiLBNbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 08:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiLBNbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 08:31:33 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C44CB390B
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 05:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KRPBdjppLpZqji2Jk04x9r3IICXm96KFLXGqvJoUUxs=; b=sjPEO7fKaKvK7fCZjKKFQeLvUK
        NuwTMEkUMTit1/3JpNPzOt1bwReLM45CGlkLLnTiFZG+0H4zOwgH3/FngvaGBRHBrfJzmBUF7D8UP
        1+oRFnz5zNxzlVhE2KMHcHGxSbyZGGuus09+R3FI+DG7/lQoabJG8Jpo5n8+OzYjj1LA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p168Y-004B4H-Ew; Fri, 02 Dec 2022 14:31:30 +0100
Date:   Fri, 2 Dec 2022 14:31:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] net: sfp: clean up i2c-bus property parsing
Message-ID: <Y4n+MnK6ZPMUIRhq@lunn.ch>
References: <E1p13A4-0096Qh-TW@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1p13A4-0096Qh-TW@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 10:20:52AM +0000, Russell King (Oracle) wrote:
> We currently have some complicated code in sfp_probe() which gets the
> I2C bus depending on whether the sfp node is DT or ACPI, and we use
> completely separate lookup functions.
> 
> This could do with being in a separate function to make the code more
> readable, so move it to a new function, sfp_i2c_get(). We can also use
> fwnode_find_reference() to lookup the I2C bus fwnode before then
> decending into fwnode-type specific parsing.
> 
> A future cleanup would be to move the fwnode-type specific parsing into
> the i2c layer, which is where it really should be.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
