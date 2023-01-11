Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2FCB6651C3
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 03:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbjAKC2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 21:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235460AbjAKC2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 21:28:23 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A066438
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 18:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=g9oTMbkDVdJ/LFfEktU0AXeIxagboU/oAfxSqKUXiaw=; b=mBOjCRy6VnDBryAfG/Gv1geiXQ
        lRuvr385xPWjkPfx7/VvzSYBtQbFue3u2hPSnlIy/8it5R1CFxAE8CKeCWVTYFo2pG3xtNGe48+/B
        ajWPnPxFt8jJhOo46YSoGpHd1h8rv1edxtBGuBBG7WLAjKB+i8oaq7fSDjQde+SgBwzs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pFQqZ-001jRs-Al; Wed, 11 Jan 2023 03:28:11 +0100
Date:   Wed, 11 Jan 2023 03:28:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Mengyuan Lou <mengyuanlou@net-swift.com>, netdev@vger.kernel.org,
        jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v7] net: ngbe: Add ngbe mdio bus driver.
Message-ID: <Y74euxqQUpXR6OGZ@lunn.ch>
References: <20230109153508.37084-1-mengyuanlou@net-swift.com>
 <Y7xFiNoTS6FdQa97@lunn.ch>
 <20230110181907.5e4abbcd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110181907.5e4abbcd@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 06:19:07PM -0800, Jakub Kicinski wrote:
> On Mon, 9 Jan 2023 17:49:12 +0100 Andrew Lunn wrote:
> > On Mon, Jan 09, 2023 at 11:35:08PM +0800, Mengyuan Lou wrote:
> > > Add mdio bus register for ngbe.
> > > The internal phy and external phy need to be handled separately.
> > > Add phy changed event detection.
> > > 
> > > Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>  
> > 
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> Any preference on this getting merged as is vs Mengyuan implementing
> the c45 support via separate callbacks? I just applied the patches
> adding the new callbacks to net-next:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=ef1757ef58467310a285e57e6dbf6cf8314e5080

Hi Jakub

Thanks for merging these patches. I forget how many patches there are
in total, something like 60, so there are a few more series to
come. Many more drivers still need splitting.

If Mengyuan wants to split C22 and C45 that would be nice, but since
this is a new requirement, i would not insist on it.

  Andrew
