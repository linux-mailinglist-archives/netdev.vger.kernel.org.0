Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAD9678E1F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbjAXCRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbjAXCRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:17:40 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C2E1ABC0
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ut+E8HJ0/rxiCKmqEvsMMSvMjHBu+Hi3aBaCKMUUs4M=; b=meXVF3dgXzBiCtF8a5EsZiy9t/
        uPDHzq/rwa3ipgIPusKnk10mq/PYyOQNyEMPSEgqHzX4TBKXsEahNbt84P2S4LsiuaaXJrEy3jN4v
        rWya/uOZmB5N4CE7T596wQycFmhjoN3276TZvRzxksOC25hhUlCnza6HyRvzkD1tYwE8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pK8sO-002yF7-MZ; Tue, 24 Jan 2023 03:17:32 +0100
Date:   Tue, 24 Jan 2023 03:17:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mdio: warn once if addr parameter is
 invalid in mdiobus_get_phy()
Message-ID: <Y88/vEjw0tJFAT29@lunn.ch>
References: <daec3f08-6192-ba79-f74b-5beb436cab6c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daec3f08-6192-ba79-f74b-5beb436cab6c@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 11:18:32PM +0100, Heiner Kallweit wrote:
> If mdiobus_get_phy() is called with an invalid addr parameter, then the
> caller has a bug. Print a call trace to help identifying the caller.
> 
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
