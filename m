Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2F251E783
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 15:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344560AbiEGNwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 09:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbiEGNwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 09:52:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE07B2408A
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 06:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PLKlBSiANjQgCcxCKdf0hIwIz7MpoGk/wq4dE03AvwM=; b=ecJ3gqvXywLiTnCRdXNjZm93ha
        AhI6+cZ+iP5fnHzjYMFnHLbdungVtVRuXVAbd5mJR73BM/7SfyzEKFGAM60yZeRnoWJfAkR3ifAim
        WyQoeULRY7N/8RTJN4DGutuSFp0ICaIeu2zBI3OaktRJvze34p+fyuF9f1kamk7I1+a4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nnKna-001fAC-OI; Sat, 07 May 2022 15:48:42 +0200
Date:   Sat, 7 May 2022 15:48:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yuiko Oshino <yuiko.oshino@microchip.com>,
        woojung.huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, ravi.hegde@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 2/2] net: phy: smsc: add LAN8742 phy support.
Message-ID: <YnZ4uqB688uAeamL@lunn.ch>
References: <20220505181252.32196-1-yuiko.oshino@microchip.com>
 <20220505181252.32196-3-yuiko.oshino@microchip.com>
 <YnQlicxRi3XXGhCG@lunn.ch>
 <20220506154513.48f16e24@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506154513.48f16e24@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 03:45:13PM -0700, Jakub Kicinski wrote:
> On Thu, 5 May 2022 21:29:13 +0200 Andrew Lunn wrote:
> > On Thu, May 05, 2022 at 11:12:52AM -0700, Yuiko Oshino wrote:
> > > The current phy IDs on the available hardware.
> > >         LAN8742 0x0007C130, 0x0007C131
> > > 
> > > Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>  
> > 
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> The comments which I think were requested in the review of v2 and
> appeared in v3 are now gone, again. Is that okay?

Ah, i had not noticed. Thanks for pointing it out.

Those comments are important, since these mask are odd, somebody is
either going to ask about them, or try to 'fix' them. Some robot will
fall over them, etc.

     Andrew
