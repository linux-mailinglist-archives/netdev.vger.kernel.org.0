Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F21B4C1978
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243213AbiBWRIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243268AbiBWRHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:07:55 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A08F5418B
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:07:27 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id lw4so53860306ejb.12
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=pITr9LldPmaEk/cgBoGsPvfDwZDRD2mGjIIyoZ12GQw=;
        b=R/N/XenKGUAgHimfuknoAteuWCGG4jvmPt4s8/vHTjx4vPNr1cBnB/x0sjaSnvwt5/
         QLTuYvsJ0q1b6cO+8wPsuYh2pRCOqCBd/o9d0dnJ9UVXH2aoO7MZSG66z5GQF+gJP4Sm
         E1VvtvNBMur3UvbEtjInH5a5UL2DX3aaEKYoT1MtAb4RxExj7mkUXkrymDccJUiFPlf2
         ssCBf2npQ/LVl2xssW30aBY95sslt1HOCRUNfo/mSQu3XE/jMGNC+XuVHGdCLzcORy/2
         UqGd2YGZIaeawDv+FHvgRlIKAfV1MW+PDah4renxTrtZkkmpt6GFkFNq0/up6totWMK1
         I8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=pITr9LldPmaEk/cgBoGsPvfDwZDRD2mGjIIyoZ12GQw=;
        b=SpE/DN8HY2QPJkDEmHhx1gk2pS5zoDLqbJPUIYBPD84C+DTAdROkS+8/fMW0eNLSF5
         N/+5vzTc/u4x/Fr8+Tt9gS3eQW9mB3aam8ZqnrOJ43Bd+UV6brs3D9A9vN4ns2n/mljC
         reVwLAVtuXkcvaxbKN4TRFP+4KICb42legNQwJGvzAejJEu3sjFZI/kRAvqKSabppzMv
         LF8YxAbFGlC1Zq4dhaitmpm5B7948Nb2CNn9mrEGl8xSLnozbKlR6FWz2uMFQQQBXb5u
         n6JfVto0SyyBE5ivaq6nfxBTj9cRwFLspvePuM6YLr8yrBkD3IgYrgEtXJWpDV1/R1PL
         vIhw==
X-Gm-Message-State: AOAM533e8DkT7VRKMYbKaFQQleNUq7nxC4FaCUJ4YorEaRsg5ol+vP26
        s03teJ88L28sKlP2vNDo6aWLV0z3UfGAoYxTtqg=
X-Google-Smtp-Source: ABdhPJy201CKho62a26iA5O5xjTFKM/MVrWzLC/b4LwrGnZxcp/0bgnE+hIZuJc8m3thXm9+RKf9JkNasSOb1wh67Lw=
X-Received: by 2002:a17:906:a10:b0:6ce:7107:598b with SMTP id
 w16-20020a1709060a1000b006ce7107598bmr485913ejf.653.1645636045813; Wed, 23
 Feb 2022 09:07:25 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a54:3087:0:0:0:0:0 with HTTP; Wed, 23 Feb 2022 09:07:25
 -0800 (PST)
Reply-To: www.ecobank6@gmail.com
From:   MESSI PETER <messip883@gmail.com>
Date:   Wed, 23 Feb 2022 18:07:25 +0100
Message-ID: <CAFuOU_TpP_4u=H064Q1g943y3xtMRcM0upGW=hJXr3fT4stzbw@mail.gmail.com>
Subject: ATENTIE DRAGA
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:643 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [www.ecobank6[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [messip883[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [messip883[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FONDUL MONETAR INTERNA=C8=9AIONAL (FMI)

Unitatea de decontare a datoriilor interna=C8=9Bionale,
# 1900, PRE=C5=9EEDINTE AV.DU
REF: -XVGNN82021

Stimate Beneficiar!

=C3=8En detaliu, noul ministru al Finan=C8=9Belor =C8=99i organul de conduc=
ere al
Unit=C4=83=C8=9Bii Monetare a Na=C8=9Biunilor Unite ne-au autorizat s=C4=83=
 investig=C4=83m
fondurile nerevendicate de mult =C3=AEnt=C3=A2rziate din co=C8=99ul guvernu=
lui de la
Na=C8=9Biunile Unite,

ceea ce i-a derutat pe proprietari crez=C3=A2nd c=C4=83 au fost =C3=AEn=C8=
=99ela=C8=9Bi de
escroci folosind numele Na=C8=9Biunilor Unite, =C3=AEn cursul investiga=C8=
=9Biei
noastre. Pe baza eviden=C8=9Bei de stocare a datelor din sistemul nostru cu
adresa dvs. de e-mail, plata dvs. se num=C4=83r=C4=83 printre 150 de Destin=
atari
clasifica=C8=9Bi ca:

Fond de loterie nelivrat / Fond de loterie nepl=C4=83tit / Mo=C8=99tenire d=
e
transfer incomplet / Fonduri contractuale.
Am descoperit, spre disperarea noastr=C4=83, c=C4=83 plata dvs. a fost
=C3=AEnt=C3=A2rziat=C4=83 =C3=AEn mod inutil de oficiali corup=C8=9Bi ai b=
=C4=83ncii, =C3=AEn =C3=AEncercarea
de a v=C4=83 frauda fondul, ceea ce a dus la multe pierderi din partea dvs.
=C8=99i =C3=AEnt=C3=A2rzieri inutile =C3=AEn primirea pl=C4=83=C8=9Bii dvs.

Organiza=C8=9Bia Na=C8=9Biunilor Unite =C8=99i Fondul Monetar Interna=C8=9B=
ional (FMI) au
ales s=C4=83 pl=C4=83teasc=C4=83 toate fondurile de compensare c=C4=83tre 1=
50 de
Beneficiari din America de Nord, America de Sud, Statele Unite ale
Americii,

Europa =C8=99i Asia =C8=99i =C3=AEn =C3=AEntreaga lume prin cardul Visa  AT=
M, deoarece
este o tehnologie de plat=C4=83 global=C4=83 care permite consumatorilor,
=C3=AEntreprinderilor, institu=C8=9Biilor financiare =C8=99i guvernelor s=
=C4=83 foloseasc=C4=83
moneda digital=C4=83 =C3=AEn loc de numerar =C8=99i cecuri.

Am aranjat ca plata dumneavoastr=C4=83 s=C4=83 v=C4=83 fie pl=C4=83tit=C4=
=83 printr-un card
Visa ATM =C8=99i va fi emis=C4=83 pe numele dumneavoastr=C4=83 =C8=99i trim=
is=C4=83 direct la
adresa dumneavoastr=C4=83 prin DHL sau orice serviciu de curierat
disponibil =C3=AEn =C8=9Bara dumneavoastr=C4=83. La contactarea noastr=C4=
=83,

suma de 800.000,00 SUA va fi creditat=C4=83 pe cardul Visa ATM =C8=99i aces=
t
lucru v=C4=83 va permite s=C4=83 v=C4=83 retrage=C8=9Bi fondurile de la ori=
ce bancomat din
=C8=9Bara dumneavoastr=C4=83 cu o retragere minim=C4=83 de 25.000 SUA pe zi=
. =C3=8En acest
sens, trebuie s=C4=83 comunica=C8=9Bi =C8=99i s=C4=83 furniza=C8=9Bi inform=
a=C8=9Biile solicitate
Direc=C8=9Biei de Pl=C4=83=C8=9Bi =C8=99i Transferuri Interna=C8=9Bionale c=
u urm=C4=83toarele;
1. Numele =C8=99i prenumele dvs
2. Adresa dvs. de re=C8=99edin=C8=9B=C4=83 complet=C4=83 =C8=99i =C8=9Bara =
dvs
3. Nationalitate
4. Data na=C8=99terii / sexul
5. Ocupa=C8=9Bia
6. Num=C4=83r de telefon/fax
7. Adresa ora=C8=99ului dvs.

Utiliza=C8=9Bi acest cod (Ref: CLIENT-966/16) ca subiect al e-mailului dvs.
pentru identificare =C8=99i =C3=AEncerca=C8=9Bi s=C4=83 furniza=C8=9Bi info=
rma=C8=9Biile de mai sus
oficialilor de mai jos pentru emiterea =C8=99i livrarea cardului dvs. ATM
Visa;

Am sf=C4=83tuit agentul bancar s=C4=83 deschid=C4=83 o adres=C4=83 de e-mai=
l privat=C4=83 cu un
num=C4=83r nou care ne va permite s=C4=83 monitoriz=C4=83m aceste comunic=
=C4=83ri de plat=C4=83
=C8=99i transfer pentru a preveni =C3=AEnt=C3=A2rzierile ulterioare sau det=
urnarea
fondurilor dumneavoastr=C4=83. Contacta=C8=9Bi acum agentul The United Bank=
 for
Africa cu urm=C4=83toarele detalii de contact:

Contact: doamna: Angela Aneke, directorul executiv
Departamentul de compensare a transferurilor de fonduri (Eco Bank for Afric=
a)
E-mail de contact: ( www.ecobank6@gmail.com)

Solicit=C4=83m r=C4=83spunsul dvs. urgent la acest e-mail, a=C8=99a cum est=
e indicat,
pentru a evita noi =C3=AEnt=C3=A2rzieri.

Cu sinceritate

Doamna: Angela Aneke, directorul executiv
