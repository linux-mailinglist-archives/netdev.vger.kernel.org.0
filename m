Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4169E7CB5E
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 20:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbfGaSBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 14:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbfGaSBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 14:01:12 -0400
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E74A216C8;
        Wed, 31 Jul 2019 18:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564596071;
        bh=8nOFSWZySTyugJad0IhgHzCcqRmA1DQddnc5vZfLDYQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IcLzpeJ++zT1SdS0YqxWYIhVWN/Np6xGXLCvPVp+qZEAwyVzAEfzWwNTCjCc+aaHe
         CXhmhBwiGSl0GrHglJzl85gRAaUrEdgMNFBm7VLNmotfl+5dExm7sddpL8W/1kAhQd
         oiWV2PBRcO9zD40ndRE3FX+3BDlpK1Dl0VDboG+w=
Received: by mail-qk1-f181.google.com with SMTP id m14so24221948qka.10;
        Wed, 31 Jul 2019 11:01:11 -0700 (PDT)
X-Gm-Message-State: APjAAAV10odF4Ae1dsQVAu8Wztu/8A19yTuxEsENIQv6Wux0wdNGN9a3
        LEdUuLUnpwfm1M8XCGGpQamnVpxJbALf6XUjDQ==
X-Google-Smtp-Source: APXvYqyh0H1hWwgJHkwCQ5+lJzOC3u4rhsBJaDX6WnQnTqxZqhR3SatK4t4orcp+Ov221H8C92iSLGnRywlqsL+eXQQ=
X-Received: by 2002:a37:a44a:: with SMTP id n71mr17139303qke.393.1564596070704;
 Wed, 31 Jul 2019 11:01:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190731053959.16293-1-andrew@aj.id.au> <20190731053959.16293-2-andrew@aj.id.au>
In-Reply-To: <20190731053959.16293-2-andrew@aj.id.au>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 31 Jul 2019 12:00:59 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLu2M7qnO08kHbgheNCN1+Lis0shrjfnphMbkSJKRs7=A@mail.gmail.com>
Message-ID: <CAL_JsqLu2M7qnO08kHbgheNCN1+Lis0shrjfnphMbkSJKRs7=A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/4] dt-bindings: net: Add aspeed,ast2600-mdio binding
To:     Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Joel Stanley <joel@jms.id.au>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        devicetree@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-aspeed@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 11:39 PM Andrew Jeffery <andrew@aj.id.au> wrote:
>
> The AST2600 splits out the MDIO bus controller from the MAC into its own
> IP block and rearranges the register layout. Add a new binding to
> describe the new hardware.
>
> Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
>
> ---
> v2:
> * aspeed: Utilise mdio.yaml
> * aspeed: Drop status from example
> ---
>  .../bindings/net/aspeed,ast2600-mdio.yaml     | 45 +++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml

Reviewed-by: Rob Herring <robh@kernel.org>
