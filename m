Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C526368357
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237716AbhDVPbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:31:37 -0400
Received: from mail-oo1-f46.google.com ([209.85.161.46]:41730 "EHLO
        mail-oo1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbhDVPbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 11:31:36 -0400
Received: by mail-oo1-f46.google.com with SMTP id d16-20020a4a3c100000b02901f0590a614eso2227443ooa.8;
        Thu, 22 Apr 2021 08:31:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=HTlnkyJ2bx5zva7MZ1v2kYWtL16cGGPmEHiXhdTzOHU=;
        b=EzEwUI9DTgrtUEQoSY/ckO7miu6TK/4GpdX7I7IimXkPohTTXOqvS4be3LEvlkQe/V
         nqGbnQ21fQP/SEGR0aEVqGK16uWBYHeKd+mHimf2BcMlC2ha64aI2RlZaYAAR16XqH85
         RjzS0cd82EltzB/TnEeG1pjG/oHLUxNljlAXKRFwIl3GB0QOLveXQ7tliYl2ERjDCp5y
         AVhio6OO66KWvFcSAgpZr+7IsDu8yS71jwcPLGoANL6rxX4Xdcek3s90BhY+1owI19DI
         B7Anx7Jy8tqSLRshjYsxS+OsHPv84cK+06d+tUL7opLCJSkyZe4ztNJ49UOQRO8Fk+2D
         siog==
X-Gm-Message-State: AOAM530qWSSAPG8UaFpwXv0ygJooKWlAbRX5qybpS7r8TJlapiE+4P/k
        gqC1owLV6hiiWv/GiKTZDA==
X-Google-Smtp-Source: ABdhPJwqakckRYJVHwoIhYL2B1/ENLYjf63BtHWsSTRO8L+AxUf+NmRdpEGbtri7jdAiD6oKA1/hOQ==
X-Received: by 2002:a4a:e08c:: with SMTP id w12mr2847550oos.48.1619105459963;
        Thu, 22 Apr 2021 08:30:59 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id g26sm696687otr.73.2021.04.22.08.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 08:30:58 -0700 (PDT)
Received: (nullmailer pid 3134281 invoked by uid 1000);
        Thu, 22 Apr 2021 15:30:57 -0000
From:   Rob Herring <robh@kernel.org>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     davem@davemloft.net, devicetree@vger.kernel.org,
        vivien.didelot@gmail.com, olteanv@gmail.com, linux@armlinux.org.uk,
        robh+dt@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch
In-Reply-To: <20210422094257.1641396-2-prasanna.vengateshan@microchip.com>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com> <20210422094257.1641396-2-prasanna.vengateshan@microchip.com>
Subject: Re: [PATCH v2 net-next 1/9] dt-bindings: net: dsa: dt bindings for microchip lan937x
Date:   Thu, 22 Apr 2021 10:30:57 -0500
Message-Id: <1619105457.718289.3134280.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Apr 2021 15:12:49 +0530, Prasanna Vengateshan wrote:
> Documentation in .yaml format and updates to the MAINTAINERS
> Also 'make dt_binding_check' is passed
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
>  .../bindings/net/dsa/microchip,lan937x.yaml   | 142 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  2 files changed, 143 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Documentation/devicetree/bindings/net/dsa/microchip,lan937x.example.dt.yaml:0:0: /example-0/spi/switch@0/mdio: failed to match any schema with compatible: ['microchip,lan937x-mdio']

See https://patchwork.ozlabs.org/patch/1469135

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

