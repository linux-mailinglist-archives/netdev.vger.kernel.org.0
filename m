Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4C63BE2AB
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 07:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhGGFmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 01:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhGGFmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 01:42:07 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A19BC061574
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 22:39:26 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id t19so941051vst.9
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 22:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=3uomcTmhuglHjntN+DATWirqBWULDPeZ6fTco+Z3WJc=;
        b=ATWZsM/A4ypRNOecZHMDlOZu3Ng7psPuUKe9VWUtYpKZIvDRDo1VPX4HbYytvQaGoK
         dT7CNhuDgUkkJP1vsdHcZ3FbQbbipVxbGcYLwLDTEs2RARyepmxxozE3lVwTnBNYQ1jI
         nKSOpxuQeBGrVr/Yr0/PRhKAIKRKZYmDQJC+9QCkHTtZdWgC7eUji+mHMrztMzLoUhRv
         yV38jWmqvgzzUnrIikVlE7w7Sy5vV5Y/PNiAHHAO/Ju7Ukp+SO9J1zt8nVbFH0qkcMR9
         dI/F6TKu9kDWdeZu6oHKLvOXab40GA7Ar2EYMMi7no9DQ4E5DDMr4Ct6oq9aZJ++TfGE
         6oJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=3uomcTmhuglHjntN+DATWirqBWULDPeZ6fTco+Z3WJc=;
        b=O+T4KD56XNx6SUxiHUesoDqmQdPdmltYU7z7K7M9RfukEd1JPzqxYZFj54kCYCrtih
         i58C5mTBpBi2M2yizKGzGzz8sZKigRij1KbBXKpnYPGaCKjJCfu4mJeESSRXD1UCwgf5
         /l6VlZYApBQ428GEvUpA0iVOX61FPY3UgqQCQQu0v13or7u7V5qLkcoQtK15zG81ETiY
         xMGClStGDmklYjnERq466J9GSjQCjmf1JlojMllsR6DQVOj1Zz2Jq15qEKUt6iEod/AL
         t6g/uZQJnpGAWTeSB4UUkJViPeYTmXbxKyHOdLb7NOX67OniIMNzhpe/KUg6NwGTzV3X
         wNFw==
X-Gm-Message-State: AOAM531YaZaASI/KAy3O6Z3xxfbGLChvtjHpUYWVA3YWffwzologF1tq
        YSmwL4bSjzkE6QVDBJS39kKQdav6nuPB2l8Yr2w=
X-Google-Smtp-Source: ABdhPJzNQGauDE8hEwJuQe8kHjnZxSQQy9+Eujlmh3SJQyMR2381Iy8hMU2DjM5OvUeTIrPzsuSBkg46IC3Nq84nMC8=
X-Received: by 2002:a05:6102:34c7:: with SMTP id a7mr18536948vst.18.1625636365586;
 Tue, 06 Jul 2021 22:39:25 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:3894:0:0:0:0:0 with HTTP; Tue, 6 Jul 2021 22:39:25 -0700 (PDT)
Reply-To: brianjesse34@gmail.com
From:   brian jesse <brianjesse343@gmail.com>
Date:   Wed, 7 Jul 2021 05:39:25 +0000
Message-ID: <CAFJN7Jj+vsggK73mam1OjUCa8_CZaHPORy2KdsaEjhCOLXFYsw@mail.gmail.com>
Subject: =?UTF-8?B?Y3plxZvEhw==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Witaj, Uprzejmie informujemy, =C5=BCe ten e-mail, kt=C3=B3ry dotar=C5=82 do=
 Twojej
skrzynki pocztowej, nie jest b=C5=82=C4=99dem, ale zosta=C5=82 specjalnie d=
o Ciebie
skierowany. Mam propozycj=C4=99 (7,500.000,00 $) pozostawion=C4=85 przez mo=
jego
zmar=C5=82ego klienta in=C5=BCyniera Carlosa, kt=C3=B3ry nosi to samo nazwi=
sko, kt=C3=B3ry
kiedy=C5=9B pracowa=C5=82 i mieszka=C5=82 tutaj w Lome Togo. M=C3=B3j zmar=
=C5=82y klient i
rodzina uczestniczyli w wypadku samochodowym, kt=C3=B3ry zabra=C5=82 ich =
=C5=BCycie .
Skontaktuj=C4=99 si=C4=99 z tob=C4=85 jako najbli=C5=BCszym krewnym zmar=C5=
=82ego, aby=C5=9B m=C3=B3g=C5=82
otrzyma=C4=87 =C5=9Brodki na roszczenia. Po szybkiej odpowiedzi poinformuj=
=C4=99 ci=C4=99
o sposobach wykonania tego przymierza, skontaktuj si=C4=99 ze mn=C4=85 w te=
j
sprawie (brianjesse34@gmail.com)
