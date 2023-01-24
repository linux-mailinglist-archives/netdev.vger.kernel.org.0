Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7CC679455
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 10:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbjAXJiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 04:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbjAXJiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 04:38:14 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E31C3E0A3
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 01:38:06 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id h12so9251620wrv.10
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 01:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TtBQmrCG35ddZ+2/TXf0f3Gsz1JE4wBwkIjqfk22GzM=;
        b=WxBHnyTuVZ/7mh+Li/IMYUa76k6ThLFYmwRPmt9f99uhyYimDbKgf8g1LCip/lCUNU
         uYFUBNj857JUa6dknyB//IS4ozqVVE3CY0KfyKT1UAyLCgaRRL/6/zMsMoY8zlZbf2V0
         TLDUrSkGCjGu/1dZVhQI3OUuciDcWq8ccF7SjzE2w18CD6hxAlyDeK18gk1QbO97YbLy
         kD41rSh+d2+3AXGmpQfEj8RjMTL6JRgLRPM/9XFzOXsgDa2GxfkFPHbXkrYBQOJxQRLy
         3WUku8uWY5f/jbOOS083iEPdmVFSI5z0Yd/oOZ+meSR4UxxIPp/kktGNREQw9eyQNC83
         tdqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TtBQmrCG35ddZ+2/TXf0f3Gsz1JE4wBwkIjqfk22GzM=;
        b=Y4KuGX7HUHQecvl68d1mDle+psjRH5ipgTJEYK7yZ21rdMfvSNLxu5tlwOIUC+IctA
         F0Bax/GeM+24dQ+xaLnXdOuV31J79stSWRMlWaG+nK3BzyrwyNnpQf13XfRO/FTR9ESC
         LcTIjLoQzGa3pca1DjllFCVLFd7GqNWzYb78RTebqRvsQqK0E437sHo7nFvn6s+g4NBK
         Hy6ddacpSft+P7xilF66TEAVtCeB4AqjowHhYUAffbMAIXqMss2Bb2Gyk+580D0UMmMU
         bW/8EgwlIAVJ2wswiSMpb1wX5Ew1Qas+FQZiOLjHDf9eMyPYd2fTuZOQrMFISzZP3rA1
         OzSw==
X-Gm-Message-State: AFqh2kpsGr70zysDOwPzaVR9B5R1jLmLMQOXKeidxJm9E6B4r5o7ID7X
        n1MFY7FL2A/jJHkFHPHSVWXSQuQImO+RHocwIsk=
X-Received: by 2002:a5d:6b4d:0:b0:2bb:91d:35e5 with SMTP id
 x13-20020a5d6b4d000000b002bb091d35e5mt1213699wrw.142.1674553084539; Tue, 24
 Jan 2023 01:38:04 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:adf:f5d0:0:0:0:0:0 with HTTP; Tue, 24 Jan 2023 01:38:03
 -0800 (PST)
Reply-To: fatemahabbas0@gmail.com
From:   "Mrs. Fatemah Abbas" <suryazbell@gmail.com>
Date:   Tue, 24 Jan 2023 01:38:03 -0800
Message-ID: <CAL-aGqQQ=TfuzEFSDqsV=qXv9GZ_aO5FKBvez_WCgZdvKUztag@mail.gmail.com>
Subject: =?UTF-8?B?VmllbGUgR3LDvMOfZQ==?=
Cc:     mx-wagner@web.de, drsheemakhaja@gmail.com, my.transport@gmx.de,
        mybeeki@aol.com, mycm@gmx.de, mydekoflair@gmail.com,
        mynextorder@gmx.de, n-scheungraber@gmx.de, n.hohoff@freenet.de,
        n.kellmann@gmx.de, n.kesetovic@outlook.com,
        n.schlieker@t-online.de, n.simon-gerl@t-online.de,
        N.Suelzer@outlook.de, n.thoem@gmx.de, n_nebel@web.de,
        nachbarschaftshilfe@gmx.net, nachbarschaftshilfe-arnach@gmx.de,
        nachbestellung@timoerhard.de, nachhaltig_handeln@freenet.de,
        nachname.hvgg@gmx.de, Nachrichtmail@orthopaedie-enz.de,
        nachtkonzerte@gmail.com, nader7@freenet.de,
        nadia_tennis@outlook.com, nadine-fetzer@gmx.de, nadjesther@aol.com,
        naegele-teningen@t-online.de, naehmitfischer@aol.com,
        naehteam.landfrauen@gmx.de, nafla4@gmx.de, nagel-leipzig@gmx.de,
        nagold@freenet.de, nahkaufphilipp@t-online.de, nahlox@freenet.de,
        nak.elv@gmx.net, namaste@authentikka.de, nancy.beuntner@unibw.de,
        nancy.fischer@gmx.net, nanina.n@gmx.de, nartakipriya@gmail.com,
        naschinsel@web.de, natalie.gauder@web.de, natalie.thaens@gmail.com,
        natalieberrisford@gmail.com, nataschajung@freenet.de,
        nathanrihm@gmx.de, natourpur-schauinsland@gmx.de,
        natrop@isrw-klapdor.de, Nattheim.Schwimmen@gmx.de,
        natur@breuner-hof.de, natur.erleben.live@gmail.com,
        natura-balance-gmbh@gmx.de, naturfreundejugend.mv@freenet.de,
        naturheilpraxis@annerose-brandt.de,
        naturheilpraxis.schaaf@freenet.de,
        naturheilpraxis.schulze@email.de, natursteinbock@aol.com,
        naturunddesign@t-online.de, Nauert@kanzlei-mn.de,
        naumannandreas@t-online.de, neal.fischer@gmail.com,
        nedaleopold@t-online.de, neeb-matthias@gmx.de,
        Negin.falken@yahoo.com, neilyoungfanclub@gmx.de,
        neitzel.verl@freenet.de, neki.djaja@gmail.com,
        nell.zivojevic@web.de, nelli_lechner@outlook.de,
        netdev@vger.kernel.org, nettenachrichtennett@gmx.de,
        netti.ufer@icloud.vom, netzwerkertom@gmail.com,
        Neubauer-Matthias@gmx.de, neubauer.susanne@gmx.net,
        neubrander@web.de, neuekrone@freenet.de, neuenfeld99@gmail.com,
        neuenkirch@uni-trier.de, neuhaus-mueller@gmx.net,
        neukauf-hauguth@t-online.de, neumann-matthias@t-online.de,
        neumann.matthias@freenet.de, neumannbastian@web.de,
        neumibad@gmx.de, neuners@freenet.de, neunmalweinrich@aol.com,
        neuro-zentrum-nienburg@gmx.de, neurologie-kurpfalz@t-online.de,
        neuschwanstein@gmx.com, neveling@hist.unibe.ch,
        news@nordicmarketing.de, newsroom.thederrick@gmail.com,
        nf@outlook.de, nf.frank@web.de, ng.la@t-online.de,
        ngehrmeyer1@aol.com, ngoedde@web.de, ngtrang12.ftu@gmail.com,
        nhpkoehler@aol.com, nice.pilot1@gmx.net,
        nicholasherrmann521@gmail.com, nick-wilhelm@gmx.de,
        nickstave.DSV91@gmx.de, nico.engel2000@web.de,
        nico.hebenstreit@freenet.de, nico.vrazic@aol.de, nicobretz@gmx.de,
        nicoeckardt@gmx.net, nicokersten@gmx.de,
        nicola.ciliax-kindling@cdu-odenthal.de,
        nicolas@sancyexpertiseparis.com, nicole.burkowski@t-online.de,
        nicole.kunkel@student.hu-berlin.de, nicole.loecher@aol.de,
        nicole.lynar@gmx.de, nicolegildner@gmx.de, nicolekleinert@gmx.de,
        nicolettemueller@freenet.de, nicop.matthias@t-online.de,
        nicoschulz@freenet.de, nicwfischer@gmail.com,
        niederburg-manderscheid@gmx.de,
        niederkirchen@fischer-landmaschinen.de, niedlich.gross@gmail.com,
        niehues.michael@freenet.de, niehuesbernd@freenet.de,
        niels.gaby.hansen@freenet.de, niels.grabe@gmail.com,
        niemeyer.fdp@gmail.com, nieweg-gmbh@t-online.de, nik.fabian@web.de,
        niklas@evofitness.de, niklas@hochtiedswald.de,
        niklas.stratmann.ns@gmail.com, niklaus.naturholz@t-online.de,
        Niko.fischer1983@gmail.com, nikolagehrt@gmail.com,
        nikolaos.loukidelis@gmail.com, nikolaus.kern@t-online.de,
        nikolaus.schreyer.kg@t-online.de, nikolauslauf-beilngries@gmx.de,
        niloufar.deihimi@aol.de, nils.wuetherich@gmail.com,
        NilsMalte112@aol.de, nilspeterfitzl@gmx.net,
        nimmerland-mainz@gmx.de, nina-fischer@freenet.de,
        nina-maria@gmx.net, nina-steffen@gmx.net, nina-weck-schule@web.de,
        nina.adam@uni-potsdam.de, nina.ukrainehilfe@gmail.com,
        ninakrannich@web.de, nino.philipp@freenet.de, nirak.fischer@web.de,
        nitsche@fwnl.de, nitsche.matthias@web.de,
        nitschke.annett@gmail.com, nitschkelars177@gmail.com,
        njk.rsv@gmail.com, Nkbetreuung@gmail.com, nlim_ev@outlook.com,
        nm.dellinger@gmx.de, nn.weritz@freenet.de, no-ka-fischer@web.de,
        noarts.tattoo@gmail.com, nobbiknipp@freenet.de, Nobbyanne@gmx.de,
        nobfabian@t-online.de, nobird-ipv@gmx.de, nochnichtdasende@gmx.de,
        noehmeier1@aol.com, noehre32@freenet.de, noelthiombiano@gmail.com,
        nojopo@gmx.de, noleeni.fischer@gmail.com,
        nongnuch.artrith@gmail.com, nora.fischer@freenet.de,
        noramichelshof@aol.com, norbert.brigitte.Schmidt@gmail.com,
        norbert.kleese@t-online.de, norbert.mueller53@gmx.de,
        norbert.proeschel@t-online.de, norbert.theuerkauf@gmail.com,
        norbert.vogelmair@bbw.de, norbertmagel@germania-steinbach.de,
        norbertrexinsv@aol.com, norbertsteffen@t-online.de,
        nordapotheke@t-online.de, nordapotheke-pritzwalk@gmx.de,
        norddoerfer-kirchenbuero@t-online.de, nordlicht@evkirchepotsdam.de,
        norull@freenet.de, notar@dr-radke-zeitz.de,
        notarkammer@notarkammer-sachsen.de, notentext@gmail.com,
        nothhelfer@freenet.de, notz@bistum-muenster.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_GMAIL_RCVD,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,
        MISSING_HEADERS,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lieber Freund, kannst du mir helfen!!!

   Guten Tag und Komplimente der Jahreszeiten, ich wei=C3=9F, es ist wahr,
dass dieser Brief Sie =C3=BCberraschen kann. Trotzdem bitte ich Sie
dem=C3=BCtig, mir Ihre Aufmerksamkeit zu schenken und mir zuzuh=C3=B6ren. S=
ie
haben Ihre E-Mail-ID von den Handelsministerien und
Au=C3=9Fenhandelsabteilungen Ihres Landes erhalten. Ich schreibe Ihnen
diese Mail mit tiefer Trauer in meinem Herzen, diese Massage mag f=C3=BCr
Sie =C3=BCberraschend kommen, aber ich habe mich entschieden, Sie =C3=BCber=
 das
Internet zu erreichen, weil es immer noch das schnellste
Kommunikationsmedium ist. Dieses Medium Internet wurde stark
missbraucht.

     Mein Name ist Frau Fatemah Abbas. Ich bin eine sterbende Frau und
habe beschlossen, Ihnen das zu spenden, was ich habe, f=C3=BCr wohlt=C3=A4t=
ige
Zwecke/Hilfe f=C3=BCr weniger privilegierte Menschen in der Gesellschaft.
Ich bin 62 Jahre alt und bei mir wurde vor etwa 4 Jahren Krebs
diagnostiziert, unmittelbar nach dem Tod meines Mannes, der mir alles
hinterlassen hat, wof=C3=BCr er gearbeitet hat, und weil mein Arzt mir
gesagt hat, dass ich die Dauer von einem Jahr aufgrund von nicht
durchhalten w=C3=BCrde ein Krebsproblem. Aus gesundheitlichen Gr=C3=BCnden =
habe
ich von meinem verstorbenen Ehemann einige Gelder geerbt, die Summe
von drei=C3=9Fig Millionen Dollar (30.000.000,00 $) und ich brauchte eine
sehr ehrliche Person, die dieses Geld abheben und dann die Gelder f=C3=BCr
wohlt=C3=A4tige Zwecke verwenden kann.

    Ich habe mich entschlossen, Sie zu kontaktieren, wenn Sie bereit
und interessiert sind, diese Treuhandgelder in gutem Glauben zu
verwalten, bevor mir etwas passiert. Ich m=C3=B6chte eine gute Person, die
das Geld verwendet, um f=C3=BCr Wohlt=C3=A4tigkeitsheime zu arbeiten, und i=
ch
habe Sie ausgew=C3=A4hlt, nachdem ich Ihr Profil durchgesehen habe. Ich
m=C3=B6chte, dass dieses Geld mit den weniger Privilegierten geteilt wird,
da ich kein Kind habe, das das Geld erben k=C3=B6nnte.

     Daher der Grund f=C3=BCr diese mutige Entscheidung, weil ich kein Kind
habe, das dieses Geld nach meinem Tod erben wird. Ich brauche dringend
Hilfe und habe den Mut aufgebracht, mich f=C3=BCr diese Aufgabe an Sie zu
wenden, Sie d=C3=BCrfen mich und die Millionen armer Menschen in der
heutigen Welt nicht im Stich lassen. Dies ist kein gestohlenes Geld
und es sind keine Gefahren damit verbunden, es ist 100% risikofrei mit
vollem Rechtsnachweis.

  Dieses Geld ist immer noch bei der Bank und die Gesch=C3=A4ftsleitung hat
mir als dem wahren Eigent=C3=BCmer gerade geschrieben, ich solle mich
melden, um das Geld f=C3=BCr die lange Aufbewahrung zu erhalten, oder
vielmehr jemandem eine Vollmacht ausstellen, es in meinem Namen
entgegenzunehmen, da ich nicht kommen kann wegen meiner Krankheit
vorbei oder sie bekommen es eingezogen. Ich h=C3=A4tte dich gerne von
Angesicht zu Angesicht getroffen, bevor ich diese Mutter Erde
verlasse, aber die Krankheit nimmt mir weiterhin die Chance, selbst
wenn ich w=C3=A4hrend dieser Operation sterbe. Ich wei=C3=9F, dass du mich =
nicht
im Stich lassen wirst.

Zur Zeit bin ich mit meinem Laptop hier in einem Krankenhaus, wo ich
wegen Lungenkrebs behandelt wurde. Es ist mein letzter Wunsch, dass
dieses Geld in eine Organisation Ihrer Wahl investiert und jedes Jahr
an die Wohlt=C3=A4tigkeitsorganisation, die Armen und die Heime mutterloser
Babys verteilt wird.

Ich m=C3=B6chte, dass Sie dieses Geld verwenden, um Waisenh=C3=A4user und W=
itwen
zu finanzieren; Ich habe diese Entscheidung getroffen, bevor ich in
Frieden ruhe, weil meine Zeit bald abgelaufen ist. Sobald ich Ihre
Antwort erhalten habe, werde ich Ihnen die Kontaktdaten mitteilen. Ich
versichere Ihnen absolut, dass es mit diesem Geld keine Probleme gibt,
weil es das Geld meines verstorbenen Mannes ist.

Ich m=C3=B6chte, dass Sie 45 Prozent des gesamten Geldes f=C3=BCr Ihren
pers=C3=B6nlichen Gebrauch verwenden, w=C3=A4hrend 55 % des Geldes f=C3=BCr
wohlt=C3=A4tige Zwecke verwendet werden. Ich werde Ihre =C3=A4u=C3=9Ferste
Vertraulichkeit und Ihr Vertrauen in dieser Angelegenheit sch=C3=A4tzen, um
meinen Herzenswunsch zu erf=C3=BCllen, da ich nichts will, was meinen
letzten Wunsch gef=C3=A4hrden k=C3=B6nnte. Bitte antworten Sie mit weiteren
Details.


Ihre Schwester.
Frau Fatemah Abbas
