Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6D81A6B61
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 19:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732829AbgDMRdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 13:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732820AbgDMRd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 13:33:29 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46034C0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 10:33:28 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ng8so4125318pjb.2
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 10:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=MZIZpQoCDypq2s+4AqWCWc4JNSCo3evDNkWnrK3Rlwk=;
        b=X0tObaku8dM7iQNPW9fWaO1eLbyUCn4LHhtq3qZ70inm6VnoOWdY6Y39CIL+cciy0x
         frBcBCm77xjBGKufkjGG6RlVxPppL/l4zc2LXcnGjDFXm8es5HOxSVP0nxa/e+8ODDBj
         AzZJvItxXvm3t1TD4dTnlyenZy3rSEQfjeE8GbkCy6NAJ3N5gPu1iWfYVnBNV/YHqumu
         t7MkIq1bMwBeR/bmwmozNsE6FymrzAKPn/sBQjvHNbcxtGZKHUrwtTMAQW8lCCVvdr/2
         AOiO3yaK/sYGktbTAZ2kCsNR6aQPejK6JP1ckZfMNmeXLFDltFq4lr7otjtJRQCnV+Ga
         YK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MZIZpQoCDypq2s+4AqWCWc4JNSCo3evDNkWnrK3Rlwk=;
        b=GoXom2cJVBRftZRWhtAY0t7sKyq7Cm8lDPVIHkFYoMnAH9c7Dzl4D6MzbfqPMopWVe
         1bH/CniT11qlr8RsNsC3aE1ux9Zqwjzv363h4FUMX+nZma1MtAyPa9HyFeJGwFICt1kA
         zXMI5WUE1zKhW4TPMh8Q14YHRfm3CTbrad0o5Nw0sppailrQj7NM0giliMK53Y/0K3RD
         IIZQ1CfRIB/zfTuqNUWpkdujjjq2Y5Ff90zLRSRWdWdV1uAl8a9EsMbFEjzMA1eJIL7L
         +joQz2N3uVcaj771i53C3id35O9wTxqw5Jb7N/3TYaqzpWi9z6Tnhq+pMEefsVMX6OYu
         DvKA==
X-Gm-Message-State: AGi0PuZsRGU3xFEI5oPTeVzzGt/yRRNap/tPfqhXewKDlKkJWJ2aDGlB
        6ChALGTuZtBLl6INe1vg2jS+nQvny6M=
X-Google-Smtp-Source: APiQypKcZGOOpmt4Zj/kL46NK1SPgg/xS5ZBA8AsXZtveC7swYneR5PGW7lBnOI5tbsCSZI9b63TqQ==
X-Received: by 2002:a17:902:61:: with SMTP id 88mr18988242pla.30.1586799207846;
        Mon, 13 Apr 2020 10:33:27 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id y71sm9234409pfb.179.2020.04.13.10.33.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 10:33:27 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 0/2] address automated build complaints
Date:   Mon, 13 Apr 2020 10:33:09 -0700
Message-Id: <20200413173311.66947-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel build checks found a couple of things to improve.

Shannon Nelson (2):
  ionic: add dynamic_debug header
  ionic: fix unused assignment

 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.17.1

