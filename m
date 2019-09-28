Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52418C10DE
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 14:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbfI1MjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 08:39:24 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:42654 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728417AbfI1MjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 08:39:24 -0400
Received: by mail-pg1-f174.google.com with SMTP id z12so4856367pgp.9;
        Sat, 28 Sep 2019 05:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=reduc2MFsFST4q+TYMabSHg6+TfWaSCdRlTRdna3ew0=;
        b=HQkDWBQaRT11Jfgkp4sNUPrHOlL5Zv+WYOkvvVjkGv1CRoEvur4Bf/k5d5JTFPRv20
         5HHZGNrJhqki9rj3b3EelPGg1AskvlrZZNUNPe4tQOw1DfGQH0MwuSL+4eYh2NNJq70E
         vFiQJc5m3Jrnu8cd6L+AKLpdCAqCGEEM5uecmhHfL3YQeK9V/ZGRpsXdQDUY1Gjv0WIh
         V3Dbo9NJ0OArfbE+LCnXczWubas9Di/m9BVfeHwMC3Xs9JsWO6FKyrW7U3mMScuGL+bf
         9LWzFOdLyJZSiUG1VPV0RGO5/1qX7bkiRtfXw8+CRDB2pU1ekGxJ7iwjEcrx3WMbCjuf
         tbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=reduc2MFsFST4q+TYMabSHg6+TfWaSCdRlTRdna3ew0=;
        b=pUbbqSjtjousMt1a8lrDTz7EY84b52WG9KL8N1vSERkq9gGkIKRImDXlTD//cqQizi
         /EX59h105Kwm2zAbN1Kc12LTnqB2yalvU6XeO+zETaMZmqR1AHIANLeNDf6o7vevSjfM
         W4WtQyzCD3PgP6l3lrx28Dx1j63f9X0IL5Xqp5tDZGbcQ8v2pgVv9wTAB+CEdJdQ4N4C
         Mp2RmUI4mecsQDStGNaflm0R+JNrZ8i6uHpGIkBl4xa3gAmOisNf5KqLbQFXu9tq5uGh
         zsx5ZMEYoV/7F5PtwgSKdEHRzDw7vSs9YC/taRD+iRZt0Uj2zTj9TxMDwzG7oBFdy37Y
         cBwg==
X-Gm-Message-State: APjAAAVvPkPeL0lCwekxy0N4hdWOAshO2kbNfaZnLifC4s9d4Wd83xMh
        uVe20LBBcJ3IhxNnzinDrAJx72aXHNk=
X-Google-Smtp-Source: APXvYqyJIfC5dJVQyR7FqT4/rrjfp+/M2BjGIeKWV4ImeEb7ndetEYcTfbQFO+1uqHjpcNXOwn0tOw==
X-Received: by 2002:a65:6901:: with SMTP id s1mr14363378pgq.338.1569674363509;
        Sat, 28 Sep 2019 05:39:23 -0700 (PDT)
Received: from gmail.com ([45.118.67.175])
        by smtp.gmail.com with ESMTPSA id k184sm11674923pge.57.2019.09.28.05.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 05:39:22 -0700 (PDT)
Date:   Sat, 28 Sep 2019 22:39:17 +1000
From:   Adam Zerella <adam.zerella@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, adam.zerella@gmail.com
Subject: [PATCH] docs: networking: Add title caret and missing doc
Message-ID: <20190928123917.GA6876@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resolving a couple of Sphinx documentation warnings
that are generated in the networking section.

- WARNING: document isn't included in any toctree
- WARNING: Title underline too short.

Signed-off-by: Adam Zerella <adam.zerella@gmail.com>
---
 Documentation/networking/device_drivers/index.rst | 1 +
 Documentation/networking/j1939.rst                | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index f51f92571e39..1f4a629e7caa 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -24,6 +24,7 @@ Contents:
    google/gve
    mellanox/mlx5
    pensando/ionic
+   netronome/nfp
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index ce7e7a044e08..dc60b13fcd09 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -272,7 +272,7 @@ supported flags are:
 * MSG_DONTWAIT, i.e. non-blocking operation.
 
 recvmsg(2)
-^^^^^^^^^
+^^^^^^^^^^
 
 In most cases recvmsg(2) is needed if you want to extract more information than
 recvfrom(2) can provide. For example package priority and timestamp. The
-- 
2.20.1

