Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B5E6DAF54
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240857AbjDGPGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbjDGPF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:05:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A37BDE5;
        Fri,  7 Apr 2023 08:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8o3IMEyIEkFeqRjRnD7sW5LoKKolhAwIH5JPTIqWM9k=; b=M5moORhQStYLgIkMJWQUmHwGf6
        vZqfn+IEIKUSCeQ5atFFhIWJvUUdRIJmTNch5aH5AloYHpsK77IR741aG8g8jpCkj6GkbFUynr/aB
        8nCy1meZ9XmfQKXPzpZFZGjqzYSI4qO6xEzFqisEn4bLZDTMw25BWvNMpKsms4j0L0fg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pkndi-009jWF-Gs; Fri, 07 Apr 2023 17:04:34 +0200
Date:   Fri, 7 Apr 2023 17:04:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oss-drivers@corigine.com,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH 3/8] net: phy: aquantia: constify pointers to
 hwmon_channel_info
Message-ID: <2912454d-bdfa-49d6-9260-1bdf119da072@lunn.ch>
References: <20230407145911.79642-1-krzysztof.kozlowski@linaro.org>
 <20230407145911.79642-3-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407145911.79642-3-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 04:59:06PM +0200, Krzysztof Kozlowski wrote:
> Statically allocated array of pointed to hwmon_channel_info can be made
> const for safety.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

> This depends on hwmon core patch:
> https://lore.kernel.org/all/20230406203103.3011503-2-krzysztof.kozlowski@linaro.org/
> 
> Therefore I propose this should also go via hwmon tree.

Any merge conflicts should be easy to solve, so that seems reasonable.

    Andrew
