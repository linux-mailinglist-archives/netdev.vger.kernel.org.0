Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC59C38C46
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 16:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbfFGOLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 10:11:18 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40096 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729458AbfFGOLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 10:11:15 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so2085688eds.7
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 07:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xp4rSZI5WhV+6Sat4AULJy3MtrPBifsfu9gUED/8PtM=;
        b=j5fa4Xr7EV3n7eHh1YEh37F4gLNUjhYvDUz4lIuHeMDiEgRSAkv6SQOiAxlkqObRJs
         jPFxqQI4VqeibG3Mb/hOzrk2jSsXV46nL/yVFNtre5PROvxr3dwiMwLpacpOipTz70EQ
         IMFUGoSJBNeL82mmABWec4P0UZrCcMTylCJSI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xp4rSZI5WhV+6Sat4AULJy3MtrPBifsfu9gUED/8PtM=;
        b=eNSKqOTriXINMNlqKXGy8gdbTU6fFMJyUroIgXZGyadzCUYmIMNUeA+/8oTH1oQ9jZ
         dZ5/57eZdxk6DnZhY7Ppquizjzs1Fl4e2wub4qIjKpfORoXtySTZuHe0+tIupdGNTa9i
         /oh1oqI63mS6bo3F1G/FDxqrj6k2mKdHQAzdFJWB1SDhQM/i4qw3v7UHWX3jsRcGUAUj
         mlbgE6YG8f1aTiDETrHZpkSRBxZtn6mqcaA5DrD/595/Mq5JpQQss/CtlasutkXf+soy
         tAiXRefZmJLnnCof61sZIVlwPjt0/Hf5vfjYoGzbIvJTOgrYhV1mQCrzYWnIL+Xv2Iqr
         wDVQ==
X-Gm-Message-State: APjAAAVZJZcVm31NRIgQcIBf7ERUfXn2kFtiIPhF6iFzeIdJdjQGo9fI
        HLNbIRJJWHntyBTV1LalztT2gw==
X-Google-Smtp-Source: APXvYqy8+1YsywtSTa+c9W9VfssePeLtB7JQ8mgPOuXAxMPPEaW6jzftMhXPMHpXDCzCrK7FZDDhzw==
X-Received: by 2002:a50:ec8e:: with SMTP id e14mr17918728edr.153.1559916673628;
        Fri, 07 Jun 2019 07:11:13 -0700 (PDT)
Received: from locke-xps13.fritz.box (dslb-002-205-069-198.002.205.pools.vodafone-ip.de. [2.205.69.198])
        by smtp.gmail.com with ESMTPSA id a40sm546116edd.1.2019.06.07.07.11.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 07:11:13 -0700 (PDT)
From:   =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>
To:     john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net
Cc:     alban@kinvolk.io, krzesimir@kinvolk.io, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v5 2/4] bpf: sync bpf.h to tools/ for bpf_sock_ops->netns*
Date:   Fri,  7 Jun 2019 16:11:04 +0200
Message-Id: <20190607141106.32148-3-iago@kinvolk.io>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607141106.32148-1-iago@kinvolk.io>
References: <20190607141106.32148-1-iago@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alban Crequy <alban@kinvolk.io>

The change in struct bpf_sock_ops is synchronised
from: include/uapi/linux/bpf.h
to: tools/include/uapi/linux/bpf.h

Signed-off-by: Alban Crequy <alban@kinvolk.io>

---

Changes since v2:
- standalone patch for the sync (requested by Y Song)

Changes since v4:
- add netns_dev comment on uapi header (review from Y Song)
---
 tools/include/uapi/linux/bpf.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 63e0cf66f01a..41f54ac3db95 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3261,6 +3261,12 @@ struct bpf_sock_ops {
 	__u32 sk_txhash;
 	__u64 bytes_received;
 	__u64 bytes_acked;
+	/*
+	 * netns_dev might be zero if there's an error getting it
+	 * when loading the BPF program. This is very unlikely.
+	 */
+	__u64 netns_dev;
+	__u64 netns_ino;
 };
 
 /* Definitions for bpf_sock_ops_cb_flags */
-- 
2.21.0

