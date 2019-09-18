Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F856B6A97
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 20:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388717AbfIRSf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 14:35:59 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39338 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387586AbfIRSf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 14:35:58 -0400
Received: by mail-io1-f68.google.com with SMTP id a1so1561343ioc.6;
        Wed, 18 Sep 2019 11:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xbB8StCN3v2KrQ3ionmwFAI5D6do+K0+sr6EMfkGnVs=;
        b=cjM1bjwGTS3DW2hHkqZIZYgMHqO4eiF1RqYzxHabYjLe5onW60d/I2Us/8hBQRqWai
         RTrDQdIP6SD75ag3NPl+yXtF8WR8EfSSRKBsIaBmsQthOg1D0KJ2iN+yMPlLYzHoCgAR
         JeV0rJXDcK9DfMQhHiQEYQynlmE7bSNyxuNw7ai0lQ6PGFcEOJozgccbKPVTcI9N61i4
         0hA9cN153WPN7QrRMsiwGACy0HUiHB41pnIwt0Ul6v/w0B1lNHkQNgf/V76nKeqSk891
         t2z4g42/Zgp20e0DlcFDXnjbgjnPo6Oy4kgtcMxS2bkkfzJ2Ihvs8JBRO4hPzQfyYWNb
         OsDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xbB8StCN3v2KrQ3ionmwFAI5D6do+K0+sr6EMfkGnVs=;
        b=nG8oDoAjt+f1ClNaoXBorCT4t4gg3QdOhzhaQU/lykJFimHvDz6rNhv1H3t5eit9yS
         oQqa0XfjCnHw+Lzb1vCjFtq0qf19obo96FFKUBwxzahjLdw2X5fWlMzmv9drJ89osR9Z
         c/NwipEjAic43OLXTICWpDS057eZ1gMuPhGnGhZaA/WKA1JmikEn+Pa4UTpr0I5IXokx
         MPWZDT6IyvGFkch9f3uYlk3Z9vBOD/3opgCnCv82WuVPkC1rEXr3tW0Sv7PNCUMpO3qm
         Nu+TWE3wKjbV7HiwSWiTMIJnzrHfoIchnUA94EcABX/mfOuNp80OW2R0nDW6v3l0XbNv
         cwmg==
X-Gm-Message-State: APjAAAW8nU36Nw9GH6Rg4rNiKvXdP58LLSUQX4IrH2le1BUpZE+Z/DEF
        t1QVONWVAJ/IlO8Mye1Ud14=
X-Google-Smtp-Source: APXvYqx1SEQ1uWKhud0jYtsJ8ynu5/MfuZiFY+Xjjac7vDtZu4ZagGyibWNsZ0YifJf8NN466YNatA==
X-Received: by 2002:a6b:7116:: with SMTP id q22mr381365iog.280.1568831757851;
        Wed, 18 Sep 2019 11:35:57 -0700 (PDT)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id s201sm8348190ios.83.2019.09.18.11.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 11:35:57 -0700 (PDT)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Enrico Weigelt <lkml@metux.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        jan.kiszka@siemens.com, Frank Iwanitz <friw@hms-networks.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 1/5] staging: fieldbus core: remove unused strings
Date:   Wed, 18 Sep 2019 14:35:48 -0400
Message-Id: <20190918183552.28959-2-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190918183552.28959-1-TheSven73@gmail.com>
References: <20190918183552.28959-1-TheSven73@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove two unused static const strings - a leftover from
a previous stage. Interestingly, neither gcc nor sparse
warned about their presence.

Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
---
 drivers/staging/fieldbus/dev_core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/fieldbus/dev_core.c b/drivers/staging/fieldbus/dev_core.c
index f6f5b92ba914..1ba0234cc60d 100644
--- a/drivers/staging/fieldbus/dev_core.c
+++ b/drivers/staging/fieldbus/dev_core.c
@@ -23,9 +23,6 @@ static dev_t fieldbus_devt;
 static DEFINE_IDA(fieldbus_ida);
 static DEFINE_MUTEX(fieldbus_mtx);
 
-static const char ctrl_enabled[] = "enabled";
-static const char ctrl_disabled[] = "disabled";
-
 static ssize_t online_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
-- 
2.17.1

