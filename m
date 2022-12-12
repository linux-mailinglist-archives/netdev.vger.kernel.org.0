Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D3E649D00
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbiLLK4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiLLKzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:55:39 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9767A14D22
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 02:44:43 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id s196so7905625pgs.3
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 02:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hpFQAxeIso3WXdZfyXFPxEY+neVU6DO//PAOiGcoWBM=;
        b=DwZ9ZvuqnW+cE3j5FsfGkKHm5P37DfAdo9MWIF2D65KEpQX6Ri9srpH4wLUT7yNSON
         H4gylQS/B9TPirEu8bdk4mxtloLWljLAi3sYgoBBtz6iyt8r5I57C559awkwOSHxQcTb
         WhSvib2aMLAcEwpdEENrwgCtmRSJc9DUa92vBvQyiKjawoX2Xgl0Z3y8pLgRWCa2gg7X
         2jQ1xIViVbyjXQwF9W4Puc4tJuGaTodzCn51CfVp8tGZn5XjSdeTWcEQnWGZVcSL8GWf
         YboVtdhvOK35wTpq2IG37D34m7Y8+kmQ4n5KFOeG8LqT4i6X4tjdITPi22rAioYT7pKG
         qU+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hpFQAxeIso3WXdZfyXFPxEY+neVU6DO//PAOiGcoWBM=;
        b=LXdvFnoCndK/CCa0nUH2gxGYU7HDfe/mENXhvhoZOQGJ/OZlGtgB5Plg9e9hiqQbh6
         zRYU2N6uvrv0ys5oTjK9KT9OBDhotYX67uo0PBL05ZVLM41j76EtrE4sAPzyrC7ImPIZ
         CLHO9bXLaR/DS/zj63l/kPOsQWTBV90sESX3/8cwE+f6+e6kLTK7Nko54M2yMsYBPEzR
         lUIMP7GpzX4Qreztm4FUXZ9u0UhmUjlsV0C1gFJeitkLd6qGyXnwZRnMbWEit7lvtU4Q
         cWUWpd0NM9JKIQcKC7ELy753mmaYyPSHHQNmnQwQd1ASiUXWKtqM8asMDoBY/SiYjmwZ
         pmrw==
X-Gm-Message-State: ANoB5pmsCQwbd7MsbtoYfp/rkYYXVlodEe0C7DmimE6dLn79BR5ZTjaw
        qngQ6ucKtUSfNSK2EvsrYk9n0UL0vjI0xKe3ZFQ=
X-Google-Smtp-Source: AA0mqf4+WgqzdyPlLje3mCWv9vl0g2krvVFyV5aGCrdRX7EZtL8kfExiwvq4pxpqK4/SWdRHBCF/LMqAUyzHOkW+C3c=
X-Received: by 2002:aa7:9acb:0:b0:577:1f5f:cc28 with SMTP id
 x11-20020aa79acb000000b005771f5fcc28mr15138156pfp.16.1670841881861; Mon, 12
 Dec 2022 02:44:41 -0800 (PST)
MIME-Version: 1.0
Sender: frankmanes764@gmail.com
Received: by 2002:a05:6a06:1a8e:b0:587:54c9:f9a3 with HTTP; Mon, 12 Dec 2022
 02:44:40 -0800 (PST)
From:   Mrs Kristalina Georgieva <mrskristalinageorgieva847@gmail.com>
Date:   Mon, 12 Dec 2022 02:44:40 -0800
X-Google-Sender-Auth: O6OlhHf6og-ad8uHYUyWz3Jq2YQ
Message-ID: <CAMaNgx6YOdFy3NyqYsMGWeE=3RAi2qk9jn0y354E3KouzBGNkQ@mail.gmail.com>
Subject: OFICIAL FMI
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_HK_NAME_FM_MR_MRS,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:52c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4980]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [frankmanes764[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrskristalinageorgieva847[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  3.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FOND MONETAR INTERNA=C8=9AIONAL (HQ1)
700 19th Street, N.W., Washington, D.C. 20431.
Fondul nerevendicat al loteriei Mo 755.000,00 USD
detectat de proprietarul de e-mail al fondului.

REF:-XVGN 82022.
Num=C4=83rul c=C3=A2=C8=99tig=C4=83tor; 5-6-14-29-35

Stimate proprietar de e-mail al fondului,
=C8=9Ai-am trimis aceast=C4=83 scrisoare, acum o lun=C4=83, dar nu am auzit=
 de la
tine, nu sunt sigur dac=C4=83 ai primit-o =C8=99i de aceea o trimit din nou=
.
Acesta este pentru a te informa despre informa=C8=9Bii foarte importante
care vor fi de mare ajutor pentru a v=C4=83 r=C4=83scump=C4=83ra de toate
dificult=C4=83=C8=9Bile pe care le-a=C8=9Bi avut =C3=AEn ob=C8=9Binerea pl=
=C4=83=C8=9Bii restante din
cauza cererii excesive de bani de la dumneavoastr=C4=83 at=C3=A2t de c=C4=
=83tre
func=C8=9Bionari corup=C8=9Bi func=C8=9Bionari ai b=C4=83ncii, c=C3=A2t =C8=
=99i de c=C4=83tre companiile
de curierat dup=C4=83 care fondul dumneavoastr=C4=83 r=C4=83m=C3=A2ne neach=
itat.

Sunt doamna Kristalina Georgieva, un =C3=AEnalt func=C8=9Bionar la Fondul
Monetar Interna=C8=9Bional (FMI). Te-ar putea interesa s=C4=83 =C8=99tii c=
=C4=83 prin
at=C3=A2tea coresponden=C8=9Be au ajuns la biroul nostru rapoarte despre fe=
lul
tulbur=C4=83tor =C3=AEn care oamenii ca tine sunt trata=C8=9Bi de c=C4=83tr=
e Diverse
B=C4=83nci. Dup=C4=83 investiga=C8=9Bia noastr=C4=83, am aflat c=C4=83 adre=
sa dvs. de e-mail a
fost unul dintre noroco=C8=99ii c=C3=A2=C8=99tig=C4=83tori ai selec=C8=9Bie=
i de loterie Mo =C3=AEn
anul 2020, dar din cauza unor bancheri corup=C8=9Bi, ace=C8=99tia =C3=AEnce=
arc=C4=83 s=C4=83 v=C4=83
redirec=C8=9Bioneze fondurile =C3=AEn contul lor privat.
Toate prostatale guvernamentale =C8=99i neguvernamentale, ONG-urile,
companiile financiare, b=C4=83ncile, companiile de securitate =C8=99i compa=
niile
de curierat care au fost =C3=AEn contact cu dvs. =C3=AEn ultimul timp au pr=
imit
instruc=C8=9Biuni s=C4=83 v=C4=83 retrag=C4=83 tranzac=C8=9Bia =C8=99i vi s=
-a sf=C4=83tuit s=C4=83 NU
r=C4=83spunde=C8=9Bi de atunci. Fondul Monetar Interna=C8=9Bional (FMI) est=
e acum
direct responsabil pentru plata dvs., pe care o pute=C8=9Bi primi =C3=AEn c=
ontul
dvs. bancar cu ajutorul B=C4=83ncii Europene de Investi=C8=9Bii.
Numele dvs. a ap=C4=83rut pe lista noastr=C4=83 de program de pl=C4=83=C8=
=9Bi a
beneficiarilor care =C3=AE=C8=99i vor primi fondurile Loteriei Mo =C3=AEn a=
ceast=C4=83
plat=C4=83 din primul trimestru al anului 2022, deoarece transfer=C4=83m fo=
nduri
doar de dou=C4=83 ori pe an, conform reglement=C4=83rilor noastre bancare. =
Ne
cerem scuze pentru =C3=AEnt=C3=A2rzierea pl=C4=83=C8=9Bii =C8=99i v=C4=83 r=
ug=C4=83m s=C4=83 nu mai comunica=C8=9Bi
cu orice birou acum =C8=99i s=C4=83 acorda=C8=9Bi aten=C8=9Bie biroului nos=
tru =C3=AEn
consecin=C8=9B=C4=83.

Acum noua dvs. plat=C4=83, Nr. de aprobare a Na=C8=9Biunilor Unite; UN 5685=
 P,
Nr. aprobat la Casa Alba: WH44CV, Nr. referinta 35460021, Nr. alocare:
674632 Nr. parola: 339331, nr. Cod PIN: 55674 =C8=99i certificatul
dumneavoastr=C4=83 de plat=C4=83 de merit: Nr.: 103, Nr. cod emis: 0763;
Confirmare imediat=C4=83 (IMF) Telex Nr: -1114433; Cod secret nr: XXTN013.
Fondul dvs. de mo=C8=99tenire pentru plat=C4=83 par=C8=9Bial=C4=83 este de =
755.000 USD
dup=C4=83 ce a=C8=9Bi primit aceste pl=C4=83=C8=9Bi vitale. numere c=C3=A2=
=C8=99tig=C4=83toare;
5-6-14-29-35, data c=C3=A2=C8=99tig=C4=83rii; 05 octombrie 2020, sunte=C8=
=9Bi acum
calificat s=C4=83 primi=C8=9Bi =C8=99i s=C4=83 confirma=C8=9Bi plata cu Reg=
iunea African=C4=83 a
Fondului Monetar Interna=C8=9Bional (FMI) imediat =C3=AEn urm=C4=83toarele =
168 de
ore. V=C4=83 asigur=C4=83m c=C4=83 plata v=C4=83 va ajunge at=C3=A2ta timp =
c=C3=A2t urma=C8=9Bi
directivele =C8=99i instruc=C8=9Biunile mele. Am decis s=C4=83 v=C4=83 ofer=
im un COD,
CODUL ESTE: 601. V=C4=83 rug=C4=83m, de fiecare dat=C4=83 c=C3=A2nd primi=
=C8=9Bi un mail cu
numele doamnei Kristalina Georgieva, verifica=C8=9Bi dac=C4=83 exist=C4=83 =
COD (601)
dac=C4=83 codul nu este scris, v=C4=83 rug=C4=83m s=C4=83 =C8=99terge=C8=9B=
i mesaj din inbox-ul t=C4=83u!
Sunte=C8=9Bi sf=C4=83tuit prin prezenta s=C4=83 NU mai trimite=C8=9Bi nicio=
 plat=C4=83 c=C4=83tre
nicio institu=C8=9Bie cu privire la tranzac=C8=9Bia dvs., deoarece fondul
dumneavoastr=C4=83 v=C4=83 va fi transferat direct din sursa noastr=C4=83. =
Singura
plat=C4=83 necesar=C4=83 la banc=C4=83 este doar taxa pentru certificatul d=
e
lichidare FMI, astfel =C3=AEnc=C3=A2t banca va putea elibera =C3=AEntreaga =
sum=C4=83 de
bani =C3=AEn contul dvs. bancar.

Sper c=C4=83 acest lucru este clar. Orice ac=C8=9Biune contrar=C4=83 aceste=
i
instruc=C8=9Biuni este pe propriul risc. RE=C8=9AINE=C8=9AI C=C4=82 TREBUIE=
 PL=C4=82=C8=9AI=C8=9AI
COMISIONAL=C4=82 DE LIMITARE A CERTIFICATULUI FMI C=C4=82TRE BANC=C4=82 =C8=
=98I F=C4=82R=C4=82 TAX=C4=82
SUPLIMENTAR=C4=82.
Am depus deja fondul dvs. total la banca pl=C4=83titoare corespunz=C4=83toa=
re
Banca European=C4=83 de Investi=C8=9Bii, vreau s=C4=83 contacta=C8=9Bi Appr=
oval pentru a
primi fondul dvs. total =C3=AEn stare bun=C4=83, f=C4=83r=C4=83 alte =C3=AE=
nt=C3=A2rzieri sau taxe
suplimentare.
R=C4=83spunde=C8=9Bi la acest e-mail bancar:
(europeaninvestmentbankeib6@gmail.com)
=C8=98i fondul t=C4=83u va fi eliberat =C3=AEn contul t=C4=83u bancar odat=
=C4=83 ce vei contacta banca.

Contacta=C8=9Bi numele managerului b=C4=83ncii; Dr. Wilson Taylor

E-mail bancar:
(europeaninvestmentbankeib6@gmail.com)
Cu respect


Salutari,

Doamna Kristalina Georgieva, (I.M.F)(601)
