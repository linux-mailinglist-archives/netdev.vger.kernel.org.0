Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E598695882
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 06:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjBNFaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 00:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBNF35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 00:29:57 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2971493CF
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 21:29:57 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id g8so15428080vso.3
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 21:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O3iIghNYce+dgV8YXeRndeSBcZ6lqwpwyBMDGmIlOl8=;
        b=eEXN/rmUMvM9NEmKxN9Ue9KpV482KBq4WDCkGrQp2+zTrkonjV6w7wRwywOY+8xSVM
         5swR/H2nuL2ubmkZrWT9EsG2B9Ov1aS7iTD0OtQS4LPWL15XQqcttFix5586KUzOWDWW
         JK//H9mhAbVM91GlQOwobEhEPuF1skNwQR6MzFnXabACXauY4zmPIjLfmRIJWQrrvDVH
         cwffPbEHmIxo8TuOMpR8ySPL1bi53mzZ1y/HVEheoahgVxdpqS48rrnhxTG9snGkjqeG
         ahkr5oF1dt2jBVXoELcmiH7jald4El4CSWGnvWQteXRBysFROh9zv2z4BYHCtTy5MhzF
         wsKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O3iIghNYce+dgV8YXeRndeSBcZ6lqwpwyBMDGmIlOl8=;
        b=SwcDV6tVPMqt7Y1WYiZfBri31JTqCb0GRdb6r1SJzvzF461Mc7P0IcFxmssNuFzAzC
         w21C2wa3LgYUKrrYc0MyiOAhpKR8Xm/4pAgTiCwa7WxoFBNEjI0jQ6aVRkmhJtbkvd5r
         gwoTLNpJWQsp/nLK92j589vh59lYhmTlCsGbebHgJCPc8YpWHmXA+wXiMYfZkAyY7yy4
         w1e8QeNEa2fO7ezqa0ZwRk6fOaXVdHBidch06YGG1cRApibvjyZs/UpDPiNOmiQXC+Cn
         UspyGyE3Z8ofJIrgbG0Cy0oyibmExWenCbax6olP8XInXc9zYh0WaFUhw/y6a9lDeoJv
         D9Pg==
X-Gm-Message-State: AO0yUKW/YIkbaf1iYH2DbujUhJkp5y40o/Bq1VNqr2QY0wG5oBG3idY5
        5VOevIchFrhAyhNGBLdtr4+qTREGBOu8tfXGGCI=
X-Google-Smtp-Source: AK7set/NVshOBgNFLZ4QVROl1nW9Q8K5rPBktreaDbIU+Mqt7r7j4zjdx49yivkJhWw61+QVk3arrf2iKzZFJ2I1g3w=
X-Received: by 2002:a67:e143:0:b0:3fd:c79b:f165 with SMTP id
 o3-20020a67e143000000b003fdc79bf165mr153898vsl.81.1676352596125; Mon, 13 Feb
 2023 21:29:56 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab0:3da0:0:b0:683:a969:de0c with HTTP; Mon, 13 Feb 2023
 21:29:55 -0800 (PST)
Reply-To: cfc.ubagroup013@gmail.com
From:   Kristalina Georgieva <ubanitbankofficeups@gmail.com>
Date:   Mon, 13 Feb 2023 21:29:55 -0800
Message-ID: <CABPmsh_b3mAMq6aQonbpX4Hm6RLSjnTG9TdcYcFV+QRGUCaA9w@mail.gmail.com>
Subject: =?UTF-8?Q?BOAS_NOT=C3=8DCIAS?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prezado Benefici=C3=A1rio,
Enviei esta carta h=C3=A1 um m=C3=AAs, mas n=C3=A3o tive not=C3=ADcias suas=
, n=C3=A3o
Tenho certeza que voc=C3=AA recebeu, e =C3=A9 por isso que enviei para voc=
=C3=AA novamente,
Em primeiro lugar, sou a Sra. Kristalina Georgieva, Diretora Administrativa=
 e
Presidente do Fundo Monet=C3=A1rio Internacional.

Na verdade, revisamos todos os obst=C3=A1culos e quest=C3=B5es que envolvem
sua transa=C3=A7=C3=A3o incompleta e sua incapacidade de atender =C3=A0s co=
bran=C3=A7as
taxas de transfer=C3=AAncia cobradas, contra voc=C3=AA, pelas op=C3=A7=C3=
=B5es de
transfer=C3=AAncias anteriores, visite nosso site para confirma=C3=A7=C3=A3=
o 38
=C2=B0 53=E2=80=B256 =E2=80=B3 N 77 =C2=B0 2 =E2=80=B2 39 =E2=80=B3 W

Somos o Conselho de Administra=C3=A7=C3=A3o, o Banco Mundial e o Fundo Mone=
t=C3=A1rio
Internacional (FMI) de Washington, DC, juntamente com o Departamento de
Tesouro dos Estados Unidos e algumas outras ag=C3=AAncias de investiga=C3=
=A7=C3=A3o
relevante aqui nos Estados Unidos da Am=C3=A9rica. ordenou
nossa Unidade de Remessa de Pagamentos no Exterior, United Bank of
Africa Lome Togo, para lhe emitir um cart=C3=A3o VISA, onde $
1,5 milh=C3=A3o do seu fundo, para um maior saque do seu fundo.

Durante o curso de nossa investiga=C3=A7=C3=A3o, descobrimos com
consterna=C3=A7=C3=A3o que seu pagamento tenha sido atrasado por funcion=C3=
=A1rios corruptos
do Banco que est=C3=A3o tentando desviar seus fundos para suas contas
privado.

E hoje informamos que seu fundo foi creditado em um cart=C3=A3o
VISA pelo UBA Bank e tamb=C3=A9m est=C3=A1 pronto para ser entregue. Agora
entre em contato com o diretor do UBA Bank, seu nome =C3=A9 Sr. Tony
Elumelu, E-mail: (cfc.ubagroup013@gmail.com)
para lhe dizer como receber o seu cart=C3=A3o VISA Multibanco.

Sinceramente,

Sra. Kristalina Georgieva
