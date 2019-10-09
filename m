Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02732D196C
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbfJIUKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:10:50 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32844 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729865AbfJIUKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:10:50 -0400
Received: by mail-wr1-f65.google.com with SMTP id b9so4601880wrs.0;
        Wed, 09 Oct 2019 13:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lpln8geciAg4JbtsomIIKLOvA7kf5IwzYvS8cTZ6WVo=;
        b=L0zXhNw7qBam7wrKS7JhTdw08I1S4PNNqW1Az7P9Jems3tOv0VwUV61koAjx/VsqKn
         iyJltod0nZI1EPU4GZCDGAWhTUeD2qRkZKHi9xvMGIyAulkgZerJbEomKDVcsgvf9gNa
         w1M43aRwXw2kR0AbKBoQZTXAwkBhOQaCu9HYE2lbjQXHipLtd6j4pZ+2ZPq1R/NVb2bq
         gAxOPGCtJ/NQCiwrOe8Fv4aRrOVAk02mvtJwHuakxadtuuoCiDN8kemyz5PmuwavrQpD
         ztIpGrkobMqQtWbbeR1o3pG/uVUtV6eEKyGj7DnEJ404xn1SnMAf8YBS7zH0IA3h0DdQ
         P2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lpln8geciAg4JbtsomIIKLOvA7kf5IwzYvS8cTZ6WVo=;
        b=TDxO6ZZBqvz4sP4D1OqugCOFin2LUiRfxn6DTBtaMh3qZUadzzDcEn8ERTqg0ntl7Q
         BqF7JhleQzrvqpOAcZsjSPh1k9+puORAdRL2acIqXLBpJwoC2lXfc9cZOTTXoNLBvmMC
         CtedHNOzDHZBQbjzLDklJiVgHOc4RzI5nMWNLUFi0wSjXjjvWylbvDZRjyf6XU7UCRwh
         SvkXOifCtOmW83rTq6sgPhOvgBJ+tY8523u3uINZk5vtmbcKqUCEFynSz3nm/xqeqji/
         kdiu74diq3IPCJZIiIhPT2S1KckTweE3BsWTrBtuxMJzhcLuuupGX2Fr9Ahs1omZEI3w
         84oA==
X-Gm-Message-State: APjAAAW3QFcZMUDbaF7+g+JtKGcgzRwvfSDdjMY2tk6JLnsTezBgHKWO
        Tb5V+ozTrkWpQAfHDDoIKw==
X-Google-Smtp-Source: APXvYqwXoGBj3tn3XNFibK0HKaQfnFrBsFLbTYl9IfV4unRtbFWvuRg6s36sD0W1E4YCoCwyweLdCg==
X-Received: by 2002:adf:9b89:: with SMTP id d9mr4366751wrc.275.1570651848011;
        Wed, 09 Oct 2019 13:10:48 -0700 (PDT)
Received: from ninjahub.lan (host-2-102-13-201.as13285.net. [2.102.13.201])
        by smtp.googlemail.com with ESMTPSA id g3sm4638311wro.14.2019.10.09.13.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 13:10:47 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     outreachy-kernel@googlegroups.com
Cc:     grekh@linuxfoundation.org, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jules Irenge <jbi.octave@gmail.com>
Subject: [PATCH] staging: qlge: Fix multiple assignments warning by splitting the assignement into two each
Date:   Wed,  9 Oct 2019 21:10:29 +0100
Message-Id: <20191009201029.7051-1-jbi.octave@gmail.com>
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

