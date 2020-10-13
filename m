Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBEE28D4DB
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 21:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbgJMTpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 15:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgJMTpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 15:45:13 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F454C0613D0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 12:45:12 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id q9so1190695iow.6
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 12:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bm16GqpOD7Ki4zZQHCFjSyawqd78XJGBOczoXTgkkiI=;
        b=DXUphNutlOoT+5dJOxIPxWL+8g49E5OI4SfAs2WZyuNcerSowKkPCXVNkz7AvfGwcQ
         AvipuJ7EoD6+c9s0Veh74eeHfvx8WBFDj1R+u8R/bD2FL6ilOWNtB0C98k6lT5OQ+AtP
         cDpm07zBjmeAtuaCAvHQfs2nNIlq33kC09RDwjxPG6o4D3HxfHjiBzG376wQ3YSlF2Av
         lJ93P1iQL/M0pddAdMfK7NAA+bVxx2W1cvxMNzptX9wnxuGKJxqjqpfjpijM9KLK3Kgo
         M+fhRfJqRPjFh7WRiE4bfHoykTp1u5foeH+Q1qgZnTynDx4noZ+yzWOUSceWzn4o1kQi
         I32Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bm16GqpOD7Ki4zZQHCFjSyawqd78XJGBOczoXTgkkiI=;
        b=Gw7pAb0873aU26NP283pqcyPjdXGjfJKRUHaV3AInpCkpwCRlgozkbiTn9PwHcyPQq
         eH/pLpSpKsCcPLlZhZII5BX/uS4M9BxlzqdxeiqB9+kX0wP74VxhSdbAW469r3ivYcrQ
         B7A/RskSUa0Bapvi/hY5MDSsC42gYm0gLzMgqcrLsUDvJd6vg6/y3VdDCGn+D/J5+Lds
         Sq+VPfq9Y/X0BHO7jDXRn5s7Bp6G5SbMR8fFQKXs4reByrDsQoHa6TkT4FQr/1de5AZh
         8vaFNE3j+sOtHHKDtiFOsJfwwETtOv2VbqafLYispeokAoDN185YrBWBR73AptL7p5Q9
         Zjtg==
X-Gm-Message-State: AOAM531FbU9TjadWSG4Xvk9L+Lsj9a8XjkYaBHa27aWY+X+fRsgFZsFJ
        KrAPH2aCThpZ26/uf29NmyPWs2yRrRA=
X-Google-Smtp-Source: ABdhPJwouXACGC8aAisgQWWdAr7/BqE9uKzKdRmP+GLCLsWqhmqsALG7QCgd11N/MkFP/KnUHsfjPQ==
X-Received: by 2002:a5e:9e42:: with SMTP id j2mr327048ioq.87.1602618311570;
        Tue, 13 Oct 2020 12:45:11 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id b3sm677595iot.37.2020.10.13.12.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 12:45:10 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] docs: networking: update XPS to account for netif_set_xps_queue
Date:   Tue, 13 Oct 2020 15:45:08 -0400
Message-Id: <20201013194508.389495-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

With the introduction of netif_set_xps_queue, XPS can be enabled
by the driver at initialization.

Update the documentation to reflect this, as otherwise users
may incorrectly believe that the feature is off by default.

Fixes: 537c00de1c9b ("net: Add functions netif_reset_xps_queue and netif_set_xps_queue")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 Documentation/networking/scaling.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/scaling.rst b/Documentation/networking/scaling.rst
index 8f0347b9fb3d..3d435caa3ef2 100644
--- a/Documentation/networking/scaling.rst
+++ b/Documentation/networking/scaling.rst
@@ -465,9 +465,9 @@ XPS Configuration
 -----------------
 
 XPS is only available if the kconfig symbol CONFIG_XPS is enabled (on by
-default for SMP). The functionality remains disabled until explicitly
-configured. To enable XPS, the bitmap of CPUs/receive-queues that may
-use a transmit queue is configured using the sysfs file entry:
+default for SMP). If compiled in, it is driver dependent whether, and
+how, XPS is configured at device init. The mapping of CPUs/receive-queues
+to transmit queue can be inspected and configured using sysfs:
 
 For selection based on CPUs map::
 
-- 
2.28.0.1011.ga647a8990f-goog

