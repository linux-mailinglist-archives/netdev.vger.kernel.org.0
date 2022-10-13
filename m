Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB88F5FE3EF
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 23:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiJMVMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 17:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiJMVMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 17:12:41 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B433192B8C
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 14:12:29 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id e53-20020a9d01b8000000b006619152f3cdso784866ote.0
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 14:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8kAIsq170mUXwhosORBh0nwxhIgp/1cUiiRXHiSCJ+g=;
        b=fie4EQkzIuLaMAQmdz0ysljC1pPMWz84MuCXYfwEdxKtbk9+M+Y/uv7hjPFJHpCTpM
         RKELin7DajOXCxvZvHn3+fYJhPaupUHhCf4piTOCtMNl00IQGjr2qIN+CIuwQ7gRlqTW
         u49nspmVSX2Awj8zinLj/F2OX3nHAkFobj0hTVLz3zk34VllA24Hvd5YlhTK6ru/EsJT
         JP6qEdcHbYjFcNQNn9m6KCTeEpoe8gyzpGIjt872mtjWY/h5P0frY8RbrW//qI+zMNHR
         7JF6o7UySHuXxP9vhdzyoeIFr52CDM+/1lgRbF6m7cIWX9qT1H8Wo9Bv4V0+YsudqX8M
         P2gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8kAIsq170mUXwhosORBh0nwxhIgp/1cUiiRXHiSCJ+g=;
        b=E3ieJ/VgPt6GMpxGjNSFPOVVpbxY3NxS24b9Nb4T2wNnTnnSzZjA0ch1gnttyKDJZb
         TPKMxpvJ4ph3BTLKeb3Y4FBUgTShxz6CCUfjB6bROIkxxW8kV1W4oCY495ON5Jsi6UX5
         OWtniA/yobPR0LIDNobHWsMhNpYZW1fx3VPdQItEtRrOV4iYdEBIfTPItZESlt3bGh14
         w2dQ7Xqt+CjAqL5t+j81hZuJwFbK8ZfqS0efe6o4M6NIER6kJzpB6DCy608c+ZY+gKQP
         gJ5UteXPDL4shGx09dE2qTTt//TISbeyOZJfGIqRl2uufch3DXzK+fIsW2kJDGvs7D4l
         /juw==
X-Gm-Message-State: ACrzQf2Vi13R8Tp47uKSvBHOxGbAHaqhNbSFK/+i5fowF38t12XDKHO9
        JTVWiEwjjOYIzClVRW9vZKY4TLo+1iHR5h9BDUQ=
X-Google-Smtp-Source: AMsMyM6RVY+NfNTW0+YN4M//UHQdO3LrHE0t8x75r4qx23H/nfqPAmUexOVAwIsg63kt47UnQzJZID281EQS+aZ8PZA=
X-Received: by 2002:a9d:3e59:0:b0:661:c029:d7bb with SMTP id
 h25-20020a9d3e59000000b00661c029d7bbmr969509otg.112.1665695547349; Thu, 13
 Oct 2022 14:12:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:5907:b0:ca:e99c:8314 with HTTP; Thu, 13 Oct 2022
 14:12:26 -0700 (PDT)
Reply-To: mathurin.cecilia@aol.com
From:   Cecilia Mathurin <mathurincecilia719@gmail.com>
Date:   Thu, 13 Oct 2022 22:12:26 +0100
Message-ID: <CAMoFKqQ0MsCdW_VDwgvp2RnZ=vtd1cakPi3uT17nPnVd4qmrwQ@mail.gmail.com>
Subject: =?UTF-8?Q?Gospo=C4=91a_Cecilie_Mathurin?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Od Gospo=C4=91e Cecilie Mathurin

Najdra=C5=BEi u Gospodinu

Toplim srcem nudim vam svoje prijateljstvo i pozdravljam vas u ime
na=C5=A1eg gospodara, i nadam se da =C4=87ete ovo pismo do=C4=8Dekati u pra=
vo
vrijeme, predla=C5=BEem svojim slobodnim umom i kao osoba od Bo=C5=BEjeg
integriteta, znam da je ovo poruka =C4=87e vam se pojaviti kao iznena=C4=91=
enje
koje jedva znamo, ali me Bo=C5=BEja milost uputila k vama i =C5=BEelim da
pro=C4=8Ditate ovu poruku i budete blagoslovljeni u ime Gospodnje.

Imam tumor na mozgu; Trenutno u=C5=BEasno patim. Moj lije=C4=8Dnik me uprav=
o
obavijestio da su moji dani odbrojani zbog mog zdravlja, stoga sam
osu=C4=91en na sigurnu smrt. Trenutno sam potro=C5=A1io svu svoju u=C5=A1te=
=C4=91evinu za
svoju medicinsku skrb.

Ali imam ne=C5=A1to sredstava za svoj dobrotvorni projekt; ta su sredstva
deponirana kod jedne od banaka ovdje u Cote d'Ivoire Zapadnoj Africi.
Namjena za dobrotvornu zakladu, moj bra=C4=8Dni status je takav da sam
slobodna jer sam izgubila mu=C5=BEa, a na=C5=BEalost nismo imali zajedni=C4=
=8Dko
dijete, zbog =C4=8Dega nisam osoba koja bi ostavila svoje naslje=C4=91e. St=
oga,
da bih oslobodio svoja sredstva, =C5=BEelio bih dati donaciju kako ne bi
bilo o=C5=A1trog poreza na moj novac.

Na ovo bih bio tako ljubazan i kako bih pomogao siroma=C5=A1nima da dam ono
=C5=A1to iznosi spomenutu ostav=C5=A1tinu u iznosu od 4.500.000,00 (=C4=8De=
tiri
milijuna, petsto tisu=C4=87a eura) kako bih vam omogu=C4=87io osnivanje
dobrotvorne zaklade u moj spomen, tako da milost od Bog budi sa mnom
do mog posljednjeg doma kako bih mogao dobiti =C4=8Dasno mjesto s
Gospodinom, na=C5=A1im ocem.

Ne bojim se jer prije nego =C5=A1to sam vas kontaktirao, molio sam nekoliko
no=C4=87i da mi Gospodin da kontakt s osobom od povjerenja kojoj mogu
povjeriti ovu stvar i vjerujem da su moji kontakti s vama bo=C5=BEanski.
molim vas po=C5=A1aljite mi podatke ispod.

Tvoje puno ime ---
Tvoja zemlja -----
Va=C5=A1a adresa ----
Tvoje godine ---
Va=C5=A1e zaposlenje ---
Va=C5=A1 telefon ----

Nakon =C5=A1to primim va=C5=A1 odgovor, dat =C4=87u vam kontakt Banke i tak=
o=C4=91er =C4=87u
vam izdati pismo ovlasti koje =C4=87e pokazati da ste trenutni korisnik
ovih sredstava.

Znajte da 30% novca mo=C5=BEete zadr=C5=BEati za sebe, a ostatak =C4=87e se=
 koristiti
za stvaranje dobrotvorne zaklade u moju uspomenu, a ra=C4=8Dunam na va=C5=
=A1u
dobru volju, a posebno na pravilno kori=C5=A1tenje ovih sredstava u =C5=A1t=
o ne
sumnjam jer imam veliko povjerenje u tebe da me Bog mo=C5=BEe voditi prema
tebi. Moj e-mail

(cecilia.mathurin@aol.com)

Molim vas, preklinjem vas u ime Bo=C5=BEje, nikada ne uklju=C4=8Dite nevjer=
nika
u ovaj bo=C5=BEanski projekt.


U o=C4=8Dekivanju Va=C5=A1eg brzog odgovora, primite moje srda=C4=8Dne i br=
atske pozdrave.

S po=C5=A1tovanjem,
Gospo=C4=91a Cecilie Mathurin
