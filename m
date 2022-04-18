Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C96506058
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 01:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235761AbiDRXvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 19:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiDRXvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 19:51:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42681EC4A;
        Mon, 18 Apr 2022 16:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cU38b+htry2/5Va9WZtGor+Tj8lXTP2Q4dGoj/BW5FQ=; b=Rx1l305mhFCkfpm0Y4enq9MhsW
        /M6APUzsPrKYTddGmD1NY40II+QlIQMglR8P2IzhWIDMVubnoGSjr2tp4774rV0L4P74TMkzVG0UK
        WSRkThRo2LrC//O0QSWqUTJBuyz/ariKgI1YfG7SdGSmehaegt9+gCnUDjFVsiXlSbP0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ngb6K-00GPO5-Gu; Tue, 19 Apr 2022 01:48:12 +0200
Date:   Tue, 19 Apr 2022 01:48:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org,
        alsi@bang-olufsen.dk, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzk+dt@kernel.org, arinc.unal@arinc9.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
Message-ID: <Yl34vNTYnp7HIE1c@lunn.ch>
References: <20220418233558.13541-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418233558.13541-1-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 18, 2022 at 08:35:57PM -0300, Luiz Angelo Daros de Luca wrote:
> Compatible strings are used to help the driver find the chip ID/version
> register for each chip family. After that, the driver can setup the
> switch accordingly. Keep only the first supported model for each family
> as a compatible string and reference other chip models in the
> description.
> 
> The removed compatible strings have never been used in a released kernel.
> 
> CC: devicetree@vger.kernel.org
> Link: https://lore.kernel.org/netdev/20220414014055.m4wbmr7tdz6hsa3m@bang-olufsen.dk/
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
