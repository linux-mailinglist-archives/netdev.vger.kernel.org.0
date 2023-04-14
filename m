Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F307D6E2746
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 17:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjDNPr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 11:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjDNPrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 11:47:25 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F373A9C
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 08:47:23 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n42-20020a05600c3baa00b003f0b12814aaso1297518wms.0
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 08:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681487242; x=1684079242;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ROAGH3/MLol0O8DposnZ2qSsZAiwA2IYVTP8Kksz9vY=;
        b=BcU0vgNmCs3O3nL1BJrMGOUPdysG0O8cCK20bn3jpxWDdSyEI6JuGHa6Y14UD9zkkL
         ExwC5v63owpHeh8GsdQW50p+FQtXVl8T9Hi140rk+/kth8L1Q7i5YBYERj/v9gFDFOOY
         /4kCV/MD7eW6DKH/cdxD1+xCM3krUxjztJk/WMaF38d7nuenxhcgRuDiIMCkP1kREvPy
         kcmREXKGNc5ziHg6gUPokyvTOcnO/L5cq0itR1xFrzh0R+lhtt6bKbQrD0/6+XU2mHk1
         idLY7ji05pW+y5rFpohLiYrcAVtR2Ac62kbpXqEHxa9gk/ZslxZfyoj5m1mG7tK354T6
         kz6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681487242; x=1684079242;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ROAGH3/MLol0O8DposnZ2qSsZAiwA2IYVTP8Kksz9vY=;
        b=ltmDGV/1s5+N76RGue3aR8mZ3BvqiP8kBKzpytJfTrxX/tYaFlKZffjeSHINVzy5J1
         jtr9dJUBqmubPmdSgMzJR2iqfN/OrQogygNc3mJINc7y4+Dxig7c3+wUmX/RrVqY9b01
         hkrDBUWEOn+QLBlt34aMNyyOtKtJ0d11LfFySnwObIxIlbsYMW7r+aoF5nC3UYGq4+Ds
         uU34xy0zr4OS4upoTsy/8U6hPIrbU18yXNJzb86appVKElwqreCrU3AYmkJ9jnkm9EEM
         nKCiz8AZpXIdAty5VZWyRMtfF+ZPMt019j4/6N/hCNxZPzkJOJLgdvzjImuKreMc4tXo
         wYVQ==
X-Gm-Message-State: AAQBX9es534a0KqkGT3CFEQ/AAQkCLBsRubOI7qN56Dg89uFneA5k+/M
        ZyS0BstLUBPNGfsp26iMJfT3DQ==
X-Google-Smtp-Source: AKy350Z0mr0LXQVIqANCRWRGdF73h7kiyhCCcRaAzITaYTExNfjW/VmAKoBwmp/TH2DQHkwhPa2sTg==
X-Received: by 2002:a1c:7312:0:b0:3f0:9f9b:1665 with SMTP id d18-20020a1c7312000000b003f09f9b1665mr5195510wmb.3.1681487241751;
        Fri, 14 Apr 2023 08:47:21 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id x2-20020a05600c21c200b003f149715cb6sm1034298wmj.10.2023.04.14.08.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 08:47:21 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Fri, 14 Apr 2023 17:47:07 +0200
Subject: [PATCH net-next 2/5] MAINTAINERS: add git trees for MPTCP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230414-upstream-net-next-20230414-mptcp-small-cleanups-v1-2-5aa4a2e05cf2@tessares.net>
References: <20230414-upstream-net-next-20230414-mptcp-small-cleanups-v1-0-5aa4a2e05cf2@tessares.net>
In-Reply-To: <20230414-upstream-net-next-20230414-mptcp-small-cleanups-v1-0-5aa4a2e05cf2@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=830;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=vS/IFlxUvtKD47GgBJOfT3kDGNlgv5CC+NDxkpe5d+k=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkOXWGt+uBrmDtZZccm3vssXJRxb3/wgMKtBSBW
 qhi747VdSmJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZDl1hgAKCRD2t4JPQmmg
 c3uqD/wMCewm+HBVHMHDEX/wjw7fB1HzXE0Z3cLx2pd8dV25HH1vkE6HTBjRQtPa1/C0CsBlvG6
 WjhkhaiwWzkQV/Yq8jMIILjYeOdsIY03vYRNZqaC4oQ6MCZ/kqCpuwAm7E/bobwxK4FGa6kXkOi
 LrdolWQ6B19d5Js+m+12T/wInvSNk0peB1dzMt/HqOqkMhJA5R4/OmXetgeLkoglQu4glLg2AKi
 WIVfaqiZ2a6RLT948YfRQDTwCevtQGD3LUrICilewOxgOqNsoNj/xAtcFKuhqFOQOCES9zZ6n8O
 Yf6CSQMeFPc2vhv1/BOHuINF7qUsgsCXxet6XQXGrRIXmuC/hwzO9Icv1uusIRm9wIoBYMqZX/A
 oAlYci8XierSHT5aWGSFR8yH1vp2tD1NOAWjymaEjKmul9uWM+4HgHvVn/XWHvWEdNpqYTnaWWE
 c/j3m28QlDSVr36S7/rUH21gxa5t8GXCehnKGduyxOY9h51WbHnCkReUOsd88LTICbXJJ03tDPH
 dtCyE5fv2dukcogwD9Yb+ZbhnViqhQMRPJb4SbyZTPq5vUBCjuEPgO8Js7YQIBcXbEG8/cPDSec
 ZpMTdn8QgGCA5FM1TsMjMu6YlQgBUMJC0IRFsFztSeadzSCTusTjgSquhX7tOUjDLJJegHRp6GC
 JaCGmHDdXqRbD7g==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will help occasional developers to find our git repo without having
to look at our wiki.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b8b275e27cdb..1c09473685b1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14617,6 +14617,8 @@ L:	mptcp@lists.linux.dev
 S:	Maintained
 W:	https://github.com/multipath-tcp/mptcp_net-next/wiki
 B:	https://github.com/multipath-tcp/mptcp_net-next/issues
+T:	git https://github.com/multipath-tcp/mptcp_net-next.git export-net
+T:	git https://github.com/multipath-tcp/mptcp_net-next.git export
 F:	Documentation/networking/mptcp-sysctl.rst
 F:	include/net/mptcp.h
 F:	include/trace/events/mptcp.h

-- 
2.39.2

