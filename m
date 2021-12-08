Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5496546D24A
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhLHLjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhLHLjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:39:25 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E1BC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 03:35:53 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i12so2211379pfd.6
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 03:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=1H7l/DPRfnWzKIISSBKguEjOE3JeKBR02Cjb5zYBOLI=;
        b=IDCw9Zv3A3MW9QgsYEj79jFZVUee0HDt7AGKz+rKrUKGpLo4lwnLGqSK+nHtbl7Exb
         x8LqY3fv/UfCaCylh+483jR6pXYXC9x2iADdHNKYCIPgxNBW1AyfGIPCU3kY5nf9qF4r
         imOPFhSoLyb4AR1PDxXfB+uZEeH/oqf/i0WqxhOyNVE22niyqyqwnu3v162HqKPlqgLL
         SiTNwwPLvbyOvb/iB1N8o1LEDSFiTPHQx3sgEU/L8w4NhuPtN9PhmYVotCpPMDxcAvhE
         bQLhu+pGDE/ADp3Cj4nDY+LOPnQ1YvTXzYnug5eVAogx/73Dcjfx8rs8a1eq0Zz2xYwP
         tPCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=1H7l/DPRfnWzKIISSBKguEjOE3JeKBR02Cjb5zYBOLI=;
        b=hDh30PA0qgsgndzLNdeNcScEdRWeZOTljclJdhK8mfqUju+aDYcgHLA+fUOLllFpjX
         cegD/U3cqUXnMWB+YtCoh5qEjy/2ewQo9e5KvhufsIoJmIPMlXM1YCzXOj3oHKm1vyCE
         7/kcLTBMy8sPPjSh6C3OX8+ZQ8T7DyFRHzR4bmA0d80aAAIMseIRM3GKHmMYOEF/3cMh
         0aE6Y6nCzL6hq9uGsq3oC77sQ8AlciuU8xdMk9Z8h1cKFeJaf+sFQar18NJe0OLWtl2n
         n9BImSMzDW7kJvi1byfP8cSLz5Gd9GxSsP4rJUjeUSle5KLkDiMxAdXOn6WUTfw41xod
         bKnA==
X-Gm-Message-State: AOAM532EzYJiW1Pm5q2tywYiWSkOf5GY1MI21Jrw8R4lt7YGrinjm10c
        DtY/wIPOo9Ke5iD0kLBtd6mN+P8SSGAdBrdET3o=
X-Google-Smtp-Source: ABdhPJwxQhRlJKCblHLFm2tfGU4wwMZuTsyC0PfzQ6PoIUae0kqM1wdlO0jH91G3O3hk01alOBTvwn/+uQ8NBB+wRu4=
X-Received: by 2002:aa7:8b07:0:b0:4a4:d003:92a9 with SMTP id
 f7-20020aa78b07000000b004a4d00392a9mr4976939pfd.61.1638963352955; Wed, 08 Dec
 2021 03:35:52 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:169b:0:0:0:0 with HTTP; Wed, 8 Dec 2021 03:35:52
 -0800 (PST)
Reply-To: cristinacampeell@outlook.com
From:   "Mrs. Cristina Campbell" <sp2295675@gmail.com>
Date:   Wed, 8 Dec 2021 11:35:52 +0000
Message-ID: <CANV8sVF168-awpt3kB=HwKfBFXH_XcP4HYuSfr=TtMC_pejxaQ@mail.gmail.com>
Subject: Kannst du mir helfen?
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lieber geliebter,

Bitte lesen Sie dies langsam und sorgf=C3=A4ltig durch, da es sich
m=C3=B6glicherweise um eine der wichtigsten E-Mails handelt, die Sie jemals
erhalten. Ich bin Mrs. Cristina Campbell, ich war mit dem verstorbenen
Edward Campbell verheiratet. Er arbeitete fr=C3=BCher f=C3=BCr die Shell
Petroleum Development Company London und war auch ein erfahrener
Bauunternehmer in der Region Ostasien. Er starb am Montag, 31. Juli
2003 in Paris. Wir waren sieben Jahre ohne Kind verheiratet.

W=C3=A4hrend Sie dies lesen, m=C3=B6chte ich nicht, dass Sie Mitleid mit mi=
r
haben, denn ich glaube, dass jeder eines Tages sterben wird. Bei mir
wurde Speiser=C3=B6hrenkrebs diagnostiziert und mein Arzt sagte mir, dass
ich aufgrund meiner komplizierten Gesundheitsprobleme nicht lange
durchhalten w=C3=BCrde.

Ich m=C3=B6chte, dass Gott mir gegen=C3=BCber barmherzig ist und meine Seel=
e
akzeptiert, deshalb habe ich beschlossen, Almosen an
Wohlt=C3=A4tigkeitsorganisationen/ Kirchen/ buddhistische Tempel/ Moscheen/
mutterlose Babys/ weniger Privilegierte und Witwen zu geben, da ich
m=C3=B6chte, dass dies eine der letzten guten Taten ist Ich tue es auf der
Erde, bevor ich sterbe. Bisher habe ich Geld an einige
Wohlt=C3=A4tigkeitsorganisationen in Schottland, Wales, Panama, Finnland
und Griechenland verteilt. Jetzt, wo sich mein Gesundheitszustand so
stark verschlechtert hat, kann ich das nicht mehr selbst machen.

Ich habe einmal Mitglieder meiner Familie gebeten, eines meiner Konten
zu schlie=C3=9Fen und das Geld, das ich dort habe, an
Wohlt=C3=A4tigkeitsorganisationen in =C3=96sterreich, Luxemburg, Deutschlan=
d,
Italien und der Schweiz zu verteilen, sie weigerten sich und behielten
das Geld f=C3=BCr sich. Daher vertraue ich nicht sie nicht mehr, da sie
anscheinend nicht mit dem zufrieden sind, was ich ihnen hinterlassen
habe. Das letzte von meinem Geld, von dem niemand wei=C3=9F, ist die
riesige Bareinzahlung von sechs Millionen US-Dollar $ 6.000.000,00,
die ich bei einer Bank in Thailand habe, bei der ich den Fonds
hinterlegt habe. Ich m=C3=B6chte, dass Sie diesen Fonds f=C3=BCr
Wohlt=C3=A4tigkeitsprogramme verwenden und die Menschheit in Ihrem Land
unterst=C3=BCtzen, wenn Sie nur aufrichtig sind.

Ich habe diese Entscheidung getroffen, weil ich kein Kind habe, das
dieses Geld erben wird. Ich habe keine Angst vor dem Tod, daher wei=C3=9F
ich, wohin ich gehe. Ich wei=C3=9F, dass ich im Scho=C3=9F des Herrn sein w=
erde.
Sobald ich Ihre Antwort erhalten habe, werde ich Ihnen den Kontakt der
Bank mitteilen und Ihnen eine Vollmacht ausstellen, die Sie als
urspr=C3=BCnglichen Beg=C3=BCnstigten dieses Fonds bevollm=C3=A4chtigt, die=
ses
Wohlt=C3=A4tigkeitsprogramm sofort in Ihrem Land zu beginnen.

Nur ein Leben, das f=C3=BCr andere gelebt wird, ist ein lebenswertes Leben.
Ich m=C3=B6chte, dass Sie immer f=C3=BCr mich beten. Jede Verz=C3=B6gerung =
Ihrer
Antwort wird mir Raum geben, eine andere Person zu diesem Zweck zu
finden. Wenn Sie kein Interesse haben, bitte ich um Entschuldigung f=C3=BCr
die Kontaktaufnahme. Du kannst mich mit meiner privaten E-Mail
erreichen oder mir antworten: (cristinacampeell@outlook.com).

Vielen Dank,
Dein,
Frau Cristina Campbell
Email; cristinacampeell@outlook.com
