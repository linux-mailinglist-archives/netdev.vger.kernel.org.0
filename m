Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E3E6DDB1B
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjDKMpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjDKMpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:45:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D801FE4;
        Tue, 11 Apr 2023 05:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WFvtgGXh6gURF2Ev8feAnNkTzSGu1PeynGl1ztZC3/I=; b=gw+qtOn3J1iPbXBg2DgKVfkTEC
        79ACsGlkgXxvRmhNY5wt1JchiB3un/eyM8Hf4s0Pxuz+2F/Lv2Zf5/KlHzd+9IC4W0556rKPCnpo0
        hAk7kt750ykZHjkb42MktCR8H3kdxs/8rCXjG/RDO+ySDO9PBio2O70PMvqETxsLE6bM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmDMt-009zMV-54; Tue, 11 Apr 2023 14:45:03 +0200
Date:   Tue, 11 Apr 2023 14:45:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: add remove callback
Message-ID: <1c4c3085-f7e3-443b-8dfe-4cc19e85d9ad@lunn.ch>
References: <20230406095904.75456-1-radu-nicolae.pirea@oss.nxp.com>
 <e8b3646710d5fbedbe73449e5a1a7bd83fb1fa61.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8b3646710d5fbedbe73449e5a1a7bd83fb1fa61.camel@redhat.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andrew: my understanding is that a connected phy, maintains a reference
> to the relevant driver via phydev->mdio.dev.driver->owner, and such
> reference is dropped by phy_disconnect() via phy_detach().
> 
> So remove can invoked only after phy_disconnect
> 
> Does the above sounds reasonable/answer your question?

Yes, that does seem logical.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
