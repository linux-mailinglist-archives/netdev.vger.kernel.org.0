Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A5C5904E6
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236167AbiHKQq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239120AbiHKQp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:45:26 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DD0AB437
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 09:17:46 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-32a17d3bba2so55190147b3.9
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 09:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc;
        bh=leab60b7I9UNxhInyXxQiPFRsnns/qgQM+6MF7ATRlo=;
        b=C8xPgfFXl7AxVKKG8gVUwkpls8Y5rcy16GhSuZxlnH9/14BF8U6ElMM6EsRa2r2STY
         Yf3krdQc9506qFxyN0KRi+IF4vjrdIFA9q0kzrYTJbmCJ0psdhtaAZ6CXAX70n0cn2MU
         K+dabbTT2WnblPtD4EiSEIFT2G275RPZ6g9mnSfIduZkk8/hjvGlHfi8QpYhGSXUaQ95
         8GsLC1R8Cs9tbknomnb5WkFZkmo/r/WyJOWyni5ozMGkOhTi1IjJKNbamoYXzONTYGjI
         JaMdb30RlWCh9xSl60iKzA1xjM2Za5HHHqBLdUh0zAPz7Li+SzwStvQFhgbh5GL0CF4B
         9b+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=leab60b7I9UNxhInyXxQiPFRsnns/qgQM+6MF7ATRlo=;
        b=joXMQ34/kdAqnWBkY4nW+pf5NquPaVNvs0OiiK3a5Mni2nFIkmpF2P6G7ss7LSJ8iE
         jyAaBQ8/kTaRSl4MJKlmYNqIxYxaT7GpuuK2TtgpARvdfxpX8PVEOmyoSYZjB12J3A+J
         0t2cWXpNuQXuQTiCo1EiHPWFxAKxVSAdQPeqkbn+13k5cBu+wKL8zmavxKjbDxphyn6+
         2jERaODsFrR0+cbrL+v3oJWu6CvBmtxdRFj1bCpkEcMW5HjYoeCVdeRKmmWTCO4uui2j
         TFdj2wN0jRHs0lTgjurXp05itWwplbS0kmwXa1NS/ECDZV5o4YhmZs4a4YDZn5AJ7WW0
         CjGw==
X-Gm-Message-State: ACgBeo14cbP+1H9kEuNBAnHT4VhwVAvnqGqmbHybkO6ZbzxWnFs8NTFg
        BDNYvA0ei7ndslt8qwQySi1PICEpJU/xVg7dwOs=
X-Google-Smtp-Source: AA6agR4BDD6TZ7xb4KCtAI1twT7dkkIQ76HJz1356YG0x9IU5qC5q3t/RDmrJQm97jE0eGZrO9A8rCEiJePd94Qdcic=
X-Received: by 2002:a81:13c4:0:b0:321:1c6c:8f2 with SMTP id
 187-20020a8113c4000000b003211c6c08f2mr32613524ywt.323.1660234666111; Thu, 11
 Aug 2022 09:17:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5b:c51:0:0:0:0:0 with HTTP; Thu, 11 Aug 2022 09:17:45 -0700 (PDT)
Reply-To: jon768266@gmail.com
From:   johnson <oliajeremy@gmail.com>
Date:   Thu, 11 Aug 2022 16:17:45 +0000
Message-ID: <CABz_VOAXyjVObSfYLtEg4X++Fi+H3YyABL0kJ+3yPARTXz_BDA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

L=C3=BCtfen dikkat,

 Bay orlando Morris, Nas=C4=B1ls=C4=B1n, umar=C4=B1m iyi ve sa=C4=9Fl=C4=B1=
kl=C4=B1s=C4=B1nd=C4=B1r? Bu
ile i=C5=9Flemi ba=C5=9Far=C4=B1yla tamamlad=C4=B1=C4=9F=C4=B1m=C4=B1 size =
bildirmek i=C3=A7in
Hindistan'dan yeni bir orta=C4=9F=C4=B1n yard=C4=B1m=C4=B1yla ve =C5=9Fimdi=
 fon banka hesab=C4=B1na aktar=C4=B1ld=C4=B1,


Bu arada, size toplam 2,50,000,00 ABD dolar=C4=B1 tutar=C4=B1nda tazminat
=C3=B6demeye karar verdim.
(Yaln=C4=B1zca iki y=C3=BCz elli Bin ABD Dolar=C4=B1) ge=C3=A7mi=C5=9F =C3=
=A7abalar=C4=B1n=C4=B1z nedeniyle,
ger=C3=A7i beni hayal k=C4=B1r=C4=B1kl=C4=B1=C4=9F=C4=B1na u=C4=9Fratt=C4=
=B1n. Ama yine de =C3=A7ok mutluyum
i=C5=9Flemin sorunsuz bir =C5=9Fekilde sona ermesi i=C3=A7in ve bu
sana toplam=C4=B1n=C4=B1 tazmin etmeye karar vermemin nedeni bu.
Benimle sevincini payla=C5=9Fman i=C3=A7in 2.50.000,00$.

250.000,00 Dolarl=C4=B1k bir ATM kart=C4=B1 i=C3=A7in sekreterimle g=C3=B6r=
=C3=BC=C5=9Fmenizi tavsiye ederim.
senin i=C3=A7in saklad=C4=B1m. Herhangi bir gecikme olmadan =C5=9Fimdi onun=
la ileti=C5=9Fime ge=C3=A7in.

Ad=C4=B1 Bay Mike johnson
E-posta: (jon768266@gmail.com)


L=C3=BCtfen a=C5=9Fa=C4=9F=C4=B1daki bilgileri kendisine tekrar teyit edin:

Tam ad=C4=B1n=C4=B1z:........
Senin adresin:..........
Senin =C3=BClken:..........
Ya=C5=9F=C4=B1n=C4=B1z:.........
Mesle=C4=9Fin:..........
Cep Telefonu Numaran=C4=B1z: ..........
Pasaportunuz veya S=C3=BCr=C3=BCc=C3=BC Belgeniz: .........

Ona yukar=C4=B1daki bilgileri tam olarak g=C3=B6ndermediyseniz,
oldu=C4=9Fundan emin olmas=C4=B1 gerekti=C4=9Fi i=C3=A7in ATM kart=C4=B1n=
=C4=B1 size vermeyecektir.
sen. Size toplam (2.50.000.00$) ATM kart=C4=B1n=C4=B1 g=C3=B6ndermesini ist=
eyin.
senin i=C3=A7in sakland=C4=B1.

Sayg=C4=B1lar=C4=B1mla,

Bay orlando morris
