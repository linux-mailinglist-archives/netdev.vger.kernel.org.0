Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E45D467A24
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 16:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381646AbhLCPWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 10:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhLCPVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 10:21:55 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203C9C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 07:18:31 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id 13so6749416ljj.11
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 07:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Gh3tyDJIK8U1NKisFrNjdDSeqmiqil8cNnRpB61mcxM=;
        b=Oz3Q9CBZ1+/QqYmwe7ko+H7VNs7qUd2hdYs0UDJKcD5KpZm8X/gDoJ1crM5TQCXEBD
         NU52ZBDbb9V8rInRZBzuzPSmvNbYYOLGM6zX2oZEUxc1Y8oJD8hMukJo6ov3ejHYFEvJ
         IHwytxVM5UowTM4J8HHF/Cs4MJitktMHvw6g7pjQVcr0r++L4cALk2zb/QkvOj9lt2mH
         HlB7x/GcNKnqIeSZ7lH38zcNGPMevjy8KWi7EZ9E/ZibLUi/pQZ29XQ4tNVB0XXhb3Xl
         deubudYry13LSlc7dX47EQw1T/XrgCQZanQuEJ9SGXTHxP6P2KF4qIZUdVyUuEYEfw4m
         E5tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=Gh3tyDJIK8U1NKisFrNjdDSeqmiqil8cNnRpB61mcxM=;
        b=nPSyU7IiBQ3+qc+zbuqtsjQzr5efg9Zgde3wzYGqv+3YYwsOWXHPd+6Tt62csoEhQS
         0I+fF0Gf/XtguVHtGMD5DVL5eVr5zh5YGnzDZMMRfBcDUFtfXP8DSI9cbz0Lfze/Yxfy
         8z0Rlk61IiawIgKIp7xfeimBR7BF6xGtSKQsGxJYXhj7meeS5MuG1rkL91dYdlvyB+xM
         xDiJRoJG+sVvchsYEZes/Sw6qI47no6Mhxg53P+xCe/UcGT1LKbtm5BKp2Esykf1UY0W
         FnGKQIwI6nqi9hBjWaMXJTZmJbNHra4vTDVqqZPglW+rYq5iDEvWaew3G2cWWTyd7NJd
         4csw==
X-Gm-Message-State: AOAM530MUYqbqIQAi0czMaAOpeZBxzRGKRMg6jyCQBG7jjTi0uRbu76y
        Ta2krKXEJnWdmY6/EjsJgoO9L3+JIABqfTCvOeg=
X-Google-Smtp-Source: ABdhPJzjZxwj0HT7fmEhSGam/UA3es0u7yNCTpV7IDQuD7hLvYpFUfRCg0rQHE0WTjlGMQfwr/f+gFSiWFm28vDYaIk=
X-Received: by 2002:a2e:bc1c:: with SMTP id b28mr19273209ljf.500.1638544709443;
 Fri, 03 Dec 2021 07:18:29 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6504:2141:0:0:0:0 with HTTP; Fri, 3 Dec 2021 07:18:29
 -0800 (PST)
Reply-To: attorneyjoel4ever2021@gmail.com
From:   Felix Joel <starotchi200@gmail.com>
Date:   Fri, 3 Dec 2021 15:18:29 +0000
Message-ID: <CANd7BbfCaqM0Bn+_0u3SJ-w2U4x_QsJ0uJsbiWh6PKBB2GYcOg@mail.gmail.com>
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
