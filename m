Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8411C6E9DFD
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 23:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbjDTVjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 17:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjDTVjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 17:39:23 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F654EFE
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 14:39:22 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id a1e0cc1a2514c-77380e8f3bcso257687241.2
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 14:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682026761; x=1684618761;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9mgjG3VrUbLvqgFO5SBtAbchzJMAlGhBoi2UORAhg30=;
        b=sVG5kFuiWtaN6DwfBc6zId1gDl+wOb//I4cxLnycZG2GNR5R7zlVRM5G7VEDNBnAU9
         9Bx2OzccQCxP/xNDGy++h5Fwe0FkcO9/PlTnwIavxDodxfswZ64RNFRSpngrGUQuoP7+
         uiJoHIrJxZMuQa2b6GzG38HpixPhu2MFVagFnTtPgYiAQRnuI6N8zydd9sRi1rWUlbaP
         ThpXf5fmt3UVZAZeL0XWvkbg3aww2hH8S1QfbIx3HBfn72LbalJGrXY1BUYET3sUN6wK
         Yc2reBLx2/sec0YWI2O320jOvpz1MrRp/GhX40jsEU96ibDcPg36nUKj3c3UvKGtahof
         1gLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682026761; x=1684618761;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9mgjG3VrUbLvqgFO5SBtAbchzJMAlGhBoi2UORAhg30=;
        b=Q3RqGq4F7vQs2oA1qZc0508FCuBcduKJ9CYOamLzpitTjamj/z2PseWi9wCdp7Bpro
         C5m2p8pMXmKf5HO7mxVBpNsgC8fmM2YsnDZ4C6th7P//zpV8gVCgIwtEn6N4HsqOiX1y
         pev6t8KJBccFNGvzW6wU6jq9H8QkNdmix1JEGvspSZoK3sXjG7aX7jDJ/Y56xtQeSedP
         fatDKuHOg2+zaBuxGFwrgCeJBmQ98NhGDwOrpTmH6Nku9w+UBfkwgkLgt7dNkGCrMGML
         F6nYxNzk4ECHp5LxOopRdajWVhzKzjmGdv3uP71rpIkIwJt7vM3nIrrfThtRd9nXSk3c
         PqCw==
X-Gm-Message-State: AAQBX9eIHiRX1h8QQpWszJ7OplUg8JZ7pfcPTN3scswgK2PFxbLSpm4w
        Jb9ukIq/ukcp2T6FCpTCvVRcebDz+b1mxBoBQoY=
X-Google-Smtp-Source: AKy350ZNIOj8tAZ2bsJSUCumegsGwYlQrrK9oD9J4o6vjrptnkLvfj08kUeIrgAgOnUwT3fAR9n+Kqugh+YUIS6jSXw=
X-Received: by 2002:a67:c18e:0:b0:430:3021:20e3 with SMTP id
 h14-20020a67c18e000000b00430302120e3mr18054vsj.1.1682026761360; Thu, 20 Apr
 2023 14:39:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:7e58:0:b0:5e4:9eda:79ee with HTTP; Thu, 20 Apr 2023
 14:39:20 -0700 (PDT)
Reply-To: kodjovihegbor4@gmail.com
From:   kodjovihegbor <blinbelin227@gmail.com>
Date:   Thu, 20 Apr 2023 21:39:20 +0000
Message-ID: <CAB2P08oKQcAWuLHe_niv+UYSB=YB95v2MwXADg29Kj3xgX1XqA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oferuj=C4=99 moj=C4=85 przyja=C5=BA=C5=84 i wierz=C4=99, =C5=BCe przyjmiesz=
 mnie z dobrym sercem,
zosta=C5=82em zmuszony do skontaktowania si=C4=99 z tob=C4=85 i zobaczenia,=
 jak
najlepiej mo=C5=BCemy sobie pom=C3=B3c. Ja jestem
Pani Kodjovi Hegbor z Turcji i ja pracujemy jako Division Head of
Operations w StandardBNP Bank Limited Turcja. Wierz=C4=99, =C5=BCe taka jes=
t
wola Bo=C5=BCa wzgl=C4=99dem mnie
spotka=C4=87 ci=C4=99 teraz. Prowadz=C4=99 wa=C5=BCn=C4=85 rozmow=C4=99 biz=
nesow=C4=85, kt=C3=B3r=C4=85 chc=C4=99 si=C4=99 z
Tob=C4=85 podzieli=C4=87 i kt=C3=B3ra, jak s=C4=85dz=C4=99, Ci=C4=99 zainte=
resuje, poniewa=C5=BC jest
zwi=C4=85zana z nazw=C4=85 Twojego kraju i odniesiesz z tego korzy=C5=9B=C4=
=87.

W 2018 roku obywatel twojego kraju o imieniu Ivan za=C5=82o=C5=BCy=C5=82 w =
moim banku
konto nierezydenta na 36 miesi=C4=99cy kalendarza o warto=C5=9Bci 8 400 000=
,00
=C2=A3. The
data wyga=C5=9Bni=C4=99cia tej umowy depozytowej to 16 stycznia 2021 r.
Niestety, by=C5=82 on jedn=C4=85 z ofiar =C5=9Bmiertelnych w niedawnym wybu=
chu
pandemii CoronaVirus (Covid19) 2019-2020, kt=C3=B3ra mia=C5=82a miejsce w
Chinach, podczas gdy by=C5=82 w podr=C3=B3=C5=BCy s=C5=82u=C5=BCbowej, w kt=
=C3=B3rej zgin=C4=99=C5=82o co
najmniej 68 000 os=C3=B3b .

Kierownictwo mojego banku jeszcze nie wie o jego =C5=9Bmierci, wiedzia=C5=
=82em o
tym, poniewa=C5=BC by=C5=82 moim przyjacielem, a ja by=C5=82em jego ksi=C4=
=99gowym, kiedy
konto by=C5=82o
otwarte przed moj=C4=85 promocj=C4=85. Pan Ivan nie wymieni=C5=82 jednak =
=C5=BCadnego
najbli=C5=BCszego krewnego/spadkobiercy w chwili otwarcia rachunku, nie by=
=C5=82
=C5=BConaty i nie mia=C5=82
dzieci. W zesz=C5=82ym tygodniu kierownictwo mojego banku poprosi=C5=82o mn=
ie o
wydanie instrukcji, co zrobi=C4=87 z jego funduszami, je=C5=9Bli chce odnow=
i=C4=87
umow=C4=99.

Wiem, =C5=BCe tak si=C4=99 stanie i dlatego szuka=C5=82em sposobu, aby pora=
dzi=C4=87 sobie
z t=C4=85 sytuacj=C4=85, poniewa=C5=BC je=C5=9Bli dyrektorzy mojego banku d=
owiedz=C4=85 si=C4=99, =C5=BCe
Ivan
nie =C5=BCyje i nie ma =C5=BCadnego Spadkobiercy, wezm=C4=85 =C5=9Brodki na=
 w=C5=82asny u=C5=BCytek,
wi=C4=99c nie chc=C4=99, aby tak si=C4=99 sta=C5=82o. Wtedy ci=C4=99 zobacz=
y=C5=82em, by=C5=82em
szcz=C4=99=C5=9Bliwy i teraz szukam twojej wsp=C3=B3=C5=82pracy, aby przeds=
tawi=C4=87 ci=C4=99 jako
najbli=C5=BCszego krewnego / spadkobierc=C4=99 konta, poniewa=C5=BC masz te=
n sam kraj
co on, a centrala mojego banku zwolni ci konto. Nie ma =C5=BCadnego ryzyka
zaanga=C5=BCowany; transakcja zostanie przeprowadzona na podstawie zgodnego
z prawem porozumienia, kt=C3=B3re ochroni Ci=C4=99 przed jakimkolwiek
naruszeniem prawa.

Lepiej, =C5=BCeby=C5=9Bmy za=C5=BC=C4=85dali tych pieni=C4=99dzy, ni=C5=BC =
pozwolili je zabra=C4=87
dyrektorom bank=C3=B3w, oni ju=C5=BC s=C4=85 bogaci. Nie jestem chciw=C4=85=
 osob=C4=85, wi=C4=99c
sugeruj=C4=99, =C5=BCeby=C5=9Bmy
dzieli=C4=87 fundusze po r=C3=B3wno, 50/50% dla obu stron, m=C3=B3j udzia=
=C5=82 pomo=C5=BCe mi
za=C5=82o=C5=BCy=C4=87 w=C5=82asn=C4=85 firm=C4=99 i przeznaczy=C4=87 wp=C5=
=82ywy na cele charytatywne, kt=C3=B3re
do tej pory
marzenie.

Daj mi zna=C4=87, co my=C5=9Blisz o mojej propozycji, prosz=C4=99, naprawd=
=C4=99
potrzebuj=C4=99 twojej pomocy w tej transakcji, wybra=C5=82em ci=C4=99, aby=
=C5=9B mi
pomaga=C5=82, a nie sam, wykonuj=C4=85c moje
kochanie, ale na Boga, czy chc=C4=99, =C5=BCeby=C5=9B wiedzia=C5=82, =C5=BC=
e po=C5=9Bwi=C4=99ci=C5=82em sw=C3=B3j
czas na modlitw=C4=99 w sprawie tej komunikacji, zanim kiedykolwiek si=C4=
=99 z
tob=C4=85 skontaktowa=C5=82em, daj mi zna=C4=87
pami=C4=99taj o tym i traktuj te informacje jako =C5=9ACI=C5=9ALE TAJNE. Po
otrzymaniu odpowiedzi, wy=C5=82=C4=85cznie za po=C5=9Brednictwem mojego oso=
bistego
adresu e-mail, kodjovihegbor4@gmail.com
poda szczeg=C3=B3=C5=82y transakcji. Oraz kopi=C4=99 =C5=9Bwiadectwa depozy=
towego
funduszu, a tak=C5=BCe za=C5=9Bwiadczenie o zarejestrowaniu sp=C3=B3=C5=82k=
i
wygenerowa=C5=82 fundusz. Szcz=C4=99=C5=9B=C4=87 Bo=C5=BCe, oczekuj=C4=85c =
pilnej odpowiedzi
Z wyrazami szacunku
Pani Kodjovi Hegbor
kodjovihegbor4@gmail.com
