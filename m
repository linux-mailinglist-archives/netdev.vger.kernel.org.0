Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE63B42BBA
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730220AbfFLQDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:03:53 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60559 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727111AbfFLQDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:03:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B8C7E220F4;
        Wed, 12 Jun 2019 12:03:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 12 Jun 2019 12:03:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=A1j1bAJmy08T5h2IJCNTSQiFw3SBRP+6L7SLEibO1rY=; b=I19GNgrC
        3nv5kO9SRVZVa58r1PUz4vKlCHR0XvyEofwR92jnkFqUhLcKR6J0f9aOn4ABHWCn
        25IT1UE+Mt3WVaMC9IGDMP9xNTlIY5hUwT6BxQoY6fD6nn43Olvx2EanY/u3sw2F
        gjvMIChv6Afeg0Oqf/wM/W4BRwKHQMEVl16xBQMfSUnf+pneWeALSGbEU0bSHskz
        NAhF3yqd9jHRYLIcYYiR0tErIiSIJP8QJznoJVBYqNhppBym+Vnm+j87VSxZCwHV
        eo39/Bk+n/5xpACei7iWdqqr1petfb0958XeE2pLEUnDVJy6r6x9MQMH0jErMAiY
        zwDp69PLakA/oQ==
X-ME-Sender: <xms:aCIBXfOgKGquzIE5Q3RPrHRJxgYOWU39ocbj8LnWNSpBKWc4O1hNkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehjedguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeforghrthihnhgrshcurfhumhhpuhhtihhsuceomheslhgr
    mhgsuggrrdhltheqnecukfhppeefuddrudeigedruddvuddrfedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehmsehlrghmsggurgdrlhhtnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:aCIBXePOD2_cDON9NhglbJg3jQZLcmTmDtWzsBxmsFcv1Owvu5v_kg>
    <xmx:aCIBXZT1idIFgj00CfWLfLsDQz06c_pb2Xv4PYhrFoMRuzc-F8sRqg>
    <xmx:aCIBXYCRz2LODBI2NwaXlT_V6uXHAxJ6kmaVSEnVpRDtNpI_MfYYNQ>
    <xmx:aCIBXc_FW8VItjxq89px6Yrswokl088UHMpjRaTgS9XJ6O6oDHvgqg>
Received: from localhost.localdomain (xdsl-31-164-121-32.adslplus.ch [31.164.121.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id A718638008C;
        Wed, 12 Jun 2019 12:03:51 -0400 (EDT)
From:   Martynas Pumputis <m@lambda.lt>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        m@lambda.lt
Subject: [PATCH bpf v2 2/2] bpf: sync BPF_FIB_LOOKUP flag changes with BPF uapi
Date:   Wed, 12 Jun 2019 18:05:41 +0200
Message-Id: <20190612160541.2550-2-m@lambda.lt>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612160541.2550-1-m@lambda.lt>
References: <20190612160541.2550-1-m@lambda.lt>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync the changes to the flags made in "bpf: simplify definition of
BPF_FIB_LOOKUP related flags" with the BPF uapi headers.

Doing in a separate commit to ease syncing of github/libbpf.

Signed-off-by: Martynas Pumputis <m@lambda.lt>
---
 tools/include/uapi/linux/bpf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 63e0cf66f01a..a8f17bc86732 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3376,8 +3376,8 @@ struct bpf_raw_tracepoint_args {
 /* DIRECT:  Skip the FIB rules and go to FIB table associated with device
  * OUTPUT:  Do lookup from egress perspective; default is ingress
  */
-#define BPF_FIB_LOOKUP_DIRECT  BIT(0)
-#define BPF_FIB_LOOKUP_OUTPUT  BIT(1)
+#define BPF_FIB_LOOKUP_DIRECT  (1U << 0)
+#define BPF_FIB_LOOKUP_OUTPUT  (1U << 1)
 
 enum {
 	BPF_FIB_LKUP_RET_SUCCESS,      /* lookup successful */
-- 
2.21.0

