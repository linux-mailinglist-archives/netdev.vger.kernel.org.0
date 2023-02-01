Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202E6686DCD
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbjBASUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbjBASUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:20:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28BD7C30A
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 10:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E3D961910
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 18:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32B7C4339C;
        Wed,  1 Feb 2023 18:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675275620;
        bh=0tErNIpbnojJy3+d2ZzaamxQvtJbNMLH3AX3K57pu50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZcFuMY1JMOSEoBQeCmVAL2T6c758QPemB3uVfababqyzBvNI+LSyTNVelT1hwpgbO
         87A6L5hT5QHIXHEPd2yp8QWl57MeYfC6n9itf569LCUvPkewRd8GgNRmep8TGB+OFb
         r9pnQXLMOchvKhTYaSIYRhLQcps7WcjST0/7nz4G2oIW+V5ZIlTHziRcWPS8vXeuWe
         NKuAzrFsRJgGUN6V1T/Jv8Qum4V+QAEXtPfqZkMg2xZJtQl5GeumPjXIR5KXoljnP+
         ijNXNbE5Ss+em6aJprbK02ObV2qFMa5h1vEJzfAnkAQrusojHqCGIgSWmJPE/MK+M6
         EaJmY6BwjjYsA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH net 3/4] MAINTAINERS: ipv6: retire Hideaki Yoshifuji
Date:   Wed,  1 Feb 2023 10:20:13 -0800
Message-Id: <20230201182014.2362044-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230201182014.2362044-1-kuba@kernel.org>
References: <20230201182014.2362044-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We very rarely hear from Hideaki Yoshifuji and the IPv4/IPv6
entry covers a lot of code. Asking people to CC someone who
rarely responds feels wrong.

Note that Hideaki Yoshifuji already has an entry in CREDITS
for IPv6 so not adding another one.

Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
We'd obviously prefer to keep Hideaki Yoshifuji as a maintainer
but I didn't even get a response to my reach out.
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 67b9f0c585a7..f11d5386d1ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14598,7 +14598,6 @@ F:	tools/testing/selftests/net/ipsec.c
 
 NETWORKING [IPv4/IPv6]
 M:	"David S. Miller" <davem@davemloft.net>
-M:	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
 M:	David Ahern <dsahern@kernel.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
-- 
2.39.1

