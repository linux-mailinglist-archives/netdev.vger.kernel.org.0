Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD52F574EA6
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 15:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239242AbiGNNHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 09:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239257AbiGNNHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 09:07:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227E95A450;
        Thu, 14 Jul 2022 06:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=muk3dIHelVPAgQTm/sXT9cnXJeu6KyPqOGP4GYK8ICA=; b=aOlh6MOtK6Ygg3+oAK6/BmgxJA
        xDj3aMxagV6io4m47qnHJYy3cm20wP4wVMrMv7yTmZs4zsqi3+i+49Mn7M+EIlAr67SGXrA3txkIf
        26lA+qY9Bl7yiqN9yOBIR+onzaLNfmbhyZT07ZyFHq0IUrdYHUNZrXSLcvuA3ZMDOz0g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oByYV-00AHim-O8; Thu, 14 Jul 2022 15:06:59 +0200
Date:   Thu, 14 Jul 2022 15:06:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Subject: Re: [PATCH V2 net-next] net: marvell: prestera: add phylink support
Message-ID: <YtAU89nwoDDA0+dj@lunn.ch>
References: <20220713172013.29531-1-oleksandr.mazur@plvision.eu>
 <Ys8lgQGBsvWAtXDZ@shell.armlinux.org.uk>
 <Ys8+qT6ED4dty+3i@lunn.ch>
 <GV1P190MB2019C2CFF4AB6934E8752A32E4889@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
 <YtAOZGLR1a74FnoQ@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtAOZGLR1a74FnoQ@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >No way to restart 1000base-X autoneg?
> > 3. As for AN restart, no, it's not yet supported by our FW as of now.
> 
> Maybe put a comment in the code to that effect?

And also think about forward/backward compatibility. At some point
your FW will support it. Do you need to do anything now in order to
smoothly add support for it in the future?

	 Andrew
