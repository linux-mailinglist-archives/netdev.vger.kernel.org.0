Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171445B6385
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 00:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiILWR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 18:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiILWRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 18:17:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A718452446;
        Mon, 12 Sep 2022 15:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4wVTyoDRBOCUZALUxuJHx3v8qpoRRuDVNKdSlOlKlN8=; b=q5cLkAp1hiOMdlm5BXct9O2kiv
        hZYUlkjPz2gMOG4UlGx0hs1Igy1U/VJpfzzRxBMPu2raxznuIIGI1xZQr5Gl4A1Ya5kmYIFa1UBtp
        uw0l2AqHBXpYZV8BTXFBsPTLOArwYuA+g6RvhrTQ5D7GDDEdUf4CkwKfdG1RiEO/GjOk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oXriT-00GWuH-UX; Tue, 13 Sep 2022 00:15:45 +0200
Date:   Tue, 13 Sep 2022 00:15:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: phy: micrel: Cable Diag feature for
 lan8814 phy
Message-ID: <Yx+vkQJa4EklpIeX@lunn.ch>
References: <20220909083123.30134-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909083123.30134-1-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 02:01:23PM +0530, Divya Koppera wrote:
> Support for Cable Diagnostics in lan8814 phy
> 
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
