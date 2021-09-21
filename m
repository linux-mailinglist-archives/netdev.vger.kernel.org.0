Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9E6412EB8
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 08:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhIUGm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 02:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbhIUGmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 02:42:55 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B460AC061574;
        Mon, 20 Sep 2021 23:41:27 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id t4so12743869plo.0;
        Mon, 20 Sep 2021 23:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RDY/CygsuDGr2VxPOJrYoRC69tTkJlPaA3/ke6daSf0=;
        b=abtdr9HPjC1t7faBledJZIwT3FO22vN7xT97L0vm71+p3bZwqPk3Cu8KJGUNy71vhM
         VC5CR9QQ5OH06KG0W7lz37bUyFvEgrsUfkNSPOBQepJxPUKPDnRbIDTYexbOjXmEctwF
         jmZuGDjPCCEDP3yhABGNhgRf7KrRItZ+VHeXW0y48o+n9D02B13jh7JkETslbbpmds4/
         iZrb1dovtD3/J9c+D3l87ujbMjqac6fwthB2cggkYmvqoojCpS9mmdAkLLnu9psHuTHb
         w1xdvYnAbSYZBZF6bbdlYYuDb0cWfZatTdzms4YFwWQY1TWwG37DO+UDfG17t8DqgMld
         zBFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RDY/CygsuDGr2VxPOJrYoRC69tTkJlPaA3/ke6daSf0=;
        b=LmIlhAHxc+IMIeNavCTqnYeHX6DOBeJ5KkB/Qbb2NCvYO8Xboi+DJ8fH5J0rfaRmHs
         ECS+rrxdT1NTaXUJO36A5fBQS1YIff0yKo/wCtr+VgVGLFJI+09vfbeKlkcFSkPqMWEM
         JuekODNpmTdwjvo7m8TeSurHC9O6DO4AH6TvfJGKutTfxCvImA9Sm5tPwNXi4nn/uiow
         e4VZC/HaeyJ7nBX5tDJzmcj4pf/m/UdegQV3VtA98ehECyxcCPM6BX647pvaiOiKSygF
         OWJ8sfQqtzAAXKWlMBsWs6F4EHSeenNJaFW7Z3bl8VOYJVN/NXN0E4MrdDE1oxpvC4qs
         R1KA==
X-Gm-Message-State: AOAM530l+70EBv+u11Vd0sH101/74h2nsq38Hav/GvFcv1vIoRM2vXTr
        +rwGi7750vFzb3vOu9Mf110=
X-Google-Smtp-Source: ABdhPJwgDQTvgVWPoPaDVdxQa0Czy9qxk3RR168T002Vs62HkMDtg5JeT7zgZB21KvxWk30yqWe+DQ==
X-Received: by 2002:a17:903:246:b0:13a:8c8:8a31 with SMTP id j6-20020a170903024600b0013a08c88a31mr25624046plh.87.1632206487131;
        Mon, 20 Sep 2021 23:41:27 -0700 (PDT)
Received: from masabert ([202.12.244.3])
        by smtp.gmail.com with ESMTPSA id w206sm10760488pfc.45.2021.09.20.23.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 23:41:26 -0700 (PDT)
Received: by masabert (Postfix, from userid 1000)
        id A9C712360A48; Tue, 21 Sep 2021 15:41:24 +0900 (JST)
From:   Masanari Iida <standby24x7@gmail.com>
To:     linux-kernel@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Doc: networking: Fox a typo in ice.rst
Date:   Tue, 21 Sep 2021 15:41:23 +0900
Message-Id: <20210921064123.251742-1-standby24x7@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a spelling typo in ice.rst

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/networking/device_drivers/ethernet/intel/ice.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/ethernet/intel/ice.rst b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
index e7d9cbff771b..67b7a701ce9e 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/ice.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
@@ -851,7 +851,7 @@ NOTES:
 - 0x88A8 traffic will not be received unless VLAN stripping is disabled with
   the following command::
 
-    # ethool -K <ethX> rxvlan off
+    # ethtool -K <ethX> rxvlan off
 
 - 0x88A8/0x8100 double VLANs cannot be used with 0x8100 or 0x8100/0x8100 VLANS
   configured on the same port. 0x88a8/0x8100 traffic will not be received if
-- 
2.25.0

