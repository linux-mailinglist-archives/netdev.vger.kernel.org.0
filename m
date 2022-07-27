Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E235D58313B
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 19:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243175AbiG0RwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 13:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238715AbiG0Rvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:51:50 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756476557E;
        Wed, 27 Jul 2022 09:56:49 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id iw1so2522804plb.6;
        Wed, 27 Jul 2022 09:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9C42EhqujNUGLTQRquiw6KLykM7tiCDPQri3xf5gC3k=;
        b=ieUfKeUdDlULg9PAumCjD1beVPyA0VacMpNeDzUFPAP6XcS6jykM8QW/9s8oGs56gb
         g/oYn7HYhVUqY6Fw5OQeqIQT353rnclw4yL2uaG+76zLpQPErWsObksEkl0N+jP94gZB
         iEdRcsah9bF4R2ju4XbyJK/Fhx6f0PUH//ZzRMn0OJ/oig6LOy7+xidT1hyQHsNnMOeI
         36qieeqP/gGkaBXsRUwOrKHcELZQctgdqikHT8Z1hi2RM9cDlCZDU85VhjNikTibPAfO
         VtxD6mRGTQdtE3HG4nhVF4HvXnOHkXU93iaBnMiI3YkQkJ9yNSIC7UI1K1IB47Kao43L
         QHpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9C42EhqujNUGLTQRquiw6KLykM7tiCDPQri3xf5gC3k=;
        b=etUSKqwe6yAkXm7KKiPAOQdd/D0+6dgJJrB8JC1Xke21Qrn+ladBjd3EKzFUzBq+lJ
         Lt0EM6eKS3Ote1V32lfMMXyBiHen8F3CJR9RHV9KdoHbBjv7FQiWHcYzakat+95anoey
         hyJ8Un+Wi8tQf9Qromi+7AJB4O6sEpz31WIBxSflAP+b8sJTu1Sf5pQsWlZhn50OC2EH
         G7X3MidTg62Zr3ZcNgNASnxYVLUJnVZEtzDyKCfd1GY8vj2+hW0PN9FLTRIJILi57vdq
         xMNLdBMjmSw3BFhGqvBdXX3cL+5RdasWdh7ze0Ea6+y6Ns9BgGrcFADX32Z6lQPr1g5i
         sR3w==
X-Gm-Message-State: AJIora9I0Q/FdTgPzWkS2g8jpchwKp0whCq3wXOEsamnXw8kRJxoLSR6
        mORDo+7uZshV0s9SDdjbPcQ=
X-Google-Smtp-Source: AGRyM1vi21h3IwRP9EUM6w2XY3EenD1AeMYsunem2a7AJFi1iXN3jQ9XLJvDbLDCP6xU+CEvZ16TmQ==
X-Received: by 2002:a17:902:bcca:b0:16d:3e8a:bb5a with SMTP id o10-20020a170902bcca00b0016d3e8abb5amr21834367pls.94.1658941007754;
        Wed, 27 Jul 2022 09:56:47 -0700 (PDT)
Received: from rfl-device.localdomain ([39.124.24.102])
        by smtp.gmail.com with ESMTPSA id z12-20020aa7990c000000b0052baa22575asm14125503pff.134.2022.07.27.09.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 09:56:47 -0700 (PDT)
From:   RuffaloLavoisier <ruffalolavoisier@gmail.com>
X-Google-Original-From: RuffaloLavoisier <RuffaloLavoisier@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     RuffaloLavoisier <RuffaloLavoisier@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/amt.c : fix typo
Date:   Thu, 28 Jul 2022 01:56:40 +0900
Message-Id: <20220727165640.132955-1-RuffaloLavoisier@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct spelling on non-existent

Signed-off-by: RuffaloLavoisier <RuffaloLavoisier@gmail.com>
---
I am sending it again after adding the recipient list.
 drivers/net/amt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index febfcf2d92af..9a247eb7679c 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -449,7 +449,7 @@ static void amt_group_work(struct work_struct *work)
 	dev_put(amt->dev);
 }
 
-/* Non-existant group is created as INCLUDE {empty}:
+/* Non-existent group is created as INCLUDE {empty}:
  *
  * RFC 3376 - 5.1. Action on Change of Interface State
  *
-- 
2.25.1

