Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5183A8DC08
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbfHNRiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:38:04 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:34059 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728600AbfHNRiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:38:03 -0400
Received: by mail-qt1-f202.google.com with SMTP id i1so4920094qtm.1
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 10:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=80gVs8IzWGoGeL5TQc1siGuhLRsZ2VKQxE10IPj1Irs=;
        b=Q1bioI/n+qQcRZew1C8g0VJqGvV5n9pgtuUy6trAUYjnHmvSrOtv1BC0gRwtv3cIYN
         qXy3mNfP95c6J2AAmospsrxq6/YW+sZwiWl9rUqgdoxAITU7hknQQVPj4YFyLfSDDB8U
         x3kQhiAa8FnI33t9USybZgIsKakb7nP3SblL54Aieh53ARev4PKL1STrgK89hAbrxumo
         g6HCpN67+bDmvrgrEYokOsbcXIMvg5zMYUxscI6MCSfnJdUJPJXDUbRg7ovVpCZgRhZO
         PrpEl0heiaThkGfdvC8vekhSgu3wHH0lZxnaw7WybIVUervtdn0g3UVfxxyekEyydTgp
         l8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=80gVs8IzWGoGeL5TQc1siGuhLRsZ2VKQxE10IPj1Irs=;
        b=Yy9CjcWpn6GiaHfA7V/R1Q9/Iy2wwT5XaDK221ogxHgNgrwjkkEumSRY2kbVSWt8dT
         lJP4/7LrfiEDSWLh1ZUHes5sKB8UG+JA92F46bclBHN0RZ9iIw+xu+Og6NAq4FcIo22n
         N2yA88fuh+UfdwRl9w+RtSDK7RdtNADG5P+/Bc7/rq2qgHX+VYN4yv5hpba7a7Mqqmjt
         NI2LYk9yMK+1w74oLIZml+e48xE3Rl6/mH2ACos4dze4CZ6DGaasHxXnnflEjmkbcvka
         6N8x70MMI4JcKlhRh4yCuX5Pm6pmzt9w0fE3S+l9rljId93nKlo6SyGyRK41LDzsVUqZ
         /l5Q==
X-Gm-Message-State: APjAAAUlt6TYyrqJsaH+R+hVLyE5lOH+PsfD4KnULr5nE+AhEahWMcxC
        9vNTFyyq2XgEGWpa8fcIHBPZqkcfZp50/OQ5SWUtpF44lRvgrhumS9mhtKFOltLFWw+3CRRI863
        y7TC7i6oWlgFDpWZWk72YJ1cYB/Klb3WOh8OqIgvjICltma71Qw7d3g==
X-Google-Smtp-Source: APXvYqzM7C2qcyJEskTtqWiuXOTMK3bdPyK7ataW8vGHhJkDbLNYXvf5f+x6KUGryz2W6YLKW13zzo4=
X-Received: by 2002:a37:ac19:: with SMTP id e25mr551488qkm.155.1565804282786;
 Wed, 14 Aug 2019 10:38:02 -0700 (PDT)
Date:   Wed, 14 Aug 2019 10:37:50 -0700
In-Reply-To: <20190814173751.31806-1-sdf@google.com>
Message-Id: <20190814173751.31806-4-sdf@google.com>
Mime-Version: 1.0
References: <20190814173751.31806-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next v4 3/4] bpf: sync bpf.h to tools/
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync new sk storage clone flag.

Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4393bd4b2419..0ef594ac3899 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -337,6 +337,9 @@ enum bpf_attach_type {
 #define BPF_F_RDONLY_PROG	(1U << 7)
 #define BPF_F_WRONLY_PROG	(1U << 8)
 
+/* Clone map from listener for newly accepted socket */
+#define BPF_F_CLONE		(1U << 9)
+
 /* flags for BPF_PROG_QUERY */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
 
-- 
2.23.0.rc1.153.gdeed80330f-goog

