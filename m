Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDB3606AF7
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 00:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiJTWG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 18:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiJTWGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 18:06:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89DE21129A;
        Thu, 20 Oct 2022 15:06:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 193FB61D3E;
        Thu, 20 Oct 2022 22:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777E2C4347C;
        Thu, 20 Oct 2022 22:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666303582;
        bh=LEXz6lQTYIKv1JGpfH2q1eepeDnKvg6Ve/0W4r24DcM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TI6kczEW5L03DA6teLr/ZYBF2LUic/qvr3GEU62OpZhvZqQuGp+Hb0F1YzPRdCft/
         Bm48bUrIFbnSdN/X9MndJBkxJ7l4b7DHgkM+G8O19zd27skxz1ywQewfIrGHQq4o9P
         bCeZAlUxbK4VuYm2wXwUKvEo8U0Ai005IdlzfFMTu0LYkfrYQAsbe3SvJh8gY6DANh
         PC4mOAFTTMI43JckWE0WwC75a753LS6px95gnMlpQHRbYwuy2HnQJs1201x43XoTKt
         V1WXwHIq6M+F5hmEguVcHE5L/QYuO4ONEpHo6tSOR/0rVylbNkTvBA5X6EHosHhtg7
         dnr7ifmE3oRNQ==
Received: by mail-vk1-f174.google.com with SMTP id a66so534602vkc.3;
        Thu, 20 Oct 2022 15:06:22 -0700 (PDT)
X-Gm-Message-State: ACrzQf3aWj6UBvP0xfvNjuK4AQnZUZmrY3i3V1f1JUKE0YW6zry/yB9+
        vvpqMYmYavtfovmdY2+0GYqqM0o51rDv6Mu1Pg==
X-Google-Smtp-Source: AMsMyM4AlVdebaHlddeCi13gpZs/ZxpSNKAz6ATtMZsm9Gau8xHw25ymZZEs8Df/CGSiDgOtAWC2KxSw2+7ZKzRCqWQ=
X-Received: by 2002:a1f:60cd:0:b0:3ae:da42:89d0 with SMTP id
 u196-20020a1f60cd000000b003aeda4289d0mr8750783vkb.15.1666303581383; Thu, 20
 Oct 2022 15:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk> <E1ol97m-00EDSR-46@rmk-PC.armlinux.org.uk>
 <166622204824.13053.10147527260423850821.robh@kernel.org> <Y1EGqR6IEhPfx7gd@shell.armlinux.org.uk>
 <20221020141923.GA1252205-robh@kernel.org> <CAL_JsqKn0bn4nnzXXyZEVv9ZsFA6UXpV2SDHW7nkncH3Z3tsKA@mail.gmail.com>
 <Y1FydexHzzOKS1V+@shell.armlinux.org.uk>
In-Reply-To: <Y1FydexHzzOKS1V+@shell.armlinux.org.uk>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 20 Oct 2022 17:06:12 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKrJppdZzH2xtb+0SjJwir0rpdEzrGCf43t03eGriz3gg@mail.gmail.com>
Message-ID: <CAL_JsqKrJppdZzH2xtb+0SjJwir0rpdEzrGCf43t03eGriz3gg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/7] dt-bindings: net: sff,sfp: update binding
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 11:08 AM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Thu, Oct 20, 2022 at 09:27:44AM -0500, Rob Herring wrote:
> > On Thu, Oct 20, 2022 at 9:19 AM Rob Herring <robh@kernel.org> wrote:
> > >
> > > On Thu, Oct 20, 2022 at 09:28:25AM +0100, Russell King (Oracle) wrote=
:
> > > > On Wed, Oct 19, 2022 at 06:31:53PM -0500, Rob Herring wrote:
> > > > > On Wed, 19 Oct 2022 14:28:46 +0100, Russell King (Oracle) wrote:
> > > > > > Add a minimum and default for the maximum-power-milliwatt optio=
n;
> > > > > > module power levels were originally up to 1W, so this is the de=
fault
> > > > > > and the minimum power level we can have for a functional SFP ca=
ge.
> > > > > >
> > > > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.u=
k>
> > > > > > ---
> > > > > >  Documentation/devicetree/bindings/net/sff,sfp.yaml | 2 ++
> > > > > >  1 file changed, 2 insertions(+)
> > > > > >
> > > > >
> > > > > My bot found errors running 'make DT_CHECKER_FLAGS=3D-m dt_bindin=
g_check'
> > > > > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> > > > >
> > > > > yamllint warnings/errors:
> > > > >
> > > > > dtschema/dtc warnings/errors:
> > > > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bi=
ndings/net/sff,sfp.yaml: properties:maximum-power-milliwatt: 'minimum' shou=
ld not be valid under {'enum': ['const', 'enum', 'exclusiveMaximum', 'exclu=
siveMinimum', 'minimum', 'maximum', 'multipleOf', 'pattern']}
> > > > >     hint: Scalar and array keywords cannot be mixed
> > > > >     from schema $id: http://devicetree.org/meta-schemas/keywords.=
yaml#
> > > >
> > > > I'm reading that error message and it means absolutely nothing to m=
e.
> > > > Please can you explain it (and also re-word it to be clearer)?
> > >
> > > 'maxItems' is a constraint for arrays. 'maximum' is a constraint for
> > > scalar values. Mixing them does not make sense.
> >
> > TBC, dropping 'maxItems' is what is needed here.
>
> So how does this work?

Do you really want to know? ;)

>
> maxItems: 1

json-schema happily ignores any keywords that it doesn't understand or
don't make sense for a specific context. The DT meta-schema tries to
prevent that.

> tells it that there should be an array of one property, which is at the
> DT level fundamentally the same as a scalar property.

Yes, it is true that the YAML encoded DT and (currently) the internal
encoding used by the tools encode everything as matrices simply
because dtc doing the YAML encoding doesn't know the types beyond what
DTS source level provides, so everything has to be the same encoding.
Now we use the type information in the schemas to decode the DTBs
directly and don't have that limitation. Once I remove the YAML
encoding, we can stop encoding everything as a matrix and having to
fixup the schemas from scalar -> array -> matrix.

> minimum:
> default:
> maximum:
>
> tells it that this is a scalar property, so there should be exactly one
> item or the property should not be mentioned?

Not sure I follow the question. As the property is defined as a
scalar, it only needs scalar keywords. Internally, the schema gets
expanded to:

prop:
  minItems: 1
  maxItems: 1
  items:
    - maxItems: 1
      minItems: 1
      items:
        - maximum: ???
          minimum: ???
          default: ???

This is what processed-schemas.json will contain if you just have the
scalar keywords.

It's a bit more messy now with the unit suffixes as initially they
were all scalars, but over time we've had to allow for arrays. So it's
really they default to scalars unless you need an array in which you
can define:

prop:
  maxItems: 2
  items:
    maximum: ???

Could you do 'maxItems: 1' here? Yes, that would be a valid schema,
but IIRC we'll still complain because it is redundant.

Rob
