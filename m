Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D3A1C1F47
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgEAVJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 17:09:47 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:36903 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAVJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 17:09:46 -0400
Received: by mail-ot1-f66.google.com with SMTP id z17so3639467oto.4;
        Fri, 01 May 2020 14:09:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=azaNq8gnek7T+A7rdK17PV/xQfKmjBVg34Ma1l/t8qw=;
        b=MJ3obAPF0yxWvXBcvhMFx2QBlijy/sSZWh3nuYjF5xbzSDNPvALMXSMlcvujd6ODVJ
         MaNyRiPrew1QsoSOo3GP8NZr9gHrBFH3Xvluis5OEnWDSQdCEg0T1tBdZQVrkSeC2yoQ
         iupfiS/1sVIpEYBWR/1n0U6bmtOXCdjK55xUJe5htQ3aAPzGuoYeuvFtdqs7NES+eYks
         vaK6a7SSajCGNISteF+DYqFAiIU8RWKbtAIFPiWJpNJG+RA2/VzfSW5Qe5gJ1f/+TBds
         +aCzvUYumgGbKCfcCcuh+t499f//UmNpnCmZfT2r/z3tRboNPz66i6lCli66d0oTLhcB
         +rTg==
X-Gm-Message-State: AGi0PubdifZrD3afr3L6k1YDeY6T82shRfyScZcwbKZSfWgt+4vTI7df
        57CRqcz7aAzGEzmmtphoZA==
X-Google-Smtp-Source: APiQypLECOBaRa68pLT9OXVtC6bUt86y91nQBnNKSvn0KMAG/61MoBxyIwqFEkO/eNcHjZD1+jP0MQ==
X-Received: by 2002:a05:6830:20d8:: with SMTP id z24mr5338741otq.74.1588367384402;
        Fri, 01 May 2020 14:09:44 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id h24sm1105171otj.25.2020.05.01.14.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 14:09:43 -0700 (PDT)
Received: (nullmailer pid 30822 invoked by uid 1000);
        Fri, 01 May 2020 21:09:42 -0000
Date:   Fri, 1 May 2020 16:09:42 -0500
From:   Rob Herring <robh@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: [PATCH RFC v2 02/11] dt-bindings: net: dwmac-meson: Document the
 "timing-adjustment" clock
Message-ID: <20200501210942.GA27082@bogus>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
 <20200429201644.1144546-3-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429201644.1144546-3-martin.blumenstingl@googlemail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Apr 2020 22:16:35 +0200, Martin Blumenstingl wrote:
> The PRG_ETHERNET registers can add an RX delay in RGMII mode. This
> requires an internal re-timing circuit whose input clock is called
> "timing adjustment clock". Document this clock input so the clock can be
> enabled as needed.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  .../devicetree/bindings/net/amlogic,meson-dwmac.yaml   | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 

My bot found errors running 'make dt_binding_check' on your patch:

/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.example.dt.yaml: ethernet@c9410000: clocks: Additional items are not allowed ([4294967295] was unexpected)
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.example.dt.yaml: ethernet@c9410000: clocks: [[4294967295], [4294967295], [4294967295], [4294967295]] is too long
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.example.dt.yaml: ethernet@c9410000: clocks: Additional items are not allowed ([4294967295] was unexpected)
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.example.dt.yaml: ethernet@c9410000: clocks: [[4294967295], [4294967295], [4294967295], [4294967295]] is too long

See https://patchwork.ozlabs.org/patch/1279646

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure dt-schema is up to date:

pip3 install git+https://github.com/devicetree-org/dt-schema.git@master --upgrade

Please check and re-submit.
