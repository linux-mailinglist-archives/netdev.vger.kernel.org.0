Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4593A6F3FDD
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 11:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbjEBJK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 05:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjEBJK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 05:10:56 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1642D61
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 02:10:54 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 050B520013;
        Tue,  2 May 2023 09:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1683018652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1AiuFBMNSyeM4md0h+/YPCbpK5+IPsUO8QshrNnLjzM=;
        b=JMSTyp7/JmIe2+nZYrjfw1inw665ngr46bH0d9EcpdPYUdjXh1O3L7YVwQb+RfF7uqo1ni
        YCuzXQlcIWT9wfA/YFUWWe6phwOvEE0foEVUaLPFwTmEnqobSAIXhzjIhFs3oSa6OJSwzc
        /FSIEJ7itad0QEhucX9XmEEgKoEpmWd57tMBkW2b9Qo93TVGccZO1vNB10/bvmb7kS/W2Y
        XGBt9DZrp98/BoKVJLRtr2hxc3b0qP64bBKUgOQIDwJWt3zq5qRLofPcR/dAYYfyfB7HgN
        oDcmlqbwZLoqA/B1PXdzhnqDtoV3rjU+USFMX8+rUDe9U94yeZJojevoyFHswQ==
Date:   Tue, 2 May 2023 11:10:43 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 3/5] dt-bindings: net: phy: add
 timestamp preferred choice property
Message-ID: <20230502111043.2e8d48c9@kmaincent-XPS-13-7390>
In-Reply-To: <20230429174217.rawjgcxuyqs4agcf@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
        <20230406173308.401924-4-kory.maincent@bootlin.com>
        <20230412131421.3xeeahzp6dj46jit@skbuf>
        <20230412154446.23bf09cf@kmaincent-XPS-13-7390>
        <20230429174217.rawjgcxuyqs4agcf@skbuf>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
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

On Sat, 29 Apr 2023 20:42:17 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Wed, Apr 12, 2023 at 03:44:46PM +0200, K=C3=B6ry Maincent wrote:
> > On Wed, 12 Apr 2023 16:14:21 +0300 Vladimir Oltean
> > <vladimir.oltean@nxp.com> wrote: =20
> > > Do we need this device tree functionality? =20
> >=20
> > I would say so. Expected as I wrote the patch. ;)
> >=20
> > My point was that the new behavior to MAC as default timestamping does =
not
> > fit all the case, especially when a board is designed with PHY like the=
 TI
> > PHYTER which is a far better timestamping choice (according to Richard).
> > The user doesn't need to know this, he wants to have the better time st=
amp
> > selected by default without any investigation. That's why having device=
tree
> > property for that could be useful. =20
>=20
> The TI PHYTER is the "NatSemi DP83640" entry in the whitelist for PHYs
> that still use their timestamping by default. Can you please come up
> with an example which is actually useful?

If a future PHY, featured like this TI PHYTER, is supported in the future t=
he
default timestamp will be the MAC and we won't be able to select the PHY by
default.
Another example is my case with the 88E151x PHY, on the Russell side with t=
he
Macchiatobin board, the MAC is more precise, and in my side with a custom b=
oard
with macb MAC, the PHY is more precise. Be able to select the prefer one fr=
om
devicetree is convenient.
