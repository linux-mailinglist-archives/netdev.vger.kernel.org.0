Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A516E4BD1BB
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 21:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240997AbiBTU71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 15:59:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbiBTU7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 15:59:25 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4172FFE7
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 12:59:03 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id a23so28005511eju.3
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 12:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=zTCY5mF3R2lLVganCITyt3z5qqyOgdnuYbYNuvO9quU=;
        b=L7oc+GiLX3I55MAtg3eTm7R6pmKEDtE+J4w1ES+hJVLBu7wG3RshfhzMLbs5JrYR+O
         dn4cryWCwOTKzuMwyLM815FcMjz5wJSCdkr1zc5/RlIEr7HfYKqovRwS/dBvBv64JxxJ
         6ps47jiFOgd3Xu2WhrrqzHtdeZ2UTdj3tFUg0SBg/GtvUPymDnwuaSpBACNi90r5pYOO
         U2sUCbBQ6Mjxn15WeVCvHZ7YgxKleLkTnEKNKMai9Gcfw74fUC9FyCxwloiH7rOYtRGq
         rBDy9uilFJkHr5E6wWlokhpDAKmU71pZ/rOUiBxgjQVA+I3nH3kFd46PoSGtOAhntLnL
         sqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=zTCY5mF3R2lLVganCITyt3z5qqyOgdnuYbYNuvO9quU=;
        b=39GbC1w4sZnzy9MmjAjBXnYItDbUzKqJK8wL+ZT48tB99AiOAY6634zr8ufG4iFB3i
         4mdQbbRrgG+RTsv77d58Gc+J+5qWXqfHVfFRJMrkt8ZRIHCo26XZeFQUi2OlPnIa4DQR
         h5hJ/JVoqE2rC5f7jF2QyxX35wIZe1baGkCHdwYFIXE0HBk6byjwPRJoxhyWVs3kutZT
         Djqf1G2UjF2Uzt+CB8gnoFFCAtVJWZq0LUivfsDWl+ewqjCgGYr/AL8WiXMmJkkxwXja
         w0RqfT5M1AlfKG++f2s2LWiD/RXZ93VBidE9mwJHlH03Hk902jUdivxHJsd68necfBVp
         7mag==
X-Gm-Message-State: AOAM532p7aMhmCxLJy/vyjF6Vdy9eT9X7J26jgcQ84rAXupFLwicIEaB
        FOsN9ExJ964fnW/Qd7QHxJMrNIBn9/I/i27GVr8=
X-Google-Smtp-Source: ABdhPJxq/9ALPm/gAleZON4uRF/kjfM9pGNbyu4Fnc3S7pc4CTAGpsDNrOKyqQkpgv0S+Wcw/3x6eT5dYrFUoVEMeo4=
X-Received: by 2002:a17:906:6b8e:b0:6cf:8e6e:609a with SMTP id
 l14-20020a1709066b8e00b006cf8e6e609amr13692307ejr.243.1645390741892; Sun, 20
 Feb 2022 12:59:01 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab4:a22f:0:0:0:0:0 with HTTP; Sun, 20 Feb 2022 12:59:01
 -0800 (PST)
From:   hamid abbas <hamidabbas853@gmail.com>
Date:   Sun, 20 Feb 2022 23:59:01 +0300
Message-ID: <CA+qX7mO4pE3Us7JbtA+Abpjg6LQwGDbuAyCKq5iDB4PHxPvJZw@mail.gmail.com>
Subject: Hallo ontvanger
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:632 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [hamidabbas853[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [hamidabbas853[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  3.5 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hallo vriend,
    Hoe is het vandaag met je? Ik ben Giovanni Lanzo, een medewerker
van UBI Banca, Itali=C3=AB. Ik neem contact met u op met betrekking tot een
overleden cli=C3=ABnt die omkwam bij een auto-ongeluk terwijl hij op weg
was naar Milaan, Itali=C3=AB in 2004, hij was een prominente cli=C3=ABnt va=
n
mij. Voor zijn dood heeft mijn cli=C3=ABnt (420.346,00 euro) gestort in de
kluis van mijn financi=C3=ABle instelling hier in Rome, Itali=C3=AB,
documentatie met betrekking tot deze transacties geeft aan dat claims
alleen kunnen worden ingediend door zijn naaste verwanten. Helaas had
hij geen testament op het moment van zijn overlijden.
     Alle geleverde inspanningen onthulden geen link met een van zijn
familieleden. Het nieuwe Italiaanse erfrecht/vorderingen/fonds geeft
echter een duur aan waarin dergelijke vorderingen kunnen worden
getolereerd. De financi=C3=ABle instelling heeft mij opgedragen om de
nabestaanden te presenteren die de gelden zullen opeisen. Als u niet
op dit ultimatum reageert, zou de financi=C3=ABle instelling wettelijk
toestaan =E2=80=8B=E2=80=8Bdeze gelden aan de Banca d'Italia (Centrale Bank=
 van
Itali=C3=AB) te rapporteren als niet-opge=C3=ABiste gelden.
   Mijn collega en ik hebben alle noodzakelijke vereisten opgesteld
met betrekking tot de vrijgave van deze fondsen en het is mijn
bedoeling om u als begunstigde deze mogelijkheid te bieden. Houd er
rekening mee dat ik wettelijk ben uitgerust met alle benodigde
informatie/documentatie met betrekking tot dit fonds. Neem alstublieft
contact met mij op met uw mening door uw antwoord naar mijn
persoonlijke e-mailadres te sturen:
giovannilanzo07@gmail.com


VRIENDELIJKE GROETEN
Giovanni Lanzo
BANKREKENING OFFICIER
