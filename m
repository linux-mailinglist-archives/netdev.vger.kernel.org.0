Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 709715C484
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfGAUsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:48:47 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:33893 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbfGAUsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:48:46 -0400
Received: by mail-vk1-f201.google.com with SMTP id j5so3933212vkj.1
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 13:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bFfe9UYfTQADjR9AyiHnTtCwXNfUK/5CDZ1sDAGgDRw=;
        b=Q1fImz0yEfudVE17zVKhz9wdgOYxytn2+8LK7qGRJiNbhdyqAVsfRRzuoM6QyU+E8S
         lShWiLbSp6lVaqJ1Hz+9RNGc1utj3o6F3PYbbTJMCsn/jQCsRA9jXBIi6eQA5+kgtcDH
         XQJ73P1EM/T9N90qhoohyQK4jzjbioD5xZU4m42wBB4wbFAeiFqqnkrmXnfD+FZyqIEo
         X7KOoGv8nen3ACTEPe6SGV7IwrGz/RptDKL4yJONeYeRV0GTeoKFM9R7I3Wz8MBCw2bA
         n4RHzxgykpm2g3scQdfTm4T5G17WuzhWE/mcNQ7PVQKzRngpLx0uT59zjci63jOw5knN
         LVmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bFfe9UYfTQADjR9AyiHnTtCwXNfUK/5CDZ1sDAGgDRw=;
        b=i0m1OONRrreRwDrb8LOZ+GkcfKQGdpcQn+fL4dVR/tAt/fXoZOQiq3A6O6mOFJm+jm
         7QQgLnJsmtdSN9Vi+/453lJJwEuQ0HtBmmzMJRDS1rExVQ0KGQJ+qQkA58APYMsv5w+z
         C1vYjbj6c5Dc8KT0JrZRWKWbfG+PyX9ARTX1+cFx/7IZeXOcuhFilbqm/dIiWLOr96MI
         uFckBIMtvdOUI+zWbAz54qrHQFZiWjSqNn9+ZBO/P1//EU4e456vaDUvOpVZ3rMUnqY5
         hjFUnGVFFJViEpAxai8OgJnqETmCsMBzaGHAKWpf7/9RbSw4f9h0YLRfV5UlZED4QxQd
         51qg==
X-Gm-Message-State: APjAAAXTr1wx9+/EYJCb5U51VMnoFYDL2CxDeyhxPVmnUt189wfkrXnE
        2u4c5nxMmdvVhbsCUDeIeOh9zfA+cONa6TnT4NhtUxjjnr3xqY0uoVtBnZM91J0amOvPrT2ay2Q
        xuCn4oQU8IVywFVaekI7UoBLStWaVvo2RUFXshs1ec1p7UoQtnTd8Qg==
X-Google-Smtp-Source: APXvYqx3oet41HXYS45yolXBP3ohs5z/gCMJpvJVjsAvmH2hVBiJqmwzGUal011CmRM8CSi4VuDSivs=
X-Received: by 2002:a67:ce97:: with SMTP id c23mr15937336vse.78.1562014124757;
 Mon, 01 Jul 2019 13:48:44 -0700 (PDT)
Date:   Mon,  1 Jul 2019 13:48:21 -0700
In-Reply-To: <20190701204821.44230-1-sdf@google.com>
Message-Id: <20190701204821.44230-9-sdf@google.com>
Mime-Version: 1.0
References: <20190701204821.44230-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next 8/8] samples/bpf: fix tcp_bpf.readme detach command
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Copy-paste, should be detach, not attach.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 samples/bpf/tcp_bpf.readme | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/tcp_bpf.readme b/samples/bpf/tcp_bpf.readme
index fee746621aec..78e247f62108 100644
--- a/samples/bpf/tcp_bpf.readme
+++ b/samples/bpf/tcp_bpf.readme
@@ -25,4 +25,4 @@ attached to the cgroupv2).
 
 To remove (unattach) a socket_ops BPF program from a cgroupv2:
 
-  bpftool cgroup attach /tmp/cgroupv2/foo sock_ops pinned /sys/fs/bpf/tcp_prog
+  bpftool cgroup detach /tmp/cgroupv2/foo sock_ops pinned /sys/fs/bpf/tcp_prog
-- 
2.22.0.410.gd8fdbe21b5-goog

