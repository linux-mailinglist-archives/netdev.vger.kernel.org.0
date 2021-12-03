Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB35467A2A
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 16:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381715AbhLCPX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 10:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381713AbhLCPX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 10:23:56 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FC1C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 07:20:31 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id f18so7316426lfv.6
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 07:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Gh3tyDJIK8U1NKisFrNjdDSeqmiqil8cNnRpB61mcxM=;
        b=Pk1rspq5hxo4RRQg2jCzB0xWs14rQvSluAHBvt8pfiPJvY9BUFJGqj6w3ESAi0Kvyg
         WKGnVKuYnmV4idQuyMFORPUkEWmQdPtGjKkv7rzc4f27DmAj6MytQ91WaOpB6AiV26rl
         yiyoo0F+iF2Prsb48OAVqOz8Z2rCAIsDvKPo51Am1powtGIwPJa97+oRPEgSmU+slVxM
         w3eQbGpFCBvRJi+JJLEbBjD/bTnGm5+/iFCF4xnlWvx9LNKy/vC82K7NchzzXd5XHbDG
         43XF1uYzgRmQ6ywd/3/nAEl4TYAcFECSTLTXzs/UtXp+HVLkl6GwG5U9/JZZ0BDn7G9J
         lemQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=Gh3tyDJIK8U1NKisFrNjdDSeqmiqil8cNnRpB61mcxM=;
        b=peLg2m6uBOAj36haNXyHpa1wIIQplup9xF9e9RNfmOv3lFJZRID7S1uKgRZCJyTqeC
         69+xuTLjYoxU+NHGIoMquLjTViTKJSw9rAl0oYcP1NYG12n49fsdZTYQ/72cltCiKjoH
         wlzDeVDHhXpfVktHKvB18jDBWdaz/1p/WYV/xCryFcnaqJFn1ZEZ8Fkx4EZTGEmg7IXw
         enCzYbx14zD0fcXfYmCoKaWd9LP9FwCdnjhPHWWzZbu3UYY89QqERVaXEUB+0i7stI+u
         61zqUwBs2OqK9w4rvRXUFKILO2e706brL+ef1kJPnWmnIXyl15/RWCa446/CuTsOHRHv
         TnTQ==
X-Gm-Message-State: AOAM533U2vQxqYVbb/w4ySgy+2jsma7hMv3WSvNcbFx/jeLHkvNOA6cy
        +KHYXwGteUpIV03u8RNqnRW7WtZHDARhXCRjOQs=
X-Google-Smtp-Source: ABdhPJwVHh2LgGgCkQhKCSO0LRmNOgQ4de8XVOJtSRoQxev/T3ZH9RjcegxmNaaZuCBfDE/KgocWA0ROccxWh6McUaY=
X-Received: by 2002:a19:c352:: with SMTP id t79mr18099496lff.251.1638544830156;
 Fri, 03 Dec 2021 07:20:30 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6504:2141:0:0:0:0 with HTTP; Fri, 3 Dec 2021 07:20:29
 -0800 (PST)
Reply-To: attorneyjoel4ever2021@gmail.com
From:   Felix Joel <starotchi200@gmail.com>
Date:   Fri, 3 Dec 2021 15:20:29 +0000
Message-ID: <CANd7BbdNP+zSbiqfNqq7hoH2Ozz+fSf4nmoMn3LkKnP6F_FYBA@mail.gmail.com>
Subject: =?UTF-8?B?SmVnIHZlbnRlciBww6Ugw6UgaMO4cmUgZnJhIGRlZy4=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Hallo,
V=C3=A6r s=C3=A5 snill, godta mine unnskyldninger. Jeg =C3=B8nsker ikke =C3=
=A5 invadere
privatlivet ditt, jeg er Felix Joel, en advokat av yrke. Jeg har
skrevet en tidligere e-post til deg, men uten svar, og i min f=C3=B8rste
e-post nevnte jeg til deg om min avd=C3=B8de klient, som har samme
etternavn som deg. Siden hans d=C3=B8d har jeg mottatt flere brev fra
banken hans hvor han foretok et innskudd f=C3=B8r hans d=C3=B8d, banken har=
 bedt
meg om =C3=A5 gi hans p=C3=A5r=C3=B8rende eller noen av hans slektninger so=
m kan
gj=C3=B8re krav p=C3=A5 hans midler, ellers vil de bli konfiskert og siden =
Jeg
kunne ikke finne noen av hans slektninger. Jeg bestemte meg for =C3=A5
kontakte deg for denne p=C3=A5standen, derfor har du samme etternavn med
ham. kontakt meg snarest for mer informasjon.
Vennlig hilsen,
Barrister Felix Joel.
