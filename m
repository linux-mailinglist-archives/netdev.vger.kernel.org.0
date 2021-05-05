Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B98737342A
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 06:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhEEEQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 00:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbhEEEQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 00:16:43 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DF3C061574;
        Tue,  4 May 2021 21:15:47 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id x9so171647uao.3;
        Tue, 04 May 2021 21:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jn4Pll+UieCKYgPHuXaqIsrSXL51vnoPQZAPG5ivrZY=;
        b=Oz96V8LMpbhaypf5NRtIuJobOn7gkQcLXUctbyD1NPbaJyvIv88nZ8Ho0oxxwK0Tt1
         MlTzH5adem6dA2XgK7ztM+LZiLkt87vddlkF2Ly9w2J9TayIFAWjDF/2T04dV1xc/dg+
         8ttGENGb06v2i/lyhFqwDWUFVilUXvQlpPeQOsdpxcRyqEbI+GbRcVNUzLld1rr7mrz6
         R/KmThcoddW4E9xAnZcP+WCyw8JmNPGIonHfjKaWmLvyEhn8Ym5vfnmqQEh/qz3b1fwa
         UHldM11FcSf4OWFDRo21Ddo84FcNd8Yglz2Kf3SnJr84u5XHDpPFtuHgKXfYPp/3LSUY
         qo/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jn4Pll+UieCKYgPHuXaqIsrSXL51vnoPQZAPG5ivrZY=;
        b=INVtwmNoBSfveyiPugymmAjimafQJ8iVNp3800qqMdoGR6+q+nbLAcNCZk1Dijp8pv
         HmOXr0sLN0yjfXfsm5i88TgONbBG9cHO3LvBt+pY862CDM49yYESUgD6L8gMSjfmb0xg
         zXWxG5kJ7r0SqSfb0GR2cJ6dmHu+9uUu4ddhIhQcCUB1wf+jxKNDiyES3VWElSu+4nF5
         P0FAjnG9pHMnenahhM9xhAJ/Gcqy25p2S4OwdiARzK/TdyB6ADngsAA/dEdczsxddlLj
         SPs774UWSFS7PpYhgZxt4F65yndyPAM21ZE8xtPQ06MZ1cH69NlqY1K8wxTR47B+Hemz
         NqDA==
X-Gm-Message-State: AOAM531+wE3N/2HIRR1z8zknK8VZv72ymcRh1BEbzOYm3btM5/V9+tkh
        rCefCSqASbm159fwUk0uV0c=
X-Google-Smtp-Source: ABdhPJxQ45ym8s6zQ8rHr4Mxf1hvsYhIymmkb8rT1yaBoDMNU4+sI6Baa9zDV7rSoNrG8rU//z0b8w==
X-Received: by 2002:a9f:35ef:: with SMTP id u44mr5987507uad.90.1620188146699;
        Tue, 04 May 2021 21:15:46 -0700 (PDT)
Received: from localhost.localdomain ([65.48.163.91])
        by smtp.gmail.com with ESMTPSA id x18sm687246uao.19.2021.05.04.21.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 21:15:46 -0700 (PDT)
From:   Sean Gloumeau <sajgloumeau@gmail.com>
To:     Jiri Kosina <trivial@kernel.org>
Cc:     kbingham@kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org, Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Gloumeau <sajgloumeau@protonmail.com>,
        Sean Gloumeau <sajgloumeau@gmail.com>
Subject: [PATCH 1/3] Fix spelling error from "eleminate" to "eliminate"
Date:   Wed,  5 May 2021 00:15:39 -0400
Message-Id: <21caf628a8aeec21ea9d3f06c95f712a7e7ce7fa.1620185393.git.sajgloumeau@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1620185393.git.sajgloumeau@gmail.com>
References: <cover.1620185393.git.sajgloumeau@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spelling error "eleminate" amended to "eliminate".

Signed-off-by: Sean Gloumeau <sajgloumeau@gmail.com>
---
 drivers/net/ethernet/brocade/bna/bnad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 7e4e831d720f..ba47777d9cff 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -1764,7 +1764,7 @@ bnad_dim_timeout(struct timer_list *t)
 		}
 	}
 
-	/* Check for BNAD_CF_DIM_ENABLED, does not eleminate a race */
+	/* Check for BNAD_CF_DIM_ENABLED, does not eliminate a race */
 	if (test_bit(BNAD_RF_DIM_TIMER_RUNNING, &bnad->run_flags))
 		mod_timer(&bnad->dim_timer,
 			  jiffies + msecs_to_jiffies(BNAD_DIM_TIMER_FREQ));
-- 
2.31.1

