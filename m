Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCF365FC44
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 08:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbjAFHw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 02:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjAFHw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 02:52:28 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FC01CC
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 23:52:27 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id s25so747251lji.2
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 23:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W03pjHPgDHK7PmQoNWr3Ta5t3Je9mtWR3KN4dTbZ8Ig=;
        b=c8pXfbDLrQ67I9ldwKds93WOQhiGBLb1u8x9dTV9oFmz+vByn87sUVJmzDq4EnkhXY
         X/qYLqXUkgx2ON6Ge5tYDyaECzCMg6OiWTVxaVFV0Rcfprk33KrUfVYVul20Ndbux/M2
         /0Z+S++oXQ6y/XSCelgzR2gIp0OlX6ouhe/ZH0oqZICoAp0CiY8SrtyzCZnOV9Rx5EzJ
         Jb9vUUDmyT4BXp8xzG0/OkfzfX48L0HqitCQCP7wSoM3BON+QJPXw4UHCcjVV0+9pPQl
         D6b4ioIPazYhYkdWjmJn49pM3aEBgkDeFd97FoIrssmBSCHup9h18+isD1MRuWlSXUWH
         WysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W03pjHPgDHK7PmQoNWr3Ta5t3Je9mtWR3KN4dTbZ8Ig=;
        b=uEj+wHmhFfLZ68+zKeGVlFSqEXFuDTCuqiB8ljYG94u6YCJ66QtmsTRQ1e6b+/O5Vz
         +bApuIEBZF7bHiATUT0avPYpa1PUquYl2ZZIDNiADv3kQM53nYZq/ZR6/GwSSpaAATsg
         ZTBnNAlnyNaQy36HnEnPwzDBl/sAJeFKpYBQkTHh+sxs3oSY2gpJe/WZevooc7NGJBqR
         W4nkeS7Q4PqXWZp1mvvRCrQhOBJe6dC5KtTViKPjucLYAvanFhWSdu1sosr+dMriG+Sq
         8z0KWBrn3d5TnS8WmdIf0N8i6SxdMkjRg6xq4+hfoHaHOD4969gfRBfVgIfB6rP+fMtQ
         miCQ==
X-Gm-Message-State: AFqh2koYoFn8pEwlhH/Hd9ya4gx6CjWUHajes5acYNLOZ0fX+vF6jC6c
        DjBPrWQgMDVoMaeV48XZuGVRmZuRpQzU7+TYWCk=
X-Google-Smtp-Source: AMrXdXtn55WfmxFX5dd8fPY85FZuLy3Bz/iTjBxx+/hrpVqKnj/Gl8/hylWHeW7OYOkKkJbfFirPVAo5VCum4lBE4F4=
X-Received: by 2002:a2e:a3d8:0:b0:27f:d464:4489 with SMTP id
 w24-20020a2ea3d8000000b0027fd4644489mr1212256lje.468.1672991545277; Thu, 05
 Jan 2023 23:52:25 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab3:2e4:0:b0:203:746c:51c2 with HTTP; Thu, 5 Jan 2023
 23:52:24 -0800 (PST)
Reply-To: www.orabank.tg1@gmail.com
From:   KRISTALINA GEORGIEVA <georgievakristalina19@gmail.com>
Date:   Fri, 6 Jan 2023 08:52:24 +0100
Message-ID: <CAD5sWaxQXAKCDAtM_g22ejd+33gr9Y-TFH2gjzgiqZN=Qe2-vw@mail.gmail.com>
Subject: URGENT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:22f listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [georgievakristalina19[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [www.orabank.tg1[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [georgievakristalina19[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.4 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MEZIN=C3=81RODN=C3=8D ODD=C4=9ALEN=C3=8D MOLOTTERY.
P=C5=98EDM=C4=9AT: OZN=C3=81MEN=C3=8D O CENY RE, MEZIN=C3=81RODN=C3=8D SEKC=
E ONLINE MOLOTTERY, (5
800 000,00 USD) V=C3=9DHERN=C3=8D FOND

POZORNOST:

V r=C3=A1mci propaga=C4=8Dn=C3=ADho slosov=C3=A1n=C3=AD byli =C3=BA=C4=8Das=
tn=C3=ADci vybr=C3=A1ni pomoc=C3=AD
po=C4=8D=C3=ADta=C4=8Dov=C3=A9ho hlasovac=C3=ADho syst=C3=A9mu sest=C3=A1va=
j=C3=ADc=C3=ADho ze 100 500 000
e-mailov=C3=BDch adres jednotlivc=C5=AF a spole=C4=8Dnost=C3=AD z cel=C3=A9=
ho sv=C4=9Bta v r=C3=A1mci
elektronick=C3=A9ho propaga=C4=8Dn=C3=ADho programu ur=C4=8Den=C3=A9ho k po=
vzbuzen=C3=AD u=C5=BEivatel=C5=AF
internetu po cel=C3=A9m sv=C4=9Bt=C4=9B. M=C4=9Bjte na pam=C4=9Bti, =C5=BEe=
 vy / va=C5=A1e e-mailov=C3=A1
adresa jste se kvalifikovali do slosov=C3=A1n=C3=AD v d=C5=AFsledku va=C5=
=A1ich r=C5=AFzn=C3=BDch
n=C3=A1v=C5=A1t=C4=9Bv r=C5=AFzn=C3=BDch webov=C3=BDch str=C3=A1nek na inte=
rnetu. Va=C5=A1e adresa/adresa va=C5=A1=C3=AD
spole=C4=8Dnosti, p=C5=99ipojen=C3=A1 k =C4=8D=C3=ADslu 230-365-3071, s po=
=C5=99adov=C3=BDm =C4=8D=C3=ADslem
710-43, p=C5=99il=C3=A1kala =C4=8D=C3=ADsla =C5=A1t=C4=9Bst=C3=AD 8, 5, 6, =
24, 19, 34 a bonus =C4=8D. 51, a
proto vyhr=C3=A1l ve druh=C3=A9 kategorii LOSOVAT ONLINE LOTOVAT.

Proto v=C3=A1m bylo schv=C3=A1leno z=C3=ADskat =C4=8D=C3=A1stku 5 800 000 0=
00 USD, st=C3=A1tn=C3=ADch
dolar=C5=AF, co=C5=BE je v=C3=BDhern=C3=AD =C4=8D=C3=A1stka pro v=C3=ADt=C4=
=9Bze druh=C3=A9 kategorie. To je z
celkov=C3=A9ho cenov=C3=A9ho fondu ve v=C3=BD=C5=A1i 38 450 000,00 USD, kte=
r=C3=BD je rozd=C4=9Blen
mezi mezin=C3=A1rodn=C3=AD v=C3=ADt=C4=9Bze ve druh=C3=A9 kategorii.

Kontaktujte =C5=99editele Ora Bank: DR. COVI CELESTINE prost=C5=99ednictv=
=C3=ADm t=C3=A9to
e-mailov=C3=A9 adresy: , (www.orabank.tg1@gmail.com)

za doru=C4=8Den=C3=AD va=C5=A1eho (5 800 000,00 USD), co=C5=BE je celkov=C3=
=A1 =C4=8D=C3=A1stka, kterou
va=C5=A1e bankomatov=C3=A1 karta obsahuje

A dnes v=C3=A1m oznamujeme, =C5=BEe va=C5=A1e prost=C5=99edky budou p=C5=99=
ips=C3=A1ny na kartu ATM
Visa od Ora Bank, Republic of Togo. Za=C5=A1lete n=C3=A1sleduj=C3=ADc=C3=AD=
 informace DR.
COVI CELESTINE, Kontakt =C5=98editel Ora Bank: DR. COVI CELESTINE
prost=C5=99ednictv=C3=ADm t=C3=A9to e-mailov=C3=A9 adresy: , (www.orabank.t=
g1@gmail.com)

1. Va=C5=A1e cel=C3=A9 jm=C3=A9no .............
2. Va=C5=A1e zem=C4=9B .............
3. Va=C5=A1e m=C4=9Bsto.............
4. Va=C5=A1e =C3=BApln=C3=A1 adresa ............
5. N=C3=A1rodnost ................
6. Datum narozen=C3=AD / pohlav=C3=AD .........
7. Povol=C3=A1n=C3=AD ............
8. Telefonn=C3=AD =C4=8D=C3=ADslo .........
9. E-mailov=C3=A1 adresa va=C5=A1=C3=AD spole=C4=8Dnosti ............
10. Osobn=C3=AD e-mailov=C3=A1 adresa ............


P=C5=98EDEM GRATULUJEME,

Dr. Coovl Celestine =C5=99editel OraBank,
  Kontaktn=C3=AD e-mail =3D , (www.orabank.tg1@gmail.com)
