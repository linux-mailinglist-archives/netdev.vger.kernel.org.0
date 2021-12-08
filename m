Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F3E46DC59
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbhLHThD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:37:03 -0500
Received: from mail-oi1-f174.google.com ([209.85.167.174]:45925 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239624AbhLHTg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:36:57 -0500
Received: by mail-oi1-f174.google.com with SMTP id 7so5419591oip.12;
        Wed, 08 Dec 2021 11:33:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gEr7R7LXCR74CnNVPji4NeZtbokuYpc7aLJyE/t7JUE=;
        b=Sihy26lWIBM3Ch1QcNfSPGW0eGVs229TXJqesLzbInZx2jS1p/dsRpBN5VpsVRyo5N
         VokSQZI8BXeJX9Ae0E2idDpa5STmi6TYRibQFOnjZO1y742q21HxRfCrJaMvJealFX6Z
         Hxbmjp2/lEmQhd/ffUuKKrIzZEB+V6KZrpa/jTxh+8rVHdQn70MKseNUwn8dJJelmciJ
         zIQsv9lJTG8A0oCQ2DPi6vyVqwawuhUv6UEpc3P6yK8gpON1+WDWDhXDPYHyfOOHnWOq
         pZqZjeFFau83mH/8qNoy9HvpiYCdGBKVF1PwLOauZzS9LnPZjgFN5Y4D3yMLajgBiuyA
         b+mA==
X-Gm-Message-State: AOAM533fFGBUMxs0omxFdni3HrJBdbIa4Mn2tTiHXisVzUT6ftEmuzkx
        X1xAK0t+cJxq8+N08p7Z+w==
X-Google-Smtp-Source: ABdhPJyeAyWxo9NKTy8y/nPZqMar6/k2i8dk3QurnUQY2Bp7EVojfeoc1ke0WPcKclsD7zxFzVY7dw==
X-Received: by 2002:aca:2115:: with SMTP id 21mr1368511oiz.25.1638992004407;
        Wed, 08 Dec 2021 11:33:24 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id y12sm936202oiv.49.2021.12.08.11.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:33:23 -0800 (PST)
Received: (nullmailer pid 199354 invoked by uid 1000);
        Wed, 08 Dec 2021 19:33:22 -0000
Date:   Wed, 8 Dec 2021 13:33:22 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com,
        Doug Berger <opendmb@gmail.com>, Vinod Koul <vkoul@kernel.org>,
        netdev@vger.kernel.org, linux-phy@lists.infradead.org,
        Ray Jui <rjui@broadcom.com>, linux-kernel@vger.kernel.org,
        Scott Branden <sbranden@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 4/8] dt-bindings: net: Convert GENET binding to YAML
Message-ID: <YbEIgtfBXJoiWOdV@robh.at.kernel.org>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
 <20211206180049.2086907-5-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206180049.2086907-5-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 06 Dec 2021 10:00:45 -0800, Florian Fainelli wrote:
> Convert the GENET binding to YAML, leveraging brcm,unimac-mdio.yaml and
> the standard ethernet-controller.yaml files.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../devicetree/bindings/net/brcm,bcmgenet.txt | 125 ---------------
>  .../bindings/net/brcm,bcmgenet.yaml           | 145 ++++++++++++++++++
>  MAINTAINERS                                   |   2 +-
>  3 files changed, 146 insertions(+), 126 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
> 

Applied, thanks!
