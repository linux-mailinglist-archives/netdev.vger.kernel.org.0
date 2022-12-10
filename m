Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705FF648E52
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 12:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiLJLEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 06:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiLJLEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 06:04:25 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A339214D29
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 03:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wI7aVprkHqsN6gXZHH6PXQ2RgrHyGushL7mBscGDUqY=; b=hLamgXQOOP4R+Ir0YCfYQjbvA+
        jMJW/+PKd3PKw/u6Qtg3FknMbqw0XQ3cJtfSFCwWfZio3FuXmgV8LRRXcgbUOFQ9cA6c3HVu0Hakp
        wISderEBhuVb3sCPrL62byDgnhTH2Pxj/nN1yPfrWKpjrZvUTDyPQKAML1jeTzg8B+n4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p3xeX-004x52-6b; Sat, 10 Dec 2022 12:04:21 +0100
Date:   Sat, 10 Dec 2022 12:04:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v4] net: ngbe: Add ngbe mdio bus driver.
Message-ID: <Y5Rntdtt3vxBV3ZG@lunn.ch>
References: <20221209102124.24652-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209102124.24652-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 06:21:24PM +0800, Mengyuan Lou wrote:
> Add mdio bus register for ngbe.
> The internal phy and external phy need to be handled separately.
> Add phy changed event detection.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> ---
> Change log:
> v4: address comments:
> 	Jiri Pirko: https://lore.kernel.org/netdev/Y5L9m%2FMMOG6GTNrb@nanopsycho/
> v3: address comments:
>         Jakub Kicinski: https://lore.kernel.org/netdev/20221208194215.55bc2ee1@kernel.org/
> v2: address comments:
>         Andrew Lunn: https://lore.kernel.org/netdev/Y4p0dQWijzQMlBmW@lunn.ch/

Sorry, i'm a bit behind on reviews and looked at an older
version. Some of the comments are still relevant for this version.

	 Andrew
