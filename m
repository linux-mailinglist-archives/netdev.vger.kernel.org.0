Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70099606304
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 16:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiJTO2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 10:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiJTO17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 10:27:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55171AFA8A;
        Thu, 20 Oct 2022 07:27:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B308961BB2;
        Thu, 20 Oct 2022 14:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2605CC43141;
        Thu, 20 Oct 2022 14:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666276075;
        bh=1ax9sjIZJ5Yiw8weIKYobKvO/epcCKBdxDxODrM4zZk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YUEtenW2+DDbdwt5k/vuf1liYoF6LXdX8SWWR/KKomvBaUsFYcuwENP8lPuPYhPDU
         Z/jymzIz9mCtVehXvxFLf8ZtwFCkBjBzcqvPEr3zv7cT3GcKgGw1oZ/Agrau8N2yZ1
         BUawmbIbDB449pEPBd+frQja6HuYdyP46PUAtPQXGj+boT9DyDyqvs9DvVNwS3X3Wk
         1153sEHP2bzoaj23z/lacNRaVwdmVhW87JxSsKx4rC2ebEyovmlyEee1tbqV6UbN8e
         RWR/9DU/n3cx9YEW041vETcivFl/lqQLVPBS2kEK4rMmzCzT+sTIDsEoiQSns8aIog
         wEQrYMLL03Kew==
Received: by mail-vk1-f174.google.com with SMTP id v81so9890286vkv.5;
        Thu, 20 Oct 2022 07:27:55 -0700 (PDT)
X-Gm-Message-State: ACrzQf3GA0gtFDExmXHeP15AyRz0scLWV8vzlr4APcZypP4EQlnVAGbP
        3YeQyhRtPp+Yelv7a/qyXirpHAP1UudjM64eVQ==
X-Google-Smtp-Source: AMsMyM4q3iwUK9QMJGLKeeMe6KJ6ttFOGgFnQlz1h2neCyn2xtgfKUowmQKrZ+t+xmI3iRxyTrpEO/9hLk75iSyMdPc=
X-Received: by 2002:a1f:3d4c:0:b0:3aa:feb8:3ec6 with SMTP id
 k73-20020a1f3d4c000000b003aafeb83ec6mr6934654vka.26.1666276073990; Thu, 20
 Oct 2022 07:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk> <E1ol97m-00EDSR-46@rmk-PC.armlinux.org.uk>
 <166622204824.13053.10147527260423850821.robh@kernel.org> <Y1EGqR6IEhPfx7gd@shell.armlinux.org.uk>
 <20221020141923.GA1252205-robh@kernel.org>
In-Reply-To: <20221020141923.GA1252205-robh@kernel.org>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 20 Oct 2022 09:27:44 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKn0bn4nnzXXyZEVv9ZsFA6UXpV2SDHW7nkncH3Z3tsKA@mail.gmail.com>
Message-ID: <CAL_JsqKn0bn4nnzXXyZEVv9ZsFA6UXpV2SDHW7nkncH3Z3tsKA@mail.gmail.com>
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

On Thu, Oct 20, 2022 at 9:19 AM Rob Herring <robh@kernel.org> wrote:
>
> On Thu, Oct 20, 2022 at 09:28:25AM +0100, Russell King (Oracle) wrote:
> > On Wed, Oct 19, 2022 at 06:31:53PM -0500, Rob Herring wrote:
> > > On Wed, 19 Oct 2022 14:28:46 +0100, Russell King (Oracle) wrote:
> > > > Add a minimum and default for the maximum-power-milliwatt option;
> > > > module power levels were originally up to 1W, so this is the defaul=
t
> > > > and the minimum power level we can have for a functional SFP cage.
> > > >
> > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > ---
> > > >  Documentation/devicetree/bindings/net/sff,sfp.yaml | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > >
> > > My bot found errors running 'make DT_CHECKER_FLAGS=3D-m dt_binding_ch=
eck'
> > > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> > >
> > > yamllint warnings/errors:
> > >
> > > dtschema/dtc warnings/errors:
> > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindin=
gs/net/sff,sfp.yaml: properties:maximum-power-milliwatt: 'minimum' should n=
ot be valid under {'enum': ['const', 'enum', 'exclusiveMaximum', 'exclusive=
Minimum', 'minimum', 'maximum', 'multipleOf', 'pattern']}
> > >     hint: Scalar and array keywords cannot be mixed
> > >     from schema $id: http://devicetree.org/meta-schemas/keywords.yaml=
#
> >
> > I'm reading that error message and it means absolutely nothing to me.
> > Please can you explain it (and also re-word it to be clearer)?
>
> 'maxItems' is a constraint for arrays. 'maximum' is a constraint for
> scalar values. Mixing them does not make sense.

TBC, dropping 'maxItems' is what is needed here.

Rob
