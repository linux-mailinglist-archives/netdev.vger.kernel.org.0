Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D3D6B2B22
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCIQsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjCIQrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:47:51 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7858EF4002
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 08:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FtrAHG0pekTsAhB+eeKq6tiMwzCQhzMQHi2Uy+KG0SY=; b=e2gMROQ3temMnANBq83v7fSkDW
        Usl7E6BWp4JUQ9fhh6rlnnJxVbaLOEkoqlHURTxH7YbBkw2YTCeKH9ZlYtHAQ8EAEpUjVRm1824MT
        LJ6iUABFnedRIJJmWZIBhy7eRtUuD5Bpu/O1KL2OOgUA3DN/CCJ/koBs3lRRCDus+V/4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1paIsa-006tXG-Vi; Thu, 09 Mar 2023 17:12:32 +0100
Date:   Thu, 9 Mar 2023 17:12:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: sfp: only use soft polling if we have
 A2h access
Message-ID: <e4b4f39a-9bd1-4665-b2e3-e428e2070c06@lunn.ch>
References: <ZAoBnqGBnIZzLwpV@shell.armlinux.org.uk>
 <E1paIdo-00DUP7-92@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1paIdo-00DUP7-92@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 03:57:16PM +0000, Russell King (Oracle) wrote:
> The soft state bits are stored in the A2h memory space, and require
> SFF-8472 compliance. This is what our have_a2 flag tells us, so use
> this to indicate whether we should attempt to use the soft signals.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
