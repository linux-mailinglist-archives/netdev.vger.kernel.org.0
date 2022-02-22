Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C183F4BEF8A
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbiBVCm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:42:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiBVCmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:42:55 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2DF25C6E
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:42:30 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id f19-20020a17090ac29300b001bc68ecce4aso936766pjt.4
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vGUg4oWH1+SgfEm05Swj4oRuQemRzGHjqfDot6CzlI4=;
        b=Q6f+cRvcX5EjQmbP0J0UGzxXEqmqUfz+dVyiuyjp5YBy7xyr0zjdVRJq0gDfYefw0y
         lNorFXFkfjjZ9tDTjTSGyeHEJlIWLLypJNFvVH0np0/Y9DJbPXSm2v/MfvPpfFmNmv8c
         D/eYq4epJbeUDxxC9g2R38vbyhuzrzLoTUpuywgkaWEchEUi1iRYxaiixXgxE6EwuqZC
         kbkm0Tkh38J9A67Hh9A+0raeMvgxcEscgeVHwb5ZGadZv0luwdd6jtSVmvMNBn2GmRst
         6n2ztVNCVyFqsjDhuWU0cOf8QWhlTp3gpSMg79zIomaiyunyK0PUgSYtuMmWE5aQ3Fm7
         JFbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vGUg4oWH1+SgfEm05Swj4oRuQemRzGHjqfDot6CzlI4=;
        b=NoHbtbtcuqni982t8uudxirbvONvRxyFEM5+S6ZHGp8DtuoluKf3+i/M94vbqZvLrw
         IjGTrdfIIDB4E2wIJqubIPi9l7UzwK2X0Jerby/KTpyWeLASzfEc0BPdRH0+eI1+J8X2
         Sxs3JSDWXF2Tht47C7mpYK6FPm/QxPD1OZmnYaetI3Ij4foE6LURVjXkyogKltbw9BWl
         HD2d81qQ62hOO/NaPSsXtypk2/BMXymrpe+FNWEWgrDMXU78mxNc7FUs5jKumQZnDald
         Ivt0nXDuaZldE5TXGeyiaMlxoAS4E2lhmVpU3rt9rwXRBOmRrM275ahwlUsJYBBNr5WZ
         M0vA==
X-Gm-Message-State: AOAM5316ef0cjt2hAbgf4PjpkR4zzYqMIp07fJLK1CrzZlPR6rI8Em5u
        2cEM4A80hChGL0zDKCdRzQ3c1Jikez1aoRImeVh/gjDy0BFCyQ==
X-Google-Smtp-Source: ABdhPJy2cxpQ1MKOgqOwR/GcpPBvk9btnCG/boxNx5R5Jw/v/0DDrew/Sjg0h5DpHbx/HpYWm489P3o47AysJGQ8ZqE=
X-Received: by 2002:a17:902:da88:b0:14a:26ae:4e86 with SMTP id
 j8-20020a170902da8800b0014a26ae4e86mr22165905plx.59.1645497750136; Mon, 21
 Feb 2022 18:42:30 -0800 (PST)
MIME-Version: 1.0
References: <20220218060959.6631-1-luizluca@gmail.com> <20220218060959.6631-3-luizluca@gmail.com>
 <8735kgpdho.fsf@bang-olufsen.dk>
In-Reply-To: <8735kgpdho.fsf@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Mon, 21 Feb 2022 23:42:19 -0300
Message-ID: <CAJq09z6v0KZU67-bD5bnFoRoWbd7a-Vc2VGotTC4N2Pk3WHHow@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] net: dsa: realtek: rtl8365mb: add support
 for rtl8_4t
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The trailing tag is also supported by this family. The default is still
> > rtl8_4 but now the switch supports changing the tag to rtl8_4t.
> >
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> > ---
> >  drivers/net/dsa/realtek/rtl8365mb.c | 78 ++++++++++++++++++++++++-----
> >  1 file changed, 66 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
> > index 2ed592147c20..043cac34e906 100644
> > --- a/drivers/net/dsa/realtek/rtl8365mb.c
> > +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> > @@ -524,9 +524,7 @@ enum rtl8365mb_cpu_rxlen {
> >   * @mask: port mask of ports that parse should parse CPU tags
> >   * @trap_port: forward trapped frames to this port
> >   * @insert: CPU tag insertion mode in switch->CPU frames
> > - * @position: position of CPU tag in frame
> >   * @rx_length: minimum CPU RX length
> > - * @format: CPU tag format
> >   *
> >   * Represents the CPU tagging and CPU port configuration of the switch. These
> >   * settings are configurable at runtime.
> > @@ -536,9 +534,7 @@ struct rtl8365mb_cpu {
> >       u32 mask;
> >       u32 trap_port;
> >       enum rtl8365mb_cpu_insert insert;
> > -     enum rtl8365mb_cpu_position position;
> >       enum rtl8365mb_cpu_rxlen rx_length;
> > -     enum rtl8365mb_cpu_format format;
>
> This struct is meant to represent the whole CPU config register. Rather
> than pulling it out and adding tag_protocol to struct rtl8365mb, can you
> instead do something like:
>
> - keep these members of _cpu
> - put back the cpu member of struct rtl8365mb (I don't know why it was removed...)

The cpu was dropped from the struct rtl8365mb because it had no use
for it. It was only used outside setup to unreliably detect ext int
ports. When I got no other use for it, I removed it (stingily saving
some bytes).

> - in get_tag_protocol: return mb->cpu.position == AFTER_SA ? RTL8_4 : RTL8_4T;

I was doing just that but I changed to an enum dsa_tag_protocol.
mb->cpu.position works together with mb->cpu.format and if it is
RTL8365MB_CPU_FORMAT_4BYTES, the code will have an undefined behavior
(and get_tag_protocol() cannot return an error). My idea was to always
do "DSA tag" to "Realtek registers" and never the opposite to avoid
that situation. get_tag_protocol() is called even before the CPU port
is configured. And although AFTER_SA and cpu format bits unset is the
desired default value, I would like to make it safe by design, not
coincidence.

> - in change_tag_protocol: just update mb->cpu.position and call
>   rtl8365mb_cpu_config again
> - avoid the arcane call to rtl8365mb_change_tag_protocol in _setup
> - avoid the need to do regmap_update_bits instead of a clean
>   regmap_write in one place

The rtl8365mb_cpu_config() was already a multi-register update, doing
a regmap_update_bits(RTL8365MB_CPU_PORT_MASK_REG) and a
regmap_write(RTL8365MB_CPU_CTRL_REG). I thought it would touch too
much just to change a single bit. After the indirect reg access, I'm
trying to touch exclusively what is strictly necessary.

> The reason I'm saying this is because, in the original version of the
> driver, CPU configuration was in a single place. Now it is scattered. I
> would kindly ask that you try to respect the existing design because I
> can already see that things are starting to get a bit messy.

My idea was to bring closer what was asked with what strictly needs to
be done. We agree on having a single place where a setting is applied.
We disagree on the granularity: I think it should be the smallest unit
a caller might be interested to change (a bit in this case), and you
that it should be the cpu-related registers. I don't know which one is
the best option.

I think it is easier to track changes when there is an individual
function that touches it (like adding a printk), instead of
conditionally printing that message from a shared function. Anyway, I
might be exaggerating for this case.

> If we subsequently want to configure other CPU parameters on the fly, it
> will be as easy as updating the cpu struct and calling cpu_config
> again. This register is also non-volatile so the state we keep will
> always conform with the switch configuration.

I'm averse to any copies of data when I could have them at a single
place. Using the CPU struct, it is a two step job: 1) change the
driver cpu struct, 2) apply. In a similar generic situation, I need to
be cautious if someone could potentially change the struct between
step 1) and 2), or even something else before step 1) could have it
changed in memory (row hammer, for example). It might not apply to
this driver but I always try to be skeptical "by design".

> Sorry if you find the feedback too opinionated - I don't mean anything
> personally. But the original design was not by accident, so I would
> appreciate if we can keep it that way unless there is a good reason to
> change it.

Thanks, Alvin. No need to feel sorry. The worst you can do is to
offend my code, my ideas, not me. ;-) It's always good to hear from
you and other devs. I always learn something.

>
> >  };
> >
> >  /**
> > @@ -566,6 +562,7 @@ struct rtl8365mb_port {
> >   * @chip_ver: chip silicon revision
> >   * @port_mask: mask of all ports
> >   * @learn_limit_max: maximum number of L2 addresses the chip can learn
> > + * @tag_protocol: current switch CPU tag protocol
> >   * @mib_lock: prevent concurrent reads of MIB counters
> >   * @ports: per-port data
> >   * @jam_table: chip-specific initialization jam table
> > @@ -580,6 +577,7 @@ struct rtl8365mb {
> >       u32 chip_ver;
> >       u32 port_mask;
> >       u32 learn_limit_max;
> > +     enum dsa_tag_protocol tag_protocol;
> >       struct mutex mib_lock;
> >       struct rtl8365mb_port ports[RTL8365MB_MAX_NUM_PORTS];
> >       const struct rtl8365mb_jam_tbl_entry *jam_table;
> > @@ -770,7 +768,54 @@ static enum dsa_tag_protocol
> >  rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
> >                          enum dsa_tag_protocol mp)
> >  {
> > -     return DSA_TAG_PROTO_RTL8_4;
> > +     struct realtek_priv *priv = ds->priv;
> > +     struct rtl8365mb *chip_data;
>
> Please stick to the convention and call this struct rtl8365mb pointer mb.

That's a great opportunity to ask. I always wondered what mb really
means. I was already asked in an old thread but nobody answered it.
The only "mb" I found is the driver suffix (rtl8365'mb') but it would
not make sense.

>
> > +
> > +     chip_data = priv->chip_data;
> > +
> > +     return chip_data->tag_protocol;
> > +}
> > +
> > +static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds, int cpu,
> > +                                      enum dsa_tag_protocol proto)
> > +{
> > +     struct realtek_priv *priv = ds->priv;
> > +     struct rtl8365mb *chip_data;
>
> s/chip_data/mb/ per convention
>
> > +     int tag_position;
> > +     int tag_format;
> > +     int ret;
> > +
> > +     switch (proto) {
> > +     case DSA_TAG_PROTO_RTL8_4:
> > +             tag_format = RTL8365MB_CPU_FORMAT_8BYTES;
> > +             tag_position = RTL8365MB_CPU_POS_AFTER_SA;
> > +             break;
> > +     case DSA_TAG_PROTO_RTL8_4T:
> > +             tag_format = RTL8365MB_CPU_FORMAT_8BYTES;
> > +             tag_position = RTL8365MB_CPU_POS_BEFORE_CRC;
> > +             break;
> > +     /* The switch also supports a 4-byte format, similar to rtl4a but with
> > +      * the same 0x04 8-bit version and probably 8-bit port source/dest.
> > +      * There is no public doc about it. Not supported yet.
> > +      */
> > +     default:
> > +             return -EPROTONOSUPPORT;
> > +     }
> > +
> > +     ret = regmap_update_bits(priv->map, RTL8365MB_CPU_CTRL_REG,
> > +                              RTL8365MB_CPU_CTRL_TAG_POSITION_MASK |
> > +                              RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK,
> > +                              FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_POSITION_MASK,
> > +                                         tag_position) |
> > +                              FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK,
> > +                                         tag_format));
> > +     if (ret)
> > +             return ret;
> > +
> > +     chip_data = priv->chip_data;
>
> nit: I would put this assignment up top like in the rest of the driver,
> respecting reverse-christmass-tree order. It's nice to stick to the
> existing style.

ok

>
> > +     chip_data->tag_protocol = proto;
> > +
> > +     return 0;
> >  }
> >
> >  static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
> > @@ -1739,13 +1784,18 @@ static int rtl8365mb_cpu_config(struct realtek_priv *priv, const struct rtl8365m
> >
> >       val = FIELD_PREP(RTL8365MB_CPU_CTRL_EN_MASK, cpu->enable ? 1 : 0) |
> >             FIELD_PREP(RTL8365MB_CPU_CTRL_INSERTMODE_MASK, cpu->insert) |
> > -           FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_POSITION_MASK, cpu->position) |
> >             FIELD_PREP(RTL8365MB_CPU_CTRL_RXBYTECOUNT_MASK, cpu->rx_length) |
> > -           FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK, cpu->format) |
> >             FIELD_PREP(RTL8365MB_CPU_CTRL_TRAP_PORT_MASK, cpu->trap_port & 0x7) |
> >             FIELD_PREP(RTL8365MB_CPU_CTRL_TRAP_PORT_EXT_MASK,
> >                        cpu->trap_port >> 3 & 0x1);
> > -     ret = regmap_write(priv->map, RTL8365MB_CPU_CTRL_REG, val);
> > +
> > +     ret = regmap_update_bits(priv->map, RTL8365MB_CPU_CTRL_REG,
> > +                              RTL8365MB_CPU_CTRL_EN_MASK |
> > +                              RTL8365MB_CPU_CTRL_INSERTMODE_MASK |
> > +                              RTL8365MB_CPU_CTRL_RXBYTECOUNT_MASK |
> > +                              RTL8365MB_CPU_CTRL_TRAP_PORT_MASK |
> > +                              RTL8365MB_CPU_CTRL_TRAP_PORT_EXT_MASK,
> > +                              val);
> >       if (ret)
> >               return ret;
> >
> > @@ -1827,6 +1877,11 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
> >               dev_info(priv->dev, "no interrupt support\n");
> >
> >       /* Configure CPU tagging */
> > +     ret = rtl8365mb_change_tag_protocol(priv->ds, -1, DSA_TAG_PROTO_RTL8_4);
> > +     if (ret) {
> > +             dev_err(priv->dev, "failed to set default tag protocol: %d\n", ret);
> > +             return ret;
> > +     }
> >       cpu.trap_port = RTL8365MB_MAX_NUM_PORTS;
> >       dsa_switch_for_each_cpu_port(cpu_dp, priv->ds) {
> >               cpu.mask |= BIT(cpu_dp->index);
> > @@ -1834,13 +1889,9 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
> >               if (cpu.trap_port == RTL8365MB_MAX_NUM_PORTS)
> >                       cpu.trap_port = cpu_dp->index;
> >       }
> > -
> >       cpu.enable = cpu.mask > 0;
> >       cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
> > -     cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
> >       cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
> > -     cpu.format = RTL8365MB_CPU_FORMAT_8BYTES;
>
> Like I said above, I think it would be nice to put this cpu struct back
> in the rtl8365mb private data.

It would require to split CPU initialization between pre dsa register
(where format must be defined) and dsa_setup (where cpu port is read
from dsa ports and settings applied to the switch). get_tag_protocol()
is called between these two to get the default tag protocol. DSA calls
change_tag_protocol afterwards if the defined tag protocol in the
devicetree does not match.

> > -
> >       ret = rtl8365mb_cpu_config(priv, &cpu);
> >       if (ret)
> >               goto out_teardown_irq;
> > @@ -1982,6 +2033,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
> >               mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX;
> >               mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
> >               mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
> > +             mb->tag_protocol = DSA_TAG_PROTO_RTL8_4;
> >
> >               break;
> >       default:
> > @@ -1996,6 +2048,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
> >
> >  static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
> >       .get_tag_protocol = rtl8365mb_get_tag_protocol,
> > +     .change_tag_protocol = rtl8365mb_change_tag_protocol,
> >       .setup = rtl8365mb_setup,
> >       .teardown = rtl8365mb_teardown,
> >       .phylink_get_caps = rtl8365mb_phylink_get_caps,
> > @@ -2014,6 +2067,7 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
> >
> >  static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
> >       .get_tag_protocol = rtl8365mb_get_tag_protocol,
> > +     .change_tag_protocol = rtl8365mb_change_tag_protocol,
> >       .setup = rtl8365mb_setup,
> >       .teardown = rtl8365mb_teardown,
> >       .phylink_get_caps = rtl8365mb_phylink_get_caps,
