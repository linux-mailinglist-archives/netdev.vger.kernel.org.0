Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A4C2A3B66
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 05:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgKCE31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 23:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgKCE31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 23:29:27 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C84C0617A6;
        Mon,  2 Nov 2020 20:29:26 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u2so2025580pls.10;
        Mon, 02 Nov 2020 20:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9yJafI9JzO1hsUL/IVtMBiZmlV+MWNs1li/SRBTAGFc=;
        b=RYBdNi+kLm1a2p+43ST8IpXxrsEeZ4mpmdwbFJMve/Ia59IpU+TPyGHq2H0UaZ8iXq
         i6tvGdQy5jfDGXTKMDBhMBCFcijaz8yTbL+CDyk00mlYSFxF6SJRKEWzHRthF0aX1eNu
         Ho3YZ+0EL5deQrdvXUd6qOWqdniXE0kR+g/kI/2OpfCeqRh/UNtOS+jdbMUapUBXPxfO
         LJDdUIf4Z7YZn3Y44bdcTi/IySvRNzfisv6cA1D3Kfy0FGN3aGdDpdpULtGFOKLGqF7q
         rPEjBUD/rh3UTCC+ph0AA9ds683Zu5RXvTvMkXIeD2G6JkfgAhq/oJvHccNmGoW/EJyw
         H9DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9yJafI9JzO1hsUL/IVtMBiZmlV+MWNs1li/SRBTAGFc=;
        b=QZ7MWIDRalQ572YnygSXtPBbQVT79H5J+YncBhe4u6fkGP2rZjjxPuV23h9fEihMiw
         m4iybxkWdK+u7HKso77lKDEdU3/gUbHWXWFWE9G4rzGpw6hTNQ77Z2VtiFZnX4ATrpr3
         uU++B5Ip4FAI7YdZ0ND6NNNi7b7mVEZMU5AXvFMNIXHGqTL5RQfHiv12kY0ycuV8YXYP
         QT3Ke572QPaO+s44sXKw3/35LMozT3lQuOJ1MWxIN+U3RJKk+4GGBjyS3AXZdkyE6Kbb
         CTd6w5teXE2VoFi2S7AIT5ywboocSFeQHgXf5ORthOJxdO9k08MBgL2AKhEtk+r2tQM2
         ySIg==
X-Gm-Message-State: AOAM531Pb4aU/G4Mv4NlE6rtBMqq2YghbSVIi9lENbb1QT8Ldt7uTQ+9
        Jn7GoN7fAP0QDBnYRqhzm24fu2jJOol5E6gk
X-Google-Smtp-Source: ABdhPJyOsne5KS/h4dyUSqu5G1qPHXnWhApA9IBMtDIUJz43h2u+u/OJPQ9JV7JOoCS75QRGKXXDvA==
X-Received: by 2002:a17:902:7298:b029:d4:c71a:357a with SMTP id d24-20020a1709027298b02900d4c71a357amr23695229pll.38.1604377765269;
        Mon, 02 Nov 2020 20:29:25 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b6sm13683279pgq.58.2020.11.02.20.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 20:29:24 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next 0/2] selftest/bpf: improve bpf tunnel test
Date:   Tue,  3 Nov 2020 12:29:06 +0800
Message-Id: <20201103042908.2825734-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
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

In this patch set I add back ip6ip6 test and remove unused code.
As I'm not sure if this should be a fixup, I didn't add the Fixes flag.

Here is the test result:
```
  Testing IP6IP6 tunnel...
  PING ::11(::11) 56 data bytes

  --- ::11 ping statistics ---
  3 packets transmitted, 3 received, 0% packet loss, time 47ms
  rtt min/avg/max/mdev = 0.031/1023.035/2044.975/834.846 ms, pipe 2
  PING 1::11(1::11) 56 data bytes

  --- 1::11 ping statistics ---
  3 packets transmitted, 3 received, 0% packet loss, time 47ms
  rtt min/avg/max/mdev = 0.027/0.046/0.058/0.013 ms
  PING 1::22(1::22) 56 data bytes

  --- 1::22 ping statistics ---
  3 packets transmitted, 3 received, 0% packet loss, time 47ms
  rtt min/avg/max/mdev = 0.041/0.056/0.074/0.014 ms
  PASS: ip6ip6tnl
```

Hangbin Liu (2):
  selftest/bpf: add missed ip6ip6 test back
  selftest/bpf: remove unused bpf tunnel testing code

 samples/bpf/test_ipip.sh                      | 179 ------------------
 .../selftests/bpf/progs/test_tunnel_kern.c    |  87 +--------
 tools/testing/selftests/bpf/test_tunnel.sh    |  39 +++-
 3 files changed, 40 insertions(+), 265 deletions(-)
 delete mode 100755 samples/bpf/test_ipip.sh

-- 
2.25.4

