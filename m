Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7DE4BECCC
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbiBUVxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:53:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiBUVxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:53:01 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F08622BD3;
        Mon, 21 Feb 2022 13:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RTi6LH7ru8wXWXIcwXIKmvFznUB5QZjmZSaLCHDFKXI=; b=lPeEODzSNa7Id/B/Ga35RJtUVA
        qY8KmZc1rQO4mBxy8m1bJLjsqHt0c0Lg8Vtql3smYmmQ2ys5AnvLRoNqaW8BH4R+ORr3OSHWY4ppe
        lqwpKH6ekkP4ocm05cvu8/WdXa/eUyk9JMxi72xe+mmpwX9kvAaKy2gv1HMnY0k82OZM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nMGbX-007R6S-5r; Mon, 21 Feb 2022 22:52:23 +0100
Date:   Mon, 21 Feb 2022 22:52:23 +0100
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
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] dt-bindings: net: dsa: add new mdio property
Message-ID: <YhQJlyfdM8KQZE/P@lunn.ch>
References: <20220221200102.6290-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221200102.6290-1-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 05:01:02PM -0300, Luiz Angelo Daros de Luca wrote:
> The optional mdio property will be used by dsa switch to configure
> slave_mii_bus when the driver does not allocate it during setup.
> 
> Some drivers already offer/require a similar property but, in some
> cases, they rely on a compatible string to identify the mdio bus node.
> Each subdriver might decide to keep existing approach or migrate to this
> new common property.

Your threading of these two patches is broken. The usual way to do this is

git format-patch HEAD~2
git send-email *.patch

You will then get uniform subject lines and the two emails threaded
together.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
