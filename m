Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82464D8F8F
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 23:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245619AbiCNW3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 18:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245612AbiCNW3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 18:29:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15421261F
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 15:28:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A3B661425
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 22:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AECC340EC;
        Mon, 14 Mar 2022 22:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647296907;
        bh=dsxgfWQgj68jaTWp2YsP8WyFa2jvnzzZbrv22ibnQHc=;
        h=From:To:Cc:Subject:Date:From;
        b=lF7ImIPopZGjza+zriopjP+APjs67FM5ThndC7BmcFSjYRpoqOM8ngvs0Sv8LjkXY
         yIco69h+IJ7eGQLJA4EoYsEMa1Itq1L0rMfR63few74n/gF3O6ES9KJxkDukfA9ScV
         zsJ6JiLfvXN18AFp05MmYyNlGPuanwVDOkO4sPvI0RWUoqSeA3yjiVRNXV8bs+r+CJ
         o/FNnOjcpPV2v9bpFYl+pednBK3i9WEE4eQiN6zu7LnWk1eMDydLCgWXFVvVPTRDzX
         KZ4LcQe3I5jGWmBfT8DlwwQJGBCb6nLVmJDMy4c2T58kKg6r0UkOBVqdw7DzprPe9Z
         fr+Tr2yM1ss8Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] Add Paolo Abeni to networking maintainers
Date:   Mon, 14 Mar 2022 15:28:19 -0700
Message-Id: <20220314222819.958428-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Growing the network maintainers team from 2 to 3.
Welcome Paolo! :)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 12440bdef9b7..2f6d9171257c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13382,6 +13382,7 @@ F:	net/core/drop_monitor.c
 NETWORKING DRIVERS
 M:	"David S. Miller" <davem@davemloft.net>
 M:	Jakub Kicinski <kuba@kernel.org>
+M:	Paolo Abeni <pabeni@redhat.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 Q:	https://patchwork.kernel.org/project/netdevbpf/list/
@@ -13428,6 +13429,7 @@ F:	tools/testing/selftests/drivers/net/dsa/
 NETWORKING [GENERAL]
 M:	"David S. Miller" <davem@davemloft.net>
 M:	Jakub Kicinski <kuba@kernel.org>
+M:	Paolo Abeni <pabeni@redhat.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 Q:	https://patchwork.kernel.org/project/netdevbpf/list/
-- 
2.34.1

