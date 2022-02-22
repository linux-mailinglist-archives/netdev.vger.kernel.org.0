Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE954BEE92
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 02:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237848AbiBVAiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 19:38:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbiBVAiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 19:38:23 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA4F24BC9
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 16:37:59 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gi6so7117322pjb.1
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 16:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aCoqbfKOgilF5NNSKi0fFE9aDPPXg9hf1s2dsMs1QEM=;
        b=eITeVoCVu7X8t8plVdeTRIGrsjxNvqdG2H2+dKgUqHCtguJi3PYmCAxxox1A+bM8qw
         6Kcv9PxydFzFLv0Bw5qHej/vxEURNw1dLTK6c04++bqr1D+anf3j92fcvvRf7zUdTML8
         9eKCSsAcpcOjY3PPenrQaVU7vaFakzFZPBCY/K00chgbB0WkyGBM58nQSrerDh6q5C7n
         wDQa9Vs9t+yiINaALTdEM1XSkJcwR/gCLa8u02fFeoPoFXZyTnpmYypDXKDLRGk87ULQ
         IJL57ee18ptzm91hduBb6G5bY/N/C59JSHmdEihkpLyo3Qgtei0DmGp/VDeDo0QIFmVI
         ozRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aCoqbfKOgilF5NNSKi0fFE9aDPPXg9hf1s2dsMs1QEM=;
        b=fmtk1xt1l/0EINGCSB86vdeaB8Pi5LldPl8PN5OLPs3opgzLV5A0vDoqR+dMKIPzh4
         tLiUpTq0JRXgZ6U/swj1lkFbsp4GZlqAzsLkISM5d5MN+HiovM+1v2k84s2Sr2syA/MA
         EH02l90rtyB9q7/HaAoX4RQxiyk1D94GjsDfrS41xQ6FjasmFY4gx1N7VW1wWRAPnz7B
         DmwvHJa31yJjO223DDbwS/735Svus06EGAEqubkde2TDocKZLWuABkxt25mnoVvsxWFv
         mlQLusA7/i2Z/XOZAHhK8UzNaZAmCjWWKdM93KNUARw8DdoaRoBzRtfR51D/B1iRpnIs
         FLVw==
X-Gm-Message-State: AOAM532qEboJ7BuZtjPAqJZk1wHNtVd95iEcTeMUnAmGaflfhWIbPsxS
        XQ0L3HN3IcJe49XmDtkSSrb/aC7u4fuV3arC7dU=
X-Google-Smtp-Source: ABdhPJzWzM6rQLixkclIJcRtY8iLv7RJZcZOndYUToLJuEqLBnc5NgWdVUarncJJ8a58Y8avUTPD0cd4WNvqB9K95SI=
X-Received: by 2002:a17:902:da88:b0:14a:26ae:4e86 with SMTP id
 j8-20020a170902da8800b0014a26ae4e86mr21815710plx.59.1645490278807; Mon, 21
 Feb 2022 16:37:58 -0800 (PST)
MIME-Version: 1.0
References: <20220218060959.6631-1-luizluca@gmail.com> <20220218060959.6631-2-luizluca@gmail.com>
 <877d9spfct.fsf@bang-olufsen.dk>
In-Reply-To: <877d9spfct.fsf@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Mon, 21 Feb 2022 21:37:47 -0300
Message-ID: <CAJq09z7VDR8Dv20MU5mbsAd4Ux1uL+1qofiuJCrLRubV3uKtpQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] net: dsa: tag_rtl8_4: add rtl8_4t
 trailing variant
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
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

Em sex., 18 de fev. de 2022 =C3=A0s 08:46, Alvin =C5=A0ipraga
<ALSI@bang-olufsen.dk> escreveu:
>
> Luiz Angelo Daros de Luca <luizluca@gmail.com> writes:
>
> > The switch supports the same tag both before ethertype or before CRC.
>
> s/The switch supports/Realtek switches support/?

Thanks!

>
> I think you should update the documentation at the top of the file as
> well.

OK

>
> >
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> > ---
> >  include/net/dsa.h    |   2 +
> >  net/dsa/tag_rtl8_4.c | 127 +++++++++++++++++++++++++++++++++----------
> >  2 files changed, 99 insertions(+), 30 deletions(-)
> >
> > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > index fd1f62a6e0a8..b688ced04b0e 100644
> > --- a/include/net/dsa.h
> > +++ b/include/net/dsa.h
> > @@ -52,6 +52,7 @@ struct phylink_link_state;
> >  #define DSA_TAG_PROTO_BRCM_LEGACY_VALUE              22
> >  #define DSA_TAG_PROTO_SJA1110_VALUE          23
> >  #define DSA_TAG_PROTO_RTL8_4_VALUE           24
> > +#define DSA_TAG_PROTO_RTL8_4T_VALUE          25
> >
> >  enum dsa_tag_protocol {
> >       DSA_TAG_PROTO_NONE              =3D DSA_TAG_PROTO_NONE_VALUE,
> > @@ -79,6 +80,7 @@ enum dsa_tag_protocol {
> >       DSA_TAG_PROTO_SEVILLE           =3D DSA_TAG_PROTO_SEVILLE_VALUE,
> >       DSA_TAG_PROTO_SJA1110           =3D DSA_TAG_PROTO_SJA1110_VALUE,
> >       DSA_TAG_PROTO_RTL8_4            =3D DSA_TAG_PROTO_RTL8_4_VALUE,
> > +     DSA_TAG_PROTO_RTL8_4T           =3D DSA_TAG_PROTO_RTL8_4T_VALUE,
> >  };
> >
> >  struct dsa_switch;
> > diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
> > index 02686ad4045d..d80357cb74b0 100644
> > --- a/net/dsa/tag_rtl8_4.c
> > +++ b/net/dsa/tag_rtl8_4.c
> > @@ -84,87 +84,133 @@
> >  #define RTL8_4_TX                    GENMASK(3, 0)
> >  #define RTL8_4_RX                    GENMASK(10, 0)
> >
> > -static struct sk_buff *rtl8_4_tag_xmit(struct sk_buff *skb,
> > -                                    struct net_device *dev)
> > +static void rtl8_4_write_tag(struct sk_buff *skb, struct net_device *d=
ev,
> > +                          void *tag)
> >  {
> >       struct dsa_port *dp =3D dsa_slave_to_port(dev);
> > -     __be16 *tag;
> > -
> > -     skb_push(skb, RTL8_4_TAG_LEN);
> > -
> > -     dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
> > -     tag =3D dsa_etype_header_pos_tx(skb);
> > +     __be16 tag16[RTL8_4_TAG_LEN / 2];
> >
> >       /* Set Realtek EtherType */
> > -     tag[0] =3D htons(ETH_P_REALTEK);
> > +     tag16[0] =3D htons(ETH_P_REALTEK);
> >
> >       /* Set Protocol; zero REASON */
> > -     tag[1] =3D htons(FIELD_PREP(RTL8_4_PROTOCOL, RTL8_4_PROTOCOL_RTL8=
365MB));
> > +     tag16[1] =3D htons(FIELD_PREP(RTL8_4_PROTOCOL, RTL8_4_PROTOCOL_RT=
L8365MB));
> >
> >       /* Zero FID_EN, FID, PRI_EN, PRI, KEEP; set LEARN_DIS */
> > -     tag[2] =3D htons(FIELD_PREP(RTL8_4_LEARN_DIS, 1));
> > +     tag16[2] =3D htons(FIELD_PREP(RTL8_4_LEARN_DIS, 1));
> >
> >       /* Zero ALLOW; set RX (CPU->switch) forwarding port mask */
> > -     tag[3] =3D htons(FIELD_PREP(RTL8_4_RX, BIT(dp->index)));
> > +     tag16[3] =3D htons(FIELD_PREP(RTL8_4_RX, BIT(dp->index)));
> > +
> > +     memcpy(tag, tag16, RTL8_4_TAG_LEN);
>
> Why not just cast tag to __be16 and avoid an extra memcpy for each xmit?

The last version I sent, there was a valid concern about unaligned
access. With ethertype tags, we know the exact position the tag will
be. However, at the end of the packet, the two bytes might fall into
different words depending on the payload. I did test different
payloads without any issues but my big endian system might have
helped.

I checked the machine code and the compiler seems to be doing a good
job here, converting the memcpy to a simple "register to memory" each
byte at a time.

>
> > +}
> > +
> > +static struct sk_buff *rtl8_4_tag_xmit(struct sk_buff *skb,
> > +                                    struct net_device *dev)
> > +{
> > +     skb_push(skb, RTL8_4_TAG_LEN);
> > +
> > +     dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
> > +
> > +     rtl8_4_write_tag(skb, dev, dsa_etype_header_pos_tx(skb));
> >
> >       return skb;
> >  }
> >
> > -static struct sk_buff *rtl8_4_tag_rcv(struct sk_buff *skb,
> > -                                   struct net_device *dev)
> > +static struct sk_buff *rtl8_4t_tag_xmit(struct sk_buff *skb,
> > +                                     struct net_device *dev)
> > +{
> > +     /* Calculate the checksum here if not done yet as trailing tags w=
ill
> > +      * break either software and hardware based checksum
> > +      */
> > +     if (skb->ip_summed =3D=3D CHECKSUM_PARTIAL && skb_checksum_help(s=
kb))
> > +             return NULL;
> > +
> > +     rtl8_4_write_tag(skb, dev, skb_put(skb, RTL8_4_TAG_LEN));
> > +
> > +     return skb;
> > +}
> > +
> > +static int rtl8_4_read_tag(struct sk_buff *skb, struct net_device *dev=
,
> > +                        void *tag)
> >  {
> > -     __be16 *tag;
> >       u16 etype;
> >       u8 reason;
> >       u8 proto;
> >       u8 port;
> > +     __be16 tag16[RTL8_4_TAG_LEN / 2];
>
> nit: Reverse christmas-tree order?

Sure! My bad.

>
> >
> > -     if (unlikely(!pskb_may_pull(skb, RTL8_4_TAG_LEN)))
> > -             return NULL;
> > -
> > -     tag =3D dsa_etype_header_pos_rx(skb);
> > +     memcpy(tag16, tag, RTL8_4_TAG_LEN);
>
> Likewise can you avoid this memcpy?
>
> >
> >       /* Parse Realtek EtherType */
> > -     etype =3D ntohs(tag[0]);
> > +     etype =3D ntohs(tag16[0]);
> >       if (unlikely(etype !=3D ETH_P_REALTEK)) {
> >               dev_warn_ratelimited(&dev->dev,
> >                                    "non-realtek ethertype 0x%04x\n", et=
ype);
> > -             return NULL;
> > +             return -EPROTO;
> >       }
> >
> >       /* Parse Protocol */
> > -     proto =3D FIELD_GET(RTL8_4_PROTOCOL, ntohs(tag[1]));
> > +     proto =3D FIELD_GET(RTL8_4_PROTOCOL, ntohs(tag16[1]));
> >       if (unlikely(proto !=3D RTL8_4_PROTOCOL_RTL8365MB)) {
> >               dev_warn_ratelimited(&dev->dev,
> >                                    "unknown realtek protocol 0x%02x\n",
> >                                    proto);
> > -             return NULL;
> > +             return -EPROTO;
> >       }
> >
> >       /* Parse REASON */
> > -     reason =3D FIELD_GET(RTL8_4_REASON, ntohs(tag[1]));
> > +     reason =3D FIELD_GET(RTL8_4_REASON, ntohs(tag16[1]));
> >
> >       /* Parse TX (switch->CPU) */
> > -     port =3D FIELD_GET(RTL8_4_TX, ntohs(tag[3]));
> > +     port =3D FIELD_GET(RTL8_4_TX, ntohs(tag16[3]));
> >       skb->dev =3D dsa_master_find_slave(dev, 0, port);
> >       if (!skb->dev) {
> >               dev_warn_ratelimited(&dev->dev,
> >                                    "could not find slave for port %d\n"=
,
> >                                    port);
> > -             return NULL;
> > +             return -ENOENT;
> >       }
> >
> > +     if (reason !=3D RTL8_4_REASON_TRAP)
> > +             dsa_default_offload_fwd_mark(skb);
> > +
> > +     return 0;
> > +}
> > +
> > +static struct sk_buff *rtl8_4_tag_rcv(struct sk_buff *skb,
> > +                                   struct net_device *dev)
> > +{
> > +     if (unlikely(!pskb_may_pull(skb, RTL8_4_TAG_LEN)))
> > +             return NULL;
> > +
> > +     if (unlikely(rtl8_4_read_tag(skb, dev, dsa_etype_header_pos_rx(sk=
b))))
> > +             return NULL;
> > +
> >       /* Remove tag and recalculate checksum */
> >       skb_pull_rcsum(skb, RTL8_4_TAG_LEN);
> >
> >       dsa_strip_etype_header(skb, RTL8_4_TAG_LEN);
> >
> > -     if (reason !=3D RTL8_4_REASON_TRAP)
> > -             dsa_default_offload_fwd_mark(skb);
> > +     return skb;
> > +}
> > +
> > +static struct sk_buff *rtl8_4t_tag_rcv(struct sk_buff *skb,
> > +                                    struct net_device *dev)
> > +{
>
> I wonder if it's necessary to check pskb_may_pull() here too.

I didn't add it because no trailing tag used it. I checked
tag_hellcreek.c, tag_ksz.c, tag_xrs700x.c. tag_sja1105.c seems to use
both head and tail space and it indeed use pskb_may_pull() but only
related to the head space (SJA1110_HEADER_LEN).

>
> > +     if (skb_linearize(skb))
> > +             return NULL;
> > +
> > +     if (unlikely(rtl8_4_read_tag(skb, dev, skb_tail_pointer(skb) - RT=
L8_4_TAG_LEN)))
> > +             return NULL;
> > +
> > +     if (pskb_trim_rcsum(skb, skb->len - RTL8_4_TAG_LEN))
> > +             return NULL;
> >
> >       return skb;
> >  }
> >
> > +/* Ethertype version */
> >  static const struct dsa_device_ops rtl8_4_netdev_ops =3D {
> >       .name =3D "rtl8_4",
> >       .proto =3D DSA_TAG_PROTO_RTL8_4,
> > @@ -172,7 +218,28 @@ static const struct dsa_device_ops rtl8_4_netdev_o=
ps =3D {
> >       .rcv =3D rtl8_4_tag_rcv,
> >       .needed_headroom =3D RTL8_4_TAG_LEN,
> >  };
> > -module_dsa_tag_driver(rtl8_4_netdev_ops);
> >
> > -MODULE_LICENSE("GPL");
> > +DSA_TAG_DRIVER(rtl8_4_netdev_ops);
> > +
> >  MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4);
> > +
> > +/* Tail version */
> > +static const struct dsa_device_ops rtl8_4t_netdev_ops =3D {
> > +     .name =3D "rtl8_4t",
> > +     .proto =3D DSA_TAG_PROTO_RTL8_4T,
> > +     .xmit =3D rtl8_4t_tag_xmit,
> > +     .rcv =3D rtl8_4t_tag_rcv,
> > +     .needed_tailroom =3D RTL8_4_TAG_LEN,
> > +};
> > +
> > +DSA_TAG_DRIVER(rtl8_4t_netdev_ops);
> > +
> > +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4L);
> > +
> > +static struct dsa_tag_driver *dsa_tag_drivers[] =3D {
> > +     &DSA_TAG_DRIVER_NAME(rtl8_4_netdev_ops),
> > +     &DSA_TAG_DRIVER_NAME(rtl8_4t_netdev_ops),
> > +};
> > +module_dsa_tag_drivers(dsa_tag_drivers);
> > +
> > +MODULE_LICENSE("GPL");
