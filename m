Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846A56AEFD2
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbjCGS0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbjCGSZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:25:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1534AB887;
        Tue,  7 Mar 2023 10:20:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C329614E8;
        Tue,  7 Mar 2023 18:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D86C433EF;
        Tue,  7 Mar 2023 18:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213222;
        bh=QMLEgpaw8nuZ6gGVRznNtZSpSJ+P4AUFwKxnyhEIEx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JV20MAJx1+Mp0pF7KL5BlWv1VBpcsNNpK+9ewQz9hnI1Zn5ZLJxQ2zDgEdN88HKjR
         OitjgHN44LH/rYijVX21kHE1BU7qFGNn5nSubeZrCAEkbvvyx/T2lrkmWJiap4Y+qg
         Gt7ei5QGLGmfDvCCaPnwZE7kOeH+cRWkhltyGJf8WZdhgGe9bk8VfoE3S8lCPXBFmx
         XMNdgLABg9ivWoB50njnROAY6hmg+GgitTIcLp6XMOO5zQjuNMwxLLTLY4LByp/C0u
         uC+ipSjJvDXp5bpfky1Ggbu3Kx761rC2wS45eXtNjVsn/WPRsmMhfjfj56KxTWd72o
         LRAn/dAytZ1YA==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com
Subject: [PATCH 14/28] qlcnic: Remove unnecessary aer.h include
Date:   Tue,  7 Mar 2023 12:19:25 -0600
Message-Id: <20230307181940.868828-15-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230307181940.868828-1-helgaas@kernel.org>
References: <20230307181940.868828-1-helgaas@kernel.org>
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

From: Bjorn Helgaas <bhelgaas@google.com>

<linux/aer.h> is unused, so remove it.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Shahed Shaikh <shshaikh@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
Cc: GR-Linux-NIC-Dev@marvell.com
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index 2fd5c6fdb500..bcef8ab715bf 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -8,7 +8,6 @@
 #include <linux/ipv6.h>
 #include <linux/ethtool.h>
 #include <linux/interrupt.h>
-#include <linux/aer.h>
 
 #include "qlcnic.h"
 #include "qlcnic_sriov.h"
-- 
2.25.1

