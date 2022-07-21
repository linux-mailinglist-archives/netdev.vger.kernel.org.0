Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D693857D1B3
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiGUQlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiGUQlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:41:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1DF27B28;
        Thu, 21 Jul 2022 09:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Tm7xpICnYi58DW3Gxx9R/Up3K1pFEqlUO/Tj5V7+eFM=; b=MHwS6r9lV7eiLRHxAUey2LGsdS
        Fbm4S7CeCB+d1mbmJLSN5dmjF09QGHVDRZHqoQc8ky0M7nvzca2dkrc/iIkvzg7jRyCbbnx3qwv/h
        WmSY/eEWY8l6bUyNLujZ8FcSNTSefmONfrS49Qu6rZb0qYYaceu/qvmaZs9qOlTQFVec=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oEZEO-00B3hh-Jj; Thu, 21 Jul 2022 18:40:56 +0200
Date:   Thu, 21 Jul 2022 18:40:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 06/11] net: phylink: Support differing link/interface
 speed/duplex
Message-ID: <YtmBmKa01DBlZO4t@lunn.ch>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-7-sean.anderson@seco.com>
 <YtekL4y/XKn1m/V4@shell.armlinux.org.uk>
 <6a2fe06b-3a96-026b-34da-6e6f13876c62@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a2fe06b-3a96-026b-34da-6e6f13876c62@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I thought we had decided that using the term "link" in these new members
> > was a bad idea.
> 
> I saw that you and Andrew were not in favor, but I did not get a response to
> my defense of this terminology. That said, this is not a terribly large
> change to make.

I know Russell tends to use media side, and i use line side. I would
be happy with either. I think we both use host side.

"link" is way to ambiguous.

I do understand you not wanting to change phydev->speed, it is used in
a lot of places. But maybe changing it is good, you then get to look
at the code and decide does it want the media speed, or the host
speed.

	Andrew
