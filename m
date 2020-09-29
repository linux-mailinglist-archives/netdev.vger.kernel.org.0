Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A3D27D7B3
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgI2UKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:10:01 -0400
Received: from mout.gmx.net ([212.227.17.20]:55251 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728952AbgI2UKB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 16:10:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601410199;
        bh=CRYuNg4D65CltJ4ASI38sXWqNcKvV4ZbHs54HCcoGDQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=bhDqIXB0ItY3mIsKPCUYbtymS7pRKULX/M/ZbZBkJqTJZblo1SQRN6s+blZRLGqSm
         a0aLRRyNmeAVJYpLmyE1wCoZsegECfa67R/XZ9Js4L4xWkX5McUZMMjLDt/oAPgXQu
         l+bzssNMp/v5ezDxgD/iPtBewcsVjx/7XGZIDqFA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from PC1310.gateway.sonic.net ([173.228.6.223]) by mail.gmx.com
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MGz1f-1k9Lim0f2J-00E56M; Tue, 29 Sep 2020 22:09:59 +0200
From:   Kevin Brace <kevinbrace@gmx.com>
To:     netdev@vger.kernel.org
Cc:     Kevin Brace <kevinbrace@gmx.com>
Subject: [PATCH net v2 0/4] via-rhine: Resume fix and other maintenance work
Date:   Tue, 29 Sep 2020 13:09:39 -0700
Message-Id: <20200929200943.3364-1-kevinbrace@gmx.com>
X-Mailer: git-send-email 2.17.1
X-Provags-ID: V03:K1:wr1X4CTJWJu97lRYPJXPfXPz4h5PeYn6lOvE0w1HpP81goBP1ry
 dcbFujRTZelq5CEqt0gtzn5yEw1jpgs3NYsNgF76mCG0ViyHnS57l0hQCizYkLwqudU9Tqe
 dj0kQToYVWLgSC6TjmDeEH5bP7KNUUxNechUjBn3xm8lSeCaEa40M9E0hustEIOd+PClBpO
 Dyt/83ZofEBFlLA99HoVQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:JlHOem1gbTc=:xQJwe2ItnD5eySu9w4zwor
 +6M7n28WW5+dAryRq4liz7x9/UT2RpYAoBr/BsUUr4LMrNDtDn6w5lOaNNf+GZridAgb0jejr
 hbHbZckY5OeTebGYgr16E1WxPE5pubsijCUalFftU/fNNOZ2B9dJJKV8APOK3X+CW6zDoupzJ
 9eiqho/JyKilbxiJTKU2HWG07dlchGFJMngYkLRKn/ps5vUSppqAkieFxhe/zhW2zv5QuvnlQ
 InoQUo9jT6XDpEi1l3WIiE+Xie0DURtErzVnYL/xCOhvbW/I9SYTTb4cJnbJ4kkmO1Ia/x0PG
 +QHCYlk5PRhv0c03H4k2UqViXksS5floHD+O5Rm77gonge36hLHcvIMUZEJU2ICcElc1dbNtK
 rUTjM56Jetb4ARzwkzUnU1zUJFEdQSpnZoWJdMLPirUnILLa1zVDCqdMBq/MQMZPH8FdhGU/X
 nzSoOt9iNY7zOIWVZFYDL0ZggjkabhGVnX+VvO3swuv9N6vtrI4zfTb2lZBFyqwnWPvwRZr/q
 hZIfhS33/RtGMIX0OIut7gOi0v39At8wGMgKZcp0RfLguoF3udJE5zio+vBB/vusoNjj7dLN0
 92Q9A23w/kAuYmrH3hhjbOhyz9TGWZ1HuiIIpNLHaIRiHLBortxPGlbIBWp+Kr591nXVNeki1
 E7dd110YhxSkGvUYpAfdwNE0PC4mFnR2NBaRg5ZKUqenT+l2pSoLnh3M8OhseloWAM4iZPb8x
 AB/XuHxaZe6ireFkXcfIrma0U6SC0ljirX3/OwdTF2JaNOcwz+apy+ZZjDPP1vmN87viAgafe
 v8DWFYpP9bMYT5Zo7M1ItIf9u+CoWD4uBIUOuSrrhdwQia43e7g6lUUOnAPdpLYnVcBwW+N2B
 3ZKznpWYRJvz1yr0GUfzIq1LuvnYdUhW3opekPm7CHvCa4dV41W4cPJx11IELJ8FrsDo4QXnH
 aLDu6IhF0xCHuiIRyvF8RZZFoX1uteH3GDEsZtD13Y3zbAZTnPEADv8IkPtTooynIE7mtk/zb
 Ex53fVthXaMhwVIHeFqo5MKukj6QZsD9YoVcnHMKfMSi/JTs5805M8boiAd2XdKJnAbLw23h5
 noevvZa1E+Dwi+2HhUP1D5WOgj8XbFUAMefo4+6ltjJqzd7uad4lzmJFqznISXV6npV8isNf4
 tcFrIy6f95LQ0O1pVkw5KytlSy42YbhP/FvvPM7qVyWSDt9/s+hzmTOTpTCMcPXPhSEaP+Fhz
 Pzz8ZA1Ia9/FmxxpBUuawaTPvlxAx8HoFL6Q4jA==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I use via-rhine based Ethernet regularly, and the Ethernet dying
after resume was really annoying me.  I decided to take the
matter into my own hands, and came up with a fix for the Ethernet
disappearing after resume.  I will also want to take over the code
maintenance work for via-rhine.  The patches apply to the latest
code, but they should be backported to older kernels as well.

=2D-
Kevin Brace (4):
  via-rhine: Fix for the hardware having a reset failure after resume
  via-rhine: VTunknown1 device is really VT8251 South Bridge
  via-rhine: Eliminate version information
  via-rhine: New device driver maintainer

 MAINTAINERS                          |  3 ++-
 drivers/net/ethernet/via/via-rhine.c | 21 ++++-----------------
 2 files changed, 6 insertions(+), 18 deletions(-)

=2D-
2.17.1

