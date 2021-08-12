Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5EB73EA85F
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 18:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhHLQQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 12:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbhHLQQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 12:16:03 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC885C0617AD
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 09:15:28 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id y14so3072834uai.7
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 09:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=N4lrIjfQR7v8dFqy6+DJJZiiNe4s9Su8vYVCzzrdzGo=;
        b=Ykv01Ih8uB1ReW+qpk7S4Qt07XnRHlNqDwz6yEWnqGouNKHn/HHdjq4W6Vd6lMlED7
         YzwQru/uA0uN6V0n8OrDsXcu4WC056RHyn2ZNoSZIuc3ycO20eIYuMu6WZAVf7Fj0kH/
         wMfpcEmvGFemzQWMjTw7w0SVymEcAJHlVx6BsJhnUg169DCDRCy9U50zb9Xvq5QoARZA
         HmNzuYyprbomqdOpRh44wiu2p/BbbJGEzdbaTiaMinXoSzvreVpNerIYnm9Kcmqsm+l6
         QcFNNgIEDNFGMzwLd7LarRPevFICs0Rnwylf0VNgDHHQlhd2lVedYKnfKOzz0GDm068h
         mLqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=N4lrIjfQR7v8dFqy6+DJJZiiNe4s9Su8vYVCzzrdzGo=;
        b=VWM1FITjGewRARGOgSEbb9N6EO+4B/3GrZIWwAwyk0hbVMiUOxDKIiex5czDFthgLt
         gE9r1LDOIIFvxfhNKEhax4IRwEdMHLr3zySJPLwbz8ak/EurL8v81WNT77bQfQp+kP4Z
         7JvEidJcMM5cwSUqU6rcfQZ6DHodH05E8rzBj58euerXn0eejK5p3FD4P3AweP13EZXt
         fISCtzIGLALhyR5euQL+/MfEE2SdcH3sYXuWAeMrHrOaj7mS6vgTrTr4ReNuXHR0ihco
         7f/dRNlGe70uSkJKPhnjW6tV/V6vaEnmn3B2MWsobld91bb3mRbGgmn+1zKTMjzNXTqb
         6TKQ==
X-Gm-Message-State: AOAM5300e7lSxTfKy1m09LPWOWd174Vs+39uUHmS3N/T2OruZzGiCzCr
        6s0tD4rj9iO14UBLW+eJ9cpBkOi5B8+vko6DZNU=
X-Google-Smtp-Source: ABdhPJxHngAsOVvjkmrSN3WHXcOQeq8BQW6eJz9aYBTRt1s5xVna4Twa45EzLhMo49pAK6fXs+94IlSw3oi03qzxhAU=
X-Received: by 2002:a9f:31a9:: with SMTP id v38mr3088339uad.137.1628784926569;
 Thu, 12 Aug 2021 09:15:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a1f:1c46:0:0:0:0:0 with HTTP; Thu, 12 Aug 2021 09:15:25
 -0700 (PDT)
Reply-To: uchennailobitenone@gmail.com
From:   uchenna <okeyyoyopa7@gmail.com>
Date:   Thu, 12 Aug 2021 09:15:25 -0700
Message-ID: <CAH8nkva3VpbTgegBzi09CpSNB1525adJYnsnAazWQ6oxWjLA3A@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pros=C3=ADm pozor,

Ja som Bar. uchenna ilobi, Ako sa m=C3=A1=C5=A1, d=C3=BAfam, =C5=BEe si v p=
oriadku a
zdrav=C3=BD? Chceme v=C3=A1s informova=C5=A5, =C5=BEe transakciu som =C3=BA=
spe=C5=A1ne uzavrel s
pomocou nov=C3=A9ho partnera z Venezuely a teraz bol fond preveden=C3=BD do
Venezuely na bankov=C3=BD =C3=BA=C4=8Det nov=C3=A9ho partnera.

Medzit=C3=BDm som sa kv=C3=B4li v=C3=A1=C5=A1mu minul=C3=A9mu =C3=BAsiliu r=
ozhodol od=C5=A1kodni=C5=A5 v=C3=A1s
sumou 350 000,00 USD (tri sto p=C3=A4=C5=A5desiat tis=C3=ADc americk=C3=BDc=
h dol=C3=A1rov), aj
ke=C4=8F ste ma v tomto smere sklamali. Ale napriek tomu som ve=C4=BEmi =C5=
=A1=C5=A5astn=C3=BD
za =C3=BAspe=C5=A1n=C3=A9 ukon=C4=8Denie transakcie bez ak=C3=BDchko=C4=BEv=
ek probl=C3=A9mov, a to je
d=C3=B4vod, pre=C4=8Do som sa rozhodol kompenzova=C5=A5 v=C3=A1s sumou 350 =
000,00 USD, aby
ste sa so mnou podelili o rados=C5=A5.

Odpor=C3=BA=C4=8Dame v=C3=A1m, aby ste sa obr=C3=A1tili na moju sekret=C3=
=A1rku pre kartu Atm
vo v=C3=BD=C5=A1ke 350 000,00 USD, ktor=C3=BA som pre v=C3=A1s uschoval. Ok=
am=C5=BEite ho
kontaktujte.

N=C3=A1zov: solomon brandy

E -mail: solomonbrandyfiveone@gmail.com

L=C3=A1skavo mu znova potvr=C4=8Fte nasleduj=C3=BAce inform=C3=A1cie:

Tvoje cel=C3=A9 meno_________________________
Va=C5=A1a adresa__________________________
Tvoja krajina___________________________
Tvoj vek______________________________
Va=C5=A1e povolanie _________________________
Va=C5=A1e =C4=8D=C3=ADslo mobiln=C3=A9ho telef=C3=B3nu ____________________=
___

V=C5=A1imnite si toho, =C5=BEe ak ste mu neposlali vy=C5=A1=C5=A1ie uveden=
=C3=A9 inform=C3=A1cie
=C3=BApln=C3=A9, kartu Atm v=C3=A1m neuvo=C4=BEn=C3=AD, preto=C5=BEe si mus=
=C3=AD by=C5=A5 ist=C3=BD, =C5=BEe ste to vy.
Po=C5=BEiadajte ho, aby v=C3=A1m poslal celkov=C3=BA sumu (350 000,00 USD)
bankomatovej karty, ktor=C3=BA som v=C3=A1m nechal.

S Pozdravom,

P=C3=A1n uchenna ilobi
