Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07A9222E6E
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 00:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgGPWJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 18:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbgGPWJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 18:09:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DA8420853;
        Thu, 16 Jul 2020 22:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594937368;
        bh=n04WlQh2KrQ2rgHTRtdKBZH8KEwlrcLQlq3ED7K3LMk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wPdJ8JHXePyNrzqg2JLYyWBVT3UqOn7zAiWgefK9thDfzA0he1IzLu7565joxYL5X
         CQkYXp8iwsn3enreTjX72DVTiSZ2Feen5pNKHTfDzBbw00ZLvWUOp6PGikD0+h2YBs
         LNvGB2sIQdLn1cWYJS9Mo8tigD0rtM+toCNyj98E=
Date:   Thu, 16 Jul 2020 15:09:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthew Hagan <mnhagan88@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Jonathan McDowell <noodles@earth.li>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL
 properties
Message-ID: <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
        <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 21:50:26 +0100 Matthew Hagan wrote:
> Add names and decriptions of additional PORT0_PAD_CTRL properties.
> 
> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> index ccbc6d89325d..3d34c4f2e891 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> @@ -13,6 +13,14 @@ Optional properties:
>  
>  - reset-gpios: GPIO to be used to reset the whole device
>  
> +Optional MAC configuration properties:
> +
> +- qca,exchange-mac0-mac6:	If present, internally swaps MAC0 and MAC6.

Perhaps we can say a little more here?

> +- qca,sgmii-rxclk-falling-edge:	If present, sets receive clock phase to
> +				falling edge.
> +- qca,sgmii-txclk-falling-edge:	If present, sets transmit clock phase to
> +				falling edge.

These are not something that other vendors may implement and therefore
something we may want to make generic? Andrew?

>  Subnodes:
>  
>  The integrated switch subnode should be specified according to the binding

