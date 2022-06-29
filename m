Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393E956039C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiF2OuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiF2OuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:50:13 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512821CFE6;
        Wed, 29 Jun 2022 07:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=S3ju5Nr7hfd110iZmCLv9+gZbDbPEjWtum1B8GQGywA=; b=JG3jkP5Vv9Jim6Yb4RJlAq1uGD
        3iBb15pzuTWKpyaU6yeJT0oBIMMv92MtP73oxfJcRyF5x1DsurCHy7GXVe57VO4/odKav7KKvOLyH
        Dq/OdFTasqachW8KWVoy7njWx1JMoNeEFv18ogkZcZjyjNRgEpHRcd9qXIekW5OPnU789Ep2J/3c4
        jo2PSV3Xg0CG376aUh2TsrOzr1X9l9mqYjjfgwUbUm8oBBn1lJZbqJzRd3yGTO0WhoDRVC2ioBDVp
        KsJAfHmzSKVBEkujLqfY4NcU2sxad2hvYD0lqZ/DlGCnqRLeQg1t7k3/LGFG5YCUlTu99V1mAC4vR
        IrzsOMnA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33102)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o6Z11-0003IC-E3; Wed, 29 Jun 2022 15:50:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o6Z0z-0005vu-EK; Wed, 29 Jun 2022 15:50:01 +0100
Date:   Wed, 29 Jun 2022 15:50:01 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 02/35] dt-bindings: net: Convert FMan MAC
 bindings to yaml
Message-ID: <YrxmmSXdKb3pD/Nv@shell.armlinux.org.uk>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-3-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628221404.1444200-3-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 06:13:31PM -0400, Sean Anderson wrote:
> This converts the MAC portion of the FMan MAC bindings to yaml.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> Changes in v2:
> - New
> 
>  .../bindings/net/fsl,fman-dtsec.yaml          | 144 ++++++++++++++++++
>  .../devicetree/bindings/net/fsl-fman.txt      | 128 +---------------
>  2 files changed, 145 insertions(+), 127 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
> new file mode 100644
> index 000000000000..809df1589f20
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
> @@ -0,0 +1,144 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/fsl,fman-dtsec.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NXP FMan MAC
> +
> +maintainers:
> +  - Madalin Bucur <madalin.bucur@nxp.com>
> +
> +description: |
> +  Each FMan has several MACs, each implementing an Ethernet interface. Earlier
> +  versions of FMan used the Datapath Three Speed Ethernet Controller (dTSEC) for
> +  10/100/1000 MBit/s speeds, and the 10-Gigabit Ethernet Media Access Controller
> +  (10GEC) for 10 Gbit/s speeds. Later versions of FMan use the Multirate
> +  Ethernet Media Access Controller (mEMAC) to handle all speeds.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - fsl,fman-dtsec
> +      - fsl,fman-xgec
> +      - fsl,fman-memac
> +
> +  cell-index:
> +    maximum: 64
> +    description: |
> +      FManV2:
> +      register[bit]           MAC             cell-index
> +      ============================================================
> +      FM_EPI[16]              XGEC            8
> +      FM_EPI[16+n]            dTSECn          n-1
> +      FM_NPI[11+n]            dTSECn          n-1
> +              n = 1,..,5
> +
> +      FManV3:
> +      register[bit]           MAC             cell-index
> +      ============================================================
> +      FM_EPI[16+n]            mEMACn          n-1
> +      FM_EPI[25]              mEMAC10         9
> +
> +      FM_NPI[11+n]            mEMACn          n-1
> +      FM_NPI[10]              mEMAC10         9
> +      FM_NPI[11]              mEMAC9          8
> +              n = 1,..8
> +
> +      FM_EPI and FM_NPI are located in the FMan memory map.
> +
> +      2. SoC registers:
> +
> +      - P2041, P3041, P4080 P5020, P5040:
> +      register[bit]           FMan            MAC             cell
> +                              Unit                            index
> +      ============================================================
> +      DCFG_DEVDISR2[7]        1               XGEC            8
> +      DCFG_DEVDISR2[7+n]      1               dTSECn          n-1
> +      DCFG_DEVDISR2[15]       2               XGEC            8
> +      DCFG_DEVDISR2[15+n]     2               dTSECn          n-1
> +              n = 1,..5
> +
> +      - T1040, T2080, T4240, B4860:
> +      register[bit]                   FMan    MAC             cell
> +                                      Unit                    index
> +      ============================================================
> +      DCFG_CCSR_DEVDISR2[n-1]         1       mEMACn          n-1
> +      DCFG_CCSR_DEVDISR2[11+n]        2       mEMACn          n-1
> +              n = 1,..6,9,10
> +
> +      EVDISR, DCFG_DEVDISR2 and DCFG_CCSR_DEVDISR2 are located in
> +      the specific SoC "Device Configuration/Pin Control" Memory
> +      Map.
> +
> +  reg:
> +    maxItems: 1
> +
> +  fsl,fman-ports:
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    maxItems: 2
> +    description: |
> +      An array of two references: the first is the FMan RX port and the second
> +      is the TX port used by this MAC.
> +
> +  ptp-timer:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: A reference to the IEEE1588 timer
> +
> +  pcsphy-handle:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: A reference to the PCS (typically found on the SerDes)

This description includes ethernet-controller.yaml, which contains:

  pcs-handle:
    $ref: /schemas/types.yaml#/definitions/phandle
    description:
      Specifies a reference to a node representing a PCS PHY device on a MDIO
      bus to link with an external PHY (phy-handle) if exists.

Is there a reason why a custom property is needed rather than using the
pcs-handle property already provided by the ethernet-controller DT
description?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
