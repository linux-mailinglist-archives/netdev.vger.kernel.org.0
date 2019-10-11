Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF0DD4546
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 18:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbfJKQVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 12:21:30 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:35088 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728213AbfJKQVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 12:21:30 -0400
Received: by mail-pf1-f202.google.com with SMTP id r7so7864954pfg.2
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 09:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KDZVxGGvtoUTk1RqaetpoYQq+Ui+ut5COCWag7pw9rs=;
        b=DRaWA1Es/TQ8MVC3DtaBGIaen9YrP/2hLr9y9MZxWp8SXEdVYr5u4cdb6TJ3Hix2zS
         bkfcW2q4LSTdI+uT+AAGvBNP0JndC/SqeVQ06d9DwH16mIJGMFUFwdm5RdrF50Glhdm+
         a3wkCKWdFktlB7XTIpCAu87NNT0qivmeXhH46m69IXRNmfJCRjVg+/ReQ7t4JgZhZu9E
         Fe9B68y/+3fKC54rEgj68JFPjR+Q1YALQTfmGuUBopPBBXGTvUnr4a8Zkyte8lZNJxpf
         U7hY8rYRGi3MlTs2t/lKe+WWt9yQe4goE706HRX8NZgMZgZDsOpXiEKumLwhCWdQgABf
         0qFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KDZVxGGvtoUTk1RqaetpoYQq+Ui+ut5COCWag7pw9rs=;
        b=RH6rU34E8yP9Y6yqtI/zs+t4SM8D8iS9BcRu5DA533frGLO3ukveMb/S16TaHC00sG
         Py26sQ+6jmqzQfM9e5Xc+vFNt5N2KzVsPdXv2NI+hD8PGLtRkgAWJpXlIJywwmAqDgQ1
         VCYDS7FWrgWrZhyTko6LCzG1CpZGflqUb/4S9B8DT5ALjICmBcegwVYZecHWrQb8xDxn
         gtjG9V2UqlYHXNalvfcUzavnICCpB+6OcXfvPW4EdTvuAUzZ1K5hCnwqbGvUrng1V9gN
         fcxVmCXbluVYF+Nj9GryxXrkeDGdoUBO5zveihU/COxmyl2iqyCoYev6xn6IhR299VXk
         No/w==
X-Gm-Message-State: APjAAAXWbvxGgWHc1G51QRFBdXPyFhRKPefbXeEEv4OtQNw2TR/3zwJh
        RXnOHL+sOTjTjwP1SqIkTZGaMunaV6WZdqRgPp0LRRHxaRxmowZxI3tYe71Byy4CvjeOzjLYoO/
        qhpl7bSFMuLx+HD744DQZpF4tC097AvQ3Hz3m1pSKW8IUY6xX0SdtCA==
X-Google-Smtp-Source: APXvYqxjQ1ZelYEyr7jRyX7StJ5karSIgWLxQNUdmm4yZKlp0cBxP1qTlJcBEuygrfv3aTUR+9WvFyo=
X-Received: by 2002:a63:d450:: with SMTP id i16mr17496713pgj.126.1570810888835;
 Fri, 11 Oct 2019 09:21:28 -0700 (PDT)
Date:   Fri, 11 Oct 2019 09:21:23 -0700
In-Reply-To: <20191011162124.52982-1-sdf@google.com>
Message-Id: <20191011162124.52982-2-sdf@google.com>
Mime-Version: 1.0
References: <20191011162124.52982-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH bpf-next 2/3] tools/bpf: sync bpf.h
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add created_by_comm.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a65c3b0c6935..4e883ecbba1e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -326,6 +326,7 @@ enum bpf_attach_type {
 #define BPF_F_NUMA_NODE		(1U << 2)
 
 #define BPF_OBJ_NAME_LEN 16U
+#define BPF_CREATED_COMM_LEN	16U
 
 /* Flags for accessing BPF object from syscall side. */
 #define BPF_F_RDONLY		(1U << 3)
@@ -3252,6 +3253,7 @@ struct bpf_prog_info {
 	__aligned_u64 prog_tags;
 	__u64 run_time_ns;
 	__u64 run_cnt;
+	char created_by_comm[BPF_CREATED_COMM_LEN];
 } __attribute__((aligned(8)));
 
 struct bpf_map_info {
-- 
2.23.0.700.g56cf767bdb-goog

