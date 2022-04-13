Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95684FFDD5
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 20:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbiDMScW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 14:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237711AbiDMScS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 14:32:18 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E6453A6F;
        Wed, 13 Apr 2022 11:29:56 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id bg9so2537724pgb.9;
        Wed, 13 Apr 2022 11:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tqUy4wIUbnHeXLECZT3EuzOLy7NbT4AdLMplw9UwAVc=;
        b=hz+Yj5/2bFOmrBQy1COFXlF/LnxLOHCumtQ990qLhTsycEgqbMQZXWjcTx0ztYdv2l
         qCW6/jsej1UlM4MnnsacAIj8t1rmSUKN+392gf0/CUGV2Nqn9ijwARMZ1HM9B+yxP3tn
         YXJ/kulsZhoFB6W658SpkEg0YopHvSgpjLGRjwJ/TRtzC+vFffHjfYbQub5C4LHDDC0v
         XTPtu/iZMBTiQdd3riWpvQrOI6F9eO7O4FCZ+lzqziGXmF1eVgE4Q7BNFbZMZlF8Axfm
         3cayOdZxM4rMwSGWysqxYI99CyuDtfuwUXyOS8xFZ/rG/jg1au3yVnWbClA2b9uwv3LJ
         +I5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tqUy4wIUbnHeXLECZT3EuzOLy7NbT4AdLMplw9UwAVc=;
        b=UqYDhgJvWpsydHQkLvpDEotKrpjh9ojC85XqKaUC+eY++e10H2C74qKBmBn8eeBmbt
         +qSOmYFpSCTam+zhRe1n577to6VGnrw0X2q4XcHPTOPvfTSwSrshaUWhcWfsUei5e9b6
         SnOLeE/PAiKZLEDyFYtxZ8RSlqRYm+EXILh8oWCrGe+f/Cosd3hjjlg38snar5roWk2C
         hp/v3W387upIbzxHC7A6Qzkk+lMGgvp81mSqr9DjRVzyw6idU2PSW+zwbgJCSkqBLjL7
         kFMJg++gdFptnDok88cjrgYYtTLwSTPKzeGRfPYfbODnJDo5XUjFYdSkUzrjPrK5zbza
         Nfbw==
X-Gm-Message-State: AOAM533K5O124FkZGuCZIbxA0NZFL08aXN+bGpfmzcjXfU5JKTLcRPd9
        qrz94HrDMILD7UDT3SotvU7vq7xxGMXzIh46Kx0=
X-Google-Smtp-Source: ABdhPJwyTh2FcolXckqzV6cIv6vpRDPezWMSTgy40VccO9wouiaqdGm8NAajogyDuS1EHDafcByBah1JKsDUpR8eC0o=
X-Received: by 2002:a05:6a00:248e:b0:506:1dce:fcba with SMTP id
 c14-20020a056a00248e00b005061dcefcbamr133998pfv.21.1649874596245; Wed, 13 Apr
 2022 11:29:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220411210406.21404-1-luizluca@gmail.com> <YlTFRqY3pq84Fw1i@lunn.ch>
 <CAJq09z7CDbaFdjkmqiZsPM1He4o+szMEJANDiaZTCo_oi+ZCSQ@mail.gmail.com>
 <YlVz2gqXbgtFZUhA@lunn.ch> <20220412133055.vmzz2copvu2qzzin@bang-olufsen.dk>
In-Reply-To: <20220412133055.vmzz2copvu2qzzin@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 13 Apr 2022 15:29:45 -0300
Message-ID: <CAJq09z4E-HiA3WD4UtBAYm6mOCehHGedmofCqxRsAwUqND+=uQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for RTL8367RB-VB
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
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

> On Tue, Apr 12, 2022 at 02:43:06PM +0200, Andrew Lunn wrote:
> > On Tue, Apr 12, 2022 at 01:12:51AM -0300, Luiz Angelo Daros de Luca wrote:
> > > > On Mon, Apr 11, 2022 at 06:04:07PM -0300, Luiz Angelo Daros de Luca wrote:
> > > > > RTL8367RB-VB was not mentioned in the compatible table, nor in the
> > > > > Kconfig help text.
> > > > >
> > > > > The driver still detects the variant by itself and ignores which
> > > > > compatible string was used to select it. So, any compatible string will
> > > > > work for any compatible model.
> > > >
> > > > Meaning the compatible string is pointless, and cannot be trusted. So
> > > > yes, you can add it, but don't actually try to use it for anything,
> > > > like quirks.
> > >
> > >
> > > Thanks, Andrew. Those compatible strings are indeed useless for now.
> > > The driver probes the chip variant. Maybe in the future, if required,
> > > we could provide a way to either force a model or let it autodetect as
> > > it does today.
> >
> > The problem is, you have to assume some percentage of shipped DT blobs
> > have the wrong compatible string, but work because it is not actually
> > used in a meaningful way. This is why the couple of dozen Marvell
> > switches have just 3 compatible strings, which is enough to find the
> > ID registers to identify the actual switch. The three compatibles are
> > the name of the lowest chip in the family which introduced to location
> > of the ID register.
>
> Right, this was basically the original behaviour:
>
> - realtek,rtl8265mb -> use rtl8365mb.c subdriver
> - realtek,rtl8366rb -> use rtl8366rb.c subdriver (different family with different register layout)
>
> We then check a chip ID/version register and store that in the driver-private
> data, in case of quirks or different behaviours between chips in the same
> family.
>
> I think Andrew has a point that adding more compatible strings is not really
> going to add any tangible benefit, due to the above bahviour. People can equally
> well just put one of the above two compatible strings.

The Realtek driver (rtl8367c) does provide a way to skip the probe and
force a specific model detection. Maybe that is a requirement for some
kind of device we might see in the future. If needed, we could add a
new property ("autodetect-{model,variant} = false") to force the model
based only on the compatible string. It would also allow a compatible
device to use the driver even if its ids are not known by the driver.

> > > There is no "family name" for those devices. The best we had was
> > > rtl8367c (with "c" probably meaning 3rd family). I suggested renaming
> > > the driver to rtl8367c but, in the end, we kept it as the first
> > > supported device name. My plan is, at least, to allow the user to
> > > specify the correct model without knowing which model it is equivalent
> > > to.
> >
> > In order words, you are quite happy to allow the DT author to get is
> > wrong, and do not care it is wrong. So the percentage of DT blobs with
> > the wrong compatible will go up, making it even more useless.

I wouldn't say it is wrong but not as specific as possible.
"compatible" seems to indicate that a driver from modelA can be used
for modelB.
We could start to warn the user when the compatible string does not
match the model (at least from what we already know).

Today, the driver only uses the model to tell the CPU and user ports
(and chip version is enough for that usage). However, the vendor
driver does an independent probe when it is setting the external port
and it does check additional registers. Today the Linux driver only
supports RGMII without actually checking if the model does support it.
When we expand that support to other port modes, we might need to
revisit the chip probe.

> > It is also something you cannot retrospectively make useful, because
> > of all those broken DT blobs.

We cannot tell if there are other models that share the same chip
version (from reg 0x1302). We can only tell from the devices we have
access to. Yes, there might already be a device using a different
compatible string from the real device and I don't intend to break it.

> I think Luiz is saying he wants to allow device tree authors to write
> "realtek,rtl8367rb" if their hardware really does have an RTL8367RB switch and
> not an RTL8365MB, rather than writing "realtek,rtl8365mb". But an enterprising
> device tree author could just as well write:
>
>          compatible = "realtek,rtl8367rb", "realtek,rtl8365mb";
>
> ... which would work without us having to continually add more (arguably
> useless) compatible strings to the driver, including this one.

Yes, Alvin. Thanks.

It feels strange to force the user to use "realtek,rtl8365mb" or any
other different string that does not match the chip's real name. I
would not expect the one writing the DT to know that rtl8367s shares
the same family with rtl8365mb and rtl8365mb driver does support
rtl8367s. Before writing the rtl8367s driver, I also didn't know the
relation between those chips. The common was only to relate rtl8367s
(or any other chip model) with the vendor driver rtl8367c. As we don't
have a generic family string, I think it is better to add every model
variant.

Regards,

Luiz
