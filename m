Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9523D75DE
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236651AbhG0NTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236693AbhG0NSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:41 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEECC06179C;
        Tue, 27 Jul 2021 06:18:37 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e2so15195327wrq.6;
        Tue, 27 Jul 2021 06:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O/vijVvlYRSC+JIeeAJkhVE0OT/VuNtm6dOkqerrQk4=;
        b=R51KU4ZEW0F2Nbkip6wnfpQAIAPUTJhyqDTHIDm1fm9SgO8PvRvi7/n4xY44eGRyrU
         K6Bm/Kyk96ERW5Ye1chQUA8IOMyqqybDCJ5psUMVjGygCy7T4IXm1goFoudTyGsPK39/
         ZjqAFoHM8oqtd4Neptu2rDWeJ9LdkOVNiUd6sa6kyKK9PcgP4m7OLQlUYYVZP801Spzt
         P8W1QPYmAols7wqbBpABScTVPPYW/vZWqQNjcHtZn4ozUhGh9fNR5VQJ0mM063XUTguS
         6LQteQ9d/pzFnZfllNDW1WnzihJVMBn0PDNIhaNBcF7w25u8gQgeQ09LjjKk0avOsWJP
         SehQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O/vijVvlYRSC+JIeeAJkhVE0OT/VuNtm6dOkqerrQk4=;
        b=WS4WJmP2X+Kczjm+bjS2f5puJv7R++ywBj1E3BS73RwXpiDS9wMvqzbPZxbtiEgS5T
         o16wjx9RKuxobGEeghBti7stDbAJSMGCsAd5VAwbLbCOWNnqXvB+xH+Yhrqs9MxmlJBv
         o37MprgtiZ/3nKRw2QbEb8eIl7niuizJQuk1S+RuKCE4WghpYtOoeIjDYl+RcUjHM8Tq
         Oxf2/wmTvpFFExPWCDJZwzs1vC2VGaqwoOv5RGgDq6iOxJb2V53HYUNjbBjgIm3lFIUL
         +Sj7eExc5VkCX/AGA8mdt/fAiCqrA1uxN+32iWCDK0nfKxLV3kQaW1vCQxhoKMzKR5MQ
         vGwg==
X-Gm-Message-State: AOAM530eIlzHYVkSAzzO2ZdPKoMwqSBNhnzBKW0Ph5e3KnnM3hB1VVEF
        WL4fg5Vse5b5zGivQsS8A4I=
X-Google-Smtp-Source: ABdhPJyk/y9tp0T4iiKRCejsONe17PBdjyL0eooFsm9cqjDdoD4HG+RJRyX4Ai9oV+QZdMs61NvZMA==
X-Received: by 2002:adf:c3c4:: with SMTP id d4mr14675641wrg.27.1627391915967;
        Tue, 27 Jul 2021 06:18:35 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:35 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 17/17] selftests: xsk: preface options with opt
Date:   Tue, 27 Jul 2021 15:17:53 +0200
Message-Id: <20210727131753.10924-18-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Preface all options with opt_ and make them booleans.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 6 +++---
 tools/testing/selftests/bpf/xdpxceiver.h | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index f0616200d5b5..d40c4d9c5061 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -400,10 +400,10 @@ static void parse_command_line(int argc, char **argv)
 			interface_index++;
 			break;
 		case 'D':
-			debug_pkt_dump = 1;
+			opt_pkt_dump = true;
 			break;
 		case 'v':
-			opt_verbose = 1;
+			opt_verbose = true;
 			break;
 		default:
 			usage(basename(argv[0]));
@@ -510,7 +510,7 @@ static bool pkt_validate(struct pkt *pkt, void *buffer, const struct xdp_desc *d
 	if (iphdr->version == IP_PKT_VER && iphdr->tos == IP_PKT_TOS) {
 		u32 seqnum = ntohl(*((u32 *)(data + PKT_HDR_SIZE)));
 
-		if (debug_pkt_dump && test_type != TEST_TYPE_STATS)
+		if (opt_pkt_dump && test_type != TEST_TYPE_STATS)
 			pkt_dump(data, PKT_SIZE);
 
 		if (pkt->len != desc->len) {
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 309a580fd1c5..664b74ac2233 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -68,12 +68,12 @@ enum stat_test_type {
 };
 
 static int configured_mode;
-static u8 debug_pkt_dump;
+static bool opt_pkt_dump;
 static u32 num_frames = DEFAULT_PKT_CNT / 4;
 static bool second_step;
 static int test_type;
 
-static u8 opt_verbose;
+static bool opt_verbose;
 
 static u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static u32 xdp_bind_flags = XDP_USE_NEED_WAKEUP | XDP_COPY;
-- 
2.29.0

