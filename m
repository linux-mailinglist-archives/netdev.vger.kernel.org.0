Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D52295A7
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390467AbfEXKZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:25:56 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43435 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389616AbfEXKZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 06:25:55 -0400
Received: by mail-lf1-f68.google.com with SMTP id u27so6726701lfg.10
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 03:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wJR/iwU7YM/qjZmG1h+ml2iAqCH+1cZ2LjNe4WsNxwM=;
        b=DpO5LuZksSQIiZi/jtJ7xytKyj5hH7fb5o8+PxpOV4Yy6+4YYha0+bm59iVKg2T0fz
         aVw5nxO/hTxR2gvMTMDzsRy836n4r/mGu+acFC5UsAWTmVgvWRdDQo71VHMavN0EvL4n
         Y43LJp8cpCU9s6+s1B6h51NtxzoRtWstAtniR7hwNVQW9FNy73wVxDxuilPNUJMriK7+
         HNlYqw2ScPzl56zOK2SsnqK+pVyFqEMuKTPsk86a0sipU/Oy364VA/COkqfzzWpL8+4m
         yuaNZYlz/wmpxgKy2PL6+Rqs64rDC8WKBqGaOreL/vGHEjwWX/7v2J10bG98CX7GL83j
         eH2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wJR/iwU7YM/qjZmG1h+ml2iAqCH+1cZ2LjNe4WsNxwM=;
        b=iSbWdt1YIAfWENc+gg1HqyG8hQlwvv3HmlLgjSzfM7jtuT0JG5UZ2LdJHn+IWqxDLZ
         r5atiikJtivtcj5ljXPrPTHRWRyyrBDuLbQo8cSjez8XbBk0w/KNaKpHqgbudMIpV+QJ
         gqBKt+vAZLoqNJsaJffpsRT0vWPHsb0PeWkhOPuw0Vcsw47hRACfr+NFGjJhz4nT2zVX
         GZXUDIRmIUrndqFAgEjv+OYKqcq9Rchgh+gWXmuTGySSgKr+uXfWnMLpi5+J0i3kbkEN
         h19LTn490+1Mc1eaGr5uKtkChegHaCYA2XPnVZ32Lb/FAIYSsOsSFlqY/OFJR3jtn92K
         b91Q==
X-Gm-Message-State: APjAAAXUfCdfoiE21kJfZgMRMiJko7VBmzJaZLCMNi53gs+/5F6KkWaR
        QiieLeM2hpjF9WIi0T8eCq2D2kiMWQaVPA==
X-Google-Smtp-Source: APXvYqwpz+c1M1DTB3uqKXv8O1dW+p5tYlkTo+6KuDk6PaF6x/BMofvmMZAgXnohRDAYwUlJp+QczQ==
X-Received: by 2002:a19:81d4:: with SMTP id c203mr50341546lfd.160.1558693553676;
        Fri, 24 May 2019 03:25:53 -0700 (PDT)
Received: from maxim-H61M-D2-B3.d-systems.local ([185.75.190.112])
        by smtp.gmail.com with ESMTPSA id n7sm421567ljc.69.2019.05.24.03.25.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 03:25:53 -0700 (PDT)
From:   Max Uvarov <muvarov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, Max Uvarov <muvarov@gmail.com>
Subject: [PATCH 0/3] net:phy:dp83867: add some fixes
Date:   Fri, 24 May 2019 13:25:38 +0300
Message-Id: <20190524102541.4478-1-muvarov@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Patch "fix speed 10 in sgmii mode" I already sent before
and the was no mutch objections. Just resending it.

Patch "increase SGMII autoneg timer duration" fixes autoneg
between mac and the phy.

And the latest "do not call config_init twice" is the logical
code clean up.

BR,
Max.

Max Uvarov (3):
  net:phy:dp83867: fix speed 10 in sgmii mode
  net:phy:dp83867: increase SGMII autoneg timer duration
  net:phy:dp83867: do not call config_init twice

 drivers/net/phy/dp83867.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

-- 
2.17.1

