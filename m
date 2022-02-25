Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6A24C3E3F
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 07:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236951AbiBYGLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 01:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiBYGL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 01:11:29 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B5B73062
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 22:10:58 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id c9so3980216pll.0
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 22:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G+8HoqTrDljCcIRzGjz+DRsOPNvwTX/KQYweK0U9SqE=;
        b=fF9346aHqcQxuzOssy2heNJkDNfCmKz5dzeRCfaN41sAqAWFAzOltR78Ba2+2xkcy9
         R0Xmoywbj57tqtA2Zr92FuuDPh1p+FW53KZjENp+vHMf9rwz7BFt8i5jecdbUYD0jeMn
         MJqr/mDjiiD6Oh7tQwcATsCgcD8PriyGgVUUEf1kUUvZb2c0qOtbdKfEcMKeWDwv9tIj
         Xa+wWzwIJ5w2kECGMiCTB/IxfqWBVmdrrkmShhXIwNwpVQALwefRi55mY9u8HXVFNNTH
         g9xwqYjMAhVeUTMWt+0+g2MRInfPLMkH/SX4G8pVeuydWUq2BiY42+87C4wW6tNy5d3h
         kNhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G+8HoqTrDljCcIRzGjz+DRsOPNvwTX/KQYweK0U9SqE=;
        b=1bbASGrZx/t2qufm9stJ+k24gAWok6l0SNCm7HQUkwOsEBcr878vewD89mov7YXP3m
         Rh1FO3CJTcc68mSIpD/bpLBZIZ1lBknr1YXS4weZ5GvAkb82wnvfXrJeApmn6rFAr4os
         s6kJeNekYrEnMWXRKcTSW2TDdEBibKtwvGyEwRPMZYW/BXeQBfwh/99j8aP5XSaWwTK9
         HNHlELM6NC4FD5RwnQmB3chYco0U7IKi26ZaNE4RT4DeNf1eablxNLx8hfxvcFhJb2J3
         +jRrQWs15TtdYnmAOy6uHx+2PMntoHCR76vAk0HCFLYTOWgaWCB/mSr0G12v1/yFTvqw
         dESA==
X-Gm-Message-State: AOAM530TdzoQIeDgcmKHdFUHYSuKbGKfrPp56GH0YuH5AKisjaEgy0ts
        9ld02iq2zAhuv09ck5ocu+cb4G6KknpZnv1ulMxu7DVX1AFC6A==
X-Google-Smtp-Source: ABdhPJyE0/AGs3K3kB1WUFLs617OpgX1ve3OMtc0in1nx5BDj8ifRMaLPAJHwFxVfWKBrHA72xhLq+zT5YGesw6Fy6A=
X-Received: by 2002:a17:902:9690:b0:14f:fc09:fd02 with SMTP id
 n16-20020a170902969000b0014ffc09fd02mr5946486plp.66.1645769457555; Thu, 24
 Feb 2022 22:10:57 -0800 (PST)
MIME-Version: 1.0
References: <20220222224758.11324-1-luizluca@gmail.com> <20220222224758.11324-2-luizluca@gmail.com>
 <20220224000423.6cb33jf47pl4e36h@skbuf>
In-Reply-To: <20220224000423.6cb33jf47pl4e36h@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 25 Feb 2022 03:10:46 -0300
Message-ID: <CAJq09z4EXxRr-H3TkoFOA2hNiFqdwA_w-dOgUqHaVogNP0n_KQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/2] net: dsa: tag_rtl8_4: add rtl8_4t
 trailing variant
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em qua., 23 de fev. de 2022 =C3=A0s 21:04, Vladimir Oltean
<olteanv@gmail.com> escreveu:
>
> On Tue, Feb 22, 2022 at 07:47:57PM -0300, Luiz Angelo Daros de Luca wrote=
:
> > diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
> > index 02686ad4045d..2e81ab49d928 100644
> > --- a/net/dsa/tag_rtl8_4.c
> > +++ b/net/dsa/tag_rtl8_4.c
> > @@ -9,11 +9,6 @@
> >   *
> >   * This tag header has the following format:
> >   *
> > - *  -------------------------------------------
> > - *  | MAC DA | MAC SA | 8 byte tag | Type | ...
> > - *  -------------------------------------------
> > - *     _______________/            \__________________________________=
____
> > - *    /                                                               =
    \
> >   *  0                                  7|8                            =
     15
> >   *  |-----------------------------------+-----------------------------=
------|---
> >   *  |                               (16-bit)                          =
      | ^
> > @@ -58,6 +53,28 @@
> >   *    TX/RX      | TX (switch->CPU): port number the packet was receiv=
ed on
> >   *               | RX (CPU->switch): forwarding port mask (if ALLOW=3D=
0)
> >   *               |                   allowance port mask (if ALLOW=3D1=
)
> > + *
> > + * The tag can be positioned before Ethertype, using tag "rtl8_4":
> > + *
> > + *  +--------+--------+------------+------+-----
> > + *  | MAC DA | MAC SA | 8 byte tag | Type | ...
> > + *  +--------+--------+------------+------+-----
> > + *
> > + * If checksum offload is enabled for CPU port device, it might break =
if the
> > + * driver does not use csum_start/csum_offset.
>
> Please. This is true of any DSA header. If you feel you have something
> to add on this topic please do so in Documentation/networking/dsa/dsa.rst
> under "Switch tagging protocols".

OK. I'll remove it from this series and add that info to docs in an
independent commit.

> Also, s/CPU port device/DSA master/.
>
> > + *
> > + * The tag can also appear between the end of the payload and before t=
he CRC,
> > + * using tag "rtl8_4t":
> > + *
> > + * +--------+--------+------+-----+---------+------------+-----+
> > + * | MAC DA | MAC SA | TYPE | ... | payload | 8-byte tag | CRC |
> > + * +--------+--------+------+-----+---------+------------+-----+
> > + *
> > + * The added bytes after the payload will break most checksums, either=
 in
> > + * software or hardware. To avoid this issue, if the checksum is still=
 pending,
> > + * this tagger checksum the packet before adding the tag, rendering an=
y
>
> s/checksum/checksums/
>
> > + * checksum offload useless.
>
> If you're adding a tail tagging driver to work around checksum offload
> issues, this solution is about as bad as it gets. You're literally not
> gaining anything in performance over fixing your DSA master driver to
> turn off checksum offloading for unrecognized DSA tagging protocols.

I wasn't adding it as a way to disable offload but as an alternative
to keep the hardware offload enabled. However, in the end, if the HW
already does not understand the tag, adding a tag after the payload
will not only break checksum offload but the software checksum as
well.

> And on top of that, you're requiring your users to be aware of this
> issue and make changes to their configuration, for something that can be
> done automatically.

I don't see how we could automatically detect that in an unspecific
Ethernet driver. No driver expects to have some bytes after the
payload it should ignore. Not even the software checksum functions
consider that case. And we should not adapt all Ethernet drivers for
DSA. The easier solution is to calculate the checksum before the tag
was added, even if that prevents checksum offload for a possible
compatible HW. After the tag was added, it is already too late for the
driver to make a decision (with existing Linux code).

> Do you have another use case as well?

Allowing the user to change the tag position is a nice tool to detect
compatible problems. I got the checksum offload but it could also help
with stacking incompatible switches, when the switch does not like the
added Ethertype DSA tag.

Regards,

Luiz
