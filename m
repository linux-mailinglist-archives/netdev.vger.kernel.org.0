Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F61F2ACAAF
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbgKJBuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgKJBub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 20:50:31 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD442C0613CF;
        Mon,  9 Nov 2020 17:50:31 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id w4so8735915pgg.13;
        Mon, 09 Nov 2020 17:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZJO8kiqdiT8P323s/vesltT136758ur/kIE6FARH4tk=;
        b=bQ4kh53fib5uKBkYM1XXkknE51ND5qzKJEozbol6Q6D8tfiB62EsuZXDxinFXjoE0W
         Jgc4rZLzbhe+mNje1lK4y/O160vaZSUlS8aY0I3dNPj1bhdQTcxWpDHMuNLDFlpkFlI7
         zuTzFDRRgohcfKaBhUcNlTK/XGiVzNQmX6uHRxFGTvCN/e585RlqzInjFj7ftv04RkXj
         TnNBJIPyMzvvg37ZekHFTMcY85D/cgusMaiFESlgpsxYlwRqt5mUOSm0PeFk3vhlDOLU
         bE6P7rM7odv2Oz1DdKG2XzptXOHMicYSErkqstI1Zs1jjwO9ahok3DKF/swbKdsD7Rc1
         oi2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZJO8kiqdiT8P323s/vesltT136758ur/kIE6FARH4tk=;
        b=VZMPcd6gm98xbs9nxRW4wz0y5bId7Spz08bW+aJDp2LUnHSwrt4YWzCVbWZM/JNVeQ
         uQoqYVdqVNq7xciPpW9dw/uL3HBDHdsIrVsj2p+U1okrri4bOHDX4vce8VgVilL69pgc
         0xMyowBaPa5I0UZvK2d2oPa8RwFw6mSarKkQFMA0OiTaG19FDHJ2e1aa7hdpwVxzn1jd
         Y1WnQuYIR1cm2YGqbP/2DDGrX4CztEQTeGrQ1YTNMe5sEu8kZGnn6ejczgfnTJEp7cOz
         H/LJIK+LESDztZGJrRPihq7r9egQlgxRLesm/2ky7JpuW0BNWF8x/6q49z24r85CrMBE
         WhrQ==
X-Gm-Message-State: AOAM5300TnqdovA+mtGpWoae4EIb/a0ZM2kAtKZlYodZ+AC5CH19Rtxd
        RfEwLgjvqzduRFz5ktIrKkYqyL+Ps1wwoQ==
X-Google-Smtp-Source: ABdhPJypgrBHsaYmtTemyMnh4bgkDxCkU/HZoLaA3SBn+dctgh/VUSMwa5yfa1XIPEVqjMRAY9XhjQ==
X-Received: by 2002:a63:5f86:: with SMTP id t128mr14212415pgb.385.1604973030813;
        Mon, 09 Nov 2020 17:50:30 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z13sm7956783pff.167.2020.11.09.17.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 17:50:30 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 bpf 0/2] Remove unused test_ipip.sh test and add missed ip6ip6 test
Date:   Tue, 10 Nov 2020 09:50:11 +0800
Message-Id: <20201110015013.1570716-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106090117.3755588-1-liuhangbin@gmail.com>
References: <20201106090117.3755588-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In comment 173ca26e9b51 ("samples/bpf: add comprehensive ipip, ipip6,
ip6ip6 test") we added some bpf tunnel tests. In commit 933a741e3b82
("selftests/bpf: bpf tunnel test.") when we moved it to the current
folder, we missed some points:

1. ip6ip6 test is not added
2. forgot to remove test_ipip.sh in sample folder
3. TCP test code is not removed in test_tunnel_kern.c

In this patch set I add back ip6ip6 test and remove unused code. I'm not sure
if this should be net or net-next, so just set to net.

Here is the test result:
```
Testing IP6IP6 tunnel...
PING ::11(::11) 56 data bytes

--- ::11 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 63ms
rtt min/avg/max/mdev = 0.014/1028.308/2060.906/841.361 ms, pipe 2
PING 1::11(1::11) 56 data bytes

--- 1::11 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 48ms
rtt min/avg/max/mdev = 0.026/0.029/0.036/0.006 ms
PING 1::22(1::22) 56 data bytes

--- 1::22 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 47ms
rtt min/avg/max/mdev = 0.030/0.048/0.067/0.016 ms
PASS: ip6ip6tnl
```

v3:
Add back ICMP check as Martin suggested.

v2: Keep ip6ip6 section in test_tunnel_kern.c.

Hangbin Liu (2):
  selftest/bpf: add missed ip6ip6 test back
  samples/bpf: remove unused test_ipip.sh

 samples/bpf/test_ipip.sh                      | 179 ------------------
 .../selftests/bpf/progs/test_tunnel_kern.c    |  42 +---
 tools/testing/selftests/bpf/test_tunnel.sh    |  43 ++++-
 3 files changed, 46 insertions(+), 218 deletions(-)
 delete mode 100755 samples/bpf/test_ipip.sh

-- 
2.25.4

