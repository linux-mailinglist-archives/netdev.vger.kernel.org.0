Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A242E56B3D2
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 09:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237238AbiGHHvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 03:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237058AbiGHHu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 03:50:56 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A0C15A12
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 00:50:54 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g1so18275426edb.12
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 00:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=xKIRb2/MTnoEIwFVecOJDKjNJQq2PQ+/gTOtiMzYegs=;
        b=EV1uN8iriWpnuO83qaduJsDDVFvDhvJBNu9fi3gTd9ZCamrlPfBwhOi/fV1xKVWNhI
         p3Lk/X3P/WJbM+TQDXic84V8WqLghbrKUC1Jv6Py/oSUtcTv9Ml5rlk+TL2ISu7GTlTT
         F8w2zZ0Lt55MPE8nsgjPZGOOlp1/RNHjYh1OGSXeYKLQ92hy/DAsMssW2RXRtbX4kP3y
         KU3iaXkWtcPBJMiZsNm/rXoXf0YXtw8SD65mqVVlhx8kBJuT4f7YYj0wgM2gmF6nXAjb
         LtGt+o0yc/ZM+mfMM4H66ZUA5p4ukN7VSfiH1h9NWT5pv5wOWZMlDQx5vLLt7mQ22e34
         ua6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=xKIRb2/MTnoEIwFVecOJDKjNJQq2PQ+/gTOtiMzYegs=;
        b=F+OgyUV7oiwYX6b/E6+W9Si0+aY7e7ciXl6nsnVxaXmvIysw6Lw5nDgSjixPslIxiL
         VhVuK1NhBwBzaIOaWNHpMG5FHCK0EXq7wuP8aOVXUtMROdk73SVEI9I7RoPuOw4Sb3N7
         Vj9jr0sSiXfB/7x+lTlYrmiRiT/V+isnTVPhfQMxbqcYg3nyt17uQ2lCkLrfmWPZnEC0
         6WxePKNt/h7e4wQiNbcywp0ACQwbVv/6IvZB9D7DPyFfji+8H3wqO+SFQXA+oaWSFJK2
         afJaJUSOhQxFZcCo2RgbhByFyjurTKxEvgkepTOXsGSuMS9ssUAyFVxh+XjwjhtNZz0J
         uwFA==
X-Gm-Message-State: AJIora9HahY046kk7SNIBcSv4SHGEK4JIAb6VB128x4iFZPehlNwIduX
        8OYhip03t6EtrOLFz2wWnNLHRpvIuzVTAcnL7lw=
X-Google-Smtp-Source: AGRyM1s0Ygt1X7ZFMJ4LdBRWvf7dcBZm508vgQ6DGxzKtxLLpVuG5+N6qOAB5dj09PngR8OFqOrdLNrPGsU1zE6urEA=
X-Received: by 2002:a05:6402:194d:b0:43a:82da:b0f3 with SMTP id
 f13-20020a056402194d00b0043a82dab0f3mr3045607edz.104.1657266653030; Fri, 08
 Jul 2022 00:50:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:640c:2d03:b0:12e:486:4127 with HTTP; Fri, 8 Jul 2022
 00:50:52 -0700 (PDT)
Reply-To: jon768266@gmail.com
From:   johnson <rahamaaliou74@gmail.com>
Date:   Fri, 8 Jul 2022 07:50:52 +0000
Message-ID: <CAHhQV0ebECQDv66f8jd55YdyPfkaPN85jB4_qzERNxmTOP75Mw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Estic encantat d'informar-vos sobre el meu =C3=A8xit a l'hora de transferir
aquests fons amb la cooperaci=C3=B3 d'un nou soci de l'=C3=8Dndia. Actualme=
nt
estic a l'=C3=8Dndia per a projectes d'inversi=C3=B3 amb la meva pr=C3=B2pi=
a part de
la suma total. Mentrestant, no he oblidat els vostres esfor=C3=A7os passats
i els vostres intents d'ajudar-me a transferir aquests fons, tot i que
d'alguna manera ens van fallar. Ara poseu-vos en contacte amb la meva
secret=C3=A0ria a Lom=C3=A9, Togo amb el seu contacte a continuaci=C3=B3, v=
aig deixar
caure una targeta de visa per caixer autom=C3=A0tic certificada, demaneu-li
que us envi=C3=AF la targeta de visat per caixer autom=C3=A0tic de 250.000,=
00
d=C3=B2lars que vaig deixar amb ell per a la vostra compensaci=C3=B3 per to=
ts
els esfor=C3=A7os i intents passats. per ajudar-me en aquest assumpte. Vaig
apreciar molt els teus esfor=C3=A7os en aquell moment.

Aix=C3=AD que no dubteu a posar-vos en contacte amb la meva secretaria i
indicar-li on us ha d'enviar la targeta Visa ATM que cont=C3=A9 l'import.
Si us plau, aviseu-me immediatament si el rebeu perqu=C3=A8 puguem
compartir junts l'alegria despr=C3=A9s de tots els sofriments d'aquell
moment. De moment, estic molt ocupat aqu=C3=AD pels projectes d'inversi=C3=
=B3
que estem tenint jo i el nou soci, finalment recordeu que havia enviat
instruccions a la meva secret=C3=A0ria en el vostre nom perqu=C3=A8 lliuris=
 la
targeta de visat ATM a tu i a tu sol. , aix=C3=AD que no dubteu a posar-vos
en contacte amb ell i enviar-li la vostra informaci=C3=B3, els vostres noms
complets, adre=C3=A7a i n=C3=BAmero de contacte per facilitar la comunicaci=
=C3=B3
fins que rebeu la targeta de visa de l'ATM.(joh768266@gmail.com)

Salutacions cordials
Orlando Moris.
