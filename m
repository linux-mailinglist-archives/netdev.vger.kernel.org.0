Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA73570606
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 16:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiGKOnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 10:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbiGKOnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 10:43:49 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB53822533
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 07:43:48 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id i7-20020a4aa6c7000000b004325d18bac9so1002877oom.7
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 07:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=vZE+qmfAgv5Q4Ok+kbuXIowyw8njtCi5ttVKDOeueCk=;
        b=c7jNZdnaj22NSPk8CBeLnYRVsYH6nZ0j4IXNSpskE72kMyveTyE4j29ITTsMt5y41x
         lYjSkZTZA9Lk/wSlB925N6ADt0V7SSsEoclGDdYduxdpEWkedKnxAwjXGjM2Ew1tMURf
         JceWsMobTOOZEPGM4rzyl0ZK1vTTMkt8w87PG554LeJbdLTGNvBfV5D4fzBtDGOIf/+d
         8zqXGidUAHxHenWP+D4lwPEbOZ4Q/kl1M1muPUE1hkBO1TfjzEQGnr3WG0AeUp2bs+vQ
         pKvLrzyVD4Edy5wgX/nWs9jYrrjPiQkNmtjeXN3iBJVwTwmqezt/utE8H3dlBPEV0CAb
         P12g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=vZE+qmfAgv5Q4Ok+kbuXIowyw8njtCi5ttVKDOeueCk=;
        b=57ZZje/Ccw9rBFgfjYhsMV+jLMTFRt//2tBMR+wflE9z3xWhgAURBPQ7iS90mkjYHE
         emUwNdf1qrS+8HQskYQFwSODj9LmwR6s71q+aN2tpKDq3JdE2dVCXwWruR/LbqlXLpoL
         yUSA1qAp5dlR676U0XaBBDR+LDA92NWQiXESULfz8zVQK6k1UmewF2ARdDxf8iZj1s3R
         7NvZAlpr+1RyB3zX5+kkztwgiyUQSOLyZtrTgm739vQtv1p4eNFb4RbuXO/R2/wHG8gN
         gGKSgjS20EHzqOkt0egybaF77WBgUPDWpca6DbnELDSafgiIV7KFZzcVfMNhWe9zuDMT
         vmdg==
X-Gm-Message-State: AJIora9PzzimnbSI07yeDshq0QwJZPvB81eL6kcy9oNir08u+Dn5FCE+
        sSPTqhuOOSMlYMfibOViFcaxcNN3kd8oWZzVT80=
X-Google-Smtp-Source: AGRyM1u07yEiUQq3OjAv5gquTK1WH8ltqq77xl/YZ/CpZHemwSvwGkFPlBw1ufAs+luEAP+xp3NoofLz06WAv+XntqA=
X-Received: by 2002:a4a:cf0e:0:b0:433:a4f4:5fcf with SMTP id
 l14-20020a4acf0e000000b00433a4f45fcfmr4228299oos.63.1657550628236; Mon, 11
 Jul 2022 07:43:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:5ed2:0:0:0:0:0 with HTTP; Mon, 11 Jul 2022 07:43:47
 -0700 (PDT)
Reply-To: abrahammorrison443@gmail.com
From:   Abraham Morrison <ikengachambers001@gmail.com>
Date:   Mon, 11 Jul 2022 07:43:47 -0700
Message-ID: <CAOYSfbd3TaVPOR=6A6Hbfe2RZvTyjOnPtW4v766Pa1ANzntKpw@mail.gmail.com>
Subject: Good day!
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
        *      [2607:f8b0:4864:20:0:0:0:c32 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4107]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ikengachambers001[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ikengachambers001[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [abrahammorrison443[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
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

Oppmerksomhet takk,

Jeg er Mr. Abraham Morrison, hvordan har du det, jeg h=C3=A5per du er frisk
og frisk? Dette er for =C3=A5 informere deg om at jeg har fullf=C3=B8rt
transaksjonen vellykket ved hjelp av en ny partner fra India, og at
fondet n=C3=A5 er overf=C3=B8rt til India til bankkontoen til den nye partn=
eren.

I mellomtiden har jeg bestemt meg for =C3=A5 kompensere deg med summen av
=E2=82=AC500 000,00 (kun fem hundre tusen euro) p=C3=A5 grunn av din tidlig=
ere
innsats, selv om du skuffet meg langs linjen. Men likevel er jeg
veldig glad for den vellykkede avslutningen av transaksjonen uten
problemer, og det er grunnen til at jeg har bestemt meg for =C3=A5
kompensere deg med summen av =E2=82=AC500 000,00 slik at du vil dele gleden
med meg.

Jeg anbefaler deg =C3=A5 kontakte sekret=C3=A6ren min for et minibankkort p=
=C3=A5
=E2=82=AC500 000,00, som jeg beholdt for deg. Kontakt henne n=C3=A5 uten
forsinkelser.

Navn: Linda Koffi
E-post: koffilinda785@gmail.com

Vennligst bekreft til henne f=C3=B8lgende informasjon nedenfor:

Ditt fulle navn:........
Adressen din:..........
Ditt land:..........
Din alder:.........
Ditt yrke:..........
Ditt mobiltelefonnummer: ..........
Ditt pass eller f=C3=B8rerkort:.........

Merk at hvis du ikke har sendt henne informasjonen ovenfor
fullstendig, vil hun ikke gi ut minibankkortet til deg fordi hun m=C3=A5
v=C3=A6re sikker p=C3=A5 at det er deg. Be henne sende deg den totale summe=
n av
(=E2=82=AC500 000,00) minibankkort, som jeg beholdt for deg.

Med vennlig hilsen,

Mr. Abraham Morrison
