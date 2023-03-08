Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B596B0A94
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 15:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjCHOIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 09:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbjCHOIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 09:08:04 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B6A49885
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 06:06:53 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id d41-20020a05600c4c2900b003e9e066550fso1223121wmp.4
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 06:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678284411;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A2ALMeXKInwV18Uj5+ps6Eyw0ShOQbMyQJ8535xwOss=;
        b=QpSk5/wcMJa6fx7GkcOZ7la3uudJwtaifNdGugGA6FCrfLy3bNykZDsSrcef5oR9vM
         2BVs7I8uN3GkE3TzpmvE1bmVFPPxlp8y/5uvFffhkAdJD2IXnnpNsAC1bGafyUfdNZfv
         E2q+gGRvvXtqnWHuufNxZifUKGRa88MNuzvYAJj1aTBFJcDMaRR/XLn4SmvaMj5nmsS1
         bdXFi6GXhPbuN2+8o1TBslkoY/YGqR/CmydNLLWle/PBIZ0bCaJkvnJGWQzV0cPa7pkx
         fJanNiGPAoMFZ7E+VAD5C0QaoZ+otS1xAHc4+DYbBJAGxT4biVcVnP3r/WOYDF50Lg6p
         stGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678284411;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A2ALMeXKInwV18Uj5+ps6Eyw0ShOQbMyQJ8535xwOss=;
        b=zTkGpbyJVHIgs2MxgykZ7UrK+GlEw+9yAU5JkK12/zvN2D1V6qI4eI9lLtomOjh2O1
         qC27B1TxngcvoFhmIrJ+9NM1bPVDeAxIZGR7H8/Bkt+SkP15nxFAvVWdhsoE3HdfODYU
         71mbIsBaDaZ36vUxlehIoO902xTyUgqFgL0tovBcelOXFeSNWUXf7mfNZvWbsFvNF71K
         pXSoCeZ4Kdg7yeOpoljF3kphFBs+JoRPKFXQ9NZchqAn1UUqUa/MaZARCISgL770T2wF
         +MSHQjo40eex8N94myI8QRxB2jgrns7OS4rrATKL1kmUK8a6M+nlztIyp9X8FjH4AYeP
         lqIA==
X-Gm-Message-State: AO0yUKVEAU4u//S8Z9/lwTapUXdU92QMTS/jxNfLsC/D0RITXz4ktici
        e0rPvCjiHzG2w9eV8c8tJEpQUJv9yEeeYhDPww==
X-Google-Smtp-Source: AK7set/rQ/Xaj34XGb4b+g4Dw5Z+mSJXvDc+jpH0WgPLx9+9+g7u6Jz7dPe2qdVdIT3QektBSe1LI2q0BApzGNEphks=
X-Received: by 2002:a05:600c:1f06:b0:3df:d852:ee11 with SMTP id
 bd6-20020a05600c1f0600b003dfd852ee11mr4206786wmb.0.1678284411598; Wed, 08 Mar
 2023 06:06:51 -0800 (PST)
MIME-Version: 1.0
Reply-To: fernelydiane@aol.com
From:   Diane Soto <jankolendersgroup@gmail.com>
Date:   Wed, 8 Mar 2023 15:06:42 +0100
Message-ID: <CAA8C46SWPD-JRWCHTx8=n8hScdciBKSTVcvh4tOgz4EwNBTUmw@mail.gmail.com>
Subject: Hallo Liebste
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_MONEY_PERCENT,T_TVD_FUZZY_SECTOR,UNDISC_FREEM,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:32a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [jankolendersgroup[at]gmail.com]
        *  0.0 T_TVD_FUZZY_SECTOR BODY: No description available.
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.1 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hallo

    Mein Name ist Diana Soto. Ich bin das einzige Kind/die einzige
Tochter des verstorbenen Ingenieurs Fredrick Soto. Mein Vater war ein
sehr wohlhabender =C3=96l- und Gasunternehmer, er hatte auch umfangreiche
Investitionen im Immobilien- und Agrarsektor.

Mein Vater wurde von seinem b=C3=B6sen Bruder aus Eifersucht zu Tode vergif=
tet.

  Meine Mutter starb am 20. M=C3=A4rz 2003 bei einem schrecklichen
Autounfall zusammen mit meinem =C3=A4lteren Bruder Jerry (7 Jahre alt) und
meinem kleinen Bruder Alex (8 Monate alt). Ich war 3 Jahre alt, als
diese Trag=C3=B6die meine Familie traf

  bevor mein Vater in einem privaten Krankenhaus starb, rief er mich
heimlich an sein Bett und sagte mir, dass er die Summe von
(7.500.000,00 EUR) sieben Millionen, f=C3=BCnfhunderttausend EUR nur auf
einem Festgeldkonto bei einer der Prime Bank hier in hat Abidjan, und
er benutzte meinen Namen als seinen Erben / Nutznie=C3=9Fer.

  Er erkl=C3=A4rte mir weiter, dass meine Onkel ihn wegen seines Reichtums
vergiftet h=C3=A4tten. Er riet mir, einen ausl=C3=A4ndischen Partner in ein=
em
Land meiner Wahl zu suchen, wo ich dieses Geld =C3=BCberweisen und es f=C3=
=BCr
Investitionen wie Immobilien oder andere gesch=C3=A4ftliche Unternehmungen
verwenden w=C3=BCrde, die ich mit dem ausl=C3=A4ndischen Gesch=C3=A4ftspart=
ner
ausgehandelt hatte.

  Bitte, ich bitte Sie ehrenhaft um Ihre Hilfe auf folgende Weise:

  (1) Bereitstellung eines Bankkontos, auf das dieses Geld =C3=BCberwiesen =
wird.

  (2) Als Anlageverwalter dieses Geldes zu fungieren.

  (3) Eine Vereinbarung zu treffen, dass ich in Ihr Land komme und
meine Ausbildung fortsetze

  (4) Um eine Aufenthaltserlaubnis f=C3=BCr mich in Ihrem Land zu erhalten.

  Au=C3=9Ferdem bin ich bereit, Ihnen 20 % des Gesamtbetrags als
Entsch=C3=A4digung f=C3=BCr Ihre Bem=C3=BChungen / Ihren Einsatz anzubieten=
, nachdem
ich diesen Betrag erfolgreich auf Ihr Bankkonto =C3=BCberwiesen habe.

  Bitte geben Sie Ihre M=C3=B6glichkeiten an, mich zu unterst=C3=BCtzen, da=
 ich
glaube, dass diese Transaktion innerhalb weniger Tage abgeschlossen
sein wird, damit Sie Ihr Interesse zeigen, mir zu helfen. Ich warte
mit gro=C3=9Fem Interesse auf Ihre Antwort

Mit freundlichen Gr=C3=BC=C3=9Fe
Diana Soto
