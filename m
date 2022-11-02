Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E35617005
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiKBVpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiKBVo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:44:59 -0400
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CC69FD2;
        Wed,  2 Nov 2022 14:44:55 -0700 (PDT)
Received: by mail-ot1-f51.google.com with SMTP id w26-20020a056830061a00b0066c320f5b49so5341oti.5;
        Wed, 02 Nov 2022 14:44:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=syOzYtOOOUOYVS4+OlEvCGBduiGZmBKkbZQSbbMUPpA=;
        b=Ai59QzDF3njfiJ8WmpJm/jR//u4TcX2m7C7weX6z5D8COwCvd81toeiR3L4MgO2b95
         BW/3Wrrr0T7bTxq9Gv4vrszQX7WPxRSIc9px7skY/DtjbKRRWGDlc9LYP84rJxT7ReKR
         VCVxUbkpJckIePw/k4jVuPRZokzDBMPa6ppIsOYSeHzScmkH+T2+0CwDQqghzMm9HiE5
         1yQhXD0FhdinbYQZv8xIBjVnxxeJCJT0DcMaYtSKsuhct0qpj1hTuoI47E0qn+Y7N0Yo
         SXV1X3Tv9nOeOU3jMSFsS+G9Fkdotc12IzlGQwrNFa/Xot65f9YwA49ppm0Xoz44Ro+A
         H92A==
X-Gm-Message-State: ACrzQf1N6Roz79uQN29+1JOxCfLFse9ZycaJN04s1cZWVi1NMwvtO5B6
        eAvIptbxSd9GboQWnSms6w==
X-Google-Smtp-Source: AMsMyM5jgp6/w71wsIeSDu5Cp2add+eO31Ja16PdaL5iDF1jEe8kETQjfyntiTk6ehIozKaHEcN28A==
X-Received: by 2002:a05:6830:108:b0:66a:8d0d:6a73 with SMTP id i8-20020a056830010800b0066a8d0d6a73mr13260759otp.193.1667425495145;
        Wed, 02 Nov 2022 14:44:55 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id q21-20020a056830233500b00661c0747545sm5655710otg.44.2022.11.02.14.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 14:44:54 -0700 (PDT)
Received: (nullmailer pid 522290 invoked by uid 1000);
        Wed, 02 Nov 2022 21:44:56 -0000
Date:   Wed, 2 Nov 2022 16:44:56 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc:     Chester Lin <clin@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>
Subject: Re: [PATCH 2/5] dt-bindings: net: add schema for NXP S32CC dwmac
 glue driver
Message-ID: <20221102214456.GB459441-robh@kernel.org>
References: <20221031101052.14956-1-clin@suse.com>
 <20221031101052.14956-3-clin@suse.com>
 <20221102155515.GA3959603-robh@kernel.org>
 <2a7ebef4-77cc-1c26-ec6d-86db5ee5a94b@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a7ebef4-77cc-1c26-ec6d-86db5ee5a94b@suse.de>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 02, 2022 at 06:13:35PM +0100, Andreas Färber wrote:
> Hi Rob,
> 
> On 02.11.22 16:55, Rob Herring wrote:
> > On Mon, Oct 31, 2022 at 06:10:49PM +0800, Chester Lin wrote:
> > > Add the DT schema for the DWMAC Ethernet controller on NXP S32 Common
> > > Chassis.
> > > 
> > > Signed-off-by: Jan Petrous <jan.petrous@nxp.com>
> > > Signed-off-by: Chester Lin <clin@suse.com>
> > > ---
> > >   .../bindings/net/nxp,s32cc-dwmac.yaml         | 145 ++++++++++++++++++
> > >   1 file changed, 145 insertions(+)
> > >   create mode 100644 Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> > > 
> > > diff --git a/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> > > new file mode 100644
> > > index 000000000000..f6b8486f9d42
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> > > @@ -0,0 +1,145 @@
> > > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > > +# Copyright 2021-2022 NXP
> > > +%YAML 1.2
> > > +---
> > > +$id: "http://devicetree.org/schemas/net/nxp,s32cc-dwmac.yaml#"
> > > +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> > > +
> > > +title: NXP S32CC DWMAC Ethernet controller
> > > +
> > > +maintainers:
> > > +  - Jan Petrous <jan.petrous@nxp.com>
> > > +  - Chester Lin <clin@suse.com>
> [...]
> > > +properties:
> > > +  compatible:
> > > +    contains:
> > 
> > Drop 'contains'.
> > 
> > > +      enum:
> > > +        - nxp,s32cc-dwmac
> 
> In the past you were adamant that we use concrete SoC-specific strings. Here
> that would mean s32g2 or s32g274 instead of s32cc (which aims to share with
> S32G3 IIUC).

Yes they should be SoC specific. Really, 1 per maskset or die is fine if 
that level of detail is known. No need for different compatibles for 
different part numbers created by fused off features or package pinout 
differences.


> [...]
> > > +  clocks:
> > > +    items:
> > > +      - description: Main GMAC clock
> > > +      - description: Peripheral registers clock
> > > +      - description: Transmit SGMII clock
> > > +      - description: Transmit RGMII clock
> > > +      - description: Transmit RMII clock
> > > +      - description: Transmit MII clock
> > > +      - description: Receive SGMII clock
> > > +      - description: Receive RGMII clock
> > > +      - description: Receive RMII clock
> > > +      - description: Receive MII clock
> > > +      - description:
> > > +          PTP reference clock. This clock is used for programming the
> > > +          Timestamp Addend Register. If not passed then the system
> > > +          clock will be used.
> > 
> > If optional, then you need 'minItems'.
> [snip]
> 
> Do we have any precedence of bindings with *MII clocks like these?

Don't know...

> AFAIU the reason there are so many here is that there are in fact physically
> just five, but different parent clock configurations that SCMI does not
> currently expose to Linux. Thus I was raising that we may want to extend the
> SCMI protocol with some SET_PARENT operation that could allow us to use less
> input clocks here, but obviously such a standardization process will take
> time...
> 
> What are your thoughts on how to best handle this here?

Perhaps use assigned-clocks if it is static for a board.

> Not clear to me has been whether the PHY mode can be switched at runtime
> (like DPAA2 on Layerscape allows for SFPs) or whether this is fixed by board
> design. If the latter, the two out of six SCMI IDs could get selected in
> TF-A, to have only physical clocks here in the binding.
> 
> Regards,
> Andreas
