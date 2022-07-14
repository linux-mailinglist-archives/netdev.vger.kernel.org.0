Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F549574AC0
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 12:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbiGNKfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 06:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238387AbiGNKfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 06:35:40 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC1A4BD2C
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:35:39 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id v1so715942ilg.11
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=29tps+9Vx4Ah6HjVzgQNT8G3zq4JUHfB4WRdFaWK7Io=;
        b=QcSLS+pbeuFWl+CmTiDhfXMlu7Lq682v+zm3WLaCeaykg4g4s/wgjaBoJqmO51gVP2
         zlwsmwsyKsb19oqYOYYVw01KY5SbimW5Cat+YW3E2nFdbQ1TBgmewUOuG/6Q4Dg/Wx9f
         Oi/s0THZbaNgMx/IbnZXEnC8izElXZOpcDipiA72i/6Bd1cjpNK71EUV9b3dXk+2FOqU
         UZIvq0bRRzgnW6xpnhhGd2+Kc3rscthA2baMvTeJ4lBpX7KqpRYEBpAZmPOTMg7/ymSi
         La+SJK/ZHT/Xxreybc5QDXLRDzSsFgbPuvr/jXkDVAs0iNSxRoYLhUzoZN/I42a7mKDx
         X30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=29tps+9Vx4Ah6HjVzgQNT8G3zq4JUHfB4WRdFaWK7Io=;
        b=vSrv1zw9Koen87c2G68rZiFVCd7U5TmZZ2F4HWhxUktjnPcb2ZsB4oQQysCx4ITBf8
         K/NSQ+TFMcaSIDb/9Nuhccs5F/GTVqzLMcfnunUuh6Bb7meiB5Wgj/O3aFK3paoiYU5U
         M2L+rgr/wxC6ZMg9QILdt/q8i+9Gco92CYIglaGIMUzBY2+bGzySeXRIfRVn8brEMktl
         UT6pDrJXglAwG0o0bcSz7rifL6ogbLtHgbLzEe00P9pvU0UTvF/AJYXhXGDe+K+/pkRP
         N23lIo0bYnPQHvZ/UnoocdJy4YvuyLiTpFfbldD5J5MUx/pWyHNcLU5we0m/HeZewZMA
         3Qxg==
X-Gm-Message-State: AJIora+oEDN89InlHRxqbojK8Xh6O9uXI2TispNkPUjjR2ZWrkxnQbm4
        pPrm4KCQMbRhkMEeLn2KYenlgkABhHZiiV1CLyk=
X-Google-Smtp-Source: AGRyM1sqSp0zBtAJcSnFjhqOawDk2sFdaw4SUrfmmsvVvZs1HmaL53Q2ZCcHOlL0QlGHuiRZIsRJYW793cCwu7dDMI4=
X-Received: by 2002:a92:d409:0:b0:2dc:40d:169 with SMTP id q9-20020a92d409000000b002dc040d0169mr4307618ilm.135.1657794939309;
 Thu, 14 Jul 2022 03:35:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6e02:106d:0:0:0:0 with HTTP; Thu, 14 Jul 2022 03:35:38
 -0700 (PDT)
Reply-To: jon768266@gmail.com
From:   johnson <adjassou665@gmail.com>
Date:   Thu, 14 Jul 2022 10:35:38 +0000
Message-ID: <CADTOec+_J+VGFUNczVFAzi983jOZu+Gg1g=frqnNtLrfuzQLdg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:144 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4990]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [adjassou665[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jon768266[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [adjassou665[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Z veseljem vas obve=C5=A1=C4=8Dam o uspehu pri prenosu teh sredstev v
sodelovanju z novim partnerjem iz Indije. Trenutno sem v Indiji zaradi
nalo=C5=BEbenih projektov z lastnim dele=C5=BEem skupne vsote. Medtem pa ni=
sem
pozabil va=C5=A1ih preteklih prizadevanj in poskusov, da bi mi pomagali pri
prenosu teh sredstev, kljub temu, da nam nekako niso uspeli. Zdaj se
obrnite na mojo tajnico v Lomeju v Togu z njegovimi spodnjimi
kontakti, izpustil sem potrjeno kartico Visa za bankomat, prosite ga,
naj vam po=C5=A1lje kartico Visa za bankomat v vrednosti 250.000,00 $, ki
sem jo pustil pri njemu kot nadomestilo za vsa pretekla prizadevanja
in poskuse da mi pomagate pri tej zadevi. Takrat sem zelo cenil va=C5=A1
trud.

Zato vas prosimo, stopite v stik z mojo tajnico in mu naro=C4=8Dite, kam
naj vam po=C5=A1lje bankomatsko kartico Visa, ki vsebuje znesek. Prosim,
takoj mi sporo=C4=8Dite, =C4=8De ga prejmete, da bomo lahko skupaj delili
veselje po vsem trpljenju v tistem =C4=8Dasu. trenutno sem tukaj zelo
zaposlen zaradi nalo=C5=BEbenih projektov, ki jih imava jaz in novi
partner, kon=C4=8Dno se spomni, da sem svoji tajnici posredoval navodila na
tvoje ime, da izdam kartico Visa za bankomat in samo tebi , zato vas
prosimo, da stopite v stik z njim in mu posredujete svoje podatke,
va=C5=A1a polna imena, naslov in kontaktno =C5=A1tevilko za la=C5=BEjo komu=
nikacijo,
dokler ne prejmete kartice ATM visa. (jon768266@gmail.com)

Lep pozdrav
Orlando Moris.
