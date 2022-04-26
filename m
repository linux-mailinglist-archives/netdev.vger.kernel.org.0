Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E64510610
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 19:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347109AbiDZSAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 14:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241036AbiDZSAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 14:00:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791974B86F
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 10:57:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3421AB8217C
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 17:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA61FC385A0;
        Tue, 26 Apr 2022 17:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650995848;
        bh=EmJQQPG6ags6AYBscJK8kqTeBuaO8kgXMdUVQ2WAhIU=;
        h=From:To:Cc:Subject:Date:From;
        b=jk7NFQK47AWd8wGTCyiQvAEE4FSIONWUeUxZF5Qjrbq1aL47P9rAAfhgmFyh7Jnf/
         wxDImj0el9jPIqRTgdsIcON9ZaBSaYc32V+XPkGkfadaRG4Fqey7Ljmn4IWM9Kabq8
         Mjdp48//+q+qQbWzc4vsYjGkS/ItqllT84GNpLYE5Z4ZSxbbBMizAkP0NgQ4Bk48+W
         UM5ykXD+9HEN8LjxkohytOehbXOexO6SCZtDglI4oTvl9dlZTxt1RjQF7oX5ftSwsf
         QyKRiA42wEAz7VFWUPHI5S3j5prMVywcgYgiMYkv06vm9FLk9SirP6hhCjiXb0mYhC
         EiqbNb/a1zDtw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] Add Eric Dumazet to networking maintainers
Date:   Tue, 26 Apr 2022 10:57:23 -0700
Message-Id: <20220426175723.417614-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Welcome Eric!

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cc5559a7fb5c..6a71feb4991e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13639,6 +13639,7 @@ F:	net/core/drop_monitor.c
 
 NETWORKING DRIVERS
 M:	"David S. Miller" <davem@davemloft.net>
+M:	Eric Dumazet <edumazet@google.com>
 M:	Jakub Kicinski <kuba@kernel.org>
 M:	Paolo Abeni <pabeni@redhat.com>
 L:	netdev@vger.kernel.org
@@ -13686,6 +13687,7 @@ F:	tools/testing/selftests/drivers/net/dsa/
 
 NETWORKING [GENERAL]
 M:	"David S. Miller" <davem@davemloft.net>
+M:	Eric Dumazet <edumazet@google.com>
 M:	Jakub Kicinski <kuba@kernel.org>
 M:	Paolo Abeni <pabeni@redhat.com>
 L:	netdev@vger.kernel.org
-- 
2.34.1

