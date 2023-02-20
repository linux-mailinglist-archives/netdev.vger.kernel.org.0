Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B570769D255
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 18:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbjBTRtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 12:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjBTRtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 12:49:31 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39F1C17D;
        Mon, 20 Feb 2023 09:49:29 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pUAHy-00031I-00;
        Mon, 20 Feb 2023 18:49:22 +0100
Date:   Mon, 20 Feb 2023 17:49:14 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Jianhui Zhao <zhaojh329@gmail.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Felix Fietkau <nbd@nbd.name>,
        Russell King <linux@armlinux.org.uk>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        John Crispin <john@phrozen.org>,
        Paolo Abeni <pabeni@redhat.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 03/12] dt-bindings: arm: mediatek: sgmiisys: Convert
 to DT schema
Message-ID: <Y/OymoWRP2pcikXy@makrotopia.org>
References: <cover.1676910958.git.daniel@makrotopia.org>
 <03f9d40849dd2d563a93b27732a7b5d7dd1defc5.1676910958.git.daniel@makrotopia.org>
 <167691325732.3971281.4378006887073697625.robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167691325732.3971281.4378006887073697625.robh@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Mon, Feb 20, 2023 at 11:15:53AM -0600, Rob Herring wrote:
> 
> On Mon, 20 Feb 2023 16:41:16 +0000, Daniel Golle wrote:
> > Convert mediatek,sgmiiisys bindings to DT schema format.
> > Add maintainer Matthias Brugger, no maintainers were listed in the
> > original documentation.
> > As this node is also referenced by the Ethernet controller and used
> > as SGMII PCS add this fact to the description.
> > Move the file to Documentation/devicetree/bindings/pcs/ which seems more
> > appropriate given that the great majority of registers are related to
> > SGMII PCS functionality and only one register represents clock bits.
> > 
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > ---
> >  .../arm/mediatek/mediatek,sgmiisys.txt        | 25 ----------
> >  .../bindings/net/pcs/mediatek,sgmiisys.yaml   | 49 +++++++++++++++++++
> >  2 files changed, 49 insertions(+), 25 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
> >  create mode 100644 Documentation/devicetree/bindings/net/pcs/mediatek,sgmiisys.yaml
> > 
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> ./Documentation/devicetree/bindings/net/pcs/mediatek,sgmiisys.yaml: $id: relative path/filename doesn't match actual path or filename
> 	expected: http://devicetree.org/schemas/net/pcs/mediatek,sgmiisys.yaml#

I simply didn't even consider that moving the file to its correct
location may cause this kind of havoc. Please apologize, I'm quite new
to this whole dt-schema game and still learning...

> 
> doc reference errors (make refcheckdocs):
> 
> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/03f9d40849dd2d563a93b27732a7b5d7dd1defc5.1676910958.git.daniel@makrotopia.org
> 
> The base for the series is generally the latest rc1. A different dependency
> should be noted in *this* patch.
> 
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
> 
> pip3 install dtschema --upgrade
> 
> Please check and re-submit after running the above command yourself. Note
> that DT_SCHEMA_FILES can be set to your schema file to speed up checking
> your schema. However, it must be unset to test all examples with your schema.
> 

I've fixed the wrong path now also within mediatek,sgmiisys.yaml itself.
Result:

[daniel@box linux.git]$ make dt_binding_check DT_SCHEMA_FILES=mediatek,sgmiisys
  HOSTCC  scripts/dtc/util.o
  LEX     scripts/dtc/dtc-lexer.lex.c
  YACC    scripts/dtc/dtc-parser.tab.[ch]
  HOSTCC  scripts/dtc/dtc-lexer.lex.o
  HOSTCC  scripts/dtc/dtc-parser.tab.o
  HOSTCC  scripts/dtc/checks.o
  HOSTLD  scripts/dtc/dtc
  HOSTCC  scripts/dtc/libfdt/fdt.o
  HOSTCC  scripts/dtc/libfdt/fdt_ro.o
  HOSTCC  scripts/dtc/libfdt/fdt_wip.o
  HOSTCC  scripts/dtc/libfdt/fdt_sw.o
  HOSTCC  scripts/dtc/libfdt/fdt_rw.o
  HOSTCC  scripts/dtc/libfdt/fdt_strerror.o
  HOSTCC  scripts/dtc/libfdt/fdt_empty_tree.o
  HOSTCC  scripts/dtc/libfdt/fdt_addresses.o
  HOSTCC  scripts/dtc/libfdt/fdt_overlay.o
  HOSTCC  scripts/dtc/fdtoverlay.o
  HOSTLD  scripts/dtc/fdtoverlay
  LINT    Documentation/devicetree/bindings
  CHKDT   Documentation/devicetree/bindings/processed-schema.json
  SCHEMA  Documentation/devicetree/bindings/processed-schema.json
  DTEX    Documentation/devicetree/bindings/net/pcs/mediatek,sgmiisys.example.dts
  DTC_CHK Documentation/devicetree/bindings/net/pcs/mediatek,sgmiisys.example.dtb


I'll wait for more potentials comments on the series and re-submit tomorrow.


Thank you!


Daniel
