Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F3A3424B7
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 19:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhCSSdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 14:33:37 -0400
Received: from mga03.intel.com ([134.134.136.65]:62028 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230218AbhCSSdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 14:33:11 -0400
IronPort-SDR: yTAApO39FOwqwogHa8cCAxNJozxqVykw25zSD2JDetHxunOkk+oskrtB028y13ZRz5p+e2h+2c
 Iyshd74ON/fA==
X-IronPort-AV: E=McAfee;i="6000,8403,9928"; a="189982780"
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="189982780"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 11:33:11 -0700
IronPort-SDR: S+RcAbZkdeBj49InRuqX0h8mJj0AF8mD2ivOcPb8a/RHF55gLEB3Re4NkDsfiOCVEqX0vV3xBR
 pD+qPSjBK6TQ==
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="406900676"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.255.228.188])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 11:33:10 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org,
        mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net] mptcp: Change mailing list address
Date:   Fri, 19 Mar 2021 11:33:02 -0700
Message-Id: <20210319183302.137063-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mailing list for MPTCP maintenance has moved to the
kernel.org-supported mptcp@lists.linux.dev address.

Complete, combined archives for both lists are now hosted at
https://lore.kernel.org/mptcp

Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0d80d3dda3d0..8e43e0417335 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12539,7 +12539,7 @@ NETWORKING [MPTCP]
 M:	Mat Martineau <mathew.j.martineau@linux.intel.com>
 M:	Matthieu Baerts <matthieu.baerts@tessares.net>
 L:	netdev@vger.kernel.org
-L:	mptcp@lists.01.org
+L:	mptcp@lists.linux.dev
 S:	Maintained
 W:	https://github.com/multipath-tcp/mptcp_net-next/wiki
 B:	https://github.com/multipath-tcp/mptcp_net-next/issues

base-commit: c79a707072fe3fea0e3c92edee6ca85c1e53c29f
-- 
2.31.0

