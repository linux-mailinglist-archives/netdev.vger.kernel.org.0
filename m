Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577EE4B489C
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 10:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243272AbiBNJ5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 04:57:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344961AbiBNJ4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 04:56:31 -0500
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DDE8092D
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 01:45:01 -0800 (PST)
Received: by mail-vk1-xa2a.google.com with SMTP id j201so1394931vke.11
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 01:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=KPrE96Y6H/rAOZwse4kRwXZYhqrqMrcdRmQmWPkHrvw=;
        b=Z5WvS7tiwrX2oYsgXV++NB89dWgOcQOGzi6dvTRiiBfUmHMBzffaXUqmJqPeiTbt4D
         cxU4xaktgc3eOR9VyCh0J52D6y2sJ55omTKQP+ubdLtpbJN2URpc1dLv7pg4kjDmqPuE
         FAPj9qR/zYhAY8xH2w38Re2+ncW7Pt+UokFuaQAuTx+yE1MsWUCq3dQws76evvQMp0+p
         HwI0yoeTsFCDr6Bxr0c3KhyCGlODFvwRB7PamIR5EQGFPwOfpKN1jFV2QAyXYtzdkXrL
         ojDXAlVPNE3zNXjO540Hhd/Oi0on+stNnaAe80A19408UFKVsmuv61oDu0USSjfjeuIy
         aUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=KPrE96Y6H/rAOZwse4kRwXZYhqrqMrcdRmQmWPkHrvw=;
        b=lrUZ7tVCpiMBaNxH9ut76IFyS1Z/lCMbKXDgcy4aIS42xftkz8NGlpMt4LBtpiM1da
         gZdzJTlMDjaX+q9E06mlSS6JGY0MRcew9c03cJVqYUqB8mC8Dg3vNtoDblN2vtUm32ky
         +P5H/KoBLfXhh9joxq9YAESPjCm11xQFdVBFxn+YSBXfdhRWrZo+HcgP5TVpQVqLD+eP
         uy9mJtHdI0Hv8/jHYQi06fyBffSTiEu+GXM/cZ+RSrEFM6QHLB+8YqRkKBUHOI+4yrjn
         slKU17kx+TK6mR2nyISvF/gihkcCr9S36fIH60+Do8zat4ItscAPsWuzYz2L41nsbK5V
         GIeg==
X-Gm-Message-State: AOAM532eZjMkZjwkbwYnjuxdTGfW4fArRF6FTQ3Kc19FZ90K+6sG1BOL
        FZ2bYBRouKwhM7yZ4bbU44lUZRSz4zu+LqwwPGs=
X-Google-Smtp-Source: ABdhPJwFT/ZvDBKQz9gxJLH78wEOEJeTGp+6il1iyVqc4lGTeGXVmKxLFN3wiHXA1gg2FxQgKjDB6YpbaprtRJofHus=
X-Received: by 2002:a05:6122:7ca:: with SMTP id l10mr649290vkr.9.1644831900436;
 Mon, 14 Feb 2022 01:45:00 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab0:2c19:0:0:0:0:0 with HTTP; Mon, 14 Feb 2022 01:45:00
 -0800 (PST)
Reply-To: tonyelumelu5501@gmail.com
From:   POST OFFICE <mrmajidaahmedmuhammed@gmail.com>
Date:   Mon, 14 Feb 2022 09:45:00 +0000
Message-ID: <CAD-=s3Ux_arrmi5n-TrRUNw2D_wSNktvVZQW+AuQdt=F9--cyg@mail.gmail.com>
Subject: =?UTF-8?Q?Lep_pozdrav_dragi_lastnik_elektronske_po=C5=A1te?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a2a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [tonyelumelu5501[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrmajidaahmedmuhammed[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dobrodo=C5=A1li na uradni e-po=C5=A1ti I.M.F. GOSPA DIREKTOR. KRISTALINA
GEORGIEVA. NA=C5=A0E PORO=C4=8CILO: UBT (UNION BANK OF TOGOLESE)

Dober dan: Spo=C5=A1tovani lastnik e-po=C5=A1te!

To pismo sem vam poslal pred enim mesecem, vendar se nisem oglasil,
nisem prepri=C4=8Dan, ali ste ga prejeli. In zato =C5=A1e enkrat povem: Prv=
i=C4=8D,
jaz sem gospa Kristalina Georgieva, generalna direktorica in
predsednica Mednarodnega denarnega sklada.

Pravzaprav smo pregledali vse ovire in te=C5=BEave v zvezi z va=C5=A1o nepo=
polno
transakcijo in va=C5=A1o nezmo=C5=BEnostjo izpolnjevanja stro=C5=A1kov pren=
osa, ki so
vam jih zara=C4=8Dunavale prej=C5=A1nje mo=C5=BEnosti prenosa. Za potrditev=
 si
oglejte na=C5=A1o spletno stran 38 =C2=B0 53=E2=80=B256 =E2=80=B3 N 77 =C2=
=B0 2 =E2=80=B2 39 =E2=80=B3 W

Mi, upravni odbor, Svetovna banka in Mednarodni denarni sklad (IMF)
Washington, D.C., skupaj z Ministrstvom za finance ZDA in nekaterimi
drugimi ustreznimi raziskovalnimi agencijami tukaj v Zdru=C5=BEenih
dr=C5=BEavah. je naro=C4=8Dil na=C5=A1i enoti za nakazila tujih pla=C4=8Dil=
, United Bank
of Africa Lome Togo, da vam izda kartico VISA, na katero bo va=C5=A1 sklad
poslan (1,2 milijona USD) USD za kasnej=C5=A1i dvig iz va=C5=A1ega sklada.

Med na=C5=A1o preiskavo smo na na=C5=A1o zaskrbljenost ugotovili, da so na=
=C5=A1e
pla=C4=8Dilo po nepotrebnem zamujali zaradi korumpiranih uradnikov banke,
ki so posku=C5=A1ali svoja sredstva preusmeriti na svoje zasebne ra=C4=8Dun=
e.

In danes vas obve=C5=A1=C4=8Damo, da je UBA Bank va=C5=A1 denar nakazal na =
kartico
VISA in je tudi pripravljen za dostavo. Zdaj se obrnite na generalnega
direktorja in direktorja UBA Bank. Ime mu je g. Tony Elumelu,

Takoj stopite v stik z g. Tonyjem Elumelujem, DIREKTORJEM ZDRU=C5=BDENE
BANKE ZA AFRIKO, ker je va=C5=A1a ATM VISA CARD zdaj odobrena za dostavo.

Elektronski naslov: (tonyelumelu5501@gmail.com)
WhatsApp Tel: +228 91889773

Po=C5=A1ljite mu naslednje podatke za dostavo va=C5=A1e akreditirane kartic=
e Atm
Visa na va=C5=A1 naslov.

1. Polno ime:

2. Priimek:

3. Dr=C5=BEavljanstvo:

4. Va=C5=A1 doma=C4=8Di naslov:

5. Telefonska =C5=A1tevilka:

6. Va=C5=A1a osebna izkaznica ali potni list =C5=A1t.

=C4=8Cakam na potrditev va=C5=A1ih osebnih podatkov, zato bomo nadaljevali =
z
dostavo kurirske slu=C5=BEbe za po=C5=A1iljanje va=C5=A1e ATM kartice na va=
=C5=A1 doma=C4=8Di
naslov v va=C5=A1i dr=C5=BEavi.

Z lepimi pozdravi

GOSPA KRISTALINA GEORGIEVA
(IMF) Predsednik.
