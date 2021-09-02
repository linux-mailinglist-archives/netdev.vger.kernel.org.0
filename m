Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5E03FED0F
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 13:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343551AbhIBLjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 07:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhIBLjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 07:39:04 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508B4C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 04:38:06 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 79-20020a1c0452000000b002e6cf79e572so1195713wme.1
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 04:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e0ZUxXvD6hqk9m36GfxMe8lgd3kciqiedHXuee2V6lQ=;
        b=h7zzcuLK74MHAMNT4KvYyOhY3GdRIDl4cUeYCvPzZVeQAuVzHxEd+szh/dSuE/0gxB
         xpJnFfu4ImI62NX+VRuvObkcIZLWQ4ig52D1sYYJYJEJiX/4/8oKgmzdEN1t3jcz/cnH
         XFhGIgdrvwblh0Jq5YJ+tlq5+lr3cFUtPyLRy1V4nf20QNne2NnF6bpSPGr9K3bildbJ
         6BL6ZrsoutkUYgwctvBXTdbsC7EXAs/HYsW3arNT1qVSAcpUUgd60I0A8+8/F+1iZvn+
         DckSqKP5iWDggFNFh10qhkkpk0NA1kgKzBU3kxBf6aOCritFpn6O8cqhcOACQHnDbax+
         LntA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e0ZUxXvD6hqk9m36GfxMe8lgd3kciqiedHXuee2V6lQ=;
        b=ezWLjN0MT12Fr6khVbT8hM5aHQBorCfhxvVd8R5hyhHoeJgSX1THbptZkB6tNK4a3E
         /G+YsDOQzTMZIvYd0/QMXcp3+lwiF79zHUE+v9ssixAd322TVgJpQgZ8bWSCUHPmsfJe
         kVksn7LAi2Xapa/3bCYS8Mn35+ogKpRk4bcm/Vw+/6zPmdLc40QdKZKJGtkK3WzC3ZhK
         4dSt4f4C/2vKuMOvpnSC6q2ICNnmQf1a9X3Bt65bqHJTWnnpMwzsEJbES+xGene+rIMj
         0BARjq4a1Z9R2FZIY+sogKZxS94Q4oUf6K1uug7XLguiX+PyV8FLGKlqbEPJouf/YWhm
         A05Q==
X-Gm-Message-State: AOAM532o77dUBAME1RMTWLktZ4FYZU5ds7lb3M05DYJY6LYPI7ZIiSkO
        baTZPYXb44z2rQsak7DUERBXYYPLKu7gqA==
X-Google-Smtp-Source: ABdhPJzaGPYQoYZIq+hi8hmwTiCh6SXnsqkEOp8n7UpVQICbvim5a9enqo8YyHa3lmHXHOoDt+LFrQ==
X-Received: by 2002:a05:600c:3641:: with SMTP id y1mr2586051wmq.43.1630582684429;
        Thu, 02 Sep 2021 04:38:04 -0700 (PDT)
Received: from localhost ([2a01:4b00:f41a:3600:df86:cebc:8870:2184])
        by smtp.gmail.com with ESMTPSA id g1sm1577622wrc.65.2021.09.02.04.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 04:38:04 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2] tree-wide: fix some typos found by Lintian
Date:   Thu,  2 Sep 2021 12:37:36 +0100
Message-Id: <20210902113736.35407-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Boccassi <bluca@debian.org>

Signed-off-by: Luca Boccassi <bluca@debian.org>
---
 man/man8/devlink-port.8 | 2 +-
 man/man8/ip-link.8.in   | 2 +-
 man/man8/tc-u32.8       | 2 +-
 tc/q_netem.c            | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index 12ccc47e..147c8e27 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -160,7 +160,7 @@ Is an alias for
 .PP
 .B "DEV/PORT_INDEX"
 - specifies the devlink port index to use for the requested new port.
-This is optional. When ommited, driver allocates unique port index.
+This is optional. When omitted, driver allocates unique port index.
 
 .TP
 .BR flavour " { " pcipf " | " pcisf " } "
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 572bed87..1a3216e0 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -2515,7 +2515,7 @@ specifies the master device which enslaves devices to show.
 .TP
 .BI vrf " NAME "
 .I NAME
-speficies the VRF which enslaves devices to show.
+specifies the VRF which enslaves devices to show.
 
 .TP
 .BI type " TYPE "
diff --git a/man/man8/tc-u32.8 b/man/man8/tc-u32.8
index a23a1846..fec9af7f 100644
--- a/man/man8/tc-u32.8
+++ b/man/man8/tc-u32.8
@@ -286,7 +286,7 @@ though inverses this behaviour: the offset is applied always, and
 will fall back to zero.
 .TP
 .BI hashkey " HASHKEY"
-Spefify what packet data to use to calculate a hash key for bucket lookup. The
+Specify what packet data to use to calculate a hash key for bucket lookup. The
 kernel adjusts the value according to the hash table's size. For this to work,
 the option
 .B link
diff --git a/tc/q_netem.c b/tc/q_netem.c
index d93e1c73..2e5a46ab 100644
--- a/tc/q_netem.c
+++ b/tc/q_netem.c
@@ -267,7 +267,7 @@ static int netem_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 					NEXT_ARG();
 					++present[TCA_NETEM_CORR];
 					if (get_percent(&cor.loss_corr, *argv)) {
-						explain1("loss correllation");
+						explain1("loss correlation");
 						return -1;
 					}
 				}
-- 
2.33.0

