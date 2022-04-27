Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC4B5124AF
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 23:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbiD0Vq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 17:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234135AbiD0Vqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 17:46:55 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F90D90CF6;
        Wed, 27 Apr 2022 14:43:43 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so4093917pjb.3;
        Wed, 27 Apr 2022 14:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fK8ie2EVzVXoUL/CWYGjwnNVixgs+iO/GFvY62KiDxQ=;
        b=BC/OG6PuUD2/8Qqlqp4KrTYo1g6ZKwfhdiKtjDS7LgNOJabHlYX6x7TI+3TmNxXikJ
         +BFFj7Zx45HhnZm30RnPXSGJUdgeddxVi/j4/Hsab2a8U7sGwrezKv7gA/PtW4g5QfbX
         kMMAAI8AvbugNak41XERlIvfFpyx/HC8ctxD8xEV0txKGIKcDuJ+0O7w4ySki/A2cUSd
         l1qIdN5+UfZqmMF3tZk5cgiXQz3/wi6WB7TxL/PQSnNtokKfo4oIi7+gacV+rQi6dDU5
         mDMN3Q+Mim9iwuAipMOQ5uDIwtl6kPdt3heS7MY0ded8iEixIJr2dR34dN0rD4SsK3NS
         wASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fK8ie2EVzVXoUL/CWYGjwnNVixgs+iO/GFvY62KiDxQ=;
        b=D6ZwS/h4jj6krLzzv/qEgtIlgIIwCbI5NIV0Yd/jmL0NzfaQD/6kNS8/a9qL3nXBlO
         JMHopcMcmZH4d+5BBMxzqFhxMZOGWqbC3CeqVM940Oq9e5JbfIxqoG8m+sWmsw8tXXV+
         T8UCei3M3Wm5pQGVkqIS+43MfQVQTrLAah+Ww9hy53FkKc/dqo7htoTZy7MpZqzqkvgh
         6ArG91ByLDInQGGlMDySJ9xI6b3lBFXchhnn/Qa4zgC4ambtjxY/Qczx8i2DUxvAvca2
         zd/VDtnB0ugV0AB6GzvB7s+uDbN6I8l3A1UUOEPpE/3nxiDA34tMUqUBHd/gaO4F5FqN
         JZFg==
X-Gm-Message-State: AOAM531oZ+wI3F6w6YjTaGFIwqWMEdMTjnIM+DkHk5af+1H8CI31GV85
        zY66mUwqcDpSCeSiZNlw3ADoaZk3qbqFpf8jZCHhjKnRQRY=
X-Google-Smtp-Source: ABdhPJytXBsy/12vkMd15iuOeFr6Xo9JIav33CyBdBuMu8Ek0cQ9eyrD6l0bJu8VC7NsoKBVqGSf+pLoMe2NyERtQUY=
X-Received: by 2002:a17:90a:3486:b0:1d9:3abd:42ed with SMTP id
 p6-20020a17090a348600b001d93abd42edmr26745345pjb.32.1651095822600; Wed, 27
 Apr 2022 14:43:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220418233558.13541-1-luizluca@gmail.com> <Ymbs9ri8JJXTM8XO@robh.at.kernel.org>
In-Reply-To: <Ymbs9ri8JJXTM8XO@robh.at.kernel.org>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 27 Apr 2022 18:43:31 -0300
Message-ID: <CAJq09z4aHS5aZz2U-=GtMfqc+QjOaX937DYHK7aUWii=GcDvwA@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
To:     Rob Herring <robh@kernel.org>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, krzk+dt@kernel.org,
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

> On Mon, Apr 18, 2022 at 08:35:57PM -0300, Luiz Angelo Daros de Luca wrote:
> > Compatible strings are used to help the driver find the chip ID/version
> > register for each chip family. After that, the driver can setup the
> > switch accordingly. Keep only the first supported model for each family
> > as a compatible string and reference other chip models in the
> > description.
>
> The power supplies needing power before you can actually read the ID
> registers are the same for all the variations?
>
> The RTL8366s has a serdes power supply while the RTL8370 does not. Maybe
> that doesn't matter as the PHYs probably don't need power to access
> registers, but I didn't look at more than 2 datasheets. If there's *any*
> differences in power sequencing then you need specific compatibles.

Hi Rob,

I don't believe we would need to deal with any special power sequences
in order to read the switch registers.
Anyway, if we face a situation where we do need to handle a special
device differently, it is always less drastic to add a new compatible
string than to remove one already in use.

Regards,

Luiz
