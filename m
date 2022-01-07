Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659574878EE
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 15:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239300AbiAGO1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 09:27:33 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:45046 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239226AbiAGO1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 09:27:33 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 207EQahw093477;
        Fri, 7 Jan 2022 08:26:36 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1641565596;
        bh=bbpnL2bqMN5H6aNKxgvIvY9vGPdi1O8RpGftvud1Gx8=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=OBKsSOCXPMflYsrV1dtvfOQBQCM+dt8F3FowNuexaOIHWQXksqzPVDy0tCsNmKU2B
         Cyo5sTcLNQCSGiL5++OUNoVs8GVUsnWwKJ7+dasTTs1eDbEXRaAXQ9VRVkgekvWx+v
         LsAhce0fL/LqhXDcbeLszNQkVccx71MkVTOsZPw8=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 207EQZXO115620
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 7 Jan 2022 08:26:35 -0600
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 7
 Jan 2022 08:26:35 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Fri, 7 Jan 2022 08:26:35 -0600
Received: from [10.249.36.164] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 207EQZKj097440;
        Fri, 7 Jan 2022 08:26:35 -0600
Subject: Re: [PATCH] dt-bindings: Drop required 'interrupt-parent'
To:     Rob Herring <robh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Michal Simek <michal.simek@xilinx.com>,
        - <patches@opensource.cirrus.com>,
        John Crispin <john@phrozen.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kumar Gogada <bharat.kumar.gogada@xilinx.com>
CC:     <linux-gpio@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <netdev@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        "Nagalla, Hari" <hnagalla@ti.com>
References: <20220107031905.2406176-1-robh@kernel.org>
From:   Suman Anna <s-anna@ti.com>
Message-ID: <cf75f1ee-8424-b6b2-f873-beea4676a29f@ti.com>
Date:   Fri, 7 Jan 2022 08:26:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220107031905.2406176-1-robh@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 1/6/22 9:19 PM, Rob Herring wrote:
> 'interrupt-parent' is never required as it can be in a parent node or a
> parent node itself can be an interrupt provider. Where exactly it lives is
> outside the scope of a binding schema.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/gpio/toshiba,gpio-visconti.yaml  | 1 -
>  .../devicetree/bindings/mailbox/ti,omap-mailbox.yaml     | 9 ---------
>  Documentation/devicetree/bindings/mfd/cirrus,madera.yaml | 1 -
>  .../devicetree/bindings/net/lantiq,etop-xway.yaml        | 1 -
>  .../devicetree/bindings/net/lantiq,xrx200-net.yaml       | 1 -
>  .../devicetree/bindings/pci/sifive,fu740-pcie.yaml       | 1 -
>  .../devicetree/bindings/pci/xilinx-versal-cpm.yaml       | 1 -
>  7 files changed, 15 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/gpio/toshiba,gpio-visconti.yaml b/Documentation/devicetree/bindings/gpio/toshiba,gpio-visconti.yaml
> index 9ad470e01953..b085450b527f 100644
> --- a/Documentation/devicetree/bindings/gpio/toshiba,gpio-visconti.yaml
> +++ b/Documentation/devicetree/bindings/gpio/toshiba,gpio-visconti.yaml
> @@ -43,7 +43,6 @@ required:
>    - gpio-controller
>    - interrupt-controller
>    - "#interrupt-cells"
> -  - interrupt-parent
>  
>  additionalProperties: false
>  
> diff --git a/Documentation/devicetree/bindings/mailbox/ti,omap-mailbox.yaml b/Documentation/devicetree/bindings/mailbox/ti,omap-mailbox.yaml
> index e864d798168d..d433e496ec6e 100644
> --- a/Documentation/devicetree/bindings/mailbox/ti,omap-mailbox.yaml
> +++ b/Documentation/devicetree/bindings/mailbox/ti,omap-mailbox.yaml
> @@ -175,15 +175,6 @@ required:
>    - ti,mbox-num-fifos
>  
>  allOf:
> -  - if:
> -      properties:
> -        compatible:
> -          enum:
> -            - ti,am654-mailbox
> -    then:
> -      required:
> -        - interrupt-parent
> -

There are multiple interrupt controllers on TI K3 devices, and we need this
property to be defined _specifically_ to point to the relevant interrupt router
parent node.

While what you state in general is true, I cannot have a node not define this on
K3 devices, and end up using the wrong interrupt parent (GIC
interrupt-controller). That's why the conditional compatible check.

regards
Suman

>    - if:
>        properties:
>          compatible:
> diff --git a/Documentation/devicetree/bindings/mfd/cirrus,madera.yaml b/Documentation/devicetree/bindings/mfd/cirrus,madera.yaml
> index 499c62c04daa..5dce62a7eff2 100644
> --- a/Documentation/devicetree/bindings/mfd/cirrus,madera.yaml
> +++ b/Documentation/devicetree/bindings/mfd/cirrus,madera.yaml
> @@ -221,7 +221,6 @@ required:
>    - '#gpio-cells'
>    - interrupt-controller
>    - '#interrupt-cells'
> -  - interrupt-parent
>    - interrupts
>    - AVDD-supply
>    - DBVDD1-supply
> diff --git a/Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml b/Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml
> index 437502c5ca96..3ce9f9a16baf 100644
> --- a/Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml
> +++ b/Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml
> @@ -46,7 +46,6 @@ properties:
>  required:
>    - compatible
>    - reg
> -  - interrupt-parent
>    - interrupts
>    - interrupt-names
>    - lantiq,tx-burst-length
> diff --git a/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml b/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml
> index 7bc074a42369..5bc1a21ca579 100644
> --- a/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml
> +++ b/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml
> @@ -38,7 +38,6 @@ properties:
>  required:
>    - compatible
>    - reg
> -  - interrupt-parent
>    - interrupts
>    - interrupt-names
>    - "#address-cells"
> diff --git a/Documentation/devicetree/bindings/pci/sifive,fu740-pcie.yaml b/Documentation/devicetree/bindings/pci/sifive,fu740-pcie.yaml
> index 2b9d1d6fc661..72c78f4ec269 100644
> --- a/Documentation/devicetree/bindings/pci/sifive,fu740-pcie.yaml
> +++ b/Documentation/devicetree/bindings/pci/sifive,fu740-pcie.yaml
> @@ -61,7 +61,6 @@ required:
>    - num-lanes
>    - interrupts
>    - interrupt-names
> -  - interrupt-parent
>    - interrupt-map-mask
>    - interrupt-map
>    - clock-names
> diff --git a/Documentation/devicetree/bindings/pci/xilinx-versal-cpm.yaml b/Documentation/devicetree/bindings/pci/xilinx-versal-cpm.yaml
> index a2bbc0eb7220..32f4641085bc 100644
> --- a/Documentation/devicetree/bindings/pci/xilinx-versal-cpm.yaml
> +++ b/Documentation/devicetree/bindings/pci/xilinx-versal-cpm.yaml
> @@ -55,7 +55,6 @@ required:
>    - reg-names
>    - "#interrupt-cells"
>    - interrupts
> -  - interrupt-parent
>    - interrupt-map
>    - interrupt-map-mask
>    - bus-range
> 

