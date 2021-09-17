Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A4D40F0FA
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 06:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244367AbhIQES2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 00:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244281AbhIQES0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 00:18:26 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B431CC061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 21:17:04 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id r18-20020a056214069200b0037a291a6081so85721211qvz.18
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 21:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=po/J2aY3w2DrwYVofE73DYMDHBE9Wi6+GVbdpbw2KWk=;
        b=QdkOYawtyVHtrpmqYMPOagzWardAk8M8gARIqdE1kVO6o49SLOLjMfj2fJdUPzjpAi
         A6jJHWAoVDe5/yEtqB+cgRqMzKBuluu5y9fTLFwM+wbMF8YcMFIsHLbp4ZKPy61P9mdV
         QjRlQb4M8a1DFvxhDpdR5vCyxfdBgZS9UiPfpiCNFOhNDWc2CNHbw52aOHaNDzfQmAer
         7rtfG4wdly93xhN4PAKLThDOX0hDFTCKOGWrTOsdp0FsF61mSvHoiDrm703XYc2vrVHL
         QmJT/EwJQJaAQXU2Bc8CtN49jNg1mJFrvazbtz7KKJtEvo7weLYZnIlZcEXRweYiksj8
         JcCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=po/J2aY3w2DrwYVofE73DYMDHBE9Wi6+GVbdpbw2KWk=;
        b=rkRpJ9DV3ejV6SjI44OipWfp48LQYbcNF/ynHEaEHOGI/t5dXTqhGSYijbp67a4dTa
         k9QjMl7odNBMo4x4k8BrhhaZ4+oi5kNjQ0WzgBXMvR8ovCUma3r5QCiyD2H+/0usHq5t
         9DDfUJpJwWIaiuOEtyeOKCYDDYlNQuaXUg7pX91D8FZzUPyNt/QDVs01dJWzu+7aswhB
         4oKpP0+rkHKXp6NX/UXSCvCCrLJaOFnFWi9Y5X8nCvwaYfvv8+G9mC/eiNqewAdzrUkR
         PFCkJY+jRxMTRo6XZ2SAhfCRkfAap2jATxaqnBtic4RERIb7bjtta3s0n8hJyuDUDmVE
         zAKg==
X-Gm-Message-State: AOAM53128+EegdcPgOQyknVZT4pzEx35/qSb2KYUKwQn1vo4UxWfesaI
        wQwjEgvhU2mvdw66x8m52ATmqPk9kAo=
X-Google-Smtp-Source: ABdhPJyu74Ao5eS3sdHnuoZzZqLPA9BZeIODyGaYLe49QI/9JWJR9lsQCnAiE32cn48wg4UhzkrLfWoLMxc=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:9e5e:759d:5f68:9395])
 (user=weiwan job=sendgmr) by 2002:a05:6214:1142:: with SMTP id
 b2mr9391775qvt.0.1631852223959; Thu, 16 Sep 2021 21:17:03 -0700 (PDT)
Date:   Thu, 16 Sep 2021 21:17:02 -0700
Message-Id: <20210917041702.167622-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [patch v2] tcp.7: Add description for TCP_FASTOPEN and
 TCP_FASTOPEN_CONNECT options
From:   Wei Wang <weiwan@google.com>
To:     linux-man@vger.kernel.org,
        Alejandro Colomar <alx.manpages@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc:     netdev@vger.kernel.org, Yuchung Cheng <ycheng@google.com>
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
Change in v2: corrected some format issues

 man7/tcp.7 | 110 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/man7/tcp.7 b/man7/tcp.7
index 0a7c61a37..5a6fa7f50 100644
--- a/man7/tcp.7
+++ b/man7/tcp.7
@@ -423,6 +423,28 @@ option.
 .\" Since 2.4.0-test7
 Enable RFC\ 2883 TCP Duplicate SACK support.
 .TP
+.IR tcp_fastopen  " (Bitmask; default: 0x1; since Linux 3.7)"
+Enables RFC\ 7413 Fast Open support.
+The flag is used as a bitmap with the following values:
+.RS
+.IP 0x1
+Enables client side Fast Open support
+.IP 0x2
+Enables server side Fast Open support
+.IP 0x4
+Allows client side to transmit data in SYN without Fast Open option
+.IP 0x200
+Allows server side to accept SYN data without Fast Open option
+.IP 0x400
+Enables Fast Open on all listeners without
+.B TCP_FASTOPEN
+socket option
+.RE
+.TP
+.IR tcp_fastopen_key " (since Linux 3.7)"
+Set server side RFC\ 7413 Fast Open key to generate Fast Open cookie
+when server side Fast Open support is enabled.
+.TP
 .IR tcp_ecn " (Integer; default: see below; since Linux 2.4)"
 .\" Since 2.4.0-test7
 Enable RFC\ 3168 Explicit Congestion Notification.
@@ -1202,6 +1224,94 @@ Bound the size of the advertised window to this value.
 The kernel imposes a minimum size of SOCK_MIN_RCVBUF/2.
 This option should not be used in code intended to be
 portable.
+.TP
+.BR TCP_FASTOPEN " (since Linux 3.6)"
+This option enables Fast Open (RFC\ 7413) on the listener socket.
+The value specifies the maximum length of pending SYNs
+(similar to the backlog argument in
+.BR listen (2)).
+Once enabled,
+the listener socket grants the TCP Fast Open cookie on incoming
+SYN with TCP Fast Open option.
+.IP
+More importantly it accepts the data in SYN with a valid Fast Open cookie
+and responds SYN-ACK acknowledging both the data and the SYN sequence.
+.BR accept (2)
+returns a socket that is available for read and write when the handshake
+has not completed yet.
+Thus the data exchange can commence before the handshake completes.
+This option requires enabling the server-side support on sysctl
+.IR net.ipv4.tcp_fastopen
+(see above).
+For TCP Fast Open client-side support,
+see
+.BR send (2)
+.B MSG_FASTOPEN
+or
+.B TCP_FASTOPEN_CONNECT
+below.
+.TP
+.BR TCP_FASTOPEN_CONNECT " (since Linux 4.11)"
+This option enables an alternative way to perform Fast Open on the active
+side (client).
+When this option is enabled,
+.BR connect (2)
+would behave differently depending if a Fast Open cookie is available for
+the destination.
+.IP
+If a cookie is not available (i.e. first contact to the destination),
+.BR connect (2)
+behaves as usual by sending a SYN immediately,
+except the SYN would include an empty Fast Open cookie option to solicit a
+cookie.
+.IP
+If a cookie is available,
+.BR connect (2)
+would return 0 immediately but the SYN transmission is defered.
+A subsequent
+.BR write (2)
+or
+.BR sendmsg (2)
+would trigger a SYN with data plus cookie in the Fast Open option.
+In other words,
+the actual connect operation is deferred until data is supplied.
+.IP
+.B Note:
+While this option is designed for convenience,
+enabling it does change the behaviors and might set new
+.I errnos
+of socket calls.
+With cookie present,
+.BR write (2)
+/
+.BR sendmsg (2)
+must be called right after
+.BR connect (2)
+in order to send out SYN+data to complete 3WHS and establish connection.
+Calling
+.BR read (2)
+right after
+.BR connect (2)
+without
+.BR write (2)
+will cause the blocking socket to be blocked forever.
+The application should use either
+.B TCP_FASTOPEN_CONNECT
+or
+.BR send (2)
+with
+.B MSG_FASTOPEN ,
+instead of both on the same connection.
+.IP
+Here is the typical call flow with this new option:
+  s = socket();
+  setsockopt(s, IPPROTO_TCP, TCP_FASTOPEN_CONNECT, 1, ...);
+  connect(s);
+  write(s); // write() should always follow connect() in order to
+            // trigger SYN to go out
+  read(s)/write(s);
+  ...
+  close(s);
 .SS Sockets API
 TCP provides limited support for out-of-band data,
 in the form of (a single byte of) urgent data.
-- 
2.33.0.464.g1972c5931b-goog

