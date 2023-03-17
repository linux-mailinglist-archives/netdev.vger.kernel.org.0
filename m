Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D5F6BF003
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjCQRm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjCQRmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:42:52 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EB55B85;
        Fri, 17 Mar 2023 10:42:50 -0700 (PDT)
Received: from jupiter.universe (dyndsl-091-248-191-142.ewe-ip-backbone.de [91.248.191.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id B713A66030BF;
        Fri, 17 Mar 2023 17:42:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1679074968;
        bh=luOsGa/W1RtrA5yKBcqt3o8mUbhckwWxkml4GSwx6zs=;
        h=From:To:Cc:Subject:Date:From;
        b=Eaxis85B7FeP+X0nYG9nRd1RJ9cjS6YmgfV/bG0eMLUJoLATbH5YtspSZcKu0OxtI
         vMx3QVFtm+xRQJoemRp0/25pPyuZ8mZvmL5YZNyW0i+j3ZnJOOERu1oJUzwIT0I1a4
         LmSgABbRz6jgzUyK4K0v6EXG+3qKsMAiUgOh83/Ot+SboX0/zyUq+BgYk6ogAWeYVn
         8ppLTfU1ESbIjuwlYo4JiX/a89jmFgnO4VjuACHiyKpYRE7TnUL5y9gGIGwV5q2Ide
         /x0KbnNaCHc6+TtU2ypQL9DXLwIF8qaxF04SMZmW7To9dqvPx0yM+XbReGEV5y73t3
         dBqZ42gXWc5wQ==
Received: by jupiter.universe (Postfix, from userid 1000)
        id 3D8204807E1; Fri, 17 Mar 2023 18:42:46 +0100 (CET)
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        kernel@collabora.com
Subject: [PATCHv1 0/2] Fix RK3588 error prints
Date:   Fri, 17 Mar 2023 18:42:41 +0100
Message-Id: <20230317174243.61500-1-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 6.3-rc1 RK3588 EVB1 board currently prints 5 error level kernel
messages. Four of them are from the stmmac driver and taken care of
by this series.

-- Sebastian

Sebastian Reichel (2):
  net: ethernet: stmmac: dwmac-rk: fix optional clock handling
  net: ethernet: stmmac: dwmac-rk: fix optional phy regulator handling

 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 58 +++++++++----------
 1 file changed, 28 insertions(+), 30 deletions(-)

-- 
2.39.2

