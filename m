Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F204BB18D
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 06:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiBRFjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 00:39:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiBRFjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 00:39:23 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0981A9350
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 21:39:07 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id h7-20020a17090a648700b001b927560c2bso7546345pjj.1
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 21:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H+oomYVdM6jBtUY7CazTqzeXDZ/f1IremrZHHCrNu5U=;
        b=qX1QTPUqDXgOTyHm6tIlpXn1uD6TWgNJQmdBjrxWVDl7kTpQZ6+hIwsl3xFcPhNPDM
         g5YRqAO9eo9QdKrPtudEKbQYcY3dk1lJwJv/5qcKiQPEy6CJnEettbe6tQceXvbhYZPg
         01RftjAFE2lGlRfluQt7Lx7eDiyNLmhhFz6gFZU3p4fLhNR4VybEA25l8XS+VdUFX8m3
         pL+P42VE2vYq6wZTd3m6TNt99vHzBYFm+Ai+SkstdB2eJ4JcpDvw+Tluc08Vzm77Yw7f
         +aSx1wRG8doLjgBmottIYI+fkW9Z7z8lP/gmv+KLoiibe0txBTWEf9wpm7NNczI5fJn/
         H1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H+oomYVdM6jBtUY7CazTqzeXDZ/f1IremrZHHCrNu5U=;
        b=5UEkB/2nIVrAS9OBL+QkPUikDAGJtIpELzGpsY2dxCI+85+DsEKog1s/9jr1yJ1/J0
         agcm08rdLjoN6Lz5pD3sNrEI4qDfvjAP/s/FPso54P950T/Ia99+ntRmxr3pJrF5uTlV
         8M/rt3MXVHgAY+1WzjlhvzNspWQyQ64UoqJQlkaa4+SimEXplK0TSGNHYnp6P+Py6JvW
         gQAKB8oWkkw8WLNXwRiALODA89KC0qFhh/z7hEOH8hFW9y1jGr5mXKN6sriSfBT378hA
         5pi9TqdHpMo1taT910tLtRJVYa7j6E9DCGtDFRGuYECriwyy7e6MbFVxkeQAJD8fqca4
         p8Ew==
X-Gm-Message-State: AOAM532mpJ2NPYjbW5NLqMJav+OVhxGTSY1Fec22A38tz4egDdcyucze
        X/XyfQcYjqAl407yhAKjzqL7QV46YX1If32vamI=
X-Google-Smtp-Source: ABdhPJy634gZpimnrqZewvqN6gQvEKeZCG8R9o3ipYTZHDwxB7d2C8mT3oG/SgHv5JO5T8jk6wn/EVJK3V1z4yzfI3g=
X-Received: by 2002:a17:90b:3806:b0:1b8:e628:d88 with SMTP id
 mq6-20020a17090b380600b001b8e6280d88mr11064734pjb.32.1645162747397; Thu, 17
 Feb 2022 21:39:07 -0800 (PST)
MIME-Version: 1.0
References: <20220209211312.7242-1-luizluca@gmail.com> <20220209211312.7242-3-luizluca@gmail.com>
 <20220209215712.tqytk6nosui7b2iu@skbuf>
In-Reply-To: <20220209215712.tqytk6nosui7b2iu@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 18 Feb 2022 02:38:56 -0300
Message-ID: <CAJq09z4AeASQWH-pq_rQbtGHFfpYPqd3+LmnUK9gOtZQ-zgMKA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: dsa: realtek: rtl8365mb: add support
 for rtl8_4t
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >  rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
> >                          enum dsa_tag_protocol mp)
> >  {
> > +     struct realtek_priv *priv = ds->priv;
> > +     u32 val;
> > +
> > +     /* No way to return error */
> > +     regmap_read(priv->map, RTL8365MB_CPU_CTRL_REG, &val);
> > +
> > +     switch (FIELD_GET(RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK, val)) {
> > +     case RTL8365MB_CPU_FORMAT_4BYTES:
> > +             /* Similar to DSA_TAG_PROTO_RTL4_A but with 1-byte version
> > +              * To CPU: [0x88 0x99 0x04 portnum]. Not supported yet.
> > +              */
> > +             break;
> > +     case RTL8365MB_CPU_FORMAT_8BYTES:
> > +             switch (FIELD_GET(RTL8365MB_CPU_CTRL_TAG_POSITION_MASK, val)) {
> > +             case RTL8365MB_CPU_POS_BEFORE_CRC:
> > +                     return DSA_TAG_PROTO_RTL8_4T;
> > +             case RTL8365MB_CPU_POS_AFTER_SA:
> > +             default:
> > +                     return DSA_TAG_PROTO_RTL8_4;
> > +             }
> > +             break;
> > +     }
> > +
> >       return DSA_TAG_PROTO_RTL8_4;
>
> Not great. dsa_get_tag_protocol gets called from dsa_port_parse_cpu,
> which is earlier than rtl8365mb_cpu_config, so you may temporarily
> report a tagging protocol which you don't expect (depending on what is
> in hardware at the time). Can you not keep the current tagging protocol
> in a variable? You could then avoid the need to return an error on
> regmap_read too.

Thanks Vladimir.

Sure. I added the variable to the chip_data struct. With that, I can
also remove the tag-related code and variables from
rtl8365mb_cpu_config() and rtl8365mb_cpu. Now I simply call the same
rtl8365mb_change_tag_protocol() during setup. I believe it is better
to have a single place that touches that config.

Regards,

Luiz
