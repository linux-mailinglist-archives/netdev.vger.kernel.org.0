Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F344C5B5E
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 14:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiB0NpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 08:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiB0NpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 08:45:16 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AF15006F
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 05:44:38 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id b5so11557992wrr.2
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 05:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=RwBqAIjZU0E6lZ4n+lEDSeo5gXmI6yBcrcnEw5Zn3Z4=;
        b=g5TSqarQw6GWukcc1Y+SzB1ElQq5VyETygxkqPEp0CQR/z0z9UuJvZjH7qMU7irVx+
         6kE0X8iacEgLFAxDuTtkNSLHONGOd2ze5FmUiUNcAXveJJULWs063VMn1QQk+zzII6a5
         KHMKLibAqBnlSlcAPvhhRvG//dTwkX10OA1j5c9bnLD/mx2ecj3FY4WT+uYh9c/pi/V+
         ydsq4/z+Rr5iI5J1RWVaKLhsvKxuGFdU4wR0mtPXAtLrov+jiisr/gJRqe71PiNBmFUq
         zoMNMZPpQDC+Mvz0SOQA8Dv3LW6P9E+b97NCmlhU9LCN2SNEh/j/gQwP6rfnjzl+uKmI
         moIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=RwBqAIjZU0E6lZ4n+lEDSeo5gXmI6yBcrcnEw5Zn3Z4=;
        b=wIVzuuQB6WC1z3WXogRMWnHXznXovQP6YcaL7FGzIOSayYx9UD4SuOcuiJkosd5rrB
         bBzM0ig5x7Y4JyvdAKb9QSOXseHiBU2SIn4fyTcUS3TSpE7YHJkWTaplfu082U4TztE/
         /8vrBAYxSxY5r5ThpXXkf1P8jqz7fUfIIBraL1qjaZ7/SOHTmLRSM2Hw2ch5WadtN5RM
         ZJ4kI0UtqWVEGPSobz+wWurihwHHmM03mJs0DlJnZ0QnPQFAKPeHsSjSMR87c+OYScvQ
         4G+stcILWMNx6dC8RLwfzbm8wo3ehHn1t8ollee4sKPjZDN1rAXjVV30z8dHgkMtnW83
         IM+Q==
X-Gm-Message-State: AOAM533kKohiJme+h76LJN4cb7hDBbv5lHyxtFOSwiZeIjGzjEEC4n6F
        MROfsaXBD3chiA0dK+Bem6trhQKNHmNu2nhKw74=
X-Google-Smtp-Source: ABdhPJyTwwlmveGO0ADsuouF8c/KPCa5KWMOksho/j2MxBB0CNTb5VKTJkTBflrPABN0pk8DtJWCxGt6Lu60Rvl0cAM=
X-Received: by 2002:adf:fe8d:0:b0:1ef:b53c:5036 with SMTP id
 l13-20020adffe8d000000b001efb53c5036mr1768507wrr.227.1645969477192; Sun, 27
 Feb 2022 05:44:37 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6000:1546:0:0:0:0 with HTTP; Sun, 27 Feb 2022 05:44:36
 -0800 (PST)
Reply-To: www.info.ubabankcard.TG@gmail.com
From:   "Mr. Tony Elumelu" <woppomm4598@gmail.com>
Date:   Sun, 27 Feb 2022 05:44:36 -0800
Message-ID: <CAG6b=vpKFxSSPrFrWmW6vKVE3vvCjg7Z9CjSBcU0tyJUR9_-ow@mail.gmail.com>
Subject: =?UTF-8?Q?Pozornost_upravi=C4=8Denca=2C?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:436 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [woppomm4598[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [woppomm4598[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pozornost upravi=C4=8Denca,

To e-po=C5=A1tno obvestilo prejmete neposredno iz skupine Odbora za boj
proti goljufijam Urada Afri=C5=A1ke unije (AU) Republike Togo v sodelovanju
z de=C5=BEurno postajo Zdru=C5=BEenih narodov (ZN) Lome-Togo, razred P-4 =
=C5=A0tevilo
post-AF / RP/RDBCPN/SHS/0001.v zvezi z obse=C5=BEnim zbiranjem
(aretacijami) internetnih prevarantov. Zaradi visoke stopnje prito=C5=BEb,
ki jih prejemamo od Zdru=C5=BEenih narodov (ZN) na ravni goljufov/goljufov
z afri=C5=A1kimi narodnostmi. Vsi ponudniki internetnih storitev so opazili
pove=C4=8Danje e-po=C5=A1tnega prometa iz Afrike na druge celine.

V tem napadu je bilo doslej aretiranih tristo =C5=A1est (306) goljufov in
ta racija =C5=A1e traja. Izterjali smo celotno vsoto 857 milijonov
dolarjev, tako v gotovini kot premo=C5=BEenju, za katerega je potrjeno, da
izvira od njegovih =C5=BErtev. Iz njihovih imenikov smo na=C5=A1li na stoti=
ne
tiso=C4=8D e-po=C5=A1tnih naslovov =C5=BErtev. V tem =C4=8Dasu vas kontakti=
ramo.

Ve=C4=8Dkrat smo brezuspe=C5=A1no posku=C5=A1ali stopiti v stik z vami, zat=
o vam =C5=A1e
zadnji=C4=8D po=C5=A1iljamo ta opomnik, po katerem od=C5=A1kodninska komisi=
ja
Zdru=C5=BEenih narodov ne bo imela druge izbire, kot da odpi=C5=A1e va=C5=
=A1 denar za
od=C5=A1kodnino v vi=C5=A1ini 750.000,00 $ in ga ozna=C4=8Di. ker ni zahtev=
ano, zato
prosimo, da nemudoma odgovorite na to pismo, da pojasnite svoje
stali=C5=A1=C4=8De o tej zadevi, preden bo prepozno, ukrepajte hitro in
upo=C5=A1tevajte navodila v svoje dobro. Ve=C4=8D podrobnosti bo na voljo, =
ko se
obrnete na United Bank of Africa Lome, Togo

=C2=BBDanes vas obve=C5=A1=C4=8Damo, da je UBA Bank va=C5=A1 denar nakazal =
na kartico VISA
in je tudi pripravljen za dostavo.
Zdaj se obrnite na generalnega direktorja Banco UBA
Ime................. G. Tony Elumelu
E-po=C5=A1tni naslov ........ www.info.ubabankcard.TG@gmail.com

Njegove podrobnosti je omenil eden od Sindikatov, ki so ga aretirali
kot eno od njihovih =C5=BErtev operacij. S tem ste opozorjeni, da jim tega
sporo=C4=8Dila iz kakr=C5=A1nega koli razloga ne posredujte ali podvajate, =
saj
na=C5=A1 agent tajne slu=C5=BEbe ZDA =C5=BEe sledi drugim kriminalcem.

Po=C5=A1ljite naslednje podatke za dostavo va=C5=A1e akreditirane kartice V=
ISA
ATM na va=C5=A1 naslov.

Va=C5=A1e polno ime=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
Va=C5=A1a dr=C5=BEava izvora=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
Va=C5=A1 naslov =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
E-po=C5=A1tni naslov =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
Va=C5=A1a telefonska =C5=A1tevilka =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Va=C5=A1a starost =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Va=C5=A1 spol =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
Va=C5=A1 poklic =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D

N/B; Zato vas prosim, da se mi takoj vrnete danes, da bomo lahko takoj
za=C4=8Deli vse potrebne postopke in protokole za sprostitev va=C5=A1ega sk=
lada
za izpla=C4=8Dilo od=C5=A1kodnin.
Pozdravi,
Urad skupine za boj proti goljufijam Afri=C5=A1ke unije (AU) Podru=C5=BEnic=
a v
Republiki Togo
