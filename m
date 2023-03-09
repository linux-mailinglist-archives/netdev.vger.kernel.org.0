Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAA76B2B21
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCIQsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjCIQrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:47:51 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B278AF5D38
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 08:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mgQn4kOQNuCA6GBkpEGygN3PH3whAKqQrJ8ipgdyynk=; b=Jls25/EhuX/aOXkWngpvTMsAj5
        wA5kvTetolrP69JKj8iPsP1rS93q9QJwyX9hlJHAJpNNztZOSJZp5WV8SgEeEV89f9CEuH/O2nCYr
        faKReibbHgvw7eQPrJHOpqw2T+U+CasncMjM+ijA1wVhqFv0ThKBc82Q8Z+5zltG53Hw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1paIs6-006tWq-QZ; Thu, 09 Mar 2023 17:12:02 +0100
Date:   Thu, 9 Mar 2023 17:12:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: sfp: add A2h presence flag
Message-ID: <0443257e-ed31-421c-af28-4fb728e14210@lunn.ch>
References: <ZAoBnqGBnIZzLwpV@shell.armlinux.org.uk>
 <E1paIdj-00DUP1-4r@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1paIdj-00DUP1-4r@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 03:57:11PM +0000, Russell King (Oracle) wrote:
> The hwmon code wants to know when it is safe to access the A2h data
> stored in a separate address. We indicate that this is present when
> we have SFF-8472 compliance and the lack of an address-change
> sequence.,
> 
> The same conditions are also true if we want to access other controls
> and status in the A2h address. So let's make a flag to indicate whether
> we can access it, instead of repeating the conditions throughout the
> code.
> 
> For now, only convert the hwmon code.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
