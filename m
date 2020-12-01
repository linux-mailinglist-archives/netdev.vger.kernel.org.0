Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AB92C93E4
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389110AbgLAA0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 19:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgLAA0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:26:35 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907C4C0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:25:55 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id o19so125461pgn.10
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=V2DCpCoJ4fXcVmTESaD1jdjEw8Si05ZR8LmLLV2FkNM=;
        b=xbJCmDd/olMeAMcpmQM57CWUeYwo380JIrFmAs6eu4jFjj2HRTU9Fwq1kI38GWZNc2
         yfsoqvRzhPwPCbTe+o+sakB7EtFPp4moifUAvPVZp4eZHzG7SZcjeCBHqWcoTphI/dia
         0H1PeYoEWBD2z/OnsRPP6xrg8CWqXKAdwfZyNgag7k1YHW8Rqj3xOxbmW7gz66CbX1XU
         4yTmx2UJjFK3X2cWU9IrpbnkhHMTB3wMMJ7ite1TMmC8L2Ya01LyaZnTlkQKTYaLhelO
         ip3/56xlcAQo2NOHjO3z7t0SrzSKPItn6RiWj2uyd9dETaAMwRIQ7Ohy12rVf3dCXVIW
         V5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V2DCpCoJ4fXcVmTESaD1jdjEw8Si05ZR8LmLLV2FkNM=;
        b=LcByx58TX34SPBGJJkG2fxmFryT/ky1z6xhCJQqeCKpJlsCABgU+cxUL75NSBJnmaQ
         wgafR4jNE29/Qyjz9b1VJotBQNEyc23LlwzHHxCyNV8jpuLYscxZtdwarJuGIj0K+Shx
         Bvjl0jOvd+IfxjTTp6xJuiDgDwDrrxp/MkMwwQpbAMRXRSlaVq2d3y0Xjmd4kAUQ8OP4
         fhvhd8W54ViP6+og6lWsX12fgPqSqZn8235GuNU8yTs38cFBBKK91AX/tGMqFu/2AUOH
         dvD3w/4Tk8QaksvZuT91esogXTa/uRs5bswL78+IdYlId1QtEUhadfm6KXgYCVqF9sBz
         ly1g==
X-Gm-Message-State: AOAM5302yqRVp3EX57uXdwwZLiHqZMr6yMJ2/Ex/44/Ebw19m0CHnrcK
        N+12DAwNNNpidT4p60Tv6HPVvL0vZxK3lw==
X-Google-Smtp-Source: ABdhPJzNMtmkR+jrpDcpMdaRTr44JvpV6ylrsd3pTkFHT8KmeLGXWlpj95mn2fy58woxCYNkNQd1pw==
X-Received: by 2002:a63:1d26:: with SMTP id d38mr20699982pgd.246.1606782354933;
        Mon, 30 Nov 2020 16:25:54 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id q12sm172632pgv.91.2020.11.30.16.25.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Nov 2020 16:25:54 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/2] ionic updates
Date:   Mon, 30 Nov 2020 16:25:44 -0800
Message-Id: <20201201002546.4123-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a pair of small code cleanups.

Shannon Nelson (2):
  ionic: remove some unnecessary oom messages
  ionic: change mtu after queues are stopped

 drivers/net/ethernet/pensando/ionic/ionic_dev.c  |  2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c  | 14 +++++++-------
 drivers/net/ethernet/pensando/ionic/ionic_main.c |  4 +---
 3 files changed, 9 insertions(+), 11 deletions(-)

-- 
2.17.1

