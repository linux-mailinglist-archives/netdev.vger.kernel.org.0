Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943461D89B0
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgERU7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgERU7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:59:03 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7B3C061A0C;
        Mon, 18 May 2020 13:59:03 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b6so11941770qkh.11;
        Mon, 18 May 2020 13:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=homKM6Zc8ViHAYH/RsIdxTybEIzfNTX2HAuRTzaH1Fk=;
        b=qMUh6BOB+GdAq8794Euckqo8K+0gjzYylHCOdt+r06F6beNlvyoQRpU5U5jSnImyAU
         S91mkJaBAPH/BIE6d3a1tDpgAlfeW0vBy0HyFY2c1qYhCzlldJoEN1/tI5ZjYlCpb3vd
         t4KsFZLE7e128lBPDnwiM/poHVcfDOl5d++fMG4XEJh/FFiG7QPihGCP4JVo/oANMxV7
         bdI5pyl9khkeYmBuj1TWkjzGux9McfNseSiUgcTym/CFK2S8NsxPQDZcStyid5oPw7lo
         Ohs0TEHPQljgFy3YaCY/GT4VdOPpWDnWf9e471h88ePRdSPiBN3F42RaCbjNQiKHWinY
         m/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=homKM6Zc8ViHAYH/RsIdxTybEIzfNTX2HAuRTzaH1Fk=;
        b=derGVrUV+IRs0Xzyg51t7XaMnmNBD/1/07ZyrvHyTXgcNgr9xar1gLsPoel82fcOb4
         I4ezHufutA1k/AWumif1n1Be0iF+x8fDF58ArMjDPTZjrLaQuoziqUwWoqOWTrtPQaX5
         USOTZueQ3XVKAEg8b7GqJIdtMSuYVpxQbJu+bre2Y2xqheCNg5ft4KNNt1moXK5A4Kz6
         wRRBbHhoXtJqxsZV6+ngSosi3swEnaiFCHR+Wcao8okSVX/6DTU17plpdYx+30mAhZG7
         HPT88pE/Lyuog/teFFChN2hmbARDagR7rZk1FYLywYffpMMJmekZK+CtDQYSmRMpszd+
         PkYg==
X-Gm-Message-State: AOAM532liqCJ/bDEsH5YwgUNLp233NDZMblMEf0hzYZrk41h0ZZQN8C1
        ABlpn6lrFmuV9iYSg8unndw=
X-Google-Smtp-Source: ABdhPJwniByKn1ifqJ57IV034WFszWuNrFnCZXTLpFCqiLTGShVhgoJ9lBSPgvad1x0nC8uMjU5Uaw==
X-Received: by 2002:a37:b303:: with SMTP id c3mr17430812qkf.397.1589835542763;
        Mon, 18 May 2020 13:59:02 -0700 (PDT)
Received: from woodmont.localdomain (185.sub-174-221-14.myvzw.com. [174.221.14.185])
        by smtp.gmail.com with ESMTPSA id i59sm10143021qtb.58.2020.05.18.13.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 13:59:02 -0700 (PDT)
From:   "Devin J. Pohly" <djpohly@gmail.com>
To:     mtk.manpages@gmail.com
Cc:     linux-man@vger.kernel.org, netdev@vger.kernel.org,
        stephen@networkplumber.org, "Devin J. Pohly" <djpohly@gmail.com>
Subject: [PATCH] veth.4: Add a more direct example
Date:   Mon, 18 May 2020 15:58:28 -0500
Message-Id: <20200518205828.13905-1-djpohly@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iproute2 allows you to specify the netns for either side of a veth
interface at creation time.  Add an example of this to veth(4) so it
doesn't sound like you have to move the interfaces in a separate step.

Verified with commands:
    # ip netns add alpha
    # ip netns add bravo
    # ip link add foo netns alpha type veth peer bar netns bravo
    # ip -n alpha link show
    # ip -n bravo link show
---
 man4/veth.4 | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/man4/veth.4 b/man4/veth.4
index 20294c097..2d59882a0 100644
--- a/man4/veth.4
+++ b/man4/veth.4
@@ -63,13 +63,23 @@ A particularly interesting use case is to place one end of a
 .B veth
 pair in one network namespace and the other end in another network namespace,
 thus allowing communication between network namespaces.
-To do this, one first creates the
+To do this, one can provide the
+.B netns
+parameter when creating the interfaces:
+.PP
+.in +4n
+.EX
+# ip link add <p1-name> netns <p1-ns> type veth peer <p2-name> netns <p2-ns>
+.EE
+.in
+.PP
+or, for an existing
 .B veth
-device as above and then moves one side of the pair to the other namespace:
+pair, move one side to the other namespace:
 .PP
 .in +4n
 .EX
-# ip link set <p2-name> netns <p2-namespace>
+# ip link set <p2-name> netns <p2-ns>
 .EE
 .in
 .PP
-- 
2.26.2

