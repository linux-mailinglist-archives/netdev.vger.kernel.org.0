Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B66945906E
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 15:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhKVOqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 09:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhKVOqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 09:46:12 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79649C061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 06:43:05 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id w22so23691801ioa.1
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 06:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d48kqNcTOfiI+YDLbhbuO0gCz2NOryaBkmV/pfQZf4I=;
        b=ewSzYrlMOjghFCBkX8QEcfZDzxMZtkH8VHVUVIf7srAOVXR9w+1rdfwas/kZlm/VdM
         8jocU2DunkYRrTbu//B/GpZ+rNINGXT8aZPqe24Ot3dSMtVD6pxkADJq+Hje8EU93LVZ
         JvdTUU4QMpK+77pSTGIozeyVkO1eZhq27Gch4AwJABzfRZitkR1Aha2/0VnMyj1tznwL
         FGDRNUwlaeBTqG6nAxmmiQeITc7LkVDX7D+uKRBbUVGkzV444ymwZU5UH/wPamCHzIWe
         i2lhdgbT6NeaWL7Kplv8kj2V+e6zoDGnkXa9EPfzVgaZ18pXIXt4QiKUUbiUu8wX3t8i
         5CTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d48kqNcTOfiI+YDLbhbuO0gCz2NOryaBkmV/pfQZf4I=;
        b=jjpZF7sFekmAN2YmvtYEOtsdg7oLJODptwREf/9uarAXaqDf64XvYOHozVWVqkHFfW
         5bimaJlyCxgCETgysWUCeM+Fhjdplp+QiabPxOdCfWwnHAzIeJwMLJFOfVt4D9AYUl/S
         IGUDi9vzT7Z7U1FXbW2uOoMPbcskFork39DjvevcbhD8DGkFyrSHv0uPrTAHthY3QQRp
         MTSHTtEZ/2cWFARrpKkPy6RIgjw6rqHbTcOQXtxZ2EQ6hsoHESvq/+rfwAetgQ7b0QzK
         RuZAcdPl9av8hdzA0VBpNw2z5GLPCng5bUQ7WJoCX1SdbePNLsphw0d22O5s4byD/Hxu
         Hq6Q==
X-Gm-Message-State: AOAM530uYgbsixrCrbf2+YtnrcP/tqk5aMtvWnp0JIpBDvS3B6+g6omz
        NuDA7cpPfdbFvSj2DA2a/TU5xw==
X-Google-Smtp-Source: ABdhPJwyBum6+m7QArvXzTGgg69aOwdxayYkVKXUb/QGSYxz/sqxlEQeu1KmVao5ygIKyRyTYn9thQ==
X-Received: by 2002:a05:6638:2585:: with SMTP id s5mr49352391jat.68.1637592185010;
        Mon, 22 Nov 2021 06:43:05 -0800 (PST)
Received: from mojaone.waya (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.gmail.com with ESMTPSA id j21sm6051938ila.6.2021.11.22.06.43.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Nov 2021 06:43:04 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
X-Google-Original-From: Jamal Hadi Salim <jhs@emojatatu.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        dcaratti@redhat.com, marcelo.leitner@gmail.com, vladbu@nvidia.com,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next  1/1] tc-testing: Add link for reviews with TC MAINTAINERS
Date:   Mon, 22 Nov 2021 09:42:52 -0500
Message-Id: <20211122144252.25156-1-jhs@emojatatu.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jamal Hadi Salim <jhs@mojatatu.com>

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 10c8ae3a8c73..2f1e78333883 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18483,6 +18483,7 @@ F:	include/uapi/linux/pkt_sched.h
 F:	include/uapi/linux/tc_act/
 F:	include/uapi/linux/tc_ematch/
 F:	net/sched/
+F:	tools/testing/selftests/tc-testing
 
 TC90522 MEDIA DRIVER
 M:	Akihiro Tsukada <tskd08@gmail.com>
-- 
2.20.1

