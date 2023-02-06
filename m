Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A0368C54F
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 19:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjBFSAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 13:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjBFSAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 13:00:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ACD2BF35;
        Mon,  6 Feb 2023 10:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A470160F94;
        Mon,  6 Feb 2023 18:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A16C433EF;
        Mon,  6 Feb 2023 18:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675706413;
        bh=1mBYfzPJ7a53DoGi9WpbXN653lhI0Zk9ACSO2DBO/g8=;
        h=From:To:Cc:Subject:Date:From;
        b=tKhM79pTG087SipJU/E0f0pQTPryoldBqFm5VVXv9V0ZWnoNvG/+6Dw1qCwKns7oz
         8R8Fj7y96MJLdzilAeMttGgi8STXm5mJu0ujUZ50ql0QPW+MoEwfCbRn2M6j3Km2O8
         yQuGeciK+NYB0x6VSPE8UKl0Ga7rwGCI1z93ksr1Smzkgn0AIE1zyiHxRAyqI0R0JJ
         0jjTwUP28Xya8UeiDxZ2OzpMKd+S6wKcBG8YJhe+nqP1gbMnJfoDm8STMmhh5ZfFc3
         2ATQefM1nUV8JvFfJbm/y7YZhtheYF6MuZcViJioMtjVZ5prLDAF6UNgVA7mlCckji
         MSgaQDt9SaOnw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        lorenzo.bianconi@redhat.com, sfr@canb.auug.org.au
Subject: [PATCH v2 bpf-next] net: add missing xdp_features description
Date:   Mon,  6 Feb 2023 19:00:06 +0100
Message-Id: <7878544903d855b49e838c9d59f715bde0b5e63b.1675705948.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing xdp_features field description in the struct net_device
documentation. This patch fix the following warning:

./include/linux/netdevice.h:2375: warning: Function parameter or member 'xdp_features' not described in 'net_device'

Fixes: d3d854fd6a1d ("netdev-genl: create a simple family for netdev stuff")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- fix indentation
---
 include/linux/netdevice.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0f7967591288..9bb11da36ef0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1819,6 +1819,7 @@ enum netdev_ml_priv_type {
  *			of Layer 2 headers.
  *
  *	@flags:		Interface flags (a la BSD)
+ *	@xdp_features:	XDP capability supported by the device
  *	@priv_flags:	Like 'flags' but invisible to userspace,
  *			see if.h for the definitions
  *	@gflags:	Global flags ( kept as legacy )
-- 
2.39.1

