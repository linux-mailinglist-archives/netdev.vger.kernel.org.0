Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5845BB85E
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 15:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiIQNHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 09:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiIQNHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 09:07:48 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4E92E9CA
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 06:07:45 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id r23so14240893pgr.6
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 06:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=YrZzsr76o+8cdLFX9duugjxnFaPrysczJIfNK8qi1Go=;
        b=UK49+eRigEtVBGRM0Uzz3wkwAiBcj/GKoTRhHwM3S4LAEDaCezMKINsUg4XkLHnMtD
         zhhFBoVfgKQI/+cbbUHmyBLZL3QK0owRqOclgZ6U9GG6//YxfnHfzRQR5+eH074XhC+f
         Pi8IaM3RBtbHmpE70Z992s0Va6j5bBIaYdxHNPuj7aQBol/VkPXr11ducGaHQ0HZ7062
         lRp+GKD2a7cDV/Yk+BQJv+wqYWC82JR93mbTRacV6ryIohxmIyq7r2W5FDOX6uIYhwVu
         iZudT7yNn7tEGiuX3w3oCvn6IF8nC2f7dkfFfrqmjoA5l64JhrO40htuk4B8iBDEQbIf
         eSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=YrZzsr76o+8cdLFX9duugjxnFaPrysczJIfNK8qi1Go=;
        b=wSPb1qWxeXdWjfh+tG6JVNuq2GK3DgZ0RPfuYfaiJHLSCqLLAl/+8rIXhNZs+NXupz
         sWBx1zIhW1lnochevn4UwqrXOsU1uLRXrTaHFcsELSIBV4jJnrin/qPY2dCr96EzwAJX
         UlAzMQ2gPgQ1oiLQ425+tIwFvooLFtQtk2s03nDSkBV6cvfzSy1icb74NnfbGsGfTKLM
         nStnSdvwpSsGQCf6TwW4vQbhXafjFVwnrMfLhCsR5Q3ds8UdDV9WaVvaVNwfUkUWZljz
         cGz40Wc8d4SMj1GZp8bNf2IK8zryTgilW7onmNOejrzcQy3qiUGIFYU/T51re+CLTirH
         Pzzw==
X-Gm-Message-State: ACrzQf3CF6jehw4TtAonYkUkMK7Xd+tG0L/iNrt3ULaCVLfh6DTrjktc
        E6Yy3W+r6hJqYEHB6Gg7OHx38l4UihY6fqCgxoo=
X-Google-Smtp-Source: AMsMyM5+dHjPrkC+hp4TcL69oxNU5dp7li0sCHRr6bKBtIz5f2opdi2adcQzKKvCWyxWYnLcRom/KaMUFieMJ7QSusE=
X-Received: by 2002:a63:590a:0:b0:439:6e0c:6381 with SMTP id
 n10-20020a63590a000000b004396e0c6381mr8592370pgb.141.1663420064920; Sat, 17
 Sep 2022 06:07:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7022:6990:b0:45:69bb:5611 with HTTP; Sat, 17 Sep 2022
 06:07:44 -0700 (PDT)
Reply-To: abraaahammorrison1980@gmail.com
From:   Abraham Morrison <aishaabello111@gmail.com>
Date:   Sat, 17 Sep 2022 06:07:44 -0700
Message-ID: <CACbDUJpvEpG_RCOzBu6BuYvLO5UA-8Akks7d9M0g4NXMHxyyRw@mail.gmail.com>
Subject: Good day!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:532 listed in]
        [list.dnswl.org]
        * -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
        *      [score: 0.0200]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [aishaabello111[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [aishaabello111[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [abraaahammorrison1980[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.5 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Uppm=C3=A4rksamhet sn=C3=A4lla,

Jag =C3=A4r Mr Abraham Morrison, hur m=C3=A5r du, jag hoppas att du m=C3=A5=
r bra och
frisk? Detta f=C3=B6r att informera dig om att jag har slutf=C3=B6rt
transaktionen framg=C3=A5ngsrikt med hj=C3=A4lp av en ny partner fr=C3=A5n =
Indien och
nu har fonden =C3=B6verf=C3=B6rts till Indien till den nya partnerns bankko=
nto.

Samtidigt har jag beslutat att kompensera dig med summan av $500
000.00 (endast femhundratusen amerikanska dollar) p=C3=A5 grund av dina
tidigare anstr=C3=A4ngningar, =C3=A4ven om du gjorde mig besviken. Men jag =
=C3=A4r
=C3=A4nd=C3=A5 v=C3=A4ldigt glad f=C3=B6r att transaktionen avslutades utan=
 problem och
det =C3=A4r anledningen till att jag har beslutat att kompensera dig med
summan av $500 000,00 s=C3=A5 att du kommer att dela gl=C3=A4djen med mig.

Jag r=C3=A5der dig att kontakta min sekreterare f=C3=B6r ett bankomatkort p=
=C3=A5
$500 000,00, som jag beh=C3=B6ll =C3=A5t dig. Kontakta henne nu utan dr=C3=
=B6jsm=C3=A5l.

Namn: Linda Koffi
E-post: koffilinda785@gmail.com


V=C3=A4nligen bekr=C3=A4fta f=C3=B6r henne f=C3=B6ljande information nedan:

Ditt fullst=C3=A4ndiga namn:........
Din adress:..........
Ditt land:..........
Din =C3=A5lder:.........
Ditt yrke:..........
Ditt mobilnummer:...........
Ditt pass eller k=C3=B6rkort:.........

Observera att om du inte har skickat till henne ovanst=C3=A5ende
information helt, kommer hon inte att l=C3=A4mna ut bankomatkortet till dig
eftersom hon m=C3=A5ste vara s=C3=A4ker p=C3=A5 att det =C3=A4r du. Be henn=
e skicka den
totala summan av ($500 000,00) bankomatkort, som jag beh=C3=B6ll =C3=A5t di=
g.

V=C3=A4nliga h=C3=A4lsningar,

Herr Abraham Morrison
