Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CDC40F0F7
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 06:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244324AbhIQERg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 00:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244281AbhIQERa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 00:17:30 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D707C061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 21:16:09 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id w2-20020a3794020000b02903b54f40b442so61575126qkd.0
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 21:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7YN2hE0tC8DFMUmiBGsXMAilK9HOomy6oAv8gFVolpU=;
        b=QD4VlrNwxDPw9usj27Dilb40GkifpcVtG3Kyqm2iCCSeTfi5cwQri5rVDkQYYcDd/e
         7NlE3i1xbg5PJPHYy1WX+S7W/eSnelsiZ2aESmsTxZsIZE24zvxjKWvfvHSJDGy0VXEE
         +AJXPOlenPQu5Gh+5bvx7Al5rgl+ZIY746HCnzxCy8JEOcmHZ4RQrEFSi7BW5/bH3VN6
         RTRMXhR0aL5cnfrlEDVYp9yNV6iFRibdXj0nvXb9xLSDfvRwdAmYqCT31CkG4BLjB6Xl
         VFfnRJr2Aq8kp/6IkB61WfkyBWjZHAmwWKqYLkNO4gaAVP7a5qG+lCT3ZXWkhn0S4JnS
         W9IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7YN2hE0tC8DFMUmiBGsXMAilK9HOomy6oAv8gFVolpU=;
        b=3TFBDIRBOdNxpjIpbvLqkWB02QdzJ8fUOu8itX5xeN1dVGOOH8FlcgbwQAGm92dMpJ
         X4WwBXm28ScinPDunZJ/R6bwd1NfDgFfWR7XcfPaibEFCHsO716bfWquwYbyaBUK9vW3
         XK8xRymA5R/smkSdQ1mDsGZiva3lHU9JW+2WcJ7o+0TjUonQ6ANYNOcEf1RCK/YRUVRq
         Q+7yX7yoEZqUAeV/4lE6N6osulK2ePK3Nt5pP/yNu1INNSgyWVCFhjVPSzDSmqVam09B
         uLN5TwKMMssObmqEGbfmK8xZiZlRQ+rMVe8uG5/V6lBktK9WbmDvm99wBCnC2xhMBntI
         rtjw==
X-Gm-Message-State: AOAM530kCfHjW9qMffT+RAKx9J19wp607dWRW7/z2/WqAKJn0uoyNxbn
        7lj6d3EPBZbzAryMAbmDMhz/J7TGjhM=
X-Google-Smtp-Source: ABdhPJzP3AORdWptwIo3VB+9W1LQAPuqm2Q2+wYrdkGfLZCvYaWqOFiLicuOyGRGzYsbCfxwADRLw9Ji0aE=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:9e5e:759d:5f68:9395])
 (user=weiwan job=sendgmr) by 2002:a25:4789:: with SMTP id u131mr11054557yba.531.1631852168320;
 Thu, 16 Sep 2021 21:16:08 -0700 (PDT)
Date:   Thu, 16 Sep 2021 21:16:06 -0700
Message-Id: <20210917041606.167192-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [patch v2] send.2: Add MSG_FASTOPEN flag
From:   Wei Wang <weiwan@google.com>
To:     linux-man@vger.kernel.org,
        Alejandro Colomar <alx.manpages@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc:     netdev@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MSG_FASTOPEN flag is available since Linux 3.7. Add detailed description
in the manpage according to RFC7413.

Signed-off-by: Wei Wang <weiwan@google.com>
Reviewed-by: Yuchung Cheng <ycheng@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
Change in v2: corrected some format issues

 man2/send.2 | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/man2/send.2 b/man2/send.2
index fd28fed90..acaa05be9 100644
--- a/man2/send.2
+++ b/man2/send.2
@@ -252,6 +252,38 @@ data on sockets that support this notion (e.g., of type
 the underlying protocol must also support
 .I out-of-band
 data.
+.TP
+.BR MSG_FASTOPEN " (since Linux 3.7)"
+Attempts TCP Fast Open (RFC7413) and sends data in the SYN like a
+combination of
+.BR connect (2)
+and
+.BR write (2),
+by performing an implicit
+.BR connect (2)
+operation.
+It blocks until the data is buffered and the handshake has completed.
+For a non-blocking socket,
+it returns the number of bytes buffered and sent in the SYN packet.
+If the cookie is not available locally,
+it returns
+.BR EINPROGRESS ,
+and sends a SYN with a Fast Open cookie request automatically.
+The caller needs to write the data again when the socket is connected.
+On errors,
+it sets the same
+.I errno
+as
+.BR connect (2)
+if the handshake fails.
+This flag requires enabling TCP Fast Open client support on sysctl
+.IR net.ipv4.tcp_fastopen .
+.IP
+Refer to
+.B TCP_FASTOPEN_CONNECT
+socket option in
+.BR tcp (7)
+for an alternative approach.
 .SS sendmsg()
 The definition of the
 .I msghdr
-- 
2.33.0.464.g1972c5931b-goog

