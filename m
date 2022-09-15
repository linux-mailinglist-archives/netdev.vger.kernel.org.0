Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F66E5B9B9B
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 15:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiIONJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 09:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiIONJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 09:09:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C538DBCAC;
        Thu, 15 Sep 2022 06:09:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88A88B81FC9;
        Thu, 15 Sep 2022 13:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426E6C433D6;
        Thu, 15 Sep 2022 13:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663247377;
        bh=voBOspV7bMcyAOeL4IXlWZdmHt1ofLGAWeFr9pfd3M4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FcSEB4Tu2M7hJtZN17ny7jw+FIqagkELjq6XkReA+6TvW2/pXT9ZtXAHbgO/LZbhm
         OoZfZaIRT0dk6GSM3C0ae0MOlpPBbmovziyTkFgM/YlTCzxyTevh3oaopIslBUziB4
         gwS+HJYwTjcFOYQQX6DyoCCK4ewTi7skLGH5HYGhHw1CUyO1rKb/j8YYuDqnJhqOKK
         cF1d4z0tr3bjhR5n9zwrEkepBbCHj6afLDe1QkZtzOLxbMVJLU8kTgMyUvZiBaA/gp
         JH6UBPG2B6PalwKfdGYtcPAsCVJ3De9e938M6EJbwPl1AvmgERkat4KXcKrqqNOzUi
         oS60f2AwuICRQ==
Received: by mail-vs1-f46.google.com with SMTP id 129so19217668vsi.10;
        Thu, 15 Sep 2022 06:09:37 -0700 (PDT)
X-Gm-Message-State: ACgBeo3wZccEcc8Koq2R3uN6a1uuPpLVV99rqytpw3x/yaTf+r05hTn6
        Oo32B5y8NVe3itdtzN25ZhwyFemG8sO8uhJNhQ==
X-Google-Smtp-Source: AA6agR4BIfzeSUOkNKwBmMYoVvW5yb/Z1HSv0FwqqEWLBeGrUkIu+Mdpm6vlUlMr86ifsZh2UV/yNNG8p8uNEyrklF0=
X-Received: by 2002:a67:ad12:0:b0:398:3d57:33e0 with SMTP id
 t18-20020a67ad12000000b003983d5733e0mr11010446vsl.6.1663247375551; Thu, 15
 Sep 2022 06:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220907170935.11757-1-sven@svenpeter.dev> <20220907170935.11757-3-sven@svenpeter.dev>
 <bcb799ea-d58e-70dc-c5c2-daaff1b19bf5@linaro.org> <20220912211226.GA1847448-robh@kernel.org>
In-Reply-To: <20220912211226.GA1847448-robh@kernel.org>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 15 Sep 2022 08:09:24 -0500
X-Gmail-Original-Message-ID: <CAL_JsqL96Er9JuDajHWtf=i7bvzrf7PLzk-G-Qm4wTxTr5BStg@mail.gmail.com>
Message-ID: <CAL_JsqL96Er9JuDajHWtf=i7bvzrf7PLzk-G-Qm4wTxTr5BStg@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] dt-bindings: net: Add Broadcom BCM4377 family PCIe Bluetooth
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sven Peter <sven@svenpeter.dev>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, netdev <netdev@vger.kernel.org>,
        devicetree@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 4:12 PM Rob Herring <robh@kernel.org> wrote:
>
> On Thu, Sep 08, 2022 at 01:19:17PM +0200, Krzysztof Kozlowski wrote:
> > On 07/09/2022 19:09, Sven Peter wrote:
> > > These chips are combined Wi-Fi/Bluetooth radios which expose a
> > > PCI subfunction for the Bluetooth part.
> > > They are found in Apple machines such as the x86 models with the T2
> > > chip or the arm64 models with the M1 or M2 chips.
> > >
> > > Signed-off-by: Sven Peter <sven@svenpeter.dev>
> > > ---

> > > +examples:
> > > +  - |
> > > +    pcie {
> > > +      #address-cells = <3>;
> > > +      #size-cells = <2>;
> > > +
> > > +      bluetooth@0,1 {
> >
> > The unit address seems to be different than reg.
>
> Right, this says dev 0, func 1.

Actually, the reg value of 0x100 is correct. func is bits 8-10. dev
starts in bit 11.

Rob
