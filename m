Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA974BF2F1
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 08:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiBVHwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 02:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiBVHwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 02:52:36 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68865E3C71;
        Mon, 21 Feb 2022 23:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MVLYW1as45dGdQ5HYH3qRKN7qZCZ0QShkvf+suOLN2I=; b=OAEd1EEjMtCLtrl9Ubv4B5Hh20
        KOqUBO5/LAFPQ62LGWlia8yUge2H70FbJp0jthQPCFi6PEtmFBBygx69IlocQr3YsgVPKYVXPdy4g
        8Shu8nF5AwxHfdpGsxUcohiGWCLxBfNHDRiKz577D97qy1j3QbJog039WOsZuG7+ggl4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nMPxe-007YYJ-TI; Tue, 22 Feb 2022 08:51:50 +0100
Date:   Tue, 22 Feb 2022 08:51:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] dt-bindings: net: dsa: add new mdio property
Message-ID: <YhSWFl/dQaGA9V70@lunn.ch>
References: <20220221200102.6290-1-luizluca@gmail.com>
 <YhQJlyfdM8KQZE/P@lunn.ch>
 <CAJq09z6dK20UDCM1P09A4KVGqjrHwPy0GTH3ogA27x7PTMtxtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z6dK20UDCM1P09A4KVGqjrHwPy0GTH3ogA27x7PTMtxtg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 09:08:05PM -0300, Luiz Angelo Daros de Luca wrote:
> > Your threading of these two patches is broken. The usual way to do this is
> >
> > git format-patch HEAD~2
> > git send-email *.patch
> >
> > You will then get uniform subject lines and the two emails threaded
> > together.
> 
> Thanks, Andrew, I did something like that. However, bindings and
> net-next have different requirements. One needs the mail to go to
> devicetree@vger.kernel.org and the other a different prefix. So, I
> used send-email twice. Or should I use net-next for both and send both
> also to devicetree@? I did forget to set the "In-Reply-To:" in the
> second message.

Binding need to be cc: to device tree, however they are generally
merged by some other subsystem, where ever the driver belongs. Rob
will review the binding, give his reviewed-by: and then Jakub or David
will merge both to net-next.

You can send both to device tree, or you can add a Cc: line to the
binding patch, before your own signed-off. git send-email will see it
and extend the list of recipients with whatever email address you put
there.

	Andrew
