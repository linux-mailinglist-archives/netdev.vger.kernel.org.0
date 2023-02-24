Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FDE6A1D83
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 15:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjBXOdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 09:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjBXOdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 09:33:54 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EC429412
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 06:33:38 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id h14so5452935wru.4
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 06:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jpdwd3xuyVkT/VZTbWwrg7JoT4Mr4P0993yBblOq6r0=;
        b=qdfy4wl+b1TUJL3DAS7rB140oqZ8mqnHKBs4fSauPep1ChmKfDz1TSA+9yIZEdWmvt
         WPo63JCNMdWCcm14I3hgnEI7nDYjnKNfMPaR4kfxIRqv0yQ46Fc01AUCP2UbfD505mnN
         LmCu59wAFsRwlM8xnxF7OWd+QJZuRSAYpv+vS3yRu0D59gDefv4sKR3D54L737ogetls
         JBbwRP5IqMzyDBQIBDOHxsn3XhVoxvkaP9OW9Hn0aVsyznPGYy6yWULVgK+rt5yOd7oM
         M3xhI940yloeCIyTXbaS0HdCEOqBqTsAJ7CkrAhsWTJJKT0p7MoIRH0vyY+Ep72Z/ZD5
         uSHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jpdwd3xuyVkT/VZTbWwrg7JoT4Mr4P0993yBblOq6r0=;
        b=Sh78fFjkPKj+jjd29d1XhusncT+qiJCCMIuqWscfcNQp4MM7E6BZTw8BOthMF5Y4z8
         DlDBghlyh7U4nndcRMB2qZ6LSt2w97wFxTQGvczVYVuRGmdmVFPsp97GoufM7TY81lxM
         c+bZOPxlnqJS+knyFAX6+s0/8JVG3Z/+OjENkCVNBYgyO6ST500lLIxu7SR8Ur5zEzNJ
         5kiQVn6qfo4gKOle+B2iCJ/NxIduk0VcStCgyH65hKDbwXgZHtePtNk0j+T6Wk3vOdAN
         Y5W1RuBv4ZpQQv65zOSoZ3Zb3lSleDyVghmCYbGjxM9ZLUejw0CKvWXktHUAaG6e0x7S
         nyWw==
X-Gm-Message-State: AO0yUKV4mlNcTGWn1daAsiFJgBaLvC9sdSUhWnQ7+sECJMpA5PHYkQI4
        7M4xri3+cwOWblr6LZ2m3w06MgWm9AkAX2OJGUY=
X-Google-Smtp-Source: AK7set8hKHHBAXCOEZAeBf2fjNHa+WcrWHfQwZwwedqBX1sHb47BfF3uqYdlddsSJXOHmOIOuBeFOcb46WZPNDaCmIg=
X-Received: by 2002:a05:6000:1d1:b0:2c5:63df:a545 with SMTP id
 t17-20020a05600001d100b002c563dfa545mr1144767wrx.0.1677249217219; Fri, 24 Feb
 2023 06:33:37 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:adf:db0d:0:0:0:0:0 with HTTP; Fri, 24 Feb 2023 06:33:36
 -0800 (PST)
Reply-To: cfc.ubagroup013@gmail.com
From:   Kristalina Georgieva <ubatogoof1@gmail.com>
Date:   Fri, 24 Feb 2023 14:33:36 +0000
Message-ID: <CAGQQY=+WR=eDBNynDHuHnq=h0w-0tfJoxhLmow1XZZA8dm2+9Q@mail.gmail.com>
Subject: HEAD UUDISED
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lugupeetud abisaaja!
Saatsin sulle selle kirja kuu aega tagasi, aga ma pole sinust midagi kuulnu=
d, ei
Olen kindel, et saite selle k=C3=A4tte ja sellep=C3=A4rast saatsin selle te=
ile uuesti.
Esiteks olen pr Kristalina Georgieva, tegevdirektor ja
Rahvusvahelise Valuutafondi president.

Tegelikult oleme l=C3=A4bi vaadanud k=C3=B5ik =C3=BCmbritsevad takistused j=
a probleemid
teie mittet=C3=A4ielik tehing ja teie suutmatus tasuda
=C3=BClekandetasud, mida v=C3=B5etakse teie vastu j=C3=A4rgmiste v=C3=B5ima=
luste eest
varasemate =C3=BClekannete kohta k=C3=BClastage kinnituse saamiseks meie sa=
iti 38
=C2=B0 53=E2=80=B256 =E2=80=B3 N 77 =C2=B0 2 =E2=80=B2 39 =E2=80=B3 W

Oleme direktorite n=C3=B5ukogu, Maailmapank ja Valuutafond
Washingtoni Rahvusvaheline (IMF) koos osakonnaga
Ameerika =C3=9Chendriikide riigikassa ja m=C3=B5ned teised uurimisasutused
asjakohane siin Ameerika =C3=9Chendriikides. on tellinud
meie Overseas Payment Remittance Unit, United Bank of
Africa Lome Togo, et v=C3=A4ljastada teile VISA kaart, kus $
1,5 miljonit teie fondist, et oma fondist rohkem v=C3=A4lja v=C3=B5tta.

Uurimise k=C3=A4igus avastasime koos
kardab, et teie makse on hilinenud korrumpeerunud ametnike poolt
pangast, kes =C3=BCritavad teie raha teie kontodele suunata
privaatne.

Ja t=C3=A4na anname teile teada, et teie raha on kaardile kantud
UBA panga VISA ja see on ka kohaletoimetamiseks valmis. N=C3=BC=C3=BCd
v=C3=B5tke =C3=BChendust UBA panga direktoriga, tema nimi on hr Tony
Elumelu, e-post: (cfc.ubagroup013@gmail.com)
et =C3=B6elda, kuidas ATM VISA kaarti k=C3=A4tte saada.

Lugupidamisega

Proua Kristalina Georgieva
