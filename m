Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF0B509170
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 22:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382116AbiDTUb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 16:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344777AbiDTUb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 16:31:59 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017C045079;
        Wed, 20 Apr 2022 13:29:12 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s137so2713679pgs.5;
        Wed, 20 Apr 2022 13:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rObiaDgQDk863msBv17PFLEYc8NPQfPCbhsT1o3EMrk=;
        b=W57BRu9PvS8sZ40h4NtRjJ8oh1cg8hrnT0MnJELbV9Xdoj0/59DYNWXxTSFVG1dJW+
         yCNtBkrTUG3P9k+HVMgjHa7obLlrzCXglyI03h2qXEAL7LMTXrk3dI5sB1SCNvltXIA+
         WMqfPPPl87SnTD7n+M741LeDFM8B3fOjMN6mIiHfNtyCv4KWDULSx3ymE99whl7gAa1H
         I6kUmXB/7gToZltsLHWR5Dm+8jre2DcwKM8ErIpq7zGwerxHLRg/dTjL5XTqKoWV9ZzH
         qhOY0vlAK2WmZFw7spHOuWb31LloJ/M4TzxEIMLaH+fJYXG1oQxb1ukXt33h7RzXEB2I
         snXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rObiaDgQDk863msBv17PFLEYc8NPQfPCbhsT1o3EMrk=;
        b=XV46l05/kEgIMAmCjRcBMaY7y9HZ+ydQh+B3c/6CGbVOtFm7s/7X81W8Cf+A0b+3Sm
         mMt/gCnhaUTmH4DzbV8vbU+T+jO0oM4xtuf57TYoA7dK0gkbjGSWrgTXW/RkSK0jxOax
         p95TVw0rhigl+/QImt7x66kqrEs9m/taQeKvBbpVPZW0jkYGVde/goqCmrwwQZ9+UzzX
         3pow4G0l7mgJF4JaG7lkvSB4QYE+wO4/rPTRCLFFqnBpRap8Esg4FlSaVOeik6mBdfh1
         bLAw8kpyzcEvpZsjFGM8f5t6FQc9By9qBa4DjgpCLF4REUAVRnBFn2AuGYSyaqANdNVa
         iwTQ==
X-Gm-Message-State: AOAM533nUL6QdEo/rEsUHPD04gUkhRoCJlAs3VTpNud426ZPERkht4me
        0U+Eqh6emxY0sHc2v0a5iylrI9oaCoHxi7mK3TY=
X-Google-Smtp-Source: ABdhPJxOpKpoVOMulS78oyHNlwEC4pIp/nuKZRgbLunmXx0ea++9kPgdQAHuqYfm+hsW7JaNtwkYMkxnvuGmr6ncb/M=
X-Received: by 2002:a63:e90a:0:b0:3aa:2c41:87b4 with SMTP id
 i10-20020a63e90a000000b003aa2c4187b4mr10315050pgh.118.1650486551525; Wed, 20
 Apr 2022 13:29:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220418233558.13541-1-luizluca@gmail.com> <165044941250.8751.17513068846690831070.git-patchwork-notify@kernel.org>
In-Reply-To: <165044941250.8751.17513068846690831070.git-patchwork-notify@kernel.org>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 20 Apr 2022 17:29:00 -0300
Message-ID: <CAJq09z5zU1WT4bHjv-=aX49XweKnOmLhnL2w8gSaBe7=Ov1APw@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
To:     "David S. Miller" <davem@davemloft.net>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, krzk+dt@kernel.org,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This series was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:
>
> On Mon, 18 Apr 2022 20:35:57 -0300 you wrote:
> > Compatible strings are used to help the driver find the chip ID/version
> > register for each chip family. After that, the driver can setup the
> > switch accordingly. Keep only the first supported model for each family
> > as a compatible string and reference other chip models in the
> > description.
> >
> > The removed compatible strings have never been used in a released kernel.
> >
> > [...]
>
> Here is the summary with links:
>   - [net,v2,1/2] dt-bindings: net: dsa: realtek: cleanup compatible strings
>     https://git.kernel.org/netdev/net-next/c/6f2d04ccae9b
>   - [net,v2,2/2] net: dsa: realtek: remove realtek,rtl8367s string
>     https://git.kernel.org/netdev/net-next/c/fcd30c96af95
>

Hi David,

I was expecting to get those patches merged to net as well. Otherwise,
the "realtek,rtl8367s" we are removing will get into a released
kernel.

Regards,
