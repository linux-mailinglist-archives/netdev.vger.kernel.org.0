Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7F76AAA97
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 16:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjCDPAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 10:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCDPAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 10:00:49 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388F4527D
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 07:00:48 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id d6so3114806pgu.2
        for <netdev@vger.kernel.org>; Sat, 04 Mar 2023 07:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677942047;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :references:in-reply-to:reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CfP2cvpb5Xi9ZJt78Gn/eATBTB7rrYLrU2oF9/cMHNY=;
        b=lnITib5B01SEKgB0UrNjjuNiC6M7fbsOcnEwahDFmzqlekgqRcA7si0n388ajuXXPp
         0g5EQ/YSu1PQiG6TizR2hD/Bl3KuVK8vp0e1RpJ13UEXK95wBbrVLaeIY2EYJ/HlCQ6n
         Rh6vvIgAjij32B7Ea5T4uni+rzBYQ1VvIy/wLm9dDT7ejxbSqQifvqj1wrnrIrYNz54I
         1a6H0IUX8yiipRIYkUofacycjcthsYd32mB7w64wb16VW9N3HdU4vR15seun2dS4y7Iy
         QvZNy3DT/x0YqNQMLrtAaA0z7JL6IS2IHtAuTfodVQVBXl9qopyRb75Vk+MDbintTNeq
         P3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677942047;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :references:in-reply-to:reply-to:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CfP2cvpb5Xi9ZJt78Gn/eATBTB7rrYLrU2oF9/cMHNY=;
        b=BpZEDHWf3ksqqa2HD+MFU35HSkNbUFXUE8+NQ7R3cQOM19g9wUW371USuOYOp9aNSE
         UXE8ackOxFN6NoWmadhrQr/l9LIYwghVFPAA473uK05vTU0GnSVc08uh9J8S30H/mf+e
         fHROvLUkUjXjClaF1NYwQ22NB8Ul9XyN1YEqCnF/U0t6XsI3CbclZ9qwMKaTOGI2EXZu
         GC5ZecVRSZJzLSBfzGIXzsxF4skfA9x7VWd2T+zcURCyxGE8Gee3W9s+KH+R7zb4fdsc
         Pfq9jMVzv7teTyl7jrUf6TZN6F2z3UKxZdVgRAWyvNIzWSBCdnPGn103L4neeQ0BIHMZ
         8Yfg==
X-Gm-Message-State: AO0yUKU6QCq2byriu0Exl5IhPmcoMLGH8TDE5GvqQ+ZMTcDspyWesEkk
        GnzDnjwd0uQ3PiZUDJm+fktkJk6IOmhW5b8CGFw=
X-Google-Smtp-Source: AK7set+10E4vuJOJDIj1VVLhgkEfeulik1x0uIajc7+fs6T65yt7N3TGq+wOFB50pIs0alXZPsvmVCrxP/krhJvdM1c=
X-Received: by 2002:a63:2948:0:b0:503:7bcd:9806 with SMTP id
 bu8-20020a632948000000b005037bcd9806mr1672944pgb.4.1677942047636; Sat, 04 Mar
 2023 07:00:47 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:2811:b0:44a:b5db:d3ed with HTTP; Sat, 4 Mar 2023
 07:00:47 -0800 (PST)
Reply-To: banqueatlantiquetogobranch@gmail.com
In-Reply-To: <CAN0R7i1KV_s48E+hdcL6t7R4RYSoVW2M84YEssmbJEa5M5apCQ@mail.gmail.com>
References: <CAN0R7i1KV_s48E+hdcL6t7R4RYSoVW2M84YEssmbJEa5M5apCQ@mail.gmail.com>
From:   "Mrs.Kristalina Georgieva" <nwakaideyaodumodu5@gmail.com>
Date:   Sat, 4 Mar 2023 15:00:47 +0000
Message-ID: <CAN0R7i1A_chFABe8YO8Gt6XXRCHis9AGjQvoqDemzTW_BJjejA@mail.gmail.com>
Subject: Attn
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:543 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [nwakaideyaodumodu5[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [nwakaideyaodumodu5[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  3.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FONDUL MONETAR INTERNA=C8=9AIONAL HQ 1
700 19th Street, NW, Washington, DC 20431 .
FONDUL MONETAR INTERNA=C8=9AIONAL.
Stimate proprietar de e-mail/destinatar al fondului,
Sunt doamna Kristalina Georgieva, director executiv =C8=99i pre=C8=99edinte=
 al
Fondului Monetar Interna=C8=9Bional. =C3=8Entr-adev=C4=83r, am analizat toa=
te obstacolele
=C8=99i problemele care au =C3=AEnso=C8=9Bit tranzac=C8=9Bia dvs. incomplet=
=C4=83 =C8=99i incapacitatea
dvs. de a face fa=C8=9B=C4=83 taxelor de transfer percepute pentru trecutul
op=C8=9Biunilor de transfer, vizita=C8=9Bi confirmarea noastr=C4=83 pagina =
38 =C2=B0 53'56 "N
77 =C2=B0 2" 39 =E2=80=B3 F.

Consiliul de administra=C8=9Bie al B=C4=83ncii Mondiale =C8=99i al Fondului=
 Monetar
Interna=C8=9Bional (FMI) Washington D.C., =C3=AEn cooperare cu Departamentu=
l de
Trezorerie al SUA =C8=99i cu alte agen=C8=9Bii de investiga=C8=9Bie relevan=
te din Statele
Unite, au ordonat Unit=C4=83=C8=9Bii noastre de transfer str=C4=83ine BANQU=
E ATLANTIQUE
INTERNATIONAL TOGO s=C4=83 converteasc=C4=83 un fond de compensare =C3=AEn =
valoare de EUR
761.000,00 =C3=AEntr-un card master ATM =C8=99i trimite=C8=9Bi-v=C4=83.

=C3=8En timpul investiga=C8=9Biei noastre, am fost =C3=AEngrozi=C8=9Bi s=C4=
=83 constat=C4=83m c=C4=83 fondul
dvs. a fost =C3=AEnt=C3=A2rziat =C3=AEn mod inutil de func=C8=9Bionari coru=
p=C8=9Bi ai b=C4=83ncilor care
=C3=AEncercau s=C4=83 v=C4=83 redirec=C8=9Bioneze fondurile c=C4=83tre cont=
urile lor private pentru
interesul lor egoist, ast=C4=83zi dorim s=C4=83 v=C4=83 inform=C4=83m c=C4=
=83 fondul dvs. a fost
depus =C3=AEn BANQUE ATLANTIQUE. INTERNATIONAL TOGO, de asemenea, gata de
livrare, acum contacta=C8=9Bi DR.YAO GUEMEDI, directorul general at BANQUE
ATLANTIQUE INTERNATIONAL TOGO, e-mail:banqueatlantiquetogobranch@gmail.com,
Trimite=C8=9Bi urm=C4=83toarele informa=C8=9Bii pentru a-i permite s=C4=83 =
transfere fondul
total de compensare =C3=AEn valoare de 761.000,00 EUR =C3=AEntr-un bancomat=
. card =C8=99i
v=C4=83 trimite=C8=9Bi f=C4=83r=C4=83 nicio gre=C8=99eal=C4=83 sau =C3=AEnt=
=C3=A2rziere.

(1) Numele dvs. complet:
(2) Adresa dvs. de domiciliu:
(3) O copie a c=C4=83r=C8=9Bii na=C8=9Bionale de identitate sau a pa=C8=99a=
portului:
(4) =C8=9Aara dvs.:
(5) Cod po=C8=99tal:
(6) Num=C4=83rul dvs. de telefon privat:

Cu sinceritate
doamna Kristalina Georgieva
Director general =C8=99i pre=C8=99edinte al Fondului Monetar Interna=C8=9Bi=
onal.
