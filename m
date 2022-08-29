Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7E05A5470
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 21:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiH2TWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 15:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiH2TWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 15:22:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E80286FD4;
        Mon, 29 Aug 2022 12:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3JNnvuwrEkVTJa7wTN0QJma+aZxZi0N5LLqlrDgzl80=; b=I71lx5CyiY45IE39TN907QMDEi
        f19u1IiOe5lWTWYgUQU7/J35G0GXSfmuMRcbN7Lg7aw2Lrex+uomFYvt/atQUhB5TOjyMgf+bGbr7
        j/u3DTU/BYeUmaf5xUxagmOM7ihBbF6dDr6+jLMIMlCTUZqnXNFw2dUQROXdKTHAyVIw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oSkL1-00EztZ-0H; Mon, 29 Aug 2022 21:22:23 +0200
Date:   Mon, 29 Aug 2022 21:22:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 2/2] net: dsa: LAN9303: Add basic support for LAN9354
Message-ID: <Yw0R7u1qV9tLSCnu@lunn.ch>
References: <20220829180037.31078-1-jerry.ray@microchip.com>
 <20220829180037.31078-2-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829180037.31078-2-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static const struct of_device_id lan9303_mdio_of_match[] = {
>  	{ .compatible = "smsc,lan9303-mdio" },
> +	{ .compatible = "microchip,lan9354-mdio" },
>  	{ /* sentinel */ },

Please add this compatible to
Documentation/devicetree/bindings/net/dsa/lan9303.txt. Better still,
please convert it to YAML.

       Andrew
