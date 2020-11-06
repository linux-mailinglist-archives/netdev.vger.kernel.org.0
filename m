Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69792A91F9
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 10:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgKFJBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 04:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgKFJBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 04:01:31 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A80C0613CF;
        Fri,  6 Nov 2020 01:01:31 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 10so722244pfp.5;
        Fri, 06 Nov 2020 01:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xLQV++ZHx1qqbL6zEREURgZGXxHeqI09SEFEGhlCJ7o=;
        b=dsCRYe+h+F17dTEpkdCTFLgdv2QAPkhDw6qmPCroOWfMBTWegivgtY0xvpW3HgwUz6
         NJEIo7hTxR0iFY4SVSYSf0XPHbK6Y9bdkbodN/KZufgvDwKBl8P/5xOlBuqXYyzF3CSJ
         SAeqqaZbYHXQgNHSUxqNQUslMXdTrFOJKj/QXFDIpo0XhLBDlJZVduWNExaGhFKdJDrG
         Qlyj1hKJLQmZVlSZ3yfJHVbc5Ar/I8OUTvmTlG2rj9tINYZpZ7oFz28/9VREujRgP4cX
         7G4yupZ/eHx9bWmlhuEP5xBIIfdlpIb38FoqaCE2JU9Yq7VJl6ycckq0dgyDikvqzy1A
         BTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xLQV++ZHx1qqbL6zEREURgZGXxHeqI09SEFEGhlCJ7o=;
        b=KblOTjfmKNhQZBO/LJIl52nptck9sACjknclS8mdtKMoqOBpDntMDvrPe8D5HEfOQe
         ruNvtZSypFhgyowHnxRrAd/9TWZ1ZGcqirB5oRCCiAEjTJ/rur9vOlqNr1z6o3+oWQgi
         Z0zbWr7vw6hTcr91QjwPTIjvPusZde9M4HPZAwV01FtOemcvPUWnEdYRDf8GaUMFWlkL
         Tm1UWe6ajUlH8LUX4kbup1CLPA1oA2JB0C/Y4YHzo43PoCez15ls6LbRvsm/sRlgrFsW
         GFmBcFdukbvC0WVmXGYv837FkRiotMWPpOZiTyBitSGwts+AkEX7x8jkSB7wlnbuB32K
         7xxA==
X-Gm-Message-State: AOAM532KmE+C8KwN+Q/zM250KUpB5LvPLDe/nd1i9nuikyhlLHkUJT6k
        DQvI436+m5jFgx6b9DG0WZFH1GZ/IfySAXAy
X-Google-Smtp-Source: ABdhPJwVAYos+9XH+4uCu5mVyjKsTkVDUizce7BSnXghPXBGFrpXGdptli+xHOldmOTw+KK2eFhciA==
X-Received: by 2002:a17:90a:6309:: with SMTP id e9mr1320369pjj.115.1604653291079;
        Fri, 06 Nov 2020 01:01:31 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g3sm985530pgl.55.2020.11.06.01.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 01:01:30 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 0/2] Remove unused test_ipip.sh test and add missed ip6ip6 test
Date:   Fri,  6 Nov 2020 17:01:15 +0800
Message-Id: <20201106090117.3755588-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103042908.2825734-1-liuhangbin@gmail.com>
References: <20201103042908.2825734-1-liuhangbin@gmail.com>
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

v2: Keep ip6ip6 section in test_tunnel_kern.c.

Hangbin Liu (2):
  selftest/bpf: add missed ip6ip6 test back
  samples/bpf: remove unused test_ipip.sh

 samples/bpf/test_ipip.sh                      | 179 ------------------
 .../selftests/bpf/progs/test_tunnel_kern.c    |  44 +----
 tools/testing/selftests/bpf/test_tunnel.sh    |  43 ++++-
 3 files changed, 44 insertions(+), 222 deletions(-)
 delete mode 100755 samples/bpf/test_ipip.sh

-- 
2.25.4

