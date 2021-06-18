Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0523AD325
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbhFRTwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhFRTwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:52:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 463F6613E9;
        Fri, 18 Jun 2021 19:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624045838;
        bh=Olzy7g261M2VzBHP3yNFLi2kVn+AxxWpUNxI0dmBqcc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dcP4F/onnC+AOTwEh+lLoHTFig1Ba3jo+I4fjjCvYFbLZbVPvhtCidPPAwY/NkJIT
         jS8iPQktgF4ztiwk8UTas962qqssLW0P29WJX2/lUIOrJGsb6gc7DjFb3lBxz2itjF
         0mszurdnDaFarK1TslyM/1ieSnyBbG79y5AU1JZD4EcUXHViPgj5OuQu/g2xAkPwdk
         FEuJlWIMIKRZSEfkLA17KhLw6b4Jv4AzZ6FdFtt8MN2EkoUl15Sj/adadfGjgiVF1O
         pj58nvIs4hSfj8TmN+B/CfujaHHguA1jxkuZj/rM/t5sJUq5snviGXyQ6epvkVogp1
         wVRYM/P5WJeyw==
Received: by mail-ej1-f52.google.com with SMTP id og14so17559407ejc.5;
        Fri, 18 Jun 2021 12:50:38 -0700 (PDT)
X-Gm-Message-State: AOAM532epyVM+6mSLy7yYtAcW36EMldqHdBUUc0On0EtyUvv1CgDC9NG
        nGt2AbvGVoASdljnUGpdRXKb005xmWqOOQNPyQ==
X-Google-Smtp-Source: ABdhPJwKAurPVIO13QjaLe6oUgNoXTxDg/+T34lz/ida9mpMP6fVsLehR3G6dZmNY0InmWB6h6ecN/5xS0kNaklg6CQ=
X-Received: by 2002:a17:907:2059:: with SMTP id pg25mr12140038ejb.130.1624045836720;
 Fri, 18 Jun 2021 12:50:36 -0700 (PDT)
MIME-Version: 1.0
References: <1623690937-52389-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1623690937-52389-2-git-send-email-zhouyanjie@wanyeetech.com>
 <CAL_Jsq+7v6GRMfxWhA6g2r0GaZSO_AztgSz7rheJsE9jKYd8uQ@mail.gmail.com>
 <20210616154526.54481912@zhouyanjie-virtual-machine> <20210617112400.5e68c172@zhouyanjie-virtual-machine>
In-Reply-To: <20210617112400.5e68c172@zhouyanjie-virtual-machine>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 18 Jun 2021 13:50:25 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJW_L3TXTy89Y6YOyQzGzOeN3g1D7pwbuGmSW6TFaO4nA@mail.gmail.com>
Message-ID: <CAL_JsqJW_L3TXTy89Y6YOyQzGzOeN3g1D7pwbuGmSW6TFaO4nA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: dwmac: Add bindings for new Ingenic SoCs.
To:     =?UTF-8?B?5ZGo55Cw5p2w?= <zhouyanjie@wanyeetech.com>
Cc:     sihui.liu@ingenic.com, David Miller <davem@davemloft.net>,
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
        jun.jiang@ingenic.com, sernia.zhou@foxmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 9:24 PM =E5=91=A8=E7=90=B0=E6=9D=B0 <zhouyanjie@wan=
yeetech.com> wrote:
>
> Hi Rob,
>
> =E4=BA=8E Wed, 16 Jun 2021 15:45:26 +0800
> =E5=91=A8=E7=90=B0=E6=9D=B0 <zhouyanjie@wanyeetech.com> =E5=86=99=E9=81=
=93:
>
> > Hi Rob,
> >
> > =E4=BA=8E Tue, 15 Jun 2021 17:05:45 -0600
> > Rob Herring <robh+dt@kernel.org> =E5=86=99=E9=81=93:
> >
> > > On Mon, Jun 14, 2021 at 11:18 AM =E5=91=A8=E7=90=B0=E6=9D=B0 (Zhou Ya=
njie)
> > > <zhouyanjie@wanyeetech.com> wrote:
> > > >
> > > > Add the dwmac bindings for the JZ4775 SoC, the X1000 SoC,
> > > > the X1600 SoC, the X1830 SoC and the X2000 SoC from Ingenic.
> > > >
> > > > Signed-off-by: =E5=91=A8=E7=90=B0=E6=9D=B0 (Zhou Yanjie) <zhouyanji=
e@wanyeetech.com>
> > > > ---
> > > >
> > > > Notes:
> > > >     v1->v2:
> > > >     No change.
> > > >
> > > >     v2->v3:
> > > >     Add "ingenic,mac.yaml" for Ingenic SoCs.
> > > >
> > > >  .../devicetree/bindings/net/ingenic,mac.yaml       | 76
> > > > ++++++++++++++++++++++ .../devicetree/bindings/net/snps,dwmac.yaml
> > > > | 15 +++++ 2 files changed, 91 insertions(+)
> > > >  create mode 100644
> > > > Documentation/devicetree/bindings/net/ingenic,mac.yaml
> > > >
> > > > diff --git
> > > > a/Documentation/devicetree/bindings/net/ingenic,mac.yaml
> > > > b/Documentation/devicetree/bindings/net/ingenic,mac.yaml new file
> > > > mode 100644 index 00000000..5fe2e81 --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
> > > > @@ -0,0 +1,76 @@
> > > > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > > > +%YAML 1.2
> > > > +---
> > > > +$id: http://devicetree.org/schemas/net/ingenic,mac.yaml#
> > > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > > +
> > > > +title: Bindings for MAC in Ingenic SoCs
> > > > +
> > > > +maintainers:
> > > > +  - =E5=91=A8=E7=90=B0=E6=9D=B0 (Zhou Yanjie) <zhouyanjie@wanyeete=
ch.com>
> > > > +
> > > > +description:
> > > > +  The Ethernet Media Access Controller in Ingenic SoCs.
> > > > +
> > > > +properties:
> > > > +  compatible:
> > > > +    enum:
> > > > +      - ingenic,jz4775-mac
> > > > +      - ingenic,x1000-mac
> > > > +      - ingenic,x1600-mac
> > > > +      - ingenic,x1830-mac
> > > > +      - ingenic,x2000-mac
> > > > +
> > > > +  reg:
> > > > +    maxItems: 1
> > > > +
> > > > +  interrupts:
> > > > +    maxItems: 1
> > > > +
> > > > +  interrupt-names:
> > > > +    const: macirq
> > > > +
> > > > +  clocks:
> > > > +    maxItems: 1
> > > > +
> > > > +  clock-names:
> > > > +    const: stmmaceth
> > > > +
> > > > +  mode-reg:
> > > > +    description: An extra syscon register that control ethernet
> > > > interface and timing delay
> > >
> > > Needs a vendor prefix and type.
> > >
> > > > +
> > > > +  rx-clk-delay-ps:
> > > > +    description: RGMII receive clock delay defined in pico
> > > > seconds +
> > > > +  tx-clk-delay-ps:
> > > > +    description: RGMII transmit clock delay defined in pico
> > > > seconds +
> > > > +required:
> > > > +  - compatible
> > > > +  - reg
> > > > +  - interrupts
> > > > +  - interrupt-names
> > > > +  - clocks
> > > > +  - clock-names
> > > > +  - mode-reg
> > > > +
> > > > +additionalProperties: false
> > > > +
> > > > +examples:
> > > > +  - |
> > > > +    #include <dt-bindings/clock/x1000-cgu.h>
> > > > +
> > > > +    mac: ethernet@134b0000 {
> > > > +        compatible =3D "ingenic,x1000-mac", "snps,dwmac";
> > >
> > > Doesn't match the schema.
> >
> > Sorry for that, somehow when I run "make dt_bindings_check", there is
> > no warrning or error message about this file. I am sure that yamllint
> > is installed and dtschema has been upgraded to 2021.6.
>
> I found that it seems to be because 5.13 newly introduced
> "DT_CHECKER_FLAGS=3D-m", and I am still using the old
> "make dt_binding_check" command, so this error is not prompted. Now I
> can see this error message after using the
> "make DT_CHECKER_FLAGS=3D-m dt_binding_check" command, and I will send a
> fix soon.

No, this error has nothing to do with the '-m' option.

Rob
