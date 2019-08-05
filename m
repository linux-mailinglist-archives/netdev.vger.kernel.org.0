Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7255481F12
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbfHEO17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:27:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34256 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbfHEO17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 10:27:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qPMjMdQW0XPhvwML3+DIpeMAETcO8BXuYgnocqdsrVI=; b=pERkNKNVe+73uwFMh3mKrh9ptl
        H1zv8D9bXN5ObQC75U0r5UHGphJNSp1OhEe57CRr39ydCEmwIUvG3vaYr1lK5Q0MuNq6T8FC83Q/w
        8k8Z+TNFpzidX6kn1dL+3RdKQfAJlDjOuyxNWWnYupocjo4mIQc8mces5VzKMun30vEU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hudxq-0007Tz-Ov; Mon, 05 Aug 2019 16:27:54 +0200
Date:   Mon, 5 Aug 2019 16:27:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH 16/16] dt-bindings: net: add bindings for ADIN PHY driver
Message-ID: <20190805142754.GL24275@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-17-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805165453.3989-17-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 07:54:53PM +0300, Alexandru Ardelean wrote:
> This change adds bindings for the Analog Devices ADIN PHY driver, detailing
> all the properties implemented by the driver.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  .../devicetree/bindings/net/adi,adin.yaml     | 93 +++++++++++++++++++
>  MAINTAINERS                                   |  2 +
>  include/dt-bindings/net/adin.h                | 26 ++++++
>  3 files changed, 121 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/adi,adin.yaml
>  create mode 100644 include/dt-bindings/net/adin.h
> 
> diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
> new file mode 100644
> index 000000000000..fcf884bb86f7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
> @@ -0,0 +1,93 @@
> +# SPDX-License-Identifier: GPL-2.0+
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/adi,adin.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Analog Devices ADIN1200/ADIN1300 PHY
> +
> +maintainers:
> +  - Alexandru Ardelean <alexandru.ardelean@analog.com>
> +
> +description: |
> +  Bindings for Analog Devices Industrial Ethernet PHYs
> +
> +properties:
> +  compatible:
> +    description: |
> +      Compatible list, may contain "ethernet-phy-ieee802.3-c45" in which case
> +      Clause 45 will be used to access device management registers. If
> +      unspecified, Clause 22 will be used. Use this only when MDIO supports
> +      Clause 45 access, but there is no other way to determine this.
> +    enum:
> +      - ethernet-phy-ieee802.3-c45

It is valid to list ethernet-phy-ieee802.3-c22, it is just not
required. So maybe you should list it here to keep the DT validater happy?

	  Andrew
