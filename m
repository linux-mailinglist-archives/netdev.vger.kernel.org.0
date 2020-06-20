Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D457202595
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 19:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgFTRTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 13:19:44 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38466 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbgFTRTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 13:19:43 -0400
Received: by mail-ed1-f65.google.com with SMTP id cy7so3738194edb.5
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 10:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cTL0Xw2hdUb9ouCJUsBsnwjcw8ImcFxoNZxeUsGgPCk=;
        b=t2lewog8isIjXiE/NwqnRhI6xB9FDapT2SIKUugIn8/5TQP66LiAcsRx6zcvnAH6Pu
         Urqj62W2uqN+ZEvmmIru6r058dkRAcfUsgc4Dg2glTxGX8YJZdyeGUYRhs7lxU/PJ7rM
         o39w0kw6yCVPrk/unk+CQSy5o7Y20ue31d9mOdZ+nGMM0CUecPUiyXTeaLgFQaoYcDuz
         0dYCjMYDdrUXre+9dqD1B7MbfLg2eUNj2WAEUiJ3265TcwOS0lZi2nKKaRgj4oQENeSN
         8tHqfsGOVxm0vz7YIx+ydcSICf71RaDp7M7jCsOCrE+8d1UPwyy0zBIn/cvxSPlnLc/S
         /5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cTL0Xw2hdUb9ouCJUsBsnwjcw8ImcFxoNZxeUsGgPCk=;
        b=XIpcio3JOyz8ay0vF40tpErRo+9AkzDFZ/rwrHVe6JwqYyEaRkPdEtWOkGIRaE9e93
         BNynEpW3/riyxFoDBZ/9i4JgTOQMnP0Jp3nzNHz7QiObzt7L7hrLPf/Xw70xHUouncyO
         6gvDKTqeP3E++e1aW0rY8upvHVqcWNmHeOksmUvAhxkZVpLhY3c3rJvQ5jIFYSAcpuWG
         4LSM9IVrCMm4y93l+WvzxovxjkYD29THq8BtQ/QxeZJIqlQnf1YBjkhPQDhNiyx8OsHh
         CKxhI25EuJtdzPdiNJZyvrQScpcm+zLGVQkB0caA5TjTkjAVcjufESzBoOMWjvN/dRQW
         yveQ==
X-Gm-Message-State: AOAM5330yVrSWoWRu6BLfMVJkndcjcetM3ySoif5HolxRfx0ZE7HbdGh
        mi/CX1U19lhAGx8PvP6KYsQ=
X-Google-Smtp-Source: ABdhPJzDEam/zoRZOh8sOb8T5RqWYbwoDybP5U67FDrS825eCireS3yHJ2i5+lmvc8U3zWNA81wyGQ==
X-Received: by 2002:aa7:c245:: with SMTP id y5mr9086164edo.189.1592673521695;
        Sat, 20 Jun 2020 10:18:41 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id a9sm7863476edr.23.2020.06.20.10.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 10:18:41 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: [PATCH net-next 0/3] Cosmetic cleanup in SJA1105 DSA driver
Date:   Sat, 20 Jun 2020 20:18:29 +0300
Message-Id: <20200620171832.3679837-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This removes the sparse warnings from the sja1105 driver and makes some
structures constant.

Vladimir Oltean (3):
  net: dsa: sja1105: remove empty structures from config table ops
  net: dsa: sja1105: make config table operation structures constant
  net: dsa: sja1105: make the instantiations of struct sja1105_info
    constant

 drivers/net/dsa/sja1105/sja1105.h             | 12 +++----
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 25 ++-----------
 .../net/dsa/sja1105/sja1105_dynamic_config.h  |  4 +--
 drivers/net/dsa/sja1105/sja1105_spi.c         | 17 +++++----
 .../net/dsa/sja1105/sja1105_static_config.c   | 36 ++++---------------
 .../net/dsa/sja1105/sja1105_static_config.h   | 12 +++----
 6 files changed, 33 insertions(+), 73 deletions(-)

-- 
2.25.1

