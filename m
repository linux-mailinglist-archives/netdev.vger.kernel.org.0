Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48DA4EB99F
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241116AbiC3E11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242546AbiC3E1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:27:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7A1E0B2;
        Tue, 29 Mar 2022 21:25:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1F6F61557;
        Wed, 30 Mar 2022 04:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB920C340EE;
        Wed, 30 Mar 2022 04:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648614319;
        bh=rr/JfM01NA9fTgIIQTyL0hc+z3aaAIbMCzadjNz0JKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5oCGCMRhcZ6iJy2SN2x04M4PxF03Ww4fA1Xyis8ISwYMpR/RJ+S9qT3kpHx8K2+7
         WCO2xOH96xt0L0goZGDm3kiP0MnMkEN5HQ4FCf2MsFYBiJQvbgEWSw8PFH/jmfs6Xu
         rfRL/1jhA8rYH75/0fzJ/NUUJ/1RJmdfbsBq/MaiviDD1TK6QSoSzyq/xk/MzAby1l
         EW7WBGUCq9FRr5j2rdlnWwZn+7U5S9AaMbnAab5FjYAGzlPHoxyIn4rUbR1eWvezfs
         BUR2nZmyxxx45XYrVDVpuZDhzIzWhiXM/YKA/9/upfo6uF33W2YC3dhFkXY+YBAyGX
         yVYjMtSBNAoeg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 14/14] docs: netdev: move the netdev-FAQ to the process pages
Date:   Tue, 29 Mar 2022 21:25:05 -0700
Message-Id: <20220330042505.2902770-15-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330042505.2902770-1-kuba@kernel.org>
References: <20220330042505.2902770-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The documentation for the tip tree is really in quite a similar
spirit to the netdev-FAQ. Move the netdev-FAQ to the process docs
as well.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/bpf/bpf_devel_QA.rst                             | 2 +-
 Documentation/networking/index.rst                             | 3 ++-
 Documentation/process/maintainer-handbooks.rst                 | 1 +
 .../netdev-FAQ.rst => process/maintainer-netdev.rst}           | 0
 MAINTAINERS                                                    | 1 +
 5 files changed, 5 insertions(+), 2 deletions(-)
 rename Documentation/{networking/netdev-FAQ.rst => process/maintainer-netdev.rst} (100%)

diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
index 253496af8fef..761474bd7fe6 100644
--- a/Documentation/bpf/bpf_devel_QA.rst
+++ b/Documentation/bpf/bpf_devel_QA.rst
@@ -658,7 +658,7 @@ Otherwise, you can use ``bpf`` target. Additionally, you *must* use bpf target
 
 .. Links
 .. _Documentation/process/: https://www.kernel.org/doc/html/latest/process/
-.. _netdev-FAQ: ../networking/netdev-FAQ.rst
+.. _netdev-FAQ: Documentation/process/maintainer-netdev.rst
 .. _selftests:
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/bpf/
 .. _Documentation/dev-tools/kselftest.rst:
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index ce017136ab05..72cf33579b78 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -1,12 +1,13 @@
 Linux Networking Documentation
 ==============================
 
+Refer to :ref:`netdev-FAQ` for a guide on netdev development process specifics.
+
 Contents:
 
 .. toctree::
    :maxdepth: 2
 
-   netdev-FAQ
    af_xdp
    bareudp
    batman-adv
diff --git a/Documentation/process/maintainer-handbooks.rst b/Documentation/process/maintainer-handbooks.rst
index 6af1abb0da48..d783060b4cc6 100644
--- a/Documentation/process/maintainer-handbooks.rst
+++ b/Documentation/process/maintainer-handbooks.rst
@@ -16,3 +16,4 @@ which is supplementary to the general development process handbook
    :maxdepth: 2
 
    maintainer-tip
+   maintainer-netdev
diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/process/maintainer-netdev.rst
similarity index 100%
rename from Documentation/networking/netdev-FAQ.rst
rename to Documentation/process/maintainer-netdev.rst
diff --git a/MAINTAINERS b/MAINTAINERS
index d91f6c6e3d3b..00dd58fc8bf3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13661,6 +13661,7 @@ B:	mailto:netdev@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
 F:	Documentation/networking/
+F:	Documentation/process/maintainer-netdev.rst
 F:	include/linux/in.h
 F:	include/linux/net.h
 F:	include/linux/netdevice.h
-- 
2.34.1

