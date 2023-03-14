Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEBB66B920C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjCNLtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjCNLtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:49:49 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251E264A9E
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:49:48 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id z11so9528849pfh.4
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678794587;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q2EEneZC0un7s/NClNGezs4nrhx2sRUJrSNVdOLyXAg=;
        b=qBKM5Zzmx6OLIHS1zOpFl8RugmqWeIH5TtUWTPiA4Pw9ykRtoNeqeoVLVEl4HF2Izg
         UdFnOkH7sAd1qyU3okwTCViEAMdyaAEH/aFmb52Plz6L7FrPmhjAwaInt/pxuDueXbNR
         KdGsLOjGcJDbRfvHlrlh1r7DFZOgSe9dhI7OdV+quRoiDZg6HN7MyTbfwnciBINEDjwY
         6lYZoHhs5rB9BK3cVjZW8XwTeE2Ciy7YBreHFs4dAoEYs5QjXnMKYa+AP37akB8bMBOz
         Bvhh/Y+NUuloAOqvlsZ5nA5NuOFR7A2YPR1wyORhSEv4YsNH8OcHbdYbtrO+z+2X1A+5
         Xvvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678794587;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q2EEneZC0un7s/NClNGezs4nrhx2sRUJrSNVdOLyXAg=;
        b=2teetNtO6azvPI7iEzLQwhKmwj7onUi3M2mvCw2savibaaIyXCkzrThRni3VIn4dTJ
         7gAZXx1enruCmm5H4p753iwKyJog6uaC6XtB/zIYSJJpypIbI/4pK/EISP/OsRzMQbU2
         /wsOK8GttIPYeqqPmh5Ig23TSyBKtmz8C0Y4PTof8Rij49UeKSNvJKAUoyuUTf6fFW6d
         UeNoWbwiHKQzGsYtmWh7FtO5RdVdtK+yZLSQRqZwhU5LB/8d81LrlTNyW85qd2F/rQFv
         CVByf+mv1sT987ZmjDejJJ2tTwj6PfaBo1xHqHVS/gNF4PbaDPb3JM4hARZdGHGJ0WDs
         4ekg==
X-Gm-Message-State: AO0yUKXLIt7xWyijH/nwoA34nMDEowRsms+LiMl1Ly2gVsGHAPV5YAnp
        ameA5jdjgy4glKbGQSMergfRBS0UaDW/ovLAquM=
X-Google-Smtp-Source: AK7set955tHyhdeVyfS6Jmp1hGxrcOg31yHUae2JyFOu0EPuJR4JvKKqPtkKdvDNM1kOoPCqLPRGYie7Jf+yYOdLNdw=
X-Received: by 2002:a62:1881:0:b0:624:899c:ea00 with SMTP id
 123-20020a621881000000b00624899cea00mr2069598pfy.1.1678794587538; Tue, 14 Mar
 2023 04:49:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:678e:b0:466:e1bb:45e4 with HTTP; Tue, 14 Mar 2023
 04:49:47 -0700 (PDT)
Reply-To: molivi27@gmail.com
From:   Johnson Williams <avrielharry87@gmail.com>
Date:   Tue, 14 Mar 2023 11:49:47 +0000
Message-ID: <CAL3mPWDta50zPCN_0fk-SewvoVcwmO_Ck=tYyeyQSaoWcoVAWA@mail.gmail.com>
Subject: PANKKIAUTOMAATTIKORTTI
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
        *      [2607:f8b0:4864:20:0:0:0:42d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4942]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [avrielharry87[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [avrielharry87[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [molivi27[at]gmail.com]
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

Onnittelut sinulle,
Mit=C3=A4 kuuluu? Pisin aika. Olen iloinen voidessani kertoa teille
onnistumisestani saada nuo perint=C3=B6varat siirretty=C3=A4 uuden kumppani=
n
yhteisty=C3=B6n=C3=A4 maastanne, t=C3=A4ll=C3=A4 hetkell=C3=A4 olen INTIAss=
a
investointiprojekteissa omalla osuudellani kokonaissummasta sill=C3=A4
v=C3=A4lin, en unohda aiemmat yrityksesi ja yrityksesi auttaa minua
siirt=C3=A4m=C3=A4=C3=A4n perint=C3=B6varat huolimatta siit=C3=A4, ett=C3=
=A4 se ep=C3=A4onnistui
jotenkin.

Ota nyt yhteytt=C3=A4 sihteeriini LOME Togossa L=C3=A4nsi-Afrikassa, h=C3=
=A4nen
nimens=C3=A4 on MRS. OLIVIA MAXWELL s=C3=A4hk=C3=B6postiosoitteestaan
(molivi27@gmail.com) pyyd=C3=A4 h=C3=A4nt=C3=A4 l=C3=A4hett=C3=A4m=C3=A4=C3=
=A4n sinulle kokonaissumma
(900 000,00 dollaria), jonka pidin korvauksellesi kaikista aiemmista
yrityksist=C3=A4 ja yrityksist=C3=A4 auttaa minua kaupassa, joten ota rohke=
asti
yhteytt=C3=A4 sihteeri ja opastaa h=C3=A4nt=C3=A4 minne l=C3=A4hett=C3=A4=
=C3=A4 sinulle
pankkiautomaattikortti kokonaissummasta (900 000,00 dollaria).
Olen t=C3=A4=C3=A4ll=C3=A4 eritt=C3=A4in kiireinen investointiprojektien ta=
kia, joita
minulla on meneill=C3=A4=C3=A4n uuden kumppanini kanssa, muista vihdoin, et=
t=C3=A4
olen v=C3=A4litt=C3=A4nyt puolestasi sihteerilleni ohjeet pankkiautomaattik=
ortin
vastaanottamiseksi.
Parhain terveisin,
herra Johnson Williams.
