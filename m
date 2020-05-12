Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CB41CF7DE
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgELOvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:51:39 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33440 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgELOvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:51:38 -0400
Received: by mail-ot1-f65.google.com with SMTP id v17so2745633ote.0;
        Tue, 12 May 2020 07:51:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+FFTVIdRJUiPRt6W0nlVnf55I2F6cDb0ZOrP06HUV2I=;
        b=tKovEz3DxG9ZgSouJTl6iqlKH5+evgwUcnmtSviz6RcWzyu6lfe8fCdjJ8xadADx0Y
         ysXbzLZXaMEf4uZx5BT+cgxdQ0Iy4z9+LQphU3f5b6F+YVlcHS99lA/lAhJSZgbdszsW
         McN7lm+60bCCnQKSbaqDeHtwc25iDqoaMeeIQ8MrL0Sb2ngiKqDoXZdeBxX/t2upcQVI
         61oBV41y0mo4GIU8yueJw1jbwJaLHLV+886FCekX7W7tFoe3kLOvquQbFG5mPq4xAlOb
         ZQimvd3b+1nm6EEn4HF1A7CZ4virRb3fokwe6UTkQswHr+Jse5AkpKq1bUBQE40oa7t7
         eVVw==
X-Gm-Message-State: AGi0PuZ7XyVtw0F4naHAy1hUUeEw/0x2jJ1TjT51M6QgwqQAkUQCTZf6
        NCJJGncEsApKJlHo9pIimUO7LMF+dA==
X-Google-Smtp-Source: APiQypIMtahsMEYjmV8Fru5Ib4Vy3CKGcEFvaBi79VV4D8sXUnBPZwpbYCnBV8pQAm5P8MdHfaaPBA==
X-Received: by 2002:a9d:2605:: with SMTP id a5mr16527573otb.259.1589295097601;
        Tue, 12 May 2020 07:51:37 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id d64sm296494oig.53.2020.05.12.07.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 07:51:36 -0700 (PDT)
Received: (nullmailer pid 21890 invoked by uid 1000);
        Tue, 12 May 2020 14:51:35 -0000
Date:   Tue, 12 May 2020 09:51:35 -0500
From:   Rob Herring <robh@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC v2 01/11] dt-bindings: net: meson-dwmac: Add the
 amlogic,rx-delay-ns property
Message-ID: <20200512145135.GA16551@bogus>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
 <20200429201644.1144546-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429201644.1144546-2-martin.blumenstingl@googlemail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 10:16:34PM +0200, Martin Blumenstingl wrote:
> The PRG_ETHERNET registers on Meson8b and newer SoCs can add an RX
> delay. Add a property with the known supported values so it can be
> configured according to the board layout.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  .../bindings/net/amlogic,meson-dwmac.yaml           | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
> index ae91aa9d8616..8d851f59d9f2 100644
> --- a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
> @@ -67,6 +67,19 @@ allOf:
>              PHY and MAC are adding a delay).
>              Any configuration is ignored when the phy-mode is set to "rmii".
>  
> +        amlogic,rx-delay-ns:
> +          $ref: /schemas/types.yaml#definitions/uint32

Don't need to define the type when in standard units.

> +          enum:
> +            - 0
> +            - 2
> +          description:
> +            The internal RGMII RX clock delay (provided by this IP block) in
> +            nanoseconds. When phy-mode is set to "rgmii" then the RX delay
> +            should be explicitly configured. When not configured a fallback of
> +            0ns is used. When the phy-mode is set to either "rgmii-id" or

'default: 0' expresses this.

> +            "rgmii-rxid" the RX clock delay is already provided by the PHY.
> +            Any configuration is ignored when the phy-mode is set to "rmii".
> +
>  properties:
>    compatible:
>      additionalItems: true
> -- 
> 2.26.2
> 
