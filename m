Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE111FD0EB
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 17:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgFQP15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 11:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgFQP14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 11:27:56 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB3AC06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 08:27:56 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id y9so1208285qvs.4
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 08:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=7pfke35ATDBZQHizYBReHxNt7Q2DP0Z55RVh2qKQIjo=;
        b=fD8c/evs+8Gafmz77OVS9YqXIwYxcDmurqBrkZfNnM+q51ee5p3wk0f/7GXxcsg00B
         G+VRlVga3dNhJPu8w3hgdgyUs5ezAn28jSbP6HWZpetrZgF4VI4PR29ZNX3PSMw3dMvR
         /CYGs22QQOjH5eZiTwv2xfZTksCzHogm+bdI35fUbKnDBor+2ZIHfF7zGS/ltFGzRMUU
         CqNywVGIkZK4jM93rSLxaxgYJCUGOvsTAWoNwB5MkXxar/h/+QWb2ZVC99610g78vatg
         Fb/mNFoVHaWXn71qokZJdlK0xjv4gnsw8TY/fU/jUabrISloQWc6MsKoLZ6prYD4wEWo
         xuSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=7pfke35ATDBZQHizYBReHxNt7Q2DP0Z55RVh2qKQIjo=;
        b=hPcWRHtRcgc6mBsiUndSGlmlh4KzXKaFsjtzavi++7Ht8wiCSVMrCMJMJeguxYx8fb
         BnARGtLo/w4JSP5qMh8Wbm8Zx2J9DGk47mkRkDaU5CVn6EJww/bqh9MnZ0Jgk8P4I95C
         TuFqK2oI9kV8PjrGeFWkbLwHtkWqB/QXDLFmmdZn6T02lXQiP/jIBVKopSLVU1sbZjJW
         EbjP21ogOZFZhb27UvpHr04BzVB39+WvoiKCV3D5UQmqEwNnmDrwOSRN2wyZ15ZgIbom
         /ZYeVHksTmXnlYbVebmtNoRk2smUJ1skgwmqHAurODM4WqTTYa97FTv0sksjZDzC2QQC
         FAlQ==
X-Gm-Message-State: AOAM531dkFzFyZRJgusV6qnV2FzGVsCadiDPD1kvYWSpCvzjXJFMMZgQ
        97PKdh9UaMA2e6vme0sn0K8af0TSm7EtwBvGNQ==
X-Google-Smtp-Source: ABdhPJwla73kt8o7qgdFJJQqy/pY2zksfKNZ6NzUFpIXfrrzGYleT7aNjEi8sy24RTrRFwUC3WRoB+X+9/GEZqjYzpw=
X-Received: by 2002:a05:6214:964:: with SMTP id do4mr8353776qvb.84.1592407675591;
 Wed, 17 Jun 2020 08:27:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a0c:da02:0:0:0:0:0 with HTTP; Wed, 17 Jun 2020 08:27:55
 -0700 (PDT)
From:   Hassan clement <hassanclement10@gmail.com>
Date:   Wed, 17 Jun 2020 15:27:55 +0000
Message-ID: <CAFeK32jpj6CinjfQPVm=Eo-+Awf3Yav-LJ74JCa5aWyd+ue0hw@mail.gmail.com>
Subject: =?UTF-8?B?RG9icsO9IGRlxYggcMOhbiAvIHBhbmks?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dobr=C3=BD de=C5=88 p=C3=A1n / pani,
E-mail, ktor=C3=BD ste dostali, bol =C5=A1pecificky adresovan=C3=BD v=C3=A1=
m. Va=C5=A1a
e-mailov=C3=A1 adresa bola n=C3=A1hodne vybran=C3=A1 zo Spojen=C3=BDch =C5=
=A1t=C3=A1tov americk=C3=BDch
pre kompenza=C4=8Dn=C3=A9 velenie v spojen=C3=AD s Medzin=C3=A1rodn=C3=BDm =
trestn=C3=BDm s=C3=BAdom (ICC)
spolu s BTCI BANK LOME TOGO, kde va=C5=A1a platba tristo tis=C3=ADc dol=C3=
=A1rov (
300 000,00 USD) sa uskuto=C4=8Dn=C3=AD priamym prevodom na v=C3=A1=C5=A1 =
=C3=BA=C4=8Det
prostredn=C3=ADctvom BANKOVEJ BANKOVEJ PREVODY ALEBO AK=C3=89HOKO=C4=BDVEK =
STREDU
V=C3=81=C5=A0HO VO=C4=BDBY.

Upozor=C5=88ujeme, =C5=BEe v=C3=A1=C5=A1 e-mail z=C3=ADskal kompenza=C4=8Dn=
=C3=BD pr=C3=ADspevok vo v=C3=BD=C5=A1ke 300
000,00 USD z vy=C5=A1=C5=A1ie uveden=C3=A9ho zv=C3=A4zku. Odpor=C3=BA=C4=8D=
ame v=C3=A1m poskytn=C3=BA=C5=A5
inform=C3=A1cie o form=C3=A1te uvedenom ni=C5=BE=C5=A1ie pre =C4=8Fal=C5=A1=
ie spracovanie v=C3=A1=C5=A1ho
dokumentu, ktor=C3=BD okam=C5=BEite po=C5=A1lete spolo=C4=8Dnosti BTCI BANK=
. Poskytnite
potrebn=C3=A9 inform=C3=A1cie ako je uveden=C3=A9 ni=C5=BE=C5=A1ie:

1) Va=C5=A1e cel=C3=A9 meno
2) Va=C5=A1e priame telef=C3=B3nne =C4=8D=C3=ADslo
3) Va=C5=A1a =C3=BApln=C3=A1 adresa
4) K=C3=B3pia va=C5=A1ej identifik=C3=A1cie I.D
5) Zamestnanie a poz=C3=ADcia

V=C4=8EAKA
Pani Alima Dawoodov=C3=A1.
Platobn=C3=BD =C3=BArad
