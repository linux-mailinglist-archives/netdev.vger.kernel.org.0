Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA41250695F
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350823AbiDSLGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiDSLGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:06:11 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1FA1FCED
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 04:03:30 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2edbd522c21so167472937b3.13
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 04:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=lvmGpGykEU8IRz0vldUl5U4XJds3FTj5wfLP38Xjlfo=;
        b=F0hX1iBvC64kWE2obuCgejwrHdwM4ec0X7p5hPlI3TebIGcK5p0DMJ9z7p1quXLP0V
         x90AOM2DLDlRXZ5VcLZB8tPV1aK7zYHwkoOetj+UCd/V6eoUtgrKYjPmuOR+rDjDDYrH
         dibR93bqQXwAjI3BzYallEZ0D9nlgKJifEVk2CG0/Q9Av3ZirnbkmGGF3zjlv/U7vOdV
         STu8s+4BIHGUojDQd6zACMb2tiaOwk21yTJaTIJ+mIh9Vp4gwHjmDgP2upKrTkDPbU3B
         uRZwvRnE15I+hyX2MRxse9hUik/EqZOVMU/CBBiuWCff/Ux/dBubKWBKbDs+BhcynBUh
         8wRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=lvmGpGykEU8IRz0vldUl5U4XJds3FTj5wfLP38Xjlfo=;
        b=Gu7TIDcyRW70/fd9JovvM/Ni33MU737i2F/OJkyFIcpmM/vhMg3y7a3sDXzL06wB/3
         GU7yU29LOopr60ByqKMs+t1UJmSeszPciABYS/mxWPC5Myb5qC/1PoJEBo4M77UqlXJs
         am/Y2KAku1wYcYrtRBhEGRfeGEw/rpiD5BE2y7RtplHRKasjaAaOndUnayw+jK/EDYFz
         JJzFCoausy/aY4h37VBIFHsvEmKwUsRlKAa+ggtcAUWVxQg6W9scDPIAVNELf13G9xrZ
         KUw6fDF0SFBIxZrhX4ITQaxIkWNDa7DPJRG3X5jiP9Su7ewzKE1PR7NHBWmOkFZR+p3T
         QRbw==
X-Gm-Message-State: AOAM5339fziilYI0oxS1E7M/gjSlX+4+0OqQX8OC3yjBIM2ExkA6Uxlv
        rszY2RYaIEvCV1SqWy+ePLyKwdGF3UtJIh9ae+Y=
X-Google-Smtp-Source: ABdhPJxIk5thCIOFmzfU+X4e6gxyjgdfuCjzoBZcyqSNfdYwfzOGzmWkAjpMF2tpvdR5XKsO3ogrhDpG+wpSvvR4Is8=
X-Received: by 2002:a81:2:0:b0:2f1:b392:dcda with SMTP id 2-20020a810002000000b002f1b392dcdamr5479397ywa.446.1650366208855;
 Tue, 19 Apr 2022 04:03:28 -0700 (PDT)
MIME-Version: 1.0
Sender: ritamichelle993@gmail.com
Received: by 2002:a05:7010:6044:b0:24c:91bd:ebad with HTTP; Tue, 19 Apr 2022
 04:03:28 -0700 (PDT)
From:   Sandrina Omaru <sandrina.omaru2022@gmail.com>
Date:   Tue, 19 Apr 2022 13:03:28 +0200
X-Google-Sender-Auth: Mj3VwwnWZxYIdFD01fR4Ci6cAwY
Message-ID: <CAMHGWHFi3YxA1RU798Ab6QEKDwA-39S=jq_j7v8BbSgghRot7g@mail.gmail.com>
Subject: =?UTF-8?Q?Fr=C3=B6ken_Sandrina_Omaru?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fr=C3=B6ken Sandrina Omaru

H=C3=A4lsningar till dig,

Det =C3=A4r en respekt och en =C3=B6dmjuk inlaga, jag ber att ange f=C3=B6l=
jande
rader f=C3=B6r din v=C3=A4nliga =C3=B6verv=C3=A4gande, jag hoppas att du ko=
mmer att spara
n=C3=A5gra av dina v=C3=A4rdefulla minuter f=C3=B6r att l=C3=A4sa f=C3=B6lj=
ande v=C3=A4djan med
sympatiskt sinne. Jag m=C3=A5ste erk=C3=A4nna att det =C3=A4r med stora
f=C3=B6rhoppningar, gl=C3=A4dje och entusiasm som jag skriver detta
e-postmeddelande till dig som jag vet och tror av tro att det s=C3=A4kert
m=C3=A5ste hitta dig i gott tillst=C3=A5nd.

Jag =C3=A4r fr=C3=B6ken Sandrina Omaru, dotter till framlidne herr Williams
Omaru. Innan min far dog ringde han mig och informerade mig om att han
har summan av tre miljoner, sexhundratusen euro. (3 600 000 euro) han
satte in i privat bank h=C3=A4r i Abidjan Elfenbenskusten.

Han ber=C3=A4ttade f=C3=B6r mig att han satte in pengarna i mitt namn, och =
gav
mig ocks=C3=A5 alla n=C3=B6dv=C3=A4ndiga juridiska dokument ang=C3=A5ende d=
enna ins=C3=A4ttning
hos banken, jag =C3=A4r undergraduate och vet verkligen inte vad jag ska
g=C3=B6ra. Nu vill jag ha en =C3=A4rlig och gudfruktig partner utomlands so=
m jag
kan =C3=B6verf=C3=B6ra dessa pengar med hans hj=C3=A4lp och efter transakti=
onen
kommer jag att bo permanent i ditt land till en s=C3=A5dan tidpunkt att det
kommer att vara bekv=C3=A4mt f=C3=B6r mig att =C3=A5terv=C3=A4nda hem om ja=
g s=C3=A5 =C3=B6nskan.
Detta beror p=C3=A5 att jag har drabbats av m=C3=A5nga bakslag till f=C3=B6=
ljd av
oupph=C3=B6rlig politisk kris h=C3=A4r i Elfenbenskusten.

Sn=C3=A4lla, =C3=B6verv=C3=A4g detta och =C3=A5terkomma till mig s=C3=A5 sn=
art som m=C3=B6jligt. Jag
bekr=C3=A4ftar omedelbart din vilja, jag kommer att skicka min bild till
dig och =C3=A4ven informera dig om mer detaljer som =C3=A4r involverade i d=
enna
fr=C3=A5ga.

V=C3=A4nliga H=C3=A4lsningar,
Fr=C3=B6ken Sandrina Omaru
