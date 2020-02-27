Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363971724AA
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgB0RJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:09:01 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40217 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729161AbgB0RJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 12:09:01 -0500
Received: by mail-ot1-f65.google.com with SMTP id a36so902262otb.7;
        Thu, 27 Feb 2020 09:09:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y+0/0aor8IhFX16F066JPY12exQAeoxh6RZ1OqotWEI=;
        b=TpgYPngQ2zi37zysh4SMLVYaayCui650BPbtfTwxdX3WYlK+2fRYW8CK3yeQiGch79
         MNJxGFa+AeJ7o+ac1VjR51e+JQ770gaZuxzK4X2txL5G5UJqddk/MYuvuLjb4nI8KIyh
         iUTOZacuULee5WA2y/ZvyAdJ0sk3b50w/agbY89i92wF2RvYuK1mcsqwDfefBrJjfCQs
         8ydY+GPmXBcY2ioKEgMYRqGK9fA+atBfmSLjHx5B/iOUhpPCV15mofu0QdcYruxN7GhJ
         09BdiK3FA3h5XWziECbMcjC/NGzTo8josWgkNwE0FT0TyY7vFNMRA3hLdMBIc6zbm30p
         curA==
X-Gm-Message-State: APjAAAVbbXay91MqRnoQJJO1EomYC5m5yici7gcD9erx9rQXgFuifEVz
        c/z51hipw4Lv2Q+3BWijZw==
X-Google-Smtp-Source: APXvYqxvFuKzzQKZDM+4rDPxUw0rZLtDRf3b/DVCqBQR5c3BydSET3hGDKIjKiov4KkROKtFPX8tjA==
X-Received: by 2002:a05:6830:1492:: with SMTP id s18mr618063otq.216.1582823340333;
        Thu, 27 Feb 2020 09:09:00 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id f1sm2119638otq.4.2020.02.27.09.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 09:08:59 -0800 (PST)
Received: (nullmailer pid 3995 invoked by uid 1000);
        Thu, 27 Feb 2020 17:08:58 -0000
Date:   Thu, 27 Feb 2020 11:08:58 -0600
From:   Rob Herring <robh@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: add dt bindings for
 marvell10g  driver
Message-ID: <20200227170858.GA2831@bogus>
References: <20200227095159.GJ25745@shell.armlinux.org.uk>
 <E1j7FqO-0003sv-Ho@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j7FqO-0003sv-Ho@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Feb 2020 09:52:36 +0000, Russell King wrote:
> Add a DT bindings document for the Marvell 10G driver, which will
> augment the generic ethernet PHY binding by having LED mode
> configuration.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  .../devicetree/bindings/net/marvell,10g.yaml  | 31 +++++++++++++++++++
>  1 file changed, 31 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/marvell,10g.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

Documentation/devicetree/bindings/display/simple-framebuffer.example.dts:21.16-37.11: Warning (chosen_node_is_root): /example-0/chosen: chosen node must be at root node
Documentation/devicetree/bindings/net/marvell,10g.example.dts:18.13-23: Warning (reg_format): /example-0/ethernet-phy@0:reg: property has invalid length (4 bytes) (#address-cells == 1, #size-cells == 1)
Documentation/devicetree/bindings/net/marvell,10g.example.dt.yaml: Warning (pci_device_bus_num): Failed prerequisite 'reg_format'
Documentation/devicetree/bindings/net/marvell,10g.example.dt.yaml: Warning (i2c_bus_reg): Failed prerequisite 'reg_format'
Documentation/devicetree/bindings/net/marvell,10g.example.dt.yaml: Warning (spi_bus_reg): Failed prerequisite 'reg_format'

See https://patchwork.ozlabs.org/patch/1245687
Please check and re-submit.
