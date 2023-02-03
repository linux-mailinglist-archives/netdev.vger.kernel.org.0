Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B10689C0F
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbjBCOlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjBCOlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:41:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05414C00;
        Fri,  3 Feb 2023 06:41:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0BCE8CE303C;
        Fri,  3 Feb 2023 14:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A98C433A0;
        Fri,  3 Feb 2023 14:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675435301;
        bh=aSsCAsgpLn8Nh2RoLgCu1FwifDval96mr38LdqDofP4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lQARH19+JJc/qQ657fHWRjoOsZ7uM7xGiTACSr4Z7TpaOID0SQHPeDW1QSfCSSE+y
         a7bvfj0+8l0DsbwuGhkXfD6tLSaqmaapz01S1pmZeBEzDTxoLUaWXrDIoLXfSjBN1u
         SEInskwTuXKoSXMlk5EkrMREPMPc0BkoN/609UxQYw4JQaBy/5+J3AlbBZWXlrBq9v
         MaDKx8xxgipmb23CH6Qp5lITlrfLoMdfZ3hrxaWijHjU/N6z+E+oqrrRXDBazAvz5s
         HYsR/VzG4OSByOG/aDq9RSIKohWhmqU2Lhsv08cHrA6ll/XsfyGCdukZmgZlOK+0ZA
         9NNAmk+GRo9Fw==
Received: by mail-vs1-f46.google.com with SMTP id e9so5575958vsj.3;
        Fri, 03 Feb 2023 06:41:41 -0800 (PST)
X-Gm-Message-State: AO0yUKUvlUzp9VMJeHLeMm76KuF75w666Q90UfgvFAiQU4iYnVzk+zuH
        QJOCgH5EFxG9zlq6enxwXe5zO+xvjRRqK3OGMg==
X-Google-Smtp-Source: AK7set91RP4lU4aTvuhe1XUgAHWEWaGbEJPsanRYf49Cujn2Gdpsc3aBBiPBWZFzfWUsAj6GCPQGp5EnCAQIU7z2r0w=
X-Received: by 2002:a05:6102:3e0c:b0:3b5:1fe4:f1c2 with SMTP id
 j12-20020a0561023e0c00b003b51fe4f1c2mr1612207vsv.0.1675435300404; Fri, 03 Feb
 2023 06:41:40 -0800 (PST)
MIME-Version: 1.0
References: <20230203-dt-bindings-network-class-v1-0-452e0375200d@jannau.net>
In-Reply-To: <20230203-dt-bindings-network-class-v1-0-452e0375200d@jannau.net>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 3 Feb 2023 08:41:28 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKD7gD86_B93M19rBCWn+rmSw24vOGEhqi9Nvne1Xixwg@mail.gmail.com>
Message-ID: <CAL_JsqKD7gD86_B93M19rBCWn+rmSw24vOGEhqi9Nvne1Xixwg@mail.gmail.com>
Subject: Re: [PATCH RFC 0/3] dt-bindings: net: Add network-class.yaml schema
To:     Janne Grunau <j@jannau.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 3, 2023 at 7:56 AM Janne Grunau <j@jannau.net> wrote:
>
> The Devicetree Specification, Release v0.3 specifies in section 4.3.1
> a "Network Class Binding". This covers MAC address and maximal frame
> size properties. "local-mac-address" and "mac-address" with a fixed
> address-size of 48 bits is already in the ethernet-controller.yaml
> schema so move those over.
> I think the only commonly used values for address-size are 48 and 64
> bits (EUI-48 and EUI-64). Unfortunately I was not able to restrict the
> mac-address size based on the address-size. This seems to be an side
> effect of the array definition and I was not able to restrict "minItems"
> or "maxItems" based on the address-size value in an "if"-"then"-"else"
> block.
> An easy way out would be to restrict address-size to 48-bits for now.

I've never seen 64-bits used...

> I've ignored "max-frame-size" since the description in
> ethernet-controller.yaml claims there is a contradiction in the
> Devicetree specification. I suppose it is describing the property
> "max-frame-size" with "Specifies maximum packet length ...".

Please include it and we'll fix the spec. It is clearly wrong. 2 nios
boards use 1518 and the consumer for them says it is MTU. Everything
else clearly uses mtu with 1500 or 9000.

> My understanding from the dt-schema README is that network-class.yaml
> should live in the dt-schema repository since it describes properties
> from the Devicetree specification. How is the synchronization handled in
> this case? The motivation for this series is to fix dtbs_check failures
> for Apple silicon devices both in the tree and upcoming ones.

Let's add it to the kernel, then later we can copy it to dtschema,
bump the minimum version the kernel requires, and delete the kernel
copy.

Rob
