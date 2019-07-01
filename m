Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17705C21A
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfGARiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:38:50 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:54041 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbfGARiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:38:50 -0400
Received: by mail-pf1-f201.google.com with SMTP id y5so9199931pfb.20
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 10:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rqxRKWNEo1osvaBkv3/KPbZBsws5mfNzEZoyqO4E7N0=;
        b=uEd08RMuRZkIcdgl/k7/xWDXggSB7BIAEHoCC54LmnZryPZbzhb0qGfkQYyeEF9HwZ
         AMqishzIroKm5Q6ZnbjDIabRPPx8VE+JMMTWLGMz07nrO8urswHBugHWM3Av2/Kc0d+D
         M9/bVmFXXreaEKJe93mL8fUF+OaQcrCt508Zabl3UqWmQZbOJ5tgSZJLvqZFhPzlButD
         1Pp4NsOtM3SYwPEd3Qgx7ioQGJzBAEJ9iX9XZr6Dvr3xVf71k7+4WMk8yuylaVRTQDP8
         ErsSFS8WXPnWAy4r0G3HWfrcbSG52CuRhyx5fxEa9AoC7Fak0lTthHifpZpvLDYQ7eIF
         T8Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rqxRKWNEo1osvaBkv3/KPbZBsws5mfNzEZoyqO4E7N0=;
        b=q6pwi884jHunQNy8nENotCpwQz68SZjp2es+TzuIrddkX/24PYgMeKe4fxj1n7KKO/
         1CYsJ2TZwEaSU2LFPtkCsTX0TuCA/lDYNR3Z0Xg8Il9WTHTYPp+O4K2Ax2Zvkws+HKmW
         Yggt6+WXusqYKTwrZoLidAu23nD61q/eEDL0ji3QUe37fmSWOttRXnMyqHZRX8jfzOrP
         FNMMXVvMBcwrlyp8RXhk4Kd86yoZioUkGcE06TR6aP7t7ILNdFgLGdr+zPuxqNrkq3zU
         Juu2eU0QzZmlE8azG8Zo0w+uac3Dbqb9AcHg3Y00GONIKvp2lAUZ3zCcBz+mvNEqksOo
         gZ1g==
X-Gm-Message-State: APjAAAWCwpQi4IkWGMqR1LdaLXZng/FolV05eEvQXbLBqFd39QTbC5M/
        goa+pDCPfHH2bEHEp84gimSopFuChazNcBCUbHcrWWLC98vz2VMA2hgqlkyKR+B+51n2bXTsqc8
        mlhy4ze2OsU1b2/POPyCUgNP+1U/rNO1lyxPN7fYIycuGkWUUl31LSA==
X-Google-Smtp-Source: APXvYqxqMd81L1DDmkwA3FYZGIcQqmw1s+00/5mYjsII7gtoJsELsfFIxiFV5KROBjQf3TfZe7iPhiw=
X-Received: by 2002:a65:5c0a:: with SMTP id u10mr26577468pgr.412.1562002729019;
 Mon, 01 Jul 2019 10:38:49 -0700 (PDT)
Date:   Mon,  1 Jul 2019 10:38:40 -0700
In-Reply-To: <20190701173841.32249-1-sdf@google.com>
Message-Id: <20190701173841.32249-3-sdf@google.com>
Mime-Version: 1.0
References: <20190701173841.32249-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v3 2/3] bpf: sync bpf.h to tools/
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync user_ip6 & msg_src_ip6 comments.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a396b516a2b2..c59dc921ce83 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3237,7 +3237,7 @@ struct bpf_sock_addr {
 	__u32 user_ip4;		/* Allows 1,2,4-byte read and 4-byte write.
 				 * Stored in network byte order.
 				 */
-	__u32 user_ip6[4];	/* Allows 1,2,4-byte read an 4-byte write.
+	__u32 user_ip6[4];	/* Allows 1,2,4-byte read and 4,8-byte write.
 				 * Stored in network byte order.
 				 */
 	__u32 user_port;	/* Allows 4-byte read and write.
@@ -3246,10 +3246,10 @@ struct bpf_sock_addr {
 	__u32 family;		/* Allows 4-byte read, but no write */
 	__u32 type;		/* Allows 4-byte read, but no write */
 	__u32 protocol;		/* Allows 4-byte read, but no write */
-	__u32 msg_src_ip4;	/* Allows 1,2,4-byte read an 4-byte write.
+	__u32 msg_src_ip4;	/* Allows 1,2,4-byte read and 4-byte write.
 				 * Stored in network byte order.
 				 */
-	__u32 msg_src_ip6[4];	/* Allows 1,2,4-byte read an 4-byte write.
+	__u32 msg_src_ip6[4];	/* Allows 1,2,4-byte read and 4,8-byte write.
 				 * Stored in network byte order.
 				 */
 	__bpf_md_ptr(struct bpf_sock *, sk);
-- 
2.22.0.410.gd8fdbe21b5-goog

