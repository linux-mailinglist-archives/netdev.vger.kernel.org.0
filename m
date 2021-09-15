Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486F440CBCC
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 19:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhIORkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 13:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhIORkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 13:40:41 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0114C061574
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:39:22 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id r5-20020ac85e85000000b0029bd6ee5179so5344839qtx.18
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=XLX+vRgeC9DGZDQhHLUomZcL4BExGNkyi+XsSjPM9bk=;
        b=b0a4LaSS6z9Rn/9jStZDI3T2p3ODikiaOnwejGvBLtk3I9+VFSthk5MX4fwOlDSqqb
         a6MgSrXsx4VlTwb09QNaR+z+P5Oigyvh/XrlULOGsQlxAzp6Ouos5GZPILnMA5Lz2v3F
         kIlTSYIZeeZ+/ai1NB9CxFaDroOmjRHwa87W3JiXj72Y1WTaJcAWJnvP2C17OkDX0+xF
         i7FEwnJAFmNTzGL7h7AQn3bFyscKKBsL0T393jL2ssOCiSotFMKHy1C7g7kaQm3qKGWH
         a7vLMypnz2k8Ev0tZwxbI2+AN/sbIoUUlJLWUvZECOpNLfRpznbN6yokX2oQz2iviSS0
         kRzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=XLX+vRgeC9DGZDQhHLUomZcL4BExGNkyi+XsSjPM9bk=;
        b=wX20A72cQ6cR9k6dX+PoulB8Drgv6D/kSdsUOg/IceQ7FYSov2a9cGuIHyu7qRrYJv
         ssk6OUEPx9cLOHMiD/dmv/Rh4KvcuSPcNUErcute1+IiwyZpa5hYWNXb6tUx20gSWIoq
         H2vmzEarW1QTu/BRxxhjk+oDwrqDjwK9oYCw9oSMT61fgUodrKefbmI7cCf06GCEhmFD
         uYoxwzxGvFOQKNLyujDXWuT3eC3irnhCEXRRQNSzxxB/+NPBtpG/qEokYQK/e4Fi6vLJ
         jpjw/QyqqdmPS1YE3aaUZh49nJrve5eE7wgBx9YgjOaOTcharbVV4enK7Jneg0E40jvp
         Qt+w==
X-Gm-Message-State: AOAM531KlLRMG34BHnbm7hL5T36w4iQw7ZZbcuflKzOQ9UNhpI07Hh4a
        XAON3b1HevUIn+Pwi5iwRWIm1Ost+gE=
X-Google-Smtp-Source: ABdhPJxzo5S6XN8ZKxFPbUFfO8Fr3uOMfCbHGuBEPEP0/ilKR1cKCx+LXYQLTIzvGdq81OiF83PsRch84Uo=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:e1fc:b721:8493:4e76])
 (user=weiwan job=sendgmr) by 2002:a05:6214:2d1:: with SMTP id
 g17mr1026738qvu.63.1631727562018; Wed, 15 Sep 2021 10:39:22 -0700 (PDT)
Date:   Wed, 15 Sep 2021 10:39:19 -0700
Message-Id: <20210915173919.2609441-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [patch] tcp.7: Add description for TCP_FASTOPEN and
 TCP_FASTOPEN_CONNECT options
From:   Wei Wang <weiwan@google.com>
To:     linux-man@vger.kernel.org,
        Alejandro Colomar <alx.manpages@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP_FASTOPEN socket option was added by:
commit 8336886f786fdacbc19b719c1f7ea91eb70706d4
TCP_FASTOPEN_CONNECT socket option was added by the following patch
series:
commit 065263f40f0972d5f1cd294bb0242bd5aa5f06b2
commit 25776aa943401662617437841b3d3ea4693ee98a
commit 19f6d3f3c8422d65b5e3d2162e30ef07c6e21ea2
commit 3979ad7e82dfe3fb94a51c3915e64ec64afa45c3
Add detailed description for these 2 options.
Also add descriptions for /proc entry tcp_fastopen and tcp_fastopen_key.

Signed-off-by: Wei Wang <weiwan@google.com>
Reviewed-by: Yuchung Cheng <ycheng@google.com> 
---
 man7/tcp.7 | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/man7/tcp.7 b/man7/tcp.7
index 0a7c61a37..1f5c8b200 100644
--- a/man7/tcp.7
+++ b/man7/tcp.7
@@ -423,6 +423,24 @@ option.
 .\" Since 2.4.0-test7
 Enable RFC\ 2883 TCP Duplicate SACK support.
 .TP
+.IR tcp_fastopen  " (Bitmask; default: 0x1; since Linux 3.7)"
+Enables RFC7413 Fast Open support. The flag is used as a bitmap with the
+following values:
+.IP 0x1
+Enables client side Fast Open support
+.IP 0x2
+Enables server side Fast Open support
+.IP 0x4
+Allows client side to transmit data in SYN without Fast Open option
+.IP 0x200
+Allows server side to accept SYN data without Fast Open option
+.IP 0x400
+Enables Fast Open on all listeners without TCP_FASTOPEN socket option
+.TP
+.IR tcp_fastopen_key " (since Linux 3.7)"
+Set server side RFC7413 Fast Open key to generate Fast Open cookie when
+server side Fast Open support is enabled.
+.TP
 .IR tcp_ecn " (Integer; default: see below; since Linux 2.4)"
 .\" Since 2.4.0-test7
 Enable RFC\ 3168 Explicit Congestion Notification.
@@ -1202,6 +1220,84 @@ Bound the size of the advertised window to this value.
 The kernel imposes a minimum size of SOCK_MIN_RCVBUF/2.
 This option should not be used in code intended to be
 portable.
+.TP
+.BR TCP_FASTOPEN " (since Linux 3.6)"
+This option enables Fast Open (RFC7413) on the listener socket. The value
+specifies the maximum length of pending SYNs (similar to the backlog argument
+in
+.BR listen (2)
+). Once enabled, the listener socket grants the TCP Fast Open cookie on
+incoming SYN with TCP Fast Open option.
+
+More importantly it accepts the data in SYN with a valid Fast Open cookie
+and responds SYN-ACK acknowledging both the data and the SYN sequence.
+.BR accept (2)
+returns a socket that is available for read and write when the handshake
+has not completed yet. Thus the data exchange can commence before the handshake
+completes. This option requires enabling the server-side support on sysctl
+net.ipv4.tcp_fastopen (see above). For TCP Fast Open client-side support,
+see
+.BR send (2)
+MSG_FASTOPEN or TCP_FASTOPEN_CONNECT below.
+
+.TP
+.BR TCP_FASTOPEN_CONNECT " (since Linux 4.11)"
+This option enables an alternative way to perform Fast Open on the active
+side (client).
+When this option is enabled,
+.BR connect (2)
+would behave differently depending if a Fast Open cookie is available for
+the destination.
+
+If a cookie is not available (i.e. first contact to the destination),
+.BR connect (2)
+behaves as usual by sending a SYN immediately, except the SYN would include
+an empty Fast Open cookie option to solicit a cookie.
+
+If a cookie is available,
+.BR connect (2)
+would return 0 immediately but the SYN transmission is defered. A subsequent
+.BR write (2)
+or
+.BR sendmsg (2)
+would trigger a SYN with data plus cookie in the Fast Open option. In other
+words, the actual connect operation is deferred until data is supplied.
+
+.B Note:
+  While this option is designed for convenience, enabling it does change
+the behaviors and might return new errnos of socket calls.
+  With cookie present,
+.BR write (2)
+/
+.BR sendmsg (2)
+must be called right after
+.BR connect (2)
+in order to send out SYN+data to complete 3WHS and establish connection.
+  Calling
+.BR read (2)
+right after
+.BR connect (2)
+without
+.BR write (2)
+will cause the blocking socket to be blocked forever.
+  The application should use either
+.B TCP_FASTOPEN_CONNECT
+or
+.BR send (2)
+with
+.B MSG_FASTOPEN
+, instead of both on the same connection.
+
+Here is the typical call flow with this new option:
+  s = socket();
+  setsockopt(s, IPPROTO_TCP, TCP_FASTOPEN_CONNECT, 1, ...);
+  connect(s);
+  write(s); // write() should always follow connect() in order to
+            // trigger SYN to go out
+  read(s)/write(s);
+  ...
+  close(s);
+
 .SS Sockets API
 TCP provides limited support for out-of-band data,
 in the form of (a single byte of) urgent data.
-- 
2.33.0.309.g3052b89438-goog

