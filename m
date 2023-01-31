Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8174768223E
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjAaCep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjAaCe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:34:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856A9366B7;
        Mon, 30 Jan 2023 18:34:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A62D6137D;
        Tue, 31 Jan 2023 02:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AD4C4331D;
        Tue, 31 Jan 2023 02:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675132447;
        bh=HQmstCDqxEZ1FyGyBDK18JF807oC0NcpwIG7clONIqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7ss2W9MvYEKZp7Xsuzxl4ov/cEr7CjZNegO7RSsk4aQ+vHGx5hNAeSr4tIyNvOka
         UufLTwNPnNancUL51smH055Ao0Msq4vZZY2cpd/qUlrEbA7xG49Tssn1loXXcMIegp
         1Jpra9zegbP7apTXdCtiVai7jO5u7PcicpKLmanYtWY9QkGsvJhau2GKKYZAs0WzTP
         zScx+KASHozoN9TAl2PH4pvX3XrGlJ1LI8LK0xEoPYjEltALMMj13fw91EVXHvOcne
         dWf1+MGOb0VefZCimf1MlwIYajoiT7BvesJQRMV67BSuhFYY5RGhON9SLbbk3VMmOg
         f4qqcP6JwDISg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        sdf@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 14/14] tools: net: use python3 explicitly
Date:   Mon, 30 Jan 2023 18:33:54 -0800
Message-Id: <20230131023354.1732677-15-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131023354.1732677-1-kuba@kernel.org>
References: <20230131023354.1732677-1-kuba@kernel.org>
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

The scripts require Python 3 and some distros are dropping
Python 2 support.

Reported-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/cli.py       | 2 +-
 tools/net/ynl/ynl-gen-c.py | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/net/ynl/cli.py b/tools/net/ynl/cli.py
index e64f1478764f..db410b74d539 100755
--- a/tools/net/ynl/cli.py
+++ b/tools/net/ynl/cli.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 # SPDX-License-Identifier: BSD-3-Clause
 
 import argparse
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index dc14da634e8e..3942f24b9163 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 
 import argparse
 import collections
-- 
2.39.1

