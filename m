Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0BF581707
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 18:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbiGZQK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 12:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbiGZQK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 12:10:26 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03518B1CD
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 09:10:26 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id s7so5781775uao.4
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 09:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=2geObz/qPbQ0zmW0zjdppN56rmNh6IuNe6i2t19UWOo=;
        b=hBeMpoFS/kw+lOSTjppnB4RigGRHn8N3FGYYylSVWmmPVjToCt5koZDIb+MT6f879m
         ZX63D1CmB9mpRAvKy9owjRflewrTyaF8jreg/8n+VTv3zWbJyliNOuqBLioiP4dcHS7J
         2UYe1gAp/bVbNdeWCHQskkm1QuLZxVeq0fZG5pkw6qYuU0YnPN6zDGX7S3PMxE+zoCrZ
         Txs4rRr8GzsLOSqBl+9F296e9iGyoRhFCU+kcUf+BE1tUatxjC4BSq60ArVXQogzgEp4
         zFOhOWtwYMKmICf99pCF7o7Z6kgdZb3qxxkpBNNh4V29PDqVINRzgTmOz6knY/lXy7Ws
         uKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=2geObz/qPbQ0zmW0zjdppN56rmNh6IuNe6i2t19UWOo=;
        b=Pdvm/Nbz+manQRY4eg9oYDvJRm4dfUbfkVmFRjiQTGfVD47a9beANaaOy3P2Gq44CF
         5DC+UAShbp/053lfIfL76VFREGicv80ayTgNiEHmPE8EKNY9Y7ggl9oCZuXXipoEtkHB
         kW9cVD06IWCi3VWtgtqsqURdAl7KH4lvBDUJT7JNNzDZ0ln1WQuRMn53R8Yk434Y2Nf/
         53PeQHG4oGrARjyxVxfvOQY5ZQyHIRe5k+lIy1RmWocpmvMHWRX1dQpw9d4ihNiVNAiA
         YInFFax2sVdmfOjthg1ZM8QOX6+5Cs5GlhGL2rPk5u7VYAJC8isedB3qveYBJvSJaMLm
         Eeig==
X-Gm-Message-State: AJIora8gANQocRLk7UAl0BrGBlJ+13Vvkbxmwk7KSPKg4EQYoXW68LAJ
        ojk5dpLvhGHqXLBbgWxJ90N8LGfbwMXbYLnkK/o=
X-Google-Smtp-Source: AGRyM1viMKAfkG+8jEVscvKm8OIR42qUFSDTUBQw3eI2u3wDRYaPizgPG2L1EzIrc2z6mGIwBj9/2j4lsvVr5vzvC+o=
X-Received: by 2002:ab0:3446:0:b0:384:c8b9:1366 with SMTP id
 a6-20020ab03446000000b00384c8b91366mr2073395uaq.66.1658851823297; Tue, 26 Jul
 2022 09:10:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a67:ea88:0:0:0:0:0 with HTTP; Tue, 26 Jul 2022 09:10:22
 -0700 (PDT)
Reply-To: cfc.ubagroup09@gmail.com
From:   Kristalina Georgieva <ubagroup.tgo12@gmail.com>
Date:   Tue, 26 Jul 2022 09:10:22 -0700
Message-ID: <CADnAz74E3wuqbZiXM9SHh2eUDV+JVYgjiw4PB7ZVKs6UdT234Q@mail.gmail.com>
Subject: =?UTF-8?Q?GOWY_T=C3=84ZELIK?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hormatly pe=C3=BDdalanyjy,
Bu haty size bir a=C3=BD =C3=B6=C5=88 iberipdim, =C3=BD=C3=B6ne sizden e=C5=
=9Fitmedim, =C3=BDok
Al=C3=BDandygy=C5=88yza ynan=C3=BDaryn we =C5=9Fonu=C5=88 =C3=BC=C3=A7inem =
size =C3=BDene iberdim,
Ilki bilen men dolandyryjy m=C3=BCdir Kristalina Georgi=C3=BDewa we
Halkara Wal=C3=BDuta Gaznasyny=C5=88 prezidenti.

Aslynda, t=C3=B6weregind=C3=A4ki =C3=A4hli p=C3=A4sgel=C3=A7ilikleri we mes=
eleleri g=C3=B6zden ge=C3=A7irdik
doly d=C3=A4l amaly=C5=88yz we t=C3=B6legleri =C3=BDerine =C3=BDetirip bilm=
ezligi=C5=88iz
opsi=C3=BDalary =C3=BC=C3=A7in size gar=C5=9Fy t=C3=B6leg t=C3=B6len=C3=BD=
=C3=A4r
=C3=B6=C5=88ki ge=C3=A7irimler, tassyklamak =C3=BC=C3=A7in sahypamyza giri=
=C5=88 38
=C2=B0 53=E2=80=B256 =E2=80=B3 N 77 =C2=B0 2 =E2=80=B2 39 =E2=80=B3 W.

Biz direktorlar ge=C5=88e=C5=9Fi, B=C3=BCtind=C3=BCn=C3=BD=C3=A4 banky we P=
ul gaznasy
Wa=C5=9Fington, Halkara Halkara Pul Gaznasy, B=C3=B6l=C3=BCm bilen bilelikd=
e
Amerikany=C5=88 Birle=C5=9Fen =C5=9Etatlaryny=C5=88 Gazna we k=C3=A4bir be=
=C3=BDleki der=C5=88ew guramalary
Amerikany=C5=88 Birle=C5=9Fen =C5=9Etatlarynda degi=C5=9Flidir. sargyt etdi
Da=C5=9Fary =C3=BDurt t=C3=B6leg t=C3=B6leg b=C3=B6l=C3=BCmimiz, United Ban=
k
Afrika Lome Togo, size $ VISA karto=C3=A7kasy bermek =C3=BC=C3=A7in
Gaznadan has k=C3=B6p pul almak =C3=BC=C3=A7in gaznadan 1,5 million.

Der=C5=88ewimizi=C5=88 dowamynda g=C3=B6zledik
t=C3=B6legi=C5=88izi=C5=88 korrumpirlenen i=C5=9Fg=C3=A4rler tarapyndan gij=
ikdirilendigine alada bildiri=C5=88
seri=C5=9Fd=C3=A4=C5=88izi hasaby=C5=88yza g=C3=B6n=C3=BCkdirm=C3=A4ge syna=
ny=C5=9F=C3=BDan Banky=C5=88
hususy.

Bu g=C3=BCn bolsa gaznany=C5=88yzy=C5=88 Karta berilendigini habar ber=C3=
=BD=C3=A4ris
UBA Bank tarapyndan VISA we eltip berm=C3=A4ge ta=C3=BDyn. Indi
UBA Bank m=C3=BCdiri bilen habarla=C5=9Fy=C5=88, ady jenap Toni
Elumelu, E-po=C3=A7ta: (cfc.ubagroup09@gmail.com)
bankomat VISA karty=C5=88yzy n=C3=A4dip almalydygyny a=C3=BDtmak =C3=BC=C3=
=A7in.

Hormatlamak bilen,

Hanym Kristalina Georgi=C3=BDewa
