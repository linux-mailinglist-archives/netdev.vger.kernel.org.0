Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9487323ADE7
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgHCUD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728229AbgHCUD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:03:58 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D9DC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 13:03:58 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j21so1958708pgi.9
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 13:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wrp4+AicanHruxIaFqv3228ns8i0Kyo7LN4QNXfR4Og=;
        b=n3ZAJlQ04kOq7FHF+QoWaYzlZmVe7RiZg1yuKBdHG7SEuee3qVtHNQQKq7wXzr+0Cr
         BNLl1uf3D1GrSAz+V97oE+f+9BiWtcb+5mDE9zKYe0ibELEcg/UH6Tnyi0oyDeIu+zI/
         /Wzgu4TWGqNOboNzHcTrj+a7tTFRd4H/2Q0Nv9CfGsOo/pC/vWoQyornVCpjaUnbMOt5
         cBlZEvXA9DBdNDIx9OYIgkQeUttIXt+DDsmVHsM3iPH+HLg0wCVUWKJEy2ftj5RRudkj
         lp4GvamLqpzefja6eznmCoaY+NZUZv7ydSoMf7aIkhkU2b6IiN+kUxLZ/Z05sBxZ9fgz
         TB5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wrp4+AicanHruxIaFqv3228ns8i0Kyo7LN4QNXfR4Og=;
        b=eaZ4Tmcj0r3ZQZbxb79DNxrNtPRnUCDwqxFVAMnYvWEFiUthgceo9v4nL/vZyGWBFq
         8RgJWlPRSGYoG9XbSBEpIxkwhG7wJcaWVSK9jnMEuW/8ld1Wv9Z4TbFuJqoyJccET40H
         JkmfKcj4tN/IlrCiBfueQM9WdeCtTnNW2AZ0GP10vjppn/uCCgQgoYC5WbC38FKuRlFg
         u55RUAw77Xw6jdACvI2lbZTWqKF1s8ziYUnUdveG1xmCJHZNn9vVWa17vVONGRMumQi+
         xTMuHxdfG1DOrxcrgqNFUhyoDlEPc0v5d1v5PFODlMxUvyniKdFfAQfSvJvNedvAohzZ
         rYMA==
X-Gm-Message-State: AOAM531TxT3qU789UP4Gqhl513vhvUc2TIIeCxVCRDqQPm/NqJGD3dTu
        DgkIwoDoXZnDPbMDBFmmfrLNFIKS
X-Google-Smtp-Source: ABdhPJyQTBL5Kqp48bYOTBeQef9t4dmAeTy1/LAsiiJMZdFc1ZMkfRXoyBaanvcpqObp1IsTW549iQ==
X-Received: by 2002:aa7:92cb:: with SMTP id k11mr16968849pfa.233.1596485037907;
        Mon, 03 Aug 2020 13:03:57 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u24sm20017521pfm.211.2020.08.03.13.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 13:03:57 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/5] net: dsa: loop: Preparatory changes for
Date:   Mon,  3 Aug 2020 13:03:49 -0700
Message-Id: <20200803200354.45062-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

These patches are all meant to help pave the way for a 802.1Q data path
added to the mockup driver, making it more useful than just testing for
configuration. Sending those out now since there is no real need to
wait.

Thanks

Florian Fainelli (5):
  net: dsa: loop: PVID should be per-port
  net: dsa: loop: Support 4K VLANs
  net: dsa: loop: Move data structures to header
  net: dsa: loop: Wire-up MTU callbacks
  net: dsa: loop: Set correct number of ports

 drivers/net/dsa/dsa_loop.c | 61 ++++++++++++++------------------------
 include/linux/dsa/loop.h   | 41 +++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 38 deletions(-)
 create mode 100644 include/linux/dsa/loop.h

-- 
2.25.1

