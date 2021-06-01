Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5E9397D30
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 01:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbhFAXuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 19:50:39 -0400
Received: from mail-oo1-f48.google.com ([209.85.161.48]:35469 "EHLO
        mail-oo1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbhFAXuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 19:50:39 -0400
Received: by mail-oo1-f48.google.com with SMTP id s20-20020a4ae9940000b02902072d5df239so181237ood.2;
        Tue, 01 Jun 2021 16:48:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Nhdv9yyqyc2cM0eNSgIXuxGtoBf6kf7h8vLahsndfwg=;
        b=HzjX5jLYMa9FbFk6pgy2MCUOxxeT83LFn7/Wi1cxa8AwPxoclMxdWXfVDAic3yoXWW
         HyrgFWMmfD0o3kGAgRbu/TJxwDqCkG0KVYQqLP0z8iRDFrGW/2kasGt2oo8rQJtkeyFk
         dCBuOhXn+nh35B6/LUx7xJELf3Cb0Y/7rJOH1uv9B2zgYQWs8X8JA2TCEjjjx4aDUPBe
         u8quxuWVNREZRWJ6kVeb7SyI7mP2OYtwZkZ8OvF6T7BXYSaqoX02gzc0B8FIor2GXTVO
         pvTyUbqJZ5ZxcepP5sXTUNZ0ZCWQQiTAXlD7Htt76oil3mMF/HMAyVhSwUduCwU7ZXK6
         uP/g==
X-Gm-Message-State: AOAM530R0sipCLmSj1tktlttv1TrSzSyK7s0SJu+uqoyHte268amQyhl
        8ZqhfE4cL0NzDbP6BDs6wtouucUIgA==
X-Google-Smtp-Source: ABdhPJx4PNWKe0l7HiCEH+vmXOGx0pj/2w264qi2I0z4IZTf+VOPET+t7I0bPZLOE5Pj4rkPfS1xuw==
X-Received: by 2002:a4a:d41a:: with SMTP id n26mr22943551oos.66.1622591336821;
        Tue, 01 Jun 2021 16:48:56 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id f8sm3672922oos.33.2021.06.01.16.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 16:48:56 -0700 (PDT)
Received: (nullmailer pid 1357101 invoked by uid 1000);
        Tue, 01 Jun 2021 23:48:55 -0000
Date:   Tue, 1 Jun 2021 18:48:55 -0500
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Scott Branden <sbranden@broadcom.com>,
        linux-arm-kernel@lists.infradead.org, Ray Jui <rjui@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2] dt-bindings: net: Convert MDIO mux bindings to DT
 schema
Message-ID: <20210601234855.GA1357013@robh.at.kernel.org>
References: <20210526181411.2888516-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526181411.2888516-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021 13:14:11 -0500, Rob Herring wrote:
> Convert the common MDIO mux bindings to DT schema.
> 
> Drop the example from mdio-mux.yaml as mdio-mux-gpio.yaml has the same one.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Ray Jui <rjui@broadcom.com>
> Cc: Scott Branden <sbranden@broadcom.com>
> Cc: bcm-kernel-feedback-list@broadcom.com
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> v2:
>  - Fix copy-n-paste error: s/I2C/MDIO/
> ---
>  .../bindings/net/brcm,mdio-mux-iproc.txt      |   2 +-
>  .../devicetree/bindings/net/mdio-mux-gpio.txt | 119 ---------------
>  .../bindings/net/mdio-mux-gpio.yaml           | 135 ++++++++++++++++++
>  .../bindings/net/mdio-mux-mmioreg.txt         |  75 ----------
>  .../bindings/net/mdio-mux-mmioreg.yaml        |  78 ++++++++++
>  .../bindings/net/mdio-mux-multiplexer.txt     |  82 -----------
>  .../bindings/net/mdio-mux-multiplexer.yaml    |  82 +++++++++++
>  .../devicetree/bindings/net/mdio-mux.txt      | 129 -----------------
>  .../devicetree/bindings/net/mdio-mux.yaml     |  44 ++++++
>  9 files changed, 340 insertions(+), 406 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/mdio-mux-gpio.txt
>  create mode 100644 Documentation/devicetree/bindings/net/mdio-mux-gpio.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/mdio-mux-mmioreg.txt
>  create mode 100644 Documentation/devicetree/bindings/net/mdio-mux-mmioreg.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/mdio-mux-multiplexer.txt
>  create mode 100644 Documentation/devicetree/bindings/net/mdio-mux-multiplexer.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/mdio-mux.txt
>  create mode 100644 Documentation/devicetree/bindings/net/mdio-mux.yaml
> 

Applied, thanks!
