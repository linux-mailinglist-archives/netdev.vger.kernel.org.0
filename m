Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A1552BE77
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 17:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239232AbiERPQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 11:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239190AbiERPQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 11:16:46 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91F0579BD
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 08:16:45 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id c24so4166477lfv.11
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 08:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=g6Lk83A6divwG1I6skDkMiATloOtXTUuKSXHzb8wwME=;
        b=dNbsn0thNSvzMJCd4pkmaTtgDWvotMTQ0ugVSbJ83qoQ1GGEGymeVYYeje7oUKfFyk
         h3fvzeWIXiTuV9lRh002dFE87FQwUKFTqU2rZwNqaUcQ+b3/H+yx/wz7soPtIDit9clG
         0H6seLEtjodilPYGdtmnhObvwaduxe4lPcUhHp4EOJZEXKZj/Hj1k4qev+geJs1vwxBb
         9kiJ5Qy6TD6JJacfhdSIxRTDkmmV/R047KB8RzK5pVuxpeW7Z63fCyg3+Dt2GUofHqTs
         wxV1GQLKViHgqqa7xYBusa4Xry2WfzS3Prp9azSIAdx2x4eqoYZhgHFrPThkSmewFCDN
         dmZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=g6Lk83A6divwG1I6skDkMiATloOtXTUuKSXHzb8wwME=;
        b=Jz81z+2FLEkINkK4dkg6tJIa8e/JnV8U9HoIoLHDwab4tmsFDUkx0kxshjqMBcPHC5
         gxFdi92BRFG5noq5npt4x9TzUZJJ9cy/15tectKXbUKk9MvfpNCyJb/uqpp7fhpE7ALB
         qoPrax1ZQKPA+S6zTK0QAFBBkGHCd6MEtgmtMxsAycT8yHhdQmmN9xWFiTjP1b4R9E49
         aAk9NgGI1mAjdzKQxlmjKzPA8WLqBnLMuy+iAmfvxN9flCePCcol43oR4gzGnqG91qMZ
         JTFebNR8OEBx4zuge1ALUWDkPg92/2bi57QAP+4xOYo3tuh6SAJY+1UJD9ChadBglFDc
         DDKw==
X-Gm-Message-State: AOAM5316OzVoFeXPYp7WA5f5Q7yQJ2cawfXbIPmGh5X2/FYXRh48JkYS
        zZvd+aZwvc8ApzwZ5gN0gLzL2FKk3fg=
X-Google-Smtp-Source: ABdhPJxwZj/PynUuK1XP16kZ9V2kTHI4TNu9tdHgLx8K/RtW9BcJzEGkrwrAEVnuyfV2NIL1iFxYSQ==
X-Received: by 2002:a19:5e5e:0:b0:474:fa8a:2d07 with SMTP id z30-20020a195e5e000000b00474fa8a2d07mr20437480lfi.455.1652887003680;
        Wed, 18 May 2022 08:16:43 -0700 (PDT)
Received: from wbg.labs.westermo.se (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id a7-20020ac25207000000b0047255d2110esm242016lfl.61.2022.05.18.08.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 08:16:43 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH net-next 1/1] selftests: forwarding: fix missing backslash
Date:   Wed, 18 May 2022 17:16:30 +0200
Message-Id: <20220518151630.2747773-1-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix missing backslash, introduced in f62c5acc800ee.  Causes all tests to
not be installed.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 tools/testing/selftests/net/forwarding/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index b5181b5a8e29..8f481218a492 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -88,7 +88,7 @@ TEST_PROGS = bridge_igmp.sh \
 	vxlan_bridge_1d_port_8472.sh \
 	vxlan_bridge_1d.sh \
 	vxlan_bridge_1q_ipv6.sh \
-	vxlan_bridge_1q_port_8472_ipv6.sh
+	vxlan_bridge_1q_port_8472_ipv6.sh \
 	vxlan_bridge_1q_port_8472.sh \
 	vxlan_bridge_1q.sh \
 	vxlan_symmetric_ipv6.sh \
-- 
2.25.1

