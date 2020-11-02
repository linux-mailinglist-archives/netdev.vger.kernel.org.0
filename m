Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816282A3108
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgKBRMF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 Nov 2020 12:12:05 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35980 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbgKBRMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 12:12:05 -0500
Received: by mail-oi1-f196.google.com with SMTP id d9so9395314oib.3;
        Mon, 02 Nov 2020 09:12:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=eA1YHLSLEbKjVZd8ZPCYquKLICIoPYEsjcgwYwIXONM=;
        b=oGOtSZAPljOnzyKnWieVFzHNL2VnMXFStXtLw7gPc4/ZPxcilAsZCHGvVd9vA4p5zn
         F290/zgHeu09Gl+jZCL1qsjLWvkNxZKi26snR39lhFzl5EsgnWDUHbFip0zAxMExCLwN
         Kql0rHBYHeNwFi50A2Anrcw+Sjh5qKByVyEdrbT+EzrVss7wP7QfIMOlOh8uN6RptIMr
         ipIzqh8V3Lp5dDvtX8pK/rH3axYFEMnv3tlpvFoHw5sJJswhWVUmfFtVkCtxyiR6iiQb
         FJMH1bcpEHRNuvjSyKk0w2WkaXZk5WgjRvacbuZfhvz2/dS/45lCjtQMBDCNy7c9V6lt
         BsXQ==
X-Gm-Message-State: AOAM532SAAlZ2zvjkcwNWybWDFJfhYQ1GN9YXyHbsPY4OADiDJMy/t9x
        TWoHljNCOjRtrtfCM6mKEQ==
X-Google-Smtp-Source: ABdhPJwIP7A0eJV2FdnAxV4GkQDkNlw2WxhwivkI2jfqP/w6eBmV9pOv23Sc+uKXnoHc+lmzjesN3Q==
X-Received: by 2002:aca:a906:: with SMTP id s6mr1968252oie.59.1604337124008;
        Mon, 02 Nov 2020 09:12:04 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id j23sm3806127otk.56.2020.11.02.09.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 09:12:03 -0800 (PST)
Received: (nullmailer pid 4059886 invoked by uid 1000);
        Mon, 02 Nov 2020 17:12:02 -0000
Date:   Mon, 2 Nov 2020 11:12:02 -0600
From:   Rob Herring <robh@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     devicetree@vger.kernel.org, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v3 3/4] dt-bindings: dp83td510: Add binding for
 DP83TD510 Ethernet PHY
Message-ID: <20201102171202.GA4059031@bogus>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-4-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201030172950.12767-4-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 12:29:49 -0500, Dan Murphy wrote:
> The DP83TD510 is a 10M single twisted pair Ethernet PHY
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../devicetree/bindings/net/ti,dp83td510.yaml | 62 +++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,dp83td510.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,dp83td510.yaml: {'$id': 'http://devicetree.org/schemas/net/ti,dp83td510.yaml#', '$schema': 'http://devicetree.org/meta-schemas/core.yaml#', 'title': 'TI DP83TD510 ethernet PHY', 'allOf': [{'$ref': 'ethernet-controller.yaml#'}, {'$ref': 'ethernet-phy.yaml#'}], 'maintainers': ['Dan Murphy <dmurphy@ti.com>'], 'description': 'The PHY is an twisted pair 10Mbps Ethernet PHY that support MII, RMII and\nRGMII interfaces.\n\nSpecifications about the Ethernet PHY can be found at:\n  http://www.ti.com/lit/ds/symlink/dp83td510e.pdf\n', 'properties': {'reg': {'maxItems': 1}, 'tx-fifo-depth': {'description': 'Transmitt FIFO depth for RMII mode.  The PHY only exposes 4 nibble\ndepths. The valid nibble depths are 4, 5, 6 and 8.\n', 'enum': [4, 5, 6, 8], 'default': 5}, 'rx-internal-delay-ps': {'description': 'Setting this property to a non-zero number sets the RX internal delay\nfor the PHY.  The internal delay for the PHY is fixed to 30ns relative\nto receive data.\n'}, 'tx-internal-delay-ps': {'description': 'Setting this property to a non-zero number sets the TX internal delay\nfor the PHY.  The internal delay for the PHY has a range of -4 to 4ns\nrelative to transmit data.\n'}}, 'required': ['reg'], 'examples': ['mdio0 {\n  #address-cells = <1>;\n  #size-cells = <0>;\n  ethphy0: ethernet-phy@0 {\n    reg = <0>;\n    tx-rx-output-high;\n    tx-fifo-depth = <5>;\n    rx-internal-delay-ps = <1>;\n    tx-internal-delay-ps = <1>;\n  };\n};\n']} is not valid under any of the given schemas
{'oneOf': [{'required': ['unevaluatedProperties']},
           {'required': ['additionalProperties']}]} (Possible causes of the failure):
	/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,dp83td510.yaml: 'unevaluatedProperties' is a required property
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,dp83td510.yaml: ignoring, error in schema: 
warning: no schema found in file: ./Documentation/devicetree/bindings/net/ti,dp83td510.yaml


See https://patchwork.ozlabs.org/patch/1391184

The base for the patch is generally the last rc1. Any dependencies
should be noted.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

