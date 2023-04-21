Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E076EAB3B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 15:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjDUNHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 09:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjDUNHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 09:07:22 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5E39758;
        Fri, 21 Apr 2023 06:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aIxUgGvt5DkV8QmGmTQ/SB4Ktspy4zcEHcRXPG7T79Y=; b=eLZUR5mAPW6VsrGcfeYqAlYiDP
        xFb1gxiHU8BJkOx4jeyCXLQ2IYnSm9NTxTZtFyA0Gs3AB/7CuwfZ1U7CeUMN4QxPG2xVNKam189yd
        p4QFHUacCC4atRZkfnh9Ogu2RvQS8huh0SW2jEgNW9kQFFT8hejqKwOCe1GwP5bbvYpU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ppqAD-00AsrA-6n; Fri, 21 Apr 2023 14:46:57 +0200
Date:   Fri, 21 Apr 2023 14:46:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: qca8k: fix LEDS_CLASS dependency
Message-ID: <b632b856-c9f9-455c-8e5c-147431b1e7c8@lunn.ch>
References: <20230420213639.2243388-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420213639.2243388-1-arnd@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 11:36:31PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> With LEDS_CLASS=m, a built-in qca8k driver fails to link:
> 
> arm-linux-gnueabi-ld: drivers/net/dsa/qca/qca8k-leds.o: in function `qca8k_setup_led_ctrl':
> qca8k-leds.c:(.text+0x1ea): undefined reference to `devm_led_classdev_register_ext'
> 
> Change the dependency to avoid the broken configuration.
> 
> Fixes: 1e264f9d2918 ("net: dsa: qca8k: add LEDs basic support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
