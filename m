Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02C8284E94
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 17:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgJFPEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 11:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgJFPEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 11:04:32 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 880ED20782;
        Tue,  6 Oct 2020 15:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601996671;
        bh=QEbxuOxO0ka+aqSAoio3aGDy6KoqJwUNWi8jz7K8uDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nDToluxV3iImsDYVKnXIqkVlUkXpOodRHlcDry5xgt209fl3iVfSTizehPCI9kuci
         k8TZPMYuKchqvi6wvrm6rVd/Yafnls7v1bRV11KXtDpwvCr4I1b42lmb+QYJnLd45K
         G9VKeiKQu6+PlNocf8sRicIYixOMpJTU8vlXhMxk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next v2 1/6] update UAPI header copies
Date:   Tue,  6 Oct 2020 08:04:20 -0700
Message-Id: <20201006150425.2631432-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201006150425.2631432-1-kuba@kernel.org>
References: <20201006150425.2631432-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel commit 9faebeb2d800.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 uapi/linux/genetlink.h | 11 +++++++++++
 uapi/linux/netlink.h   |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/uapi/linux/genetlink.h b/uapi/linux/genetlink.h
index 7c6c390c48ee..9fa720ee87ae 100644
--- a/uapi/linux/genetlink.h
+++ b/uapi/linux/genetlink.h
@@ -64,6 +64,8 @@ enum {
 	CTRL_ATTR_OPS,
 	CTRL_ATTR_MCAST_GROUPS,
 	CTRL_ATTR_POLICY,
+	CTRL_ATTR_OP_POLICY,
+	CTRL_ATTR_OP,
 	__CTRL_ATTR_MAX,
 };
 
@@ -85,6 +87,15 @@ enum {
 	__CTRL_ATTR_MCAST_GRP_MAX,
 };
 
+enum {
+	CTRL_ATTR_POLICY_UNSPEC,
+	CTRL_ATTR_POLICY_DO,
+	CTRL_ATTR_POLICY_DUMP,
+
+	__CTRL_ATTR_POLICY_DUMP_MAX,
+	CTRL_ATTR_POLICY_DUMP_MAX = __CTRL_ATTR_POLICY_DUMP_MAX - 1
+};
+
 #define CTRL_ATTR_MCAST_GRP_MAX (__CTRL_ATTR_MCAST_GRP_MAX - 1)
 
 
diff --git a/uapi/linux/netlink.h b/uapi/linux/netlink.h
index 695c88e3c29d..f774920506b3 100644
--- a/uapi/linux/netlink.h
+++ b/uapi/linux/netlink.h
@@ -327,6 +327,7 @@ enum netlink_attribute_type {
  *	the index, if limited inside the nesting (U32)
  * @NL_POLICY_TYPE_ATTR_BITFIELD32_MASK: valid mask for the
  *	bitfield32 type (U32)
+ * @NL_POLICY_TYPE_ATTR_MASK: mask of valid bits for unsigned integers (U64)
  * @NL_POLICY_TYPE_ATTR_PAD: pad attribute for 64-bit alignment
  */
 enum netlink_policy_type_attr {
@@ -342,6 +343,7 @@ enum netlink_policy_type_attr {
 	NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE,
 	NL_POLICY_TYPE_ATTR_BITFIELD32_MASK,
 	NL_POLICY_TYPE_ATTR_PAD,
+	NL_POLICY_TYPE_ATTR_MASK,
 
 	/* keep last */
 	__NL_POLICY_TYPE_ATTR_MAX,
-- 
2.26.2

