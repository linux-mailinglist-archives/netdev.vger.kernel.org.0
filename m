Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157496AA058
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 20:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbjCCTxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 14:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjCCTxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 14:53:00 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6A372A2
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 11:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EwgxD2cCScG1Gh8AbqXWaODyRs8mbMZQknozl3iNG0k=; b=hk4VLptFmvYtvdrdvv5Hagkzrq
        3NpboxXscsF6MS4t3bBaTr5mxKt4J+O422rL6uwa/G1rn9GAG2jmdRWAou0W/ocj3v8NhJAmqPbmf
        OmSoNY3k3oSq2oF6vrj5LbKXQTLLejojB/LJhzgUAQQDXVIgM+Tzv49hctK9ctyY4C/o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pYBSC-006PZ9-7Y; Fri, 03 Mar 2023 20:52:32 +0100
Date:   Fri, 3 Mar 2023 20:52:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylib: get rid of unnecessary locking
Message-ID: <2986e1d8-6cc8-4dea-8f9a-9da7716f0b8f@lunn.ch>
References: <E1pY8Pq-00D0sw-NY@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pY8Pq-00D0sw-NY@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 04:37:54PM +0000, Russell King (Oracle) wrote:
> The locking in phy_probe() and phy_remove() does very little to prevent
> any races with e.g. phy_attach_direct(), but instead causes lockdep ABBA
> warnings. Remove it.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
