Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07414F0C69
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 21:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356065AbiDCT4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 15:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239271AbiDCT4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 15:56:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03088219A;
        Sun,  3 Apr 2022 12:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=gqyV4vp9S0X60EY4aDAtM6FlvTYjN6u271pJT2WT0tE=; b=jT
        aOPXWPBLUfVvmpCWD+usZb383FZwC25EspDeMrXjS8b1rMZvYyvXqS7t1pb+jrF/QnhTyqEuR+fzS
        ybSwbXtMasEruzH54CxpEu1NOCmDVVmRii7DbdOMz1mUm2/bvgOg+c32taDjQ5dW/1jZUrvVg/pd9
        owEWK6K+GJXlElQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nb6If-00Dz4E-8z; Sun, 03 Apr 2022 21:54:13 +0200
Date:   Sun, 3 Apr 2022 21:54:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Stijn Tintel <stijn@linux-ipv6.be>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pali@kernel.org, kabel@kernel.org,
        pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        hkallweit1@gmail.com
Subject: Re: [PATCH] net: phy: marvell: add 88E1543 support
Message-ID: <Ykn7ZczbI3Zs+AOc@lunn.ch>
References: <20220403172936.3213998-1-stijn@linux-ipv6.be>
 <YknlRh7MLgLllb9q@shell.armlinux.org.uk>
 <fa04f389-df01-4838-7304-2fb43b919b98@linux-ipv6.be>
 <YknvDRbRznWZpstM@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YknvDRbRznWZpstM@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 03, 2022 at 08:01:33PM +0100, Russell King (Oracle) wrote:
> On Sun, Apr 03, 2022 at 09:30:06PM +0300, Stijn Tintel wrote:
> > On 3/04/2022 21:19, Russell King (Oracle) wrote:
> > > Hi,
> > >
> > > On Sun, Apr 03, 2022 at 08:29:36PM +0300, Stijn Tintel wrote:
> > >> Add support for the Marvell Alaska 88E1543 PHY used in the WatchGuard
> > >> Firebox M200 and M300.
> > > Looking at the IDs, this PHY should already be supported - reporting as
> > > an 88E1545. Why do you need this patch?
> > >
> > Thanks for pointing that out, you're right. Please disregard the patch. 
> > Would it be acceptable to change the name member to "Marvell
> > 88E1543/88E1545" to make this more obvious?
> 
> Unfortuantely not, the driver name is used in sysfs, and as I'm sure
> you're aware, "/" is a pathname element separator and thus can't be
> used.

The name is however reasonably free text. For example:

micrel.c:	.name		= "Micrel KSZ8021 or KSZ8031",

	Andrew
