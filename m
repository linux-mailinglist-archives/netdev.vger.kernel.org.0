Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144FA2DDEE0
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 08:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732915AbgLRHLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 02:11:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgLRHLj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 02:11:39 -0500
Date:   Fri, 18 Dec 2020 12:40:54 +0530
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608275459;
        bh=6YeZzN3KmE++VpIfogg173kMKgVjRsWI8P+AiUlw2QY=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=WsCg0hJL3D1lSK62EPjwfPee6qkg1MEOA6f6AM98JtHDFbdg6CqmKI+l2IJcX7EcY
         hiQi1wY1Nsx9G7kTfCw9KXMyrliT8sfqsa0D/MxyRzcs8l4S1reR28ghFM1irRE0on
         cwZjYItI2E/qFXze0h+mbYUzjU7lagvgBA/8uAFJ41UZWFSR0HHkpsqzcoI/g7q//L
         tku3ee0HrsJrcMZiHSK1krf8vwWdybOhFjIleqPPoyhdlPo27dltZpCOvkAsAK3bzw
         h1EexmFE12d+BqXJ2pLBU3ID1bmI6sAbL/wQMS73LlyoD0hbHheDVUh8PA+8A4hV83
         WE+RqBJne2dMg==
From:   Vinod Koul <vkoul@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jingoo Han <jingoohan1@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix JSON pointers
Message-ID: <20201218071054.GH8403@vkoul-mobl>
References: <20201217223429.354283-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217223429.354283-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17-12-20, 16:34, Rob Herring wrote:
> The correct syntax for JSON pointers begins with a '/' after the '#'.
> Without a '/', the string should be interpretted as a subschema
> identifier. The jsonschema module currently doesn't handle subschema
> identifiers and incorrectly allows JSON pointers to begin without a '/'.
> Let's fix this before it becomes a problem when jsonschema module is
> fixed.
> 
> Converted with:
> perl -p -i -e 's/yaml#definitions/yaml#\/definitions/g' `find Documentation/devicetree/bindings/ -name "*.yaml"`

>  .../devicetree/bindings/dma/dma-common.yaml   |  4 +-
>  .../devicetree/bindings/dma/dma-router.yaml   |  2 +-
>  .../devicetree/bindings/dma/ingenic,dma.yaml  |  2 +-
>  .../bindings/dma/snps,dma-spear1340.yaml      | 10 ++---

Acked-By: Vinod Koul <vkoul@kernel.org>

-- 
~Vinod
