Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07416259F5F
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 21:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbgIATql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 15:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbgIATqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 15:46:40 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463D7C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 12:46:40 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d18so2822419iop.13
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 12:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=WJSK0rAqcArA2MbbO3PFbhqleerexamenNF30IAiUpI=;
        b=wqHEyj3/+ST4DPyyyuU7wRZASj0wGgKzq+d3bwhxD53q+d+sXHisgRPaZCJUflgMTz
         0zXAjdhSn7gaWyI+aGJ70dtvg3xFY/U5e6804Affzt/N2FaStoSia2bU4GzepQMkZ0a4
         dd4avOphb4Tf3QOVjVeykp7acvjeT3Yz4S873b4MKQzuomADOP2qEwixH2WizK+gLWk7
         wVTrFHZvHprrSays6Sz5pUdwc23d3U/ZbW8hMCk2oxXiWyFahENvdaN1kxOU3mryxjS+
         HqTAG4CpMomTrKNvtu2WNZe+tm3tv+TUh4KIs6mcyxc7egknMMZAQy8X4jQ4sqn4G83r
         9wQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WJSK0rAqcArA2MbbO3PFbhqleerexamenNF30IAiUpI=;
        b=ofOp7stuS0R9dP5eehU7A1o5DOYQDJQixMvCnghuH19834Uw0gmnvsKCF8aUEHqZnS
         wiA650IHj6HC44ON9/OfPrb2ZV1NARAEEFICZdHUgALP62gkgq/r/7pgfrCkkfY5EdgV
         mOBposPBTxwSbVIzkiLbPw2ENZc81EkSyXFj42kN8K19kaiH4WSSRJBTNceZ7/f4BsUv
         4C0HkrWdhn5UITt7Fz/QRTNwMbIVD0ZzYf1n0aE6QKYdM/Ra4lncUv/efwQRXYSkl9E+
         MLsExueSxLchj+LxAoCsXvafSl47rWAeBb1prZpU00jmPGSDQM81O8PUCQ84o9u/YJHX
         hGEQ==
X-Gm-Message-State: AOAM530mD5DwRnxu7ylnquDJEoQIdfETnZcqa9RSaNnwmCiiaDxU19Md
        hZqY3GCB2afNVj83JZIlfceqQg==
X-Google-Smtp-Source: ABdhPJytsZbPaOOExq8T/DwvxSPEsykmGTHsqxFpIY4v40hdKHNrLZNssp55YvebIaXU7OyY6KjQoQ==
X-Received: by 2002:a05:6602:2d4e:: with SMTP id d14mr567876iow.127.1598989599652;
        Tue, 01 Sep 2020 12:46:39 -0700 (PDT)
Received: from mojatatu.com ([74.127.202.161])
        by smtp.gmail.com with ESMTPSA id t8sm1067730ild.21.2020.09.01.12.46.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 12:46:38 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel@mojatatu.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH iproute2 1/1] ip: updated ip-link man page
Date:   Tue,  1 Sep 2020 15:46:12 -0400
Message-Id: <1598989572-4694-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added description of link flags allmulticast, promisc and trailers.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 man/man8/ip-link.8.in | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 367105b72f44..f451ecf3418f 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1917,6 +1917,28 @@ change the
 flag on the device.
 
 .TP
+.BR "allmulticast on " or " allmulticast off"
+change the
+.B ALLMULTI
+flag on the device. When enabled, instructs network driver to retrieve all
+multicast packets from the network to the kernel for further processing.
+
+.TP
+.BR "promisc on " or " promisc off"
+change the
+.B PROMISC
+flag on the device. When enabled, activates promiscuous operation of the
+network device.
+
+.TP
+.BR "trailers on " or " trailers off"
+change the
+.B NOTRAILERS
+flag on the device,
+.B NOT
+used by the Linux and exists for BSD compatibility.
+
+.TP
 .BR "protodown on " or " protodown off"
 change the
 .B PROTODOWN
-- 
2.7.4

