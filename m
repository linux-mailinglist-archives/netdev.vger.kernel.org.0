Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA0371449AD
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 03:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgAVCFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 21:05:25 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43622 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgAVCFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 21:05:25 -0500
Received: by mail-ot1-f67.google.com with SMTP id p8so4871052oth.10;
        Tue, 21 Jan 2020 18:05:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5KDHhB97+OZpmUZ0CpohOMTK6dCD2tSEOncivv/7Pgw=;
        b=rMZ8ifBZCC7FE/9t0VWrOMqucWkutK3wl805i/MprW6qPf4rbmxMOzrTlYh1N6nQsC
         /XH7qX3AEszhYJT5V6clhq9QxXlO9JknVYBMVeTdHOojnUmz+4NGW4/dDRqqqd54qujU
         MdXT6tLZ9lwDgW0XLMGWj7Bw6chXKqcY7I5vlgBKCjnmFyN9P8fKTEOZhTXsu63RJw6t
         UdBNXCpdMH6FMa2LeS1oVX+AQC69egaCo0wZk7lCkVkoqILKqcAOTz4EyDiITPdpr6Sm
         3xDqiHbHrFJVsEJwVFGJs70N+lOv8VBDYUUeZy6VnAFemHaamJr5DwGBrkDSbNvlpN/t
         oOuA==
X-Gm-Message-State: APjAAAWjHEMOkwFhC5UJWGAlf7Usu5oVaIpso3PZaMChQnm+8s8Lp1te
        agd6CI2vOccDVkhmoUk0Bw==
X-Google-Smtp-Source: APXvYqzkfbpLEJGKkcLHIHyxBnU94Fou1ccxpuM+pfV/pzRrIsQMB2bPSHSJROq5isXH9ct8XAs62w==
X-Received: by 2002:a9d:7a97:: with SMTP id l23mr6087185otn.34.1579658724729;
        Tue, 21 Jan 2020 18:05:24 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id n22sm14452502otj.36.2020.01.21.18.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 18:05:23 -0800 (PST)
Received: (nullmailer pid 29799 invoked by uid 1000);
        Wed, 22 Jan 2020 02:05:23 -0000
Date:   Tue, 21 Jan 2020 20:05:23 -0600
From:   Rob Herring <robh@kernel.org>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH 4/4] dt-bindings: net: adin: document 1588 TX/RX SOP
 bindings
Message-ID: <20200122020523.GA22232@bogus>
References: <20200116091454.16032-1-alexandru.ardelean@analog.com>
 <20200116091454.16032-5-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116091454.16032-5-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 11:14:54AM +0200, Alexandru Ardelean wrote:
> This change documents the device-tree bindings for the TX/RX indication of
> IEEE 1588 packets.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  .../devicetree/bindings/net/adi,adin.yaml     | 60 +++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
> index d95cc691a65f..eb56f35309e0 100644
> --- a/Documentation/devicetree/bindings/net/adi,adin.yaml
> +++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
> @@ -36,6 +36,60 @@ properties:
>      enum: [ 4, 8, 12, 16, 20, 24 ]
>      default: 8
>  
> +  adi,1588-rx-sop-delays-cycles:
> +    allOf:
> +      - $ref: /schemas/types.yaml#definitions/uint8-array
> +      - items:
> +          - minItems: 3
> +            maxItems: 3

You can split up the description into constraints something like this 
(and minItems/maxItems becomes implied):

items:
  - description: delay for 10BASE-T
  - description: delay for 100BASE-T
  - description: delay for 1000BASE-T

> +    description: |
> +      Enables Start Packet detection (SOP) for received IEEE 1588 time stamp
> +      controls, and configures the number of cycles (of the MII RX_CLK clock)
> +      to delay the indication of RX SOP frames for 10/100/1000 BASE-T links.
> +      The first element (in the array) configures the delay for 10BASE-T,
> +      the second for 100BASE-T, and the third for 1000BASE-T.
> +
> +  adi,1588-rx-sop-pin-name:
> +    description: |
> +      This option must be used in together with 'adi,1588-rx-sop-delays-cycles'
> +      to specify which physical pin should be used to signal the MAC that
> +      the PHY is currently processing an IEEE 1588 timestamp control packet.
> +      The driver will report an error if the value of this property is the
> +      same as 'adi,1588-tx-sop-pin-name'
> +    enum:
> +      - gp_clk
> +      - link_st
> +      - int_n
> +      - led_0
> +
> +  adi,1588-tx-sop-delays-ns:
> +    allOf:
> +      - $ref: /schemas/types.yaml#definitions/uint8-array
> +      - items:
> +          - minItems: 3
> +            maxItems: 3

This should be:

      - minItems: 3
        maxItems: 3
        items:
          multipleOf: 8

> +    description: |
> +      Enables Start Packet detection (SOP) for IEEE 1588 time stamp controls,
> +      and configures the number of nano-seconds to delay the indication of
> +      TX frames for 10/100/1000 BASE-T links.
> +      The first element (in the array) configures the delay for 10BASE-T,
> +      the second for 100BASE-T, and the third for 1000BASE-T.
> +      The delays must be multiples of 8 ns (i.e. 8, 16, 24, etc).
> +
> +  adi,1588-tx-sop-pin-name:
> +    description: |
> +      This option must be used in together with 'adi,1588-tx-sop-delays-ns'
> +      to specify which physical pin should be used to signal the MAC that
> +      the PHY is currently processing an IEEE 1588 timestamp control packet
> +      on the TX path.
> +      The driver will report an error if the value of this property is the
> +      same as 'adi,1588-rx-sop-pin-name'
> +    enum:
> +      - gp_clk
> +      - link_st
> +      - int_n
> +      - led_0
> +
>  examples:
>    - |
>      ethernet {
> @@ -62,5 +116,11 @@ examples:
>              reg = <1>;
>  
>              adi,fifo-depth-bits = <16>;
> +
> +            adi,1588-rx-sop-delays-cycles = [ 00 00 00 ];
> +            adi,1588-rx-sop-pin-name = "int_n";
> +
> +            adi,1588-tx-sop-delays-ns = [ 00 08 10 ];
> +            adi,1588-tx-sop-pin-name = "led_0";
>          };
>      };
> -- 
> 2.20.1
> 
