Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28D2CD19FD
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732366AbfJIUnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:43:25 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35549 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731884AbfJIUnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:43:25 -0400
Received: by mail-wr1-f68.google.com with SMTP id v8so4699665wrt.2;
        Wed, 09 Oct 2019 13:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lpln8geciAg4JbtsomIIKLOvA7kf5IwzYvS8cTZ6WVo=;
        b=Zq3v1jke+W/GXtjRbhGK/s7oBsB1wxO6GbK2me7gUkAwQawUoK/3KI/TseJwLbGnzt
         ARybW3WTsltkrseBEKdY/nn2GxLEHDFLv8nf5sLBx4Np1p9VXzLM0QiawEVcf71ZfDYq
         McMmuR9U9XSaD0qwNvPfnALJ+yniImr45Gc9gI8DgkmPct4ytA8kKU8Uesmj0Yc7Ohdi
         3Gd7wLNwvwwqIPr3Xw2llSqbV5CK+Ou4BDbD9GwH07EOsr+jQZRPh7NWW6dOClPjMFVW
         uFFduiRwcygYh199z6579/wKVKMjOrGmfLkI3e0TrWzKiAjSuUtUs2FkhSm3YehUag0a
         lUxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lpln8geciAg4JbtsomIIKLOvA7kf5IwzYvS8cTZ6WVo=;
        b=a7MPZj5ewih8azZWQ0E3ozSVE2WFtZwfABry68ZDX2BNys9xM3LzDjxCQN0uJ6tyPb
         b9jJhZ0KRRDp4UUxFKJ8/0zXB+6lVSKLauPZD/brkrYajQQAe5EReNCmyWJJr97MXmjT
         O4LkVdc750eU1sdb3lWLE+K0k+HkQyPW9Du+Z9FUpnsCoJJzJAgkY5xKntQMynZ1qNUk
         1h2fapXufjQEfuNF8LFlGsRRlJGbDyRSuuxFcYciaLPhSazaofiytAEW/+584T3SGawx
         AUTj0Ipo2WKnSfWtQS5Mq2ZYqXp5o4C+z5dIP5bhBiTJknFu4Fba9cv7zsO8wIZPwCIZ
         8qzA==
X-Gm-Message-State: APjAAAUhFz9k1wrlPa+fH6U5HG/RC7JRSDMzcc7OY+qBm3Fpv/EgJT1W
        s/aIqiDbLffASoN0S/ha6Q==
X-Google-Smtp-Source: APXvYqwmkgUaym+RBIuuknYDK4XTZEQuWJzx9o7ZWqA1RdSGXschjm+nGXM4knVx56JAXAXYj0eAHQ==
X-Received: by 2002:a5d:4a81:: with SMTP id o1mr4349969wrq.291.1570653803279;
        Wed, 09 Oct 2019 13:43:23 -0700 (PDT)
Received: from ninjahub.lan (host-2-102-13-201.as13285.net. [2.102.13.201])
        by smtp.googlemail.com with ESMTPSA id f8sm3601546wmb.37.2019.10.09.13.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 13:43:22 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     outreachy-kernel@googlegroups.com
Cc:     gregkh@linuxfoundation.org, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jules Irenge <jbi.octave@gmail.com>
Subject: [PATCH] staging: qlge: Fix multiple assignments warning by splitting the assignement into two each
Date:   Wed,  9 Oct 2019 21:43:11 +0100
Message-Id: <20191009204311.7988-1-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix multiple assignments warning " check
 issued by checkpatch.pl tool:
"CHECK: multiple assignments should be avoided".

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 086f067fd899..69bd4710c5ec 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -141,8 +141,10 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 	u32 *direct_ptr, temp;
 	u32 *indirect_ptr;
 
-	xfi_direct_valid = xfi_indirect_valid = 0;
-	xaui_direct_valid = xaui_indirect_valid = 1;
+	xfi_indirect_valid = 0;
+	xfi_direct_valid = xfi_indirect_valid;
+	xaui_indirect_valid = 1;
+	xaui_direct_valid = xaui_indirect_valid
 
 	/* The XAUI needs to be read out per port */
 	status = ql_read_other_func_serdes_reg(qdev,
-- 
2.21.0

