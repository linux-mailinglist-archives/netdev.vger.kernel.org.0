Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF682A0661
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 14:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgJ3NZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 09:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgJ3NZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 09:25:13 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEB3C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 06:25:11 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l16so6670091eds.3
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 06:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=s8cDFr+xlIOagfB6iz9XB//e4MCHUSuHhWsm3z4udjc=;
        b=pRTbDtPGW7p5QKkyCqGIbHsbwCX4Hgj8STG6sDM21RknYuTQJ4kam2KVvYM9b0Z6j1
         9Tj+pw69/v0wUfZtIJypYp+in2NBuEC86m8Ov3HBZLh2QSF/A0Rofq7ylq7ee5BlHsHq
         nnlJrAaDkPbKfJ57NZ/+0WMvXrM4rw4XDMNKpDqQfZ8dZAFAxjYCdQ6kwNO+HhUDy0pZ
         W74Q6o0ofu5Q1ZYGN9AGU1CiTbJmvmBD8zBjj5lWyUzljc+/6xkxRODjJswX+wOk8Ey9
         BdzInSsCFk/jPiONG0wG6sVIphpnWa9vfamdFkEx11E6g6J5kTNXChRxbXmjPjiPNK4Z
         F8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=s8cDFr+xlIOagfB6iz9XB//e4MCHUSuHhWsm3z4udjc=;
        b=do3e1Fza3kTUmqiZWZPVhTHuDo1gElINJfchWFT4MSZBOC03cBqwlXWUShORWokwqu
         ORB4QFb7Mb5Zp3AOmTSFqR4S6BdOZjfFRsYFnXyq13APtBmoiYU0fgTCntsPXXX6Fw0E
         lUT7yX4BjLz2TxCJCG15NU0Zd9gXR4T5XEpt9ytJTPskQzL4zRZqwwRTLvSEpjBUZGAe
         gxQhK/lbxti6z3KdsOZB3SADAThS5bV76OIoNyYIRe2mE2ZG99MNgYKTTYrA2xOIEbjF
         52wbrB5iAH3cUxM9ZzRpPRvWB95Ug5om6/3GZcffMQ1yugTCLyhHws24YqF2WlYUa9V9
         CbnA==
X-Gm-Message-State: AOAM531YzFnAUjYd8NYeQ7KT8WHNsVF2/7eLthgQ9AAinWRumEpArSlR
        gpeWO32x5jXRDRZqgtdvS0ryXEoUFg89aWQn4OQ=
X-Google-Smtp-Source: ABdhPJzZMmL0ia7cYGOIvZZpGNzqmLX9Y5KTpbZwZ/t74BGkZ+A2liPXwEB8kJffKNID4B6MMChmTcaXOfIroyFfQQQ=
X-Received: by 2002:aa7:cb8f:: with SMTP id r15mr2369979edt.356.1604064310711;
 Fri, 30 Oct 2020 06:25:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:7005:0:0:0:0:0 with HTTP; Fri, 30 Oct 2020 06:25:10
 -0700 (PDT)
Reply-To: w.1nfo@yandex.com
From:   martin agboagbo <magboagbo@gmail.com>
Date:   Fri, 30 Oct 2020 14:25:10 +0100
Message-ID: <CANftJ5ftGm6Za_9Fk-G48hqCGibbLLe1hwyrVb37Z1FE7cUm0g@mail.gmail.com>
Subject: =?UTF-8?Q?Ihre_dringende_Antwort_ben=C3=B6tigt=2C?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ihre dringende Antwort ben=C3=B6tigt,

Wie sieht es allgemein aus? Ich hoffe, diese Nachricht trifft Sie gut.
Bitte ignorieren Sie diese Nachricht nicht anders als zuvor, da Ihr
Erbschaftsfonds in H=C3=B6he von 9,2 Mio. USD jetzt nicht mehr auf Ihre
sofortige positive Antwort wartet. Ich fordere Sie jedoch dringend
auf, Ihre vollst=C3=A4ndigen Namen weiterzuleiten: Land: Adresse: Beruf:
Familienstand: Geschlecht: Alter: Private Telefonnummer: und Ihre
Identifikationsnachweis-ID:

Hochachtungsvoll.
Rechtsanwalt Muhammed Rahman Ali. (Esquire)
