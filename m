Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A605E4A3069
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 17:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351649AbiA2QCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 11:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349121AbiA2QCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 11:02:44 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1377DC061714;
        Sat, 29 Jan 2022 08:02:44 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id s16so7924053pgs.13;
        Sat, 29 Jan 2022 08:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZgycSTmdEVS3UMK+SZ2VDh/3h8V+r6g5hyN2V5SrbbA=;
        b=RgYQpG2FlQRNNSA5Sjc3zrPpVKbLhD8S9obualpBqIQROyqRvFji8mAC4hl1ogdEMs
         qtoFisGkm4yrx4FASkNz6Swi+7x5FZ6ECPY8LdeEBfuusMoYC/qrswmY7iYA4+Fmrt/i
         RUaXyKlafewNksonZwM5xrL+wxLB28kDUULTwhfo9NlLyUZk8KIJRQ/kuJeNyY1KmLVZ
         N5CNcEB3cnUVJy7FWvn3NzrAtat1iT3FXHX8ZrFGyfWYpHWxAySN1EeLqJtD2ukOPrHX
         3xT1byG8Va0po398d5LCCgtrQm09ko9ix+XE5HVLFTnlsqzRn7t/RRp0pSAOTmJx42Pb
         AHyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZgycSTmdEVS3UMK+SZ2VDh/3h8V+r6g5hyN2V5SrbbA=;
        b=6m00of3QvSRBU8bc93GtUrdLBfKqf9Rhh5ln/niLkqnqDfpPyDa8f6qEdjIQ+YWPAu
         bnD5sdoe2lFt/jHwNJjMseH+3dV1UO9So+tGr+DbSZ9zyExvV5Dsfw/3dcpRaKS6ldLe
         3NB0V11+CEgNqmA8qISrvpVR+Pw8uQGmLkER7ZSy1JCwVPKy68pUJLIS88lcqmn6hAZ3
         Qb6sw7Y8ALZuXUErpfjtrbwg+mNGMxwp7T1sssfdZWBCPLDQoArP0Ua2R+m4gmPM0feL
         aKiYGoPxjMj0bXCcz4y6vUARBjH0dtpec5uKxqk8tOa28Aa5ETfRZ784KK77nyPWfVq1
         YSSg==
X-Gm-Message-State: AOAM533RuUNUZ1MfxHjLcT2zKnIqQkdiJ2DK09niRjDqcq6hzzvwNHcI
        nwjcASi/HBGDLrNlBkEa7OIlklbdG97CZOWNP/Q=
X-Google-Smtp-Source: ABdhPJyjC4g+Cdo5ZCzR7r+CNDlmK0RK6WFO9bjmnYQ5k6P86MFmZRqhyG14Jb6Qn1949BAylSMMJx5nfxoZV5sa5vY=
X-Received: by 2002:a62:190b:: with SMTP id 11mr12338535pfz.77.1643472163390;
 Sat, 29 Jan 2022 08:02:43 -0800 (PST)
MIME-Version: 1.0
References: <20211228072645.32341-1-luizluca@gmail.com> <Ydx4+o5TsWZkZd45@robh.at.kernel.org>
In-Reply-To: <Ydx4+o5TsWZkZd45@robh.at.kernel.org>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 29 Jan 2022 13:02:32 -0300
Message-ID: <CAJq09z4G40ttsTHXtOywjyusNLSjt_BQ9D78PhwSodJr=4p6OA@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML schema
To:     Rob Herring <robh@kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Rob, now that the code side is merged, I'm back to docs.


> > +      interrupt-controller:
> > +        description: see interrupt-controller/interrupts.txt
>
> Don't need generic descriptions. Just 'true' here is fine.

Do you really mean quoted true, like in "description: 'true' "?
Without quotes it will fail
>
> > +
> > +      interrupts:
> > +        description: TODO
>
> You have to define how many interrupts and what they are.

I didn't write the interruption code and Linus and Alvin might help here.

The switch has a single interrupt pin that signals an interruption happened.
The code reads a register to multiplex to these interruptions:

INT_TYPE_LINK_STATUS = 0,
INT_TYPE_METER_EXCEED,
INT_TYPE_LEARN_LIMIT,
INT_TYPE_LINK_SPEED,
INT_TYPE_CONGEST,
INT_TYPE_GREEN_FEATURE,
INT_TYPE_LOOP_DETECT,
INT_TYPE_8051,
INT_TYPE_CABLE_DIAG,
INT_TYPE_ACL,
INT_TYPE_RESERVED, /* Unused */
INT_TYPE_SLIENT,

And most of them, but not all, multiplex again to each port.

However, the linux driver today does not care about any of these
interruptions but INT_TYPE_LINK_STATUS. So it simply multiplex only
this the interruption to each port, in a n-cell map (n being number of
ports).
I don't know what to describe here as device-tree should be something
independent of a particular OS or driver.

Anyway, I doubt someone might want to plug one of these interruptions
outside the switch driver. Could it be simple as this:

      interrupts:
       minItems: 3
       maxItems: 10
       description:
         interrupt mapping one per switch port

Once realtek-smi.yaml settles, I'll also send the realtek-mdio.yaml.

Regards,

Luiz
