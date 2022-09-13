Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10DF5B6626
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 05:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiIMDca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 23:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiIMDc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 23:32:27 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9B25070F
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 20:32:24 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-127ba06d03fso28788774fac.3
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 20:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=fLTc+jz/QKJgnru63E2L2MYuceE2eK3O9scIdNFS8yY=;
        b=RDOMUtJMKtq5fTmcmvGICsYQiv4j1kZee4RXnuNTd88+byffJltSxgf9Pd2v1CVYyu
         uMjYBlUTbeL+zFYkh+1K6ZW8KVznPWEBEUsSw8g6njWN3iXEesiLAR/8+npMgJF+V39I
         6EPMzcrO/FnQvE353XN1tKxl7pA/Y3OADaDk9EZq0Ym+QbEyWkow+6DGyHeV08fYWOVP
         pSoQQsU9OEkuSy/UPoHbHGzXh1Q53rEJHeSO97Wpb9hJstdig1qewv+XivJnnEnER1IR
         8tL3yVKo7+FmvoRuHTRmmTW1I4KuL6is/EIy8kR6BTaLO4yX+CLAAvvR1Mmj0AKAkN2A
         GG6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=fLTc+jz/QKJgnru63E2L2MYuceE2eK3O9scIdNFS8yY=;
        b=US420ZmXmsPsSfifuZ1C3rGw1eYHLg6y9J1ey31+ozCeHuJaMnDLTMMIbn7FcKsZqn
         n6Qbchj71DHEeBNGk8M/7gSSBTkC+kyABku9U3OjWXCmFeU6knXdpr/+2vKBVO8agbVM
         JU92H/QB7xOk/n0VXlG3rws7iMpDl3H0tTcEtQtUJoLdQlGW+ki7DUcQbX9DFyqXfEwO
         M1775rJokITPoHDNcg5Ow269P3JYaralVSDTqsTpxEQYC5Sq7QVCFeKmZQcWgISYWctU
         0XnagULgwVDAyZBy3b8tuxn65Mkhx0ww4WiEdnnLZ9tsBLgsqw1yj0ujwu51YgL2dWVT
         FcXg==
X-Gm-Message-State: ACgBeo2SuSZBNtlyR7lNJ5hN5l/+S1NxBMoFPi6e9bdv83qJkXiD1Zwh
        15jJF0vKkN4NlUc4ZlwNoCxoBf35IIUzgMYAszRek+DSKEU=
X-Google-Smtp-Source: AA6agR6ijAXhZZduZor1qcx7NE7eyuJnUWZrJgs8g1Vjb+wX4AjxpqRVreAD/hv3O9ByKOa3x0Vq8tsWxjgzA7LNP1o=
X-Received: by 2002:a05:6808:bcb:b0:345:aa85:6f33 with SMTP id
 o11-20020a0568080bcb00b00345aa856f33mr658837oik.83.1663039943582; Mon, 12 Sep
 2022 20:32:23 -0700 (PDT)
MIME-Version: 1.0
References: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
 <Yx8thSbBKJhxv169@lore-desk> <Yx9z9Dm4vJFxGaJI@lore-desk> <170d725f-2146-f1fa-e570-4112972729df@arinc9.com>
 <Yx+W9EoEfoRsq1rt@lore-desk>
In-Reply-To: <Yx+W9EoEfoRsq1rt@lore-desk>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Tue, 13 Sep 2022 05:32:13 +0200
Message-ID: <CAMhs-H8wWNrqb0RgQdcL4J+=oGws8pB8Uv_H=6Q8AyzXDgF89Q@mail.gmail.com>
Subject: Re: mtk_eth_soc for mt7621 won't work after 6.0-rc1
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev <netdev@vger.kernel.org>
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

Hi Lorenzo,

On Mon, Sep 12, 2022 at 10:30 PM Lorenzo Bianconi <lorenzo@kernel.org> wrot=
e:
>
> > Hi Lorenzo,
> >
> > On 12.09.2022 21:01, Lorenzo Bianconi wrote:
> > > > > Ethernet for MT7621 SoCs no longer works after changes introduced=
 to
> > > > > mtk_eth_soc with 6.0-rc1. Ethernet interfaces initialise fine. Pa=
ckets are
> > > > > sent out from the interface fine but won't be received on the int=
erface.
> > > > >
> > > > > Tested with MT7530 DSA switch connected to gmac0 and ICPlus IP100=
1 PHY
> > > > > connected to gmac1 of the SoC.
> > > > >
> > > > > Last working kernel is 5.19. The issue is present on 6.0-rc5.
> > > > >
> > > > > Ar=C4=B1n=C3=A7
> > > >
> > > > Hi Ar=C4=B1n=C3=A7,
> > > >
> > > > thx for testing and reporting the issue. Can you please identify
> > > > the offending commit running git bisect?
> > > >
> > > > Regards,
> > > > Lorenzo
> > >
> > > Hi Ar=C4=B1n=C3=A7,
> > >
> > > just a small update. I tested a mt7621 based board (Buffalo WSR-1166D=
HP) with
> > > OpenWrt master + my mtk_eth_soc series and it works fine. Can you ple=
ase
> > > provide more details about your development board/environment?
> >
> > I've got a GB-PC2, Sergio has got a GB-PC1. We both use Neil's gnubee-t=
ools
> > which makes an image with filesystem and any Linux kernel of choice wit=
h
> > slight modifications (maybe not at all) on the kernel.
> >
> > https://github.com/neilbrown/gnubee-tools
> >
> > Sergio experiences the same problem on GB-PC1.
>
> ack, can you please run git bisect in order to identify the offending com=
mit?
> What is the latest kernel version that is working properly? 5.19.8?

I'll try to get time today to properly bisect and identify the
offending commit. I get a working platform with 5.19.8, yes but with
v6-rc-1 my network is totally broken.

Thanks,
    Sergio Paracuellos

>
> Regards,
> Lorenzo
>
> >
> > Ar=C4=B1n=C3=A7
