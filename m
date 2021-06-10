Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340323A23AE
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 07:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhFJFDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 01:03:44 -0400
Received: from bmailout2.hostsharing.net ([83.223.78.240]:38497 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhFJFDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 01:03:43 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id C111B2800B4B4;
        Thu, 10 Jun 2021 07:01:46 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id AE6FD19C92; Thu, 10 Jun 2021 07:01:46 +0200 (CEST)
Date:   Thu, 10 Jun 2021 07:01:46 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>, Rob Herring <robh@kernel.org>,
        kernel@dh-electronics.com, netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: ks8851: Convert to YAML schema
Message-ID: <20210610050146.GA26722@wunner.de>
References: <20210610002748.134140-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610002748.134140-1-marex@denx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 02:27:48AM +0200, Marek Vasut wrote:
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/micrel,ks8851.yaml
> @@ -0,0 +1,94 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/micrel,ks8851.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Micrel KS8851 Ethernet MAC (MLL)

(SPI or MLL)
