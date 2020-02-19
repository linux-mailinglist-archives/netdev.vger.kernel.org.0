Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D26B2164F96
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 21:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgBSUJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 15:09:29 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44582 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbgBSUJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 15:09:28 -0500
Received: by mail-oi1-f196.google.com with SMTP id d62so25054763oia.11;
        Wed, 19 Feb 2020 12:09:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mbkzQqUjkxGy2kasJcyhjpJz1rKXG3oq8o4SsxcCO/g=;
        b=Qg5spdiBWw0OuUZQ7wWM0VlyQ1nJwIxu9GOBmx6CJYRwIuw+bQJUqHQ7p0JjJVnoh4
         axOKZqTbQyBIDWjTDLlqDjqYAscnXMnBK32d29/PyYLXF65otPErSiKfTNT7eEmiDDk1
         Rb0dHCK87ay/YEmqMxpLVhRAlQJoB3FZlcYRZFcDm3gmBLn6vSh+UCaM4QTECDP4eiEO
         STGqUK7yb+kikgeU1VUKQ5jiXa1hXRXYZNxnn5WYs9SRpUNcmf0dD7RdcSfgVIOfwZxp
         T8lXPWdljrST9pGzPyaEXIyboqQYoQ5l3p22EKMjXCzaIdMXYqa3Y4Xoqyj8QoNd4/DT
         vxgg==
X-Gm-Message-State: APjAAAVBScGJmwC8/J+vG/JP6pC7Mc5beff086DR30StKQcmii3rKnSW
        odI1WZ+L4WMwXLrOLMmX5g==
X-Google-Smtp-Source: APXvYqx7craa94cySPkeWut3Mcv/WirXtJmPA1s1cNBhvO13jw3nlv/Dh0x4LuMM8fFg3C9iZlRbRg==
X-Received: by 2002:a05:6808:a8e:: with SMTP id q14mr5549272oij.173.1582142967720;
        Wed, 19 Feb 2020 12:09:27 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 76sm258701otf.53.2020.02.19.12.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 12:09:27 -0800 (PST)
Received: (nullmailer pid 21822 invoked by uid 1000);
        Wed, 19 Feb 2020 20:09:26 -0000
Date:   Wed, 19 Feb 2020 14:09:26 -0600
From:   Rob Herring <robh@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Simon Horman <simon.horman@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v2] dt-bindings: net: mdio: remove compatible string from
 example
Message-ID: <20200219200926.GA21759@bogus>
References: <20200214194408.9308-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214194408.9308-1-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Feb 2020 21:44:08 +0200, Grygorii Strashko wrote:
> Remove vendor specific compatible string from example, otherwise DT YAML
> schemas validation may trigger warnings specific to TI ti,davinci_mdio
> and not to the generic MDIO example.
> 
> For example, the "bus_freq" is required for davinci_mdio, but not required for
> generic mdio example. As result following warning will be produced:
>  mdio.example.dt.yaml: mdio@5c030000: 'bus_freq' is a required property
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
> Remove compatible string from example instead of changing it.
> 
> v1: https://patchwork.ozlabs.org/patch/1201674/
> 
>  Documentation/devicetree/bindings/net/mdio.yaml | 1 -
>  1 file changed, 1 deletion(-)
> 

Applied, thanks.

Rob
