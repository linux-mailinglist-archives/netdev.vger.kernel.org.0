Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283D66ED430
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 20:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbjDXSPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 14:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbjDXSPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 14:15:48 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9064EE3;
        Mon, 24 Apr 2023 11:14:59 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-54f6f0dae19so32748507b3.0;
        Mon, 24 Apr 2023 11:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682360098; x=1684952098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XzUuV71xlywRhSGB5NsLHjJvYQxnpMeaPTWJLwb1hAI=;
        b=Zl71GsOyhmESY9jYgO6iLjOhVx8eC/OnUROmISnQJgtnd6t8SrEAoeKB1skTRAJZ7P
         ePvZFuRfi6UFS1eNCGgh+Hz/lxanx2rGRxOtJL9j5NITb0843Fl1kquIpWw01tPtgXx8
         FlfRYVrDzoZliMPkOPnwOwle4WqWhGhTIURsnbulH82eplNycxUYgbu3Mrf1lE0dNEy6
         5gsGihJv8xkgNWQ3oJPxDRIyheeCqmlxFDMaAJlFoHMFD0/8Ib0feRBnSMVVTb6WPwdI
         uLKhW2KCuIwXlCTO49s8wPxc+339MnEDbvbBQ2viPW4gt23Y7oCrqAvWMJ3YyESJeeh7
         a1Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682360098; x=1684952098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XzUuV71xlywRhSGB5NsLHjJvYQxnpMeaPTWJLwb1hAI=;
        b=dDdG/GtfjXMvnSH6mivAQiV1oy9eaNokubv7HWj8IQSLYpTuWXgJISDAddcTl0c18/
         +ullU3WKhgA0XUGzq2uif5MZlv7QVdyXNbJlntPwYq83UiPzRMyta4TCJKN+4yEgDxGf
         DXujj98LwPSsxlJi0aQ1qP8nkYIoOsT9O9kDm+8fvQf0cqiZqi/m4q7TxJQFo6MebfR8
         gcgx8Gz16bdnSisswYc/EJhXEv0/Hise2RUXBGWB7ACwjjsO2CdUE+psvX7mYkLyCJFr
         z/mej/xPNYrtD38TcZiQnu7MbYjTgqhs31661281rq0UFcsLZzgur+SlOI1wPIYregMd
         emmw==
X-Gm-Message-State: AAQBX9fEiMwOmmS8Lgc+bw3ivRHZp2AXIKfXr6aMTWmqyezWA7dsP6i4
        JyQyFnzyVzssktZGACe5iC0e6d6aazqtVeYhHyY=
X-Google-Smtp-Source: AKy350apcZVtlQedv1SFzob/DDZM7LIKQflG72XIzIVjRiOTTQzsTPOrG6AamPjIXZAD9v+Aoargnxls9GL6gjVxnp4=
X-Received: by 2002:a81:5a05:0:b0:556:2699:f3cf with SMTP id
 o5-20020a815a05000000b005562699f3cfmr6537955ywb.40.1682360098243; Mon, 24 Apr
 2023 11:14:58 -0700 (PDT)
MIME-Version: 1.0
References: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
 <1681863018-28006-2-git-send-email-justinpopo6@gmail.com> <e2069707-3f09-f1e7-6973-a2e115af7536@linaro.org>
In-Reply-To: <e2069707-3f09-f1e7-6973-a2e115af7536@linaro.org>
From:   Justin Chen <justinpopo6@gmail.com>
Date:   Mon, 24 Apr 2023 11:14:47 -0700
Message-ID: <CAJx26kXnYy9oQiXZ+dbAbzf-jAO9M6ggWL164_67MDS_3cfNnA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/6] dt-bindings: net: Brcm ASP 2.0 Ethernet controller
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        bcm-kernel-feedback-list@broadcom.com, justin.chen@broadcom.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 12:29=E2=80=AFAM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 19/04/2023 02:10, Justin Chen wrote:
> > From: Florian Fainelli <f.fainelli@gmail.com>
> >
> > Add a binding document for the Broadcom ASP 2.0 Ethernet
> > controller.
> >
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > Signed-off-by: Justin Chen <justinpopo6@gmail.com>
> > ---
> >  .../devicetree/bindings/net/brcm,asp-v2.0.yaml     | 146 +++++++++++++=
++++++++
> >  1 file changed, 146 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0=
.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml b=
/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> > new file mode 100644
> > index 000000000000..3817d722244f
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> > @@ -0,0 +1,146 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: "http://devicetree.org/schemas/net/brcm,asp-v2.0.yaml#"
> > +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
>
> Drop quotes.
>
> > +
> > +title: Broadcom ASP 2.0 Ethernet controller
> > +
> > +maintainers:
> > +  - Justin Chen <justinpopo6@gmail.com>
> > +  - Florian Fainelli <f.fainelli@gmail.com>
> > +
> > +description: Broadcom Ethernet controller first introduced with 72165
> > +
> > +properties:
> > +  '#address-cells':
> > +    const: 1
> > +  '#size-cells':
> > +    const: 1
> > +
> > +  compatible:
> > +    enum:
> > +      - brcm,bcm72165-asp-v2.0
> > +      - brcm,asp-v2.0
> > +      - brcm,asp-v2.1
>
> Is this part of SoC? If so, then SoC compatibles are preferred, not IP
> block versions.
We have the same IP on different chips. So no, it isn't tied to a specific =
SoC.

>
> > +
> > +  reg:
> > +    maxItems: 1
> > +    description: ASP registers
>
> Drop description.
>
> > +
> > +  ranges: true
> > +
> > +  interrupts:
> > +    minItems: 1
> > +    items:
> > +      - description: RX/TX interrupt
> > +      - description: Port 0 Wake-on-LAN
> > +      - description: Port 1 Wake-on-LAN
> > +
> > +  clocks:
> > +    $ref: /schemas/types.yaml#/definitions/phandle-array
>
> Drop.
>
> > +    description: Phandle to clock controller
>
> Drop.
>
> Instead maxItems.
>
> > +
> > +  clock-names:
> > +    const: sw_asp
>
> Drop entire property.
>
> > +
> > +  ethernet-ports:
> > +    type: object
> > +    properties:
> > +      '#address-cells':
> > +        const: 1
> > +      '#size-cells':
> > +        const: 0
>
> Missing additionalProperties:false. Look at existing bindings how it is
> done.
>
> > +
> > +    patternProperties:
> > +      "^port@[0-9]+$":
> > +        type: object
> > +
> > +        $ref: ethernet-controller.yaml#
> > +
> > +        properties:
> > +          reg:
> > +            maxItems: 1
> > +            description: Port number
> > +
> > +          channel:
> > +            maxItems: 1
> > +            description: ASP channel number
> > +
> > +        required:
> > +          - reg
> > +          - channel
> > +
> > +patternProperties:
> > +  "^mdio@[0-9a-f]+$":
> > +    type: object
> > +    $ref: "brcm,unimac-mdio.yaml"
> > +
> > +    description:
> > +      ASP internal UniMAC MDIO bus
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +  - clocks
> > +  - clock-names
> > +  - ranges
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    asp@9c00000 {
>
> Node names should be generic.
> https://devicetree-specification.readthedocs.io/en/latest/chapter2-device=
tree-basics.html#generic-names-recommendation
>
> > +        compatible =3D "brcm,asp-v2.0";
> > +        reg =3D <0x9c00000 0x1fff14>;
> > +        interrupts =3D <0x0 0x33 0x4>;
>
> Use proper defines for flags.
Not understanding this comment. Can you elaborate?

Thanks,
Justin
>
> > +        ranges;
> > +        clocks =3D <&scmi 14>;
> > +        clock-names =3D "sw_asp";
> > +        #address-cells =3D <1>;
> > +        #size-cells =3D <1>;
>
>
> Best regards,
> Krzysztof
>
