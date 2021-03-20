Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF91342FA2
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 22:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhCTVJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 17:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhCTVJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 17:09:21 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC42C061574;
        Sat, 20 Mar 2021 14:09:20 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id 7so6708907qka.7;
        Sat, 20 Mar 2021 14:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vzWME/XuekcEcQlH0cQ+Enyts6EE84rdTzIRzesN/to=;
        b=CGGCu4vBfWeBGeZpGkbovZsTFUBiFgUmUl1yZkVXA5tPCsTdIP6UcWj063ZijJ0d1P
         9e0NbVY21NrJ5OiNQW7n8yMy5GuTjHvEAaXfScc6Pj4xCJkVY+2laDCx4Gk4HnqI78qy
         PSpALBYdwKpCcRjj9dzNqdnTqp2R5Wz9tyqEW991K8wrTJJ1bNfzyODnT3BKPYLo3YPU
         RnMNwbphnknIyS5DeV1nWsIOJoyEWGfak30IwCysWz/ivIiutICYgiUJDqxeMXg4Loar
         6vT8xF0AtjlyiQsMf5KDeuOETMcZ05onT8mTadImYdaKeINkkRwE3reXITvGArp/koMe
         Ii8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vzWME/XuekcEcQlH0cQ+Enyts6EE84rdTzIRzesN/to=;
        b=b/8v7zvC3cc/RXibWmYPkMw1fKHwEtFHwDJASqD+vZRHe8HuLgVz508lh6NlUolygu
         Bmn4HgtfYP3MeRUw2vWPtD8o9ZKuWvoIdKX7IQFCY69AZCYTPfr3qLG81jPRwOYpneWo
         czUm+XDkwVhDO58W5bRaV0dbAAFYsHiVBwQ9XV7T64nSyP23po237VdxVVoEbvcjM+Cq
         Wsf2I0GkPCV45lFF0xSFwo1nJwR2j7oYSl/oqboUiCCAKI5w1rXQeME6RrRfBF8GobTx
         ltV6lSH9KHzOQ/nMYZTXOPU5JH6yYNmOxW6I22hfLDVv5Qw/J/cKa7+OqTN3OfMmhaWs
         rhfA==
X-Gm-Message-State: AOAM531WinScqVQu8pzBFSpjaw0bT3MqPcevlCpuYTBqfRRB3Y9USHWm
        DItLU0Zcu0/azjw6PQZ6kcY=
X-Google-Smtp-Source: ABdhPJwsrQAyD5fRlq9oaiTV5wq6RS+aWaHuW009fWcIgk/k/SedTINW6y/LQD5JP+haJIomTppXRA==
X-Received: by 2002:ae9:edc1:: with SMTP id c184mr4401047qkg.453.1616274560087;
        Sat, 20 Mar 2021 14:09:20 -0700 (PDT)
Received: from localhost.localdomain ([138.199.13.205])
        by smtp.gmail.com with ESMTPSA id p1sm7493193qkj.73.2021.03.20.14.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 14:09:19 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] docs: networking: Fix a typo
Date:   Sun, 21 Mar 2021 02:37:03 +0530
Message-Id: <20210320210703.32588-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/subsytem/subsystem/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 Documentation/networking/xfrm_device.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/xfrm_device.rst b/Documentation/networking/xfrm_device.rst
index da1073acda96..01391dfd37d9 100644
--- a/Documentation/networking/xfrm_device.rst
+++ b/Documentation/networking/xfrm_device.rst
@@ -50,7 +50,7 @@ Callbacks to implement

 The NIC driver offering ipsec offload will need to implement these
 callbacks to make the offload available to the network stack's
-XFRM subsytem.  Additionally, the feature bits NETIF_F_HW_ESP and
+XFRM subsystem.  Additionally, the feature bits NETIF_F_HW_ESP and
 NETIF_F_HW_ESP_TX_CSUM will signal the availability of the offload.


--
2.26.2

