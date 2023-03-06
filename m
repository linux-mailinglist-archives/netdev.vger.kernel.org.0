Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A38B6AC7F6
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjCFQan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjCFQak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:30:40 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564008681
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 08:30:13 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id ec29so10219103edb.6
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 08:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678120138;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TZ33nvxDIoKP0NoXJTFfgk6u5oxfDARQnBSmQB7yDdw=;
        b=mtH66TQta9Bzs4liR00krRHX3fdgFBRgtRqFehzk8UYnYJtEfJB673A1fcjeYo8UAs
         +yWvjErBparo+qfjJnXswZ07YX+TOODpdXEkArHD8MR+TnUijxslDeWeWdNlkXyAV5PJ
         xtVfPIwgDQ6rSHBPY1PaVU4CkPQquD3ZwyIAf2brG8GYma8rt7IfpA1ap5FkgBtELoEF
         c2EAEbB/bWluI3z//RbJxkkVUTOLMAzq8/iUXU8upZ2PX5TPk3fsPedj8b+3mygR5Rqr
         OxKYvMrh0RlUWZtrC6c1GF2fie9QEzRAeDUMmqxucpwa4jRcn0dD9Y9gyylO5riQL/ad
         NVag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678120138;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TZ33nvxDIoKP0NoXJTFfgk6u5oxfDARQnBSmQB7yDdw=;
        b=EnCFvoA0wRkqLbRSzzpkj4t60RhfmJROCrqs+JB3Rp89onpJBuJPg+Em5CzC+qPzAn
         aTX+MZTbvHja8WTXOvcEq7KQ5efZuGr/ZHzwYWAdG+5WX6UqUZ+PoR4Yn/MLcKs/t+Cc
         K8JuHFFkkYo2GeqwXN9hcnUWjG4wuEkj02fs2vQvV8bSmHYT5+e4PPk+2JREcB3/hNkH
         UfsYlGr7SFfDRdo0g3j8yMt/PkA3KqetD2vINqM011fNNrJmK2wlM1mW/P+gMVHoY49e
         tuMizimUB5zpETJPE0Nv11TCLlYgiDQHRIkVYDx35Kvs0QlX5VNnPmyGzYHd1+9sz+SB
         +gIA==
X-Gm-Message-State: AO0yUKWR4BXuLJH0PnjbuOvVWFf1q9tXwfE7KMn8E0Uh+Mp8M1l71+Vl
        N1GUcCE6FNQy19NOxW1nKP3W3fNvEZtYzejWgXwsRFkyqc/zFQ==
X-Google-Smtp-Source: AK7set+Ci649UgjASEMMZl/CD2+czHowvLO01DFfPG8O0O4pskUl+KO9EJRbEY6qipEtBZqTaB7jBpFyB5T14NnSdbs=
X-Received: by 2002:a05:6402:12c7:b0:4af:6e95:85e9 with SMTP id
 k7-20020a05640212c700b004af6e9585e9mr7965294edx.4.1678119172351; Mon, 06 Mar
 2023 08:12:52 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:640c:2907:b0:1a8:2a2c:1e99 with HTTP; Mon, 6 Mar 2023
 08:12:51 -0800 (PST)
Reply-To: jeankoffi4243@gmail.com
From:   jean koffi <koj146374@gmail.com>
Date:   Mon, 6 Mar 2023 16:12:51 +0000
Message-ID: <CAEb-5BRABO9VfSxqwZnaPiNy5b8iCzOj7NnWi3bePv2tQNaVDg@mail.gmail.com>
Subject: =?UTF-8?B?Q3plxZvEhw==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:543 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [koj146374[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [koj146374[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jeankoffi4243[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mi=C5=82o mi poinformowa=C4=87 o moim sukcesie w przekazywaniu tych =C5=9Br=
odk=C3=B3w
we wsp=C3=B3=C5=82pracy z nowym partnerem z Indii. Jestem obecnie w Indiach
dzi=C4=99ki projektom inwestycyjnym z udzia=C5=82em w=C5=82asnym. w
tymczasem nie zapomnia=C5=82em o waszych dotychczasowych wysi=C5=82kach i p=
r=C3=B3bach pomocy
przela=C4=87 te =C5=9Brodki, mimo =C5=BCe jako=C5=9B nam si=C4=99 nie uda=
=C5=82o. Teraz
skontaktuj si=C4=99 z moim sekretarzem w Lome, Togo z jego kontaktem
poni=C5=BCej, rzuci=C5=82em
certyfikowan=C4=85 kart=C4=99 wizow=C4=85 do bankomatu, popro=C5=9B go o pr=
zes=C5=82anie karty
wizowej do bankomatu
z bankomatu na kwot=C4=99 250 000,00 dolar=C3=B3w, kt=C3=B3re zostawi=C5=82=
em u niego jako
zado=C5=9B=C4=87uczynienie za wszystkie dotychczasowe starania i pr=C3=B3by=
 pomocy mi w tym
materia=C5=82. Naprawd=C4=99 docenia=C5=82em wtedy twoje wysi=C5=82ki.

Wi=C4=99c nie wahaj si=C4=99 skontaktowa=C4=87 z moim sekretarzem i poinstr=
uuj go,
dok=C4=85d ma si=C4=99 uda=C4=87
wy=C5=9Blij kart=C4=99 wizow=C4=85 do bankomatu z odpowiedni=C4=85 kwot=C4=
=85. Prosz=C4=99 daj mi zna=C4=87
natychmiast, je=C5=9Bli go zdob=C4=99dziesz, aby=C5=9Bmy mogli dzieli=C4=87=
 si=C4=99 rado=C5=9Bci=C4=85
po wszystkim
trudy tamtego czasu. Jestem tu teraz bardzo zaj=C4=99ty z powodu
projekty inwestycyjne, kt=C3=B3re wraz z moim nowym partnerem mamy pod r=C4=
=99k=C4=85. I
przekaza=C4=87 swoje dane, pe=C5=82ne imi=C4=99 i nazwisko, adres i numer k=
ontaktowy do
=C5=82atwa komunikacja do momentu otrzymania karty Visa w bankomacie.
(jeankoffi4243@gmail.com)

Pozdrowienia
Dawid Bojan.
