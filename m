Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B9C3D6814
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 22:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhGZTjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbhGZTjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:39:07 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7D8C061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:19:36 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id o7-20020ac87c470000b029025f8084df09so5125024qtv.6
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YZiRJCULAk0NgZWlw4NhyxwOUxRg8I5AfZi4pSeW7rI=;
        b=oQk1seDxX4hy9rYxFNTS4Ro/4O8OjDW/nJG6LXNJQ4gEQfyB7E2Ki+yYYUKVihluxW
         mhc4l38AX0jaJzO8qyMuIKSCGO54O2pLS1Nf0LTNJQOZKdhWC6DCxAfYbYTgGLyS84n1
         fi8eBKB3R5lruvnoxW4nlI2YsNcVmcJsc1sn8RCxtMWbQ6kx3FotZF7Vu5DjrXyghHP0
         bIHkLLUA+e4f5g5wqnjpLXfmnhNEpchc2rrGsHnBlshsQt8PWdpmPs/I6UkTQbBOELIS
         Vh0UCpQNPD0OdL1XtUn4tS9qZBQb6yBwgiFyFx1Uqhgf5l1iDqaTr4xSIBGvtWcJCRQu
         Npcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YZiRJCULAk0NgZWlw4NhyxwOUxRg8I5AfZi4pSeW7rI=;
        b=ImGE95kPd+V8ssxYClRe6tfl+Rgo50o42Kzy0yA0ORt3I+XTOHzrgkDLnHW4gZoA+q
         LaBJaEdt3VPdiyz+vz5mwESagGGmclT4wSZu2fZwKIbaBQEdZTiRB+ij+4YxxxIfjR/v
         6tvGqAsp7aJ72DcH+fiT2Teu+0KSBadvVrWjU68Vm4yKDaRLk/ttSRfVv99X0VWCPMKg
         70DcjJf6QNWnMVNfLzKwhlAsdcIM0MJohiPOfSdqk6tIlZWxV/Xjnh6al/9Gy9eUVfTu
         P+ma7RzSQfhm4qY0fPAqw9YzioLkS7FOMkiulDU/aUdp6oTft8YYAOTh5pRzejR+V3G9
         7wpg==
X-Gm-Message-State: AOAM532L+me8dGeyZp+DIuyggTFBEsS0HFdmFb+HkMDcFA5ZVMkDLzXf
        wdFOarI2kq+4Y1yj85qnqOXOaEPm
X-Google-Smtp-Source: ABdhPJy3LTbBOQ7NzZ8565Lly5b5AVSH3LlZs2RZM9CPhqw6+vphE/8RaBXr21HOSoDuH7z/OqsDJOe0gw==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:ccf7:db54:b9d7:814f])
 (user=morbo job=sendgmr) by 2002:a05:6214:10c8:: with SMTP id
 r8mr19696156qvs.28.1627330775317; Mon, 26 Jul 2021 13:19:35 -0700 (PDT)
Date:   Mon, 26 Jul 2021 13:19:24 -0700
In-Reply-To: <20210726201924.3202278-1-morbo@google.com>
Message-Id: <20210726201924.3202278-4-morbo@google.com>
Mime-Version: 1.0
References: <20210714091747.2814370-1-morbo@google.com> <20210726201924.3202278-1-morbo@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 3/3] scsi: qla2xxx: remove unused variable 'status'
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
2.32.0.432.gabb21c7263-goog

