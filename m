Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6073A9456
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhFPHsf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Jun 2021 03:48:35 -0400
Received: from out29-53.mail.aliyun.com ([115.124.29.53]:59386 "EHLO
        out29-53.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbhFPHrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:47:39 -0400
X-Alimail-AntiSpam: AC=SUSPECT;BC=0.6743332|-1;BR=01201311R101b1;CH=blue;DM=|SUSPECT|false|;DS=CONTINUE|ham_regular_dialog|0.64693-0.00539747-0.347672;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047193;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=21;RT=21;SR=0;TI=SMTPD_---.KT5RiOm_1623829528;
Received: from zhouyanjie-virtual-machine(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.KT5RiOm_1623829528)
          by smtp.aliyun-inc.com(10.147.44.129);
          Wed, 16 Jun 2021 15:45:29 +0800
Date:   Wed, 16 Jun 2021 15:45:26 +0800
From:   =?UTF-8?B?5ZGo55Cw5p2w?= <zhouyanjie@wanyeetech.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com
Subject: Re: [PATCH v3 1/2] dt-bindings: dwmac: Add bindings for new Ingenic
 SoCs.
Message-ID: <20210616154526.54481912@zhouyanjie-virtual-machine>
In-Reply-To: <CAL_Jsq+7v6GRMfxWhA6g2r0GaZSO_AztgSz7rheJsE9jKYd8uQ@mail.gmail.com>
References: <1623690937-52389-1-git-send-email-zhouyanjie@wanyeetech.com>
        <1623690937-52389-2-git-send-email-zhouyanjie@wanyeetech.com>
        <CAL_Jsq+7v6GRMfxWhA6g2r0GaZSO_AztgSz7rheJsE9jKYd8uQ@mail.gmail.com>
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

于 Tue, 15 Jun 2021 17:05:45 -0600
Rob Herring <robh+dt@kernel.org> 写道:

> On Mon, Jun 14, 2021 at 11:18 AM 周琰杰 (Zhou Yanjie)
> <zhouyanjie@wanyeetech.com> wrote:
> >
> > Add the dwmac bindings for the JZ4775 SoC, the X1000 SoC,
> > the X1600 SoC, the X1830 SoC and the X2000 SoC from Ingenic.
> >
> > Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
> > ---
> >
> > Notes:
> >     v1->v2:
> >     No change.
> >
> >     v2->v3:
> >     Add "ingenic,mac.yaml" for Ingenic SoCs.
> >
> >  .../devicetree/bindings/net/ingenic,mac.yaml       | 76
> > ++++++++++++++++++++++ .../devicetree/bindings/net/snps,dwmac.yaml
> > | 15 +++++ 2 files changed, 91 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/net/ingenic,mac.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/ingenic,mac.yaml
> > b/Documentation/devicetree/bindings/net/ingenic,mac.yaml new file
> > mode 100644 index 00000000..5fe2e81
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
> > @@ -0,0 +1,76 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/ingenic,mac.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Bindings for MAC in Ingenic SoCs
> > +
> > +maintainers:
> > +  - 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
> > +
> > +description:
> > +  The Ethernet Media Access Controller in Ingenic SoCs.
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - ingenic,jz4775-mac
> > +      - ingenic,x1000-mac
> > +      - ingenic,x1600-mac
> > +      - ingenic,x1830-mac
> > +      - ingenic,x2000-mac
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +  interrupt-names:
> > +    const: macirq
> > +
> > +  clocks:
> > +    maxItems: 1
> > +
> > +  clock-names:
> > +    const: stmmaceth
> > +
> > +  mode-reg:
> > +    description: An extra syscon register that control ethernet
> > interface and timing delay  
> 
> Needs a vendor prefix and type.
> 
> > +
> > +  rx-clk-delay-ps:
> > +    description: RGMII receive clock delay defined in pico seconds
> > +
> > +  tx-clk-delay-ps:
> > +    description: RGMII transmit clock delay defined in pico seconds
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +  - interrupt-names
> > +  - clocks
> > +  - clock-names
> > +  - mode-reg
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/clock/x1000-cgu.h>
> > +
> > +    mac: ethernet@134b0000 {
> > +        compatible = "ingenic,x1000-mac", "snps,dwmac";  
> 
> Doesn't match the schema.

Sorry for that, somehow when I run "make dt_bindings_check", there is no
warrning or error message about this file. I am sure that yamllint is
installed and dtschema has been upgraded to 2021.6.

I will send a fix.

Thanks and best regards!

> 
> > +        reg = <0x134b0000 0x2000>;
> > +
> > +        interrupt-parent = <&intc>;
> > +        interrupts = <55>;
> > +        interrupt-names = "macirq";
> > +
> > +        clocks = <&cgu X1000_CLK_MAC>;
> > +        clock-names = "stmmaceth";
> > +
> > +        mode-reg = <&mac_phy_ctrl>;
> > +    };
> > +...
> > diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > b/Documentation/devicetree/bindings/net/snps,dwmac.yaml index
> > 2edd8be..9c0ce92 100644 ---
> > a/Documentation/devicetree/bindings/net/snps,dwmac.yaml +++
> > b/Documentation/devicetree/bindings/net/snps,dwmac.yaml @@ -56,6
> > +56,11 @@ properties:
> >          - amlogic,meson8m2-dwmac
> >          - amlogic,meson-gxbb-dwmac
> >          - amlogic,meson-axg-dwmac
> > +        - ingenic,jz4775-mac
> > +        - ingenic,x1000-mac
> > +        - ingenic,x1600-mac
> > +        - ingenic,x1830-mac
> > +        - ingenic,x2000-mac
> >          - rockchip,px30-gmac
> >          - rockchip,rk3128-gmac
> >          - rockchip,rk3228-gmac
> > @@ -310,6 +315,11 @@ allOf:
> >                - allwinner,sun8i-r40-emac
> >                - allwinner,sun8i-v3s-emac
> >                - allwinner,sun50i-a64-emac
> > +              - ingenic,jz4775-mac
> > +              - ingenic,x1000-mac
> > +              - ingenic,x1600-mac
> > +              - ingenic,x1830-mac
> > +              - ingenic,x2000-mac
> >                - snps,dwxgmac
> >                - snps,dwxgmac-2.10
> >                - st,spear600-gmac
> > @@ -353,6 +363,11 @@ allOf:
> >                - allwinner,sun8i-r40-emac
> >                - allwinner,sun8i-v3s-emac
> >                - allwinner,sun50i-a64-emac
> > +              - ingenic,jz4775-mac
> > +              - ingenic,x1000-mac
> > +              - ingenic,x1600-mac
> > +              - ingenic,x1830-mac
> > +              - ingenic,x2000-mac
> >                - snps,dwmac-4.00
> >                - snps,dwmac-4.10a
> >                - snps,dwmac-4.20a
> > --
> > 2.7.4
>   

