Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40AE4E99FE
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 16:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244001AbiC1Oo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 10:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244011AbiC1Oo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 10:44:57 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EA21AF3F;
        Mon, 28 Mar 2022 07:43:15 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 88236240002;
        Mon, 28 Mar 2022 14:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648478593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4RNpBLa/scaiQLYLfS5SMt5LVBIxZWpIM554lUw5974=;
        b=CA11zv8FiUuwD84/NN2IMFZym0Ik56paljMqTIVIc+ANlaDuGW6Lfmf4eu0uYeJt+u2AjY
        HKz24Gguzs2NK9OZxaS4vKa9K3ZchbrGbJktyObEqkU/FbtMVYxAd9EWZ3fPezlPlJ6AO/
        Wym0k1wsasdocRBGCY2oiZx4F8uXnDzlnsGU43oWz2FtLP47LFES4puwqsK6pVodpL91I0
        cWoMg8GgcE8E9B0GWFBovChLEv8c1lFUyYPdIgfERXFc8H1cC9TLpLPZAtx6anke5Bsn+k
        dWUO63qh1W6S4Dtm9HyPu/EfRB5hXUT58ObnK1PRXTQxu78GPcKrsYIff3zdyQ==
Date:   Mon, 28 Mar 2022 16:41:48 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next 1/5] net: mdio: fwnode: add fwnode_mdiobus_register()
Message-ID: <20220328164148.061c3a63@fixe.home>
In-Reply-To: <YkHCUbWxaqDJeQoK@lunn.ch>
References: <20220325172234.1259667-1-clement.leger@bootlin.com>
        <20220325172234.1259667-2-clement.leger@bootlin.com>
        <Yj4MIIu7Qtvv25Fs@lunn.ch>
        <20220328082642.471281e7@fixe.home>
        <YkGyFJuUDS6x4wrC@lunn.ch>
        <20220328152700.74be6037@fixe.home>
        <YkHCUbWxaqDJeQoK@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, 28 Mar 2022 16:12:33 +0200,
Andrew Lunn <andrew@lunn.ch> a =C3=A9crit :

> > With this series, fwnode_mdiobus_register() supports exactly the same
> > subset that is supported by of_mdiobus_register(). =20
>=20
> I need to see the side-by-side conversion. But it looked to me you did
> not support everything in DT.

I splat the conversion as you requested and it make it clear that it's
a 1:1 conversion. But indeed, it will be better by looking at patches.

>=20
> And another question is, should it support everything in DT. The DT
> binding has things which are deprecated. We have to support them in
> DT, they are ABI. But anything new should not be using them.

Ok, so maybe, the fwnode support should stop supporting these
deprecated features. From what I can see, there is at least the
following two things:

- Whitelist id table (seems to check legacy compatible strings)
- Scanning of child nodes that don't have a reg property. reg is
  specified as required in the bindings so it's probably not a good
  thing to keep that.

So maybe these features can be removed from the fwnode support.

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
