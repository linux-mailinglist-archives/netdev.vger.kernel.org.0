Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBE24722C2
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 09:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbhLMIgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 03:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbhLMIgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 03:36:35 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D9DC06173F
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 00:36:35 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id g19so14298855pfb.8
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 00:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yNk6D/ZqjxutLUSmSE3RnefutYHZGLQwj2JuZp1B3nQ=;
        b=L8+pp0C8JVtWqN+mz33teqZHeE7gOnWdLapcI6wD6aHEcTPrK6idW/n4fMTowtM5H9
         VoFWdcWb5zQC/1rn0IwSM9KdSr007xA/8NS6bLo5f+WfI0G65BUpoQNEcMpto6e/CgWs
         JBzhhqfyVxGwEIWOAWcyJb7h6Mmwvo80tveh9G4FNNr+CHtOhTFCx7ae6XWw5Orkd54s
         DDqc4nvP7TNXBhThp47zVcOSoO63TFB132TaJ/pnvnVNs9yEBHxyvyyf5T2zBMGhs7aQ
         Ps3UwaAhBBxOVVsXxpF7oz0IWh9KZ8JIZH8BKnHlov62rfYzcYIRjn1mhk9QOAOTbF2C
         1waA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yNk6D/ZqjxutLUSmSE3RnefutYHZGLQwj2JuZp1B3nQ=;
        b=i4Sdq4yUW6lQPuA/xesPd2lXoERH8YuAuaPEiwBu3Q100qAc5kCX06OlSHiAkLqZXf
         luVMp1qsRfw12khwqqOSZ9/Qe1TG4lYB+IRdA3jp8bcfXCiPe49jB0ZTF3iodWbjzlQc
         znLzOEnvnZRmDaYNPP6CCGWuuY2tj5WcStqHxTHP5PkpvGf0fQMgCxHSOcWv+c0kBNRB
         dk1DVY7UCqU+M+pMypltm1iDyzUEMtZ9HaJyjD0tYUPOSg71oukojBFOdVyFkQ+6szbR
         wqzQcup82wtlqd6XtZw61JfCQypkSaKEE/H7g2RUzqgUotARau4v/aEG1pGMKhp8XMx4
         hSKg==
X-Gm-Message-State: AOAM532MVTv+Bj8S7dVPojIYbvHt+IaJCgwYrapPFgxJ11+QBSm7U+b5
        EqAZah2GuM826TXllxO8LPLJCyYkjhTk9A==
X-Google-Smtp-Source: ABdhPJwTp1QDa4ohUa/iY5QpozgfDUXtA3xp0XZDbzkcym2nSY/RQWQ3IApns+4FScjSWLm5+Ul48w==
X-Received: by 2002:a65:4c43:: with SMTP id l3mr14449134pgr.398.1639384594957;
        Mon, 13 Dec 2021 00:36:34 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id nv17sm6390065pjb.55.2021.12.13.00.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 00:36:34 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftest/net/forwarding: declare NETIFS p9 p10
Date:   Mon, 13 Dec 2021 16:36:00 +0800
Message-Id: <20211213083600.2117824-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The resent GRE selftests defined NUM_NETIFS=10. If the users copy
forwarding.config.sample to forwarding.config directly, they will get
error "Command line is not complete" when run the GRE tests, because
create_netif_veth() failed with no interface name defined.

Fix it by extending the NETIFS with p9 and p10.

Fixes: 2800f2485417 ("selftests: forwarding: Test multipath hashing on inner IP pkts for GRE tunnel")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/forwarding/forwarding.config.sample | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/forwarding.config.sample b/tools/testing/selftests/net/forwarding/forwarding.config.sample
index bf17e485684f..b0980a2efa31 100644
--- a/tools/testing/selftests/net/forwarding/forwarding.config.sample
+++ b/tools/testing/selftests/net/forwarding/forwarding.config.sample
@@ -13,6 +13,8 @@ NETIFS[p5]=veth4
 NETIFS[p6]=veth5
 NETIFS[p7]=veth6
 NETIFS[p8]=veth7
+NETIFS[p9]=veth8
+NETIFS[p10]=veth9
 
 # Port that does not have a cable connected.
 NETIF_NO_CABLE=eth8
-- 
2.31.1

