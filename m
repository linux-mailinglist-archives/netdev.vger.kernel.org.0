Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3DA45D40F
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfGBQO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:14:28 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:37340 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbfGBQO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:14:28 -0400
Received: by mail-pf1-f201.google.com with SMTP id x18so11122081pfj.4
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 09:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qE7suO2UFdUOl1bpnieLTUEEVsWprC362QKm2f24m1I=;
        b=XiQtO1DME3wcd5SCB4YdN1LYplzMNGMSuGLeXa2eYVb9gQ5OHo2Vi/R6oJr7RstZH+
         oq+fuQHJlGp6dowSzFHdU5ndkxOjHcH37fw2yJC+uQJjPr/1OKtYVdbdSryE8yhFqOKr
         HzJLgjEjekbpC9ghDnwJcJMxQm1LCyBak0cnXbYI/Znray5/Q4FyKtrAfg7wMyixW4PG
         qCgHPbDNXAA7WGF+LT1nJ/LSDF33vLsRxOAPPpUzG1TrPNi59SdEavxo+EZqV6IESgHx
         vQ8TWq9sQRyzGVeJCm5R/8n5fqlGg0ob9BlZAWDpbPltrmboYvdC7z3RxWrf+C+B8Vm+
         Vlyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qE7suO2UFdUOl1bpnieLTUEEVsWprC362QKm2f24m1I=;
        b=BVP+EsT6fkIhR3tttSWd2BynapTcDr4WeRn/hJZRX1syc1CbTsAWFy2+dA4nKJ0asf
         /czY8wjdyaHUVa6DGNFABsRa6PpTyFCOriNmgNSzDQD7mfqGeqKbhMl7rod9lcR2DQwg
         Pvx9VMpTV92AYBXYlUpFVI+vqw5K6YcUQTjqwpNxIUDIHzDUOUbecf84wqUhfOxjT8BX
         qJum8+HvXP5xPzCEJqskp8Ckp8A3nUaLu68vKZOQ98ij3g3ycIC5G5A6+1POV+ey9cIF
         R+T3uOQyMUTPNZq0Q0UKEFFX2DYtwvW4dXdjwZJW4mTfWolK8KdA+QhATv5QP4/qr5/7
         9sVA==
X-Gm-Message-State: APjAAAWE2PqGIOUGMXHxm2JQZluOvFM+cjBLFJgp10PdPacuwDVi6q6s
        k5dwA8DlqWpBTbGRFebnFjafmyfi7tC8uYdtIJZTSKPQzA5kiy9GEAEF3o69BwzRH1ZVTLqd55P
        BvRdLCF32yWmdncefrqA7ZTnbVusAprXlhe5w46Y8UYU7KYDowHs2tQ==
X-Google-Smtp-Source: APXvYqwznCVcMsVuucOGPPCknJOX6GBJT2rd+FNqfh4ENBG7v6QZ/GecD3M22ouChVCv0SvTVNexja8=
X-Received: by 2002:a63:490a:: with SMTP id w10mr30955818pga.6.1562084066857;
 Tue, 02 Jul 2019 09:14:26 -0700 (PDT)
Date:   Tue,  2 Jul 2019 09:14:03 -0700
In-Reply-To: <20190702161403.191066-1-sdf@google.com>
Message-Id: <20190702161403.191066-9-sdf@google.com>
Mime-Version: 1.0
References: <20190702161403.191066-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v2 8/8] samples/bpf: fix tcp_bpf.readme detach command
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Copy-paste, should be detach, not attach.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
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

