Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C044E2DEA27
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 21:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgLRUY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 15:24:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgLRUY5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 15:24:57 -0500
Date:   Fri, 18 Dec 2020 12:24:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608323056;
        bh=XkZYkmu+hqkJiE4AYPKfnmPTnlc8YTQQFzYuoyFeYF0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mi0yhMuhGjodh5NPaJIzk9obRSG/pV6V7GLFHKXWb6ewITwXW5onlofK77xwLuhs5
         SCMGv/M83ONWU/bIjUDCiR5YqybIYkqhO0orXSkjR3om50R53rt9hUKK921eyorl2V
         JqkXGWdL7NqHl96w6EPHQO2+TgUQhWwsUREE5o3f451/BvJX+XzlO9UwB/Z31W/ynR
         E27aHhpmsclG+XOT9rRiZvB4zvZOs1NzKaDRWRkWKlNSoa/z11cAgUntHPmV/ecvay
         PqgRrbsPfMSgczT/9GgMZCrg1QKBduwTTrJqqaxHUldo6AuvrQKtgbkLfAxX//7K15
         3ev5Pb8Ijbm9A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jingoo Han <jingoohan1@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix JSON pointers
Message-ID: <20201218122415.7a7bdfe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201217223429.354283-1-robh@kernel.org>
References: <20201217223429.354283-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 16:34:29 -0600 Rob Herring wrote:
> The correct syntax for JSON pointers begins with a '/' after the '#'.
> Without a '/', the string should be interpretted as a subschema
> identifier. The jsonschema module currently doesn't handle subschema
> identifiers and incorrectly allows JSON pointers to begin without a '/'.
> Let's fix this before it becomes a problem when jsonschema module is
> fixed.
> 
> Converted with:
> perl -p -i -e 's/yaml#definitions/yaml#\/definitions/g' `find Documentation/devicetree/bindings/ -name "*.yaml"`
> 
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Jingoo Han <jingoohan1@gmail.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>

Acked-by: Jakub Kicinski <kuba@kernel.org>
