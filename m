Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652D76A0F7C
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 19:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjBWSb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 13:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjBWSb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 13:31:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E2A4FAA8
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 10:31:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDA496176F
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 18:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006D0C4339C;
        Thu, 23 Feb 2023 18:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677177114;
        bh=cZz8X3smydPnE78bkUqI8V2qRVCQTH/BDidfA+YXgQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVjTCaoA+6xs5dm9B/XzEPgzFsIj1xYQ7214MBc0lLWNuVmjC0aaL/BJiAa7t/Y9I
         +mJjDtDeBwi8o7fhIVELFZnXM57R7pHbedgRy8y+8WR10RniTvXIgBc9HT1q/ExXom
         74EF1zQd4kFJWh2Da0Tgwl/j2TkeNzdtAPKVLe/6BTAdZmSv8FZvVEx6y1BW6oVs1E
         wqWxOYVbOvXxh1/LpkDDILMwXziDBgqmzMly8ldyx33eOqMPJfUO3N17tzWDORJ8zp
         2FRi6x3G/8iASn/gl2maZVldM7F3o/W+Td8rwxjHTGnlVUeWIaSLOJ1OhA7YLrCepb
         EA2fok8B5bChg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>
Subject: [PATCH net 3/3] tools: net: add __pycache__ to gitignore
Date:   Thu, 23 Feb 2023 10:31:41 -0800
Message-Id: <20230223183141.1422857-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223183141.1422857-1-kuba@kernel.org>
References: <20230223183141.1422857-1-kuba@kernel.org>
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

Python will generate its customary cache when running ynl scripts:

?? tools/net/ynl/lib/__pycache__/

Reported-by: Chuck Lever III <chuck.lever@oracle.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/net/ynl/lib/.gitignore

diff --git a/tools/net/ynl/lib/.gitignore b/tools/net/ynl/lib/.gitignore
new file mode 100644
index 000000000000..c18dd8d83cee
--- /dev/null
+++ b/tools/net/ynl/lib/.gitignore
@@ -0,0 +1 @@
+__pycache__/
-- 
2.39.2

