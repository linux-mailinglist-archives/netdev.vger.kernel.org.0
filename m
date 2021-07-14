Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2D73C8153
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238788AbhGNJVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238725AbhGNJU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 05:20:58 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF11AC061760
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 02:18:07 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id q10-20020a056902150ab02905592911c932so1801866ybu.15
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 02:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FcI/RIY6fqkfvACcmmOBOBRj9VFnw/wDoj5wb2ryU84=;
        b=TNW6CpKuyM53R38THHQO0l30/FsZ9YikSCaulyuCOpmdp6eXcsXkoxcbkYcVlTa3HD
         x5q6GlfQUimHaaisAjdfphUOz0/lKnbvGxdC7Oi6oP5BWmA7oqA7E3vm+QLuu6KygR9u
         7yXW9+luCs5FgL4y1khvw0TU3nzvQa7VivWYxwQur9hapOKYRW2OkZubYBaudJiGGbWS
         bKx9ntWf5faubfJyRLuMSGX8nYX+mPHREiJSDZsAXBBYqLWVPb5DwY/88NJsaN3WrC5W
         9r2Hm467OjHp1bMdchvb14u00iAstp/YVlY8woschlERs0/4VVpFxu1lpj9OrCNU+r2e
         +4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FcI/RIY6fqkfvACcmmOBOBRj9VFnw/wDoj5wb2ryU84=;
        b=igT6ZmtATHqBsJdnLBoXCgSx5BKZ+vUOma8+KBRghY5akoCjkFAwkPX6+sQ/tadnpu
         eavcWoGEpf08FAIQioYEkiDo9VYo0afkHh7/ZKEMJsU37rxtBdFVPQ6D2Sq1aC5SP4Hy
         GnaIYbZ8kbQRABkwL5oltAUHThDgnGfbSuLEjdHMeqnjPhHU4u2bA/uR1KL7ypWpxoGq
         r8cHdP0ycPZkqs/9hF1+0NL8LXeZ7IX2XsDzg+LF0bd4qIwrRcZmPtNrMIq56FEG9FZC
         X7PsGWzRilvjiipKnV5Ny9LjXLyjlm4128BHTYMJIUU+RbYVe7OjkERS6+1ysEGobq73
         lFsQ==
X-Gm-Message-State: AOAM532/NT7SFogP/IJfpFyNBdnV06mdJUkgPP+gbeUWXaqd+oj6o5y5
        CsQsKPmnLZkIUELNXsDnD/hNtQky
X-Google-Smtp-Source: ABdhPJwQumiJEuoqIwwwDHzc73CCuMQCDncvnVhvq5UA/X4SUeW+Mf62MlhxfQh8V4UyJqwzttHAa/vVQw==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:c569:463c:c488:ac2])
 (user=morbo job=sendgmr) by 2002:a25:7355:: with SMTP id o82mr11572449ybc.471.1626254286988;
 Wed, 14 Jul 2021 02:18:06 -0700 (PDT)
Date:   Wed, 14 Jul 2021 02:17:47 -0700
In-Reply-To: <20210714091747.2814370-1-morbo@google.com>
Message-Id: <20210714091747.2814370-4-morbo@google.com>
Mime-Version: 1.0
References: <20210714091747.2814370-1-morbo@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 3/3] scsi: qla2xxx: remove unused variable 'status'
From:   Bill Wendling <morbo@google.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the clang build warning:

  drivers/scsi/qla2xxx/qla_nx.c:2209:6: error: variable 'status' set but not used [-Werror,-Wunused-but-set-variable]
        int status = 0;

Signed-off-by: Bill Wendling <morbo@google.com>
---
 drivers/scsi/qla2xxx/qla_nx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 615e44af1ca6..11aad97dfca8 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2166,7 +2166,6 @@ qla82xx_poll(int irq, void *dev_id)
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_82xx __iomem *reg;
-	int status = 0;
 	uint32_t stat;
 	uint32_t host_int = 0;
 	uint16_t mb[8];
@@ -2195,7 +2194,6 @@ qla82xx_poll(int irq, void *dev_id)
 		case 0x10:
 		case 0x11:
 			qla82xx_mbx_completion(vha, MSW(stat));
-			status |= MBX_INTERRUPT;
 			break;
 		case 0x12:
 			mb[0] = MSW(stat);
-- 
2.32.0.93.g670b81a890-goog

