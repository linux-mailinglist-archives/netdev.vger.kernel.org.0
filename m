Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD94F40CBC8
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 19:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhIORjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 13:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhIORjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 13:39:20 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2FAC061574
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:38:01 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id b24-20020ac86798000000b0029eaa8c35d6so5370533qtp.1
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=3pp1o88+7rBaDDOeovPzTAYW6X919MoZJGH7G7NquPo=;
        b=QbQLQvPD+EIx+PJ8ngz1qyxXpKLBTeIvUDdYJXKP0CHPuWQDc9s00dbom8bMZIOT3h
         /nwjorvTI9JpqUwDANoyVLcb912N15lQQC6xsZoJF4IpzfW26geq3xCf0Cnz5xRgJlf2
         vx9z8Zzygl62EJWEM0qO3uOOr+7sk0uOZZ/yr4D3wSnCLGxeFZrrL23nWJqcTbSK1MAx
         s4I22QGZ1ShTux5BHxz9Rf58bK48HI0OTxfPl9G1JNFrBHDYoVuqsmD02577ryvu7J+m
         aACV2ty76CaeGeQXOxLHJfv2ELDd2w46DEPSF6kiO7YFTgdvP9duWULcswZm1nltYcKv
         XBqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=3pp1o88+7rBaDDOeovPzTAYW6X919MoZJGH7G7NquPo=;
        b=KjkNVhQjwOBtfwFpAUCQTU0TEN1u3tR9YKinZbLb69ucgErMjavouTrlipcDQTBghz
         0vTm/CxtQDSqio3nCv9LuTyJFLYoh4WzF3KAywFsYDcwK1zYTdjBMJNOfHCDjIpiagx8
         ut6OMeedCeJGCyPQenPWCJF/AMyOyehHDd/Z5B677ixmCb5dfgw6eAPXYexUrOeC5uKT
         6tE+crxQoLYUaJ+RwFPc+9GssbvlepgZLOGEJLzsy3ylnUeNpiv6VhUe0iZV89lyd8Fk
         KU/ZhgoFRH0aRFYENY4Rodulibg5Qe8rILUpDoPPqExJ/Zq9gcbtivEkQjxe5ZCBs8o8
         UIjA==
X-Gm-Message-State: AOAM530Fp9oDr9d9Hv2Mw88f39wwznIMH/wNe0iBBRyljRTnqjNId/GC
        QelDhw1NNw5cBmRhNZrNx2sEj0/PMr8=
X-Google-Smtp-Source: ABdhPJzP9C+WQbS5UgINwyh91IbL54F60n8FammwyWdjHtpi1iq5jI8iOyF3oRDYV/nBUTPzoR5USnw2STI=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:e1fc:b721:8493:4e76])
 (user=weiwan job=sendgmr) by 2002:a05:6214:98d:: with SMTP id
 dt13mr1135264qvb.13.1631727480812; Wed, 15 Sep 2021 10:38:00 -0700 (PDT)
Date:   Wed, 15 Sep 2021 10:37:58 -0700
Message-Id: <20210915173758.2608988-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [patch] send.2: Add MSG_FASTOPEN flag
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
 man2/send.2 | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/man2/send.2 b/man2/send.2
index fd28fed90..a40ae6214 100644
--- a/man2/send.2
+++ b/man2/send.2
@@ -252,6 +252,33 @@ data on sockets that support this notion (e.g., of type
 the underlying protocol must also support
 .I out-of-band
 data.
+.TP
+.BR MSG_FASTOPEN " (since Linux 3.7)"
+Attempts TCP Fast Open (RFC7413) and sends data in the SYN like a
+combination of
+.BR connect (2)
+and
+.BR write (2)
+, by performing an implicit
+.BR connect (2)
+operation. It blocks until the data is buffered and the handshake
+has completed.
+For a non-blocking socket, it returns the number of bytes buffered
+and sent in the SYN packet. If the cookie is not available locally,
+it returns
+.B EINPROGRESS
+, and sends a SYN with a Fast Open cookie request automatically.
+The caller needs to write the data again when the socket is connected.
+On errors, it returns the same errno as
+.BR connect (2)
+if the handshake fails. This flag requires enabling TCP Fast Open
+client support on sysctl net.ipv4.tcp_fastopen.
+
+Refer to
+.B TCP_FASTOPEN_CONNECT
+socket option in
+.BR tcp (7)
+for an alternative approach.
 .SS sendmsg()
 The definition of the
 .I msghdr
-- 
2.33.0.309.g3052b89438-goog

