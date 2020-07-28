Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0DE23106C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731789AbgG1RGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731684AbgG1RGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 13:06:01 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053CDC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 10:06:01 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t15so127242pjq.5
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 10:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SajCbeRjaoHVqSZj+JcE5NKjS9P+HzPthnniJWh905E=;
        b=dE7BpXvjexjjbuj3KawcJoyu6BBciTS37hsCvm7Os74iLIEg4y01hojJDDI0VrrIga
         SdlEbJNZcYefrNacShvUBCuCsqd3y/CLB9FEEI6/lSpYku/vGWyAqcVbCucSKlY9HfQ1
         Ix65xkSJ2vM8ICn7Q8p4H8tV35xZFiUKg8lCkNeVmxHok8WlF8kMJq+5E0utcuMQa+s7
         qUxy4s73mpPYsyCGsbN9ccN/fjT+LLs/C22nsK7Xuc1rA1kNhzVRct7IVT2V9J4H5oxg
         tnqZK+COCey24W/fIiA0xtsJrSNUJdLEmJKx4M3NI3N1PAAtAIzo2LuEA+PbPHHJtsSU
         DBfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SajCbeRjaoHVqSZj+JcE5NKjS9P+HzPthnniJWh905E=;
        b=N0wtmzNODp+nZWYqFZpFz71ZIrCYOyWFSaYgSvby0NuDmuLBPZo6PTrULKKo/kbjr/
         nNcnf/anVs+Usevq5cQa4LRV5Mt/0OqzcpoUX+kK39PYi9Wx6OkQOWGKUocLsP7Z/Sb2
         1NvwvUKfCC8qn4a6LKbvhVKZ/t3ePHAInnZNNEu9dE+7/rIU39r/DkYP/NyIYaHSXQz+
         Y6qgAmw08ci2+0fjEQrfl1VNoGrxm4N3cZHLv4VIHNvY6/BArVL8YbE2QtFR3hAaj9sN
         sAv9xE1lu48dDlNuGZW8ehdawGKdz9lFuIvePBtxDMxMZ01MXXfCKr+p8z3NoVosrJxA
         +2BA==
X-Gm-Message-State: AOAM533cPMAwa+Xom1j3HJs72NDw07/6J6LTlCIcP2Y0kVCeRxzAuka8
        mihNWWQQMygHKM7GCf/cAWpsY9bG
X-Google-Smtp-Source: ABdhPJx+oKJZDEnZFMC+nL1ZBWxuoCsD8o1JB9kB+Pt3zKHj11nwoTRpKdoubUwtR2Q8rm1UA1FlRw==
X-Received: by 2002:a17:90a:bb8a:: with SMTP id v10mr5302896pjr.144.1595955960279;
        Tue, 28 Jul 2020 10:06:00 -0700 (PDT)
Received: from localhost.localdomain ([42.109.141.4])
        by smtp.gmail.com with ESMTPSA id y9sm3632982pja.13.2020.07.28.10.05.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 10:05:59 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        corbet@lwn.net
Cc:     Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net] Documentation: bareudp: Corrected description of bareudp module.
Date:   Tue, 28 Jul 2020 22:35:52 +0530
Message-Id: <1595955952-2839-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

Removed redundant words.

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
 Documentation/networking/bareudp.rst | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/bareudp.rst b/Documentation/networking/bareudp.rst
index ff406563ea88..b9d04ee6dac1 100644
--- a/Documentation/networking/bareudp.rst
+++ b/Documentation/networking/bareudp.rst
@@ -8,9 +8,8 @@ There are various L3 encapsulation standards using UDP being discussed to
 leverage the UDP based load balancing capability of different networks.
 MPLSoUDP (__ https://tools.ietf.org/html/rfc7510) is one among them.
 
-The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
-support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
-a UDP tunnel.
+The Bareudp tunnel module provides a generic L3 encapsulation support for
+tunnelling different L3 protocols like MPLS, IP, NSH etc. inside a UDP tunnel.
 
 Special Handling
 ----------------
-- 
2.18.4

