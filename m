Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B0A3EBC66
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 21:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhHMTFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 15:05:41 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:43971 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhHMTFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 15:05:38 -0400
Received: by mail-oi1-f174.google.com with SMTP id bf25so8539006oib.10;
        Fri, 13 Aug 2021 12:05:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UauQNiyQ5ZmWcAqT8b3gtv9YVrBnVk+e/I1e3FEyYIE=;
        b=QAb7HetyT3ocblozGmuMIs/foEqoZ5kH7i0eJZmcMJFxPBedaVOiMxHwgmIWS6fvOj
         5ZyMNPSLOIeektIxtjOPV0EmlPw1NeVYsoqLkjxgTUxZM9TY76sC8ZR6xvTBT7SRid5M
         8hCjccFQ6yl5MH1C98vMvu1IxHSCbQeKtObTbUEzz+sNYd22Yq8aCNMXAgFy+R/iYEDT
         hCxFbJhQ1o/CxHkMNUKDK5o2SgERgXon+Yfcdfe4lPCj1aNOWP9QJR8x38u1u8UgSCMg
         mvLjXCojaZ9TZG1E8+5VgAGxQpIf/LNgJgBnBPGq/+cK0WdEyIpRKEF55SJeUr5GQ8rJ
         Q+sw==
X-Gm-Message-State: AOAM531nxMF9eymGDT9ZZC1UpjZcUW3Q8z23EkqGbbeEDoVSd5EhtfBR
        5RhTmOo9oCguGBul1LzE3A==
X-Google-Smtp-Source: ABdhPJxgy2pWnu66VUs1L67X1WHhNnP1VZIxa2mY9sVG4cRH/2LzdAqBvKjXQywVNWeDkSRl4N7Jpw==
X-Received: by 2002:aca:5c0a:: with SMTP id q10mr3426899oib.11.1628881511015;
        Fri, 13 Aug 2021 12:05:11 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id b1sm511318ots.29.2021.08.13.12.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 12:05:10 -0700 (PDT)
Received: (nullmailer pid 3875845 invoked by uid 1000);
        Fri, 13 Aug 2021 19:05:09 -0000
Date:   Fri, 13 Aug 2021 14:05:09 -0500
From:   Rob Herring <robh@kernel.org>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v5] dt-bindings: net: can: c_can: convert to json-schema
Message-ID: <YRbCZWEatI5+GUdT@robh.at.kernel.org>
References: <20210805192750.9051-1-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805192750.9051-1-dariobin@libero.it>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 05 Aug 2021 21:27:50 +0200, Dario Binacchi wrote:
> Convert the Bosch C_CAN/D_CAN controller device tree binding
> documentation to json-schema.
> 
> Document missing properties.
> Remove "ti,hwmods" as it is no longer used in TI dts.
> Make "clocks" required as it is used in all dts.
> Update the examples.
> 
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
> 
> ---
> 
> Changes in v5:
>  - Complete 'interrupts' property description
> 
> Changes in v4:
>  - Fix 'syscon-raminit' property to pass checks.
>  - Drop 'status' property from CAN node of examples.
>  - Replace CAN node of examples (compatible = "bosch,d_can")  with a
>    recent version taken from socfpga.dtsi dts.
>  - Update the 'interrupts' property due to the examples updating.
>  - Add 'resets' property due to the examples updating.
> 
> Changes in v3:
>  - Add type (phandle-array) and size (maxItems: 2) to syscon-raminit
>    property.
> 
> Changes in v2:
>  - Drop Documentation references.
> 
>  .../bindings/net/can/bosch,c_can.yaml         | 119 ++++++++++++++++++
>  .../devicetree/bindings/net/can/c_can.txt     |  65 ----------
>  2 files changed, 119 insertions(+), 65 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/can/c_can.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
