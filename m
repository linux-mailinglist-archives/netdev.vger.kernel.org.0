Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3367A549C63
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 20:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243586AbiFMS5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 14:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344610AbiFMS52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 14:57:28 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7561040A08
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 09:04:47 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x17so7729960wrg.6
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 09:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=AXautoqWPbDGQ8jIW32Yr94ZX6pp2sRp2xY2VCYt9IQ=;
        b=Y3Zaso87YlfTlu4ajq7LPn7acVP6OEqktDetC90IXLCFuqbxDLk/ScLjQ06HUaagv5
         54S3UZWC99l+Oove5asnkJ0zAiiVjL/71E2YiANfvFRdMsbEPRHEahP0ZrKsuS5tui2o
         hSYFIcmjJ6p6S+vTMGHMFi2ftGzpsmVFs70EA6Ay0LaLqWnBI330dyxWgV7GViTyDae6
         8qD9ZQMMh4yjquXLbWCzhWjK0ZPtRHQDcvpco8v4JAmSNwTS23MPV4wi6gKF4pw3mGZV
         zeltwKrUGX9pGV5cACkHc96u/m7hVCml7LrbbfNnrmQKW/r5mms1S4N/nBGDKFXMczFM
         1ypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=AXautoqWPbDGQ8jIW32Yr94ZX6pp2sRp2xY2VCYt9IQ=;
        b=z79okhj05gID17uVxKAWaLt0ZC5ljHaHzW8j5yK6vIn+2l1/ihakB0j/hjPWCSEWh0
         XG49z8XEvNd+JlZmBHoaLJYtxIWiMGbyawsZvoUOgjMSpL0I9b37x4StgqLuvPBwkX2D
         6KnvzU/EZuHE7qNAlIpHl9WCWHPCFuRwH6L724vPPVHshhJ+A0AjSB3DY7v7x23MxoF0
         m9jnyfFtT6taSUNIObguqFh6DxoGaKsk2e4r1A8cRJ4kXFmt4nZnJ0qMdBr2Mx66Ngjk
         TJdZb2jCzWrJl/ZqMcDLj+P86mQ2LofYfa/dJRaGw+hh4b2Va1yR7MLnjq1wO2ryWWDX
         MuLg==
X-Gm-Message-State: AJIora/1nOy5soI3nqrfo8ocqpqsn7HRZ3iyAmyfvG9AXEm0uuoomQcR
        0/oxVwfYQXETgHoeVtb/aGZwdAm81lcJmRTlHJI=
X-Google-Smtp-Source: AGRyM1ulfKHQ+oVC9xkJkpKGWNyo4mLoeS6sR4zeHou9luaombOz1cu7xil1EWh1T/1ovPEz8A8ywdSGjBZhhcbAByw=
X-Received: by 2002:a5d:5142:0:b0:212:af29:530 with SMTP id
 u2-20020a5d5142000000b00212af290530mr550700wrt.444.1655136285655; Mon, 13 Jun
 2022 09:04:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:5942:0:0:0:0:0 with HTTP; Mon, 13 Jun 2022 09:04:43
 -0700 (PDT)
From:   nnani nawafo <nnadinawafo11@gmail.com>
Date:   Mon, 13 Jun 2022 16:04:43 +0000
Message-ID: <CAPhDfr06DxSLgxXXHS5_LbtZcjPKPRWbb-zuMQSD+7AaRMBW+g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gratulujem!

Organiz=C3=A1cia Spojen=C3=BDch n=C3=A1rodov dospela k z=C3=A1veru, =C5=BEe=
 schv=C3=A1li vyplatenie
kompenza=C4=8Dn=C3=A9ho fondu vo v=C3=BD=C5=A1ke =C5=A1iestich mili=C3=B3no=
v americk=C3=BDch dol=C3=A1rov (6
000 000,00 USD) =C5=A1=C5=A5astn=C3=BDm pr=C3=ADjemcom na celom svete prost=
redn=C3=ADctvom
pomoci novozvolen=C3=A9ho prezidenta v d=C3=B4sledku ochorenia COVID-19
(koronav=C3=ADrus), ktor=C3=BD sp=C3=B4sobil ekonomick=C3=BD kolaps v roku =
r=C3=B4znych
krajin=C3=A1ch a glob=C3=A1lne ohrozenie to=C4=BEk=C3=BDch =C5=BEivotov.

 Organiz=C3=A1cia Spojen=C3=BDch n=C3=A1rodov poverila =C5=A1vaj=C4=8Diarsk=
u svetov=C3=BA banku, aby
v spolupr=C3=A1ci s bankou IBE v Spojenom kr=C3=A1=C4=BEovstve uvo=C4=BEnil=
a platby z
kompenza=C4=8Dn=C3=A9ho fondu.

Platba bude vystaven=C3=A1 na bankomatov=C3=BA v=C3=ADzov=C3=BA kartu a odo=
slan=C3=A1 =C5=A1=C5=A5astn=C3=A9mu
pr=C3=ADjemcovi, ktor=C3=BD o =C5=88u po=C5=BEiada prostredn=C3=ADctvom ban=
ky IBE v Spojenom
kr=C3=A1=C4=BEovstve prostredn=C3=ADctvom diplomatickej kuri=C3=A9rskej spo=
lo=C4=8Dnosti v
bl=C3=ADzkosti prij=C3=ADmaj=C3=BAcej krajiny.

Toto s=C3=BA inform=C3=A1cie, ktor=C3=A9 vedenie Spojen=C3=A9ho kr=C3=A1=C4=
=BEovstva vy=C5=BEaduje na
doru=C4=8Denie platby z kompenza=C4=8Dn=C3=A9ho fondu do prij=C3=ADmacej kr=
ajiny.

1. Va=C5=A1e meno:
2. Adresa bydliska:
3. Mesto:
4. Krajina:
5. Povolanie:
6. Sex:
7. Rodinn=C3=BD stav:
8. Vek:
9. Pas / ob=C4=8Diansky preukaz / vodi=C4=8Dsk=C3=BD preukaz
10. Telef=C3=B3nne =C4=8D=C3=ADslo:
Kontaktujte n=C3=A1=C5=A1ho e-mailov=C3=A9ho z=C3=A1stupcu:
n=C3=A1zov solomo brandy

EMIL ADDRESS (solomonbrandyfiveone@gmail.com) pre va=C5=A1u platbu bez ome=
=C5=A1kania,

S pozdravom
Pani Mary J Robertsonov=C3=A1.
