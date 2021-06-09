Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929933A15F9
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbhFINtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:49:39 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:55115 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbhFINti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:49:38 -0400
Received: by mail-wm1-f45.google.com with SMTP id o127so4048890wmo.4;
        Wed, 09 Jun 2021 06:47:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PFgz/1tQM60sdhxORV5wAxYQfiArT5ICKQQEdiEUvNA=;
        b=f1okKktLpv/C6EJAqLj5sUc0ihYOfta9XUQlnwfeyjHuewWjzcHkerS0BEcEdVKvsX
         AB+CX5StYdl6Nu2mogw7yo0Uf39Lh94qzupsXGFk83JdsIShkmLIb+QkF5hR5csSwAX3
         9yu7sAl5rA1dAPPiiamxHF+8ffTsiNxo3rKjViq6apRAGEzB6gJxx/BkdpZeaNkXYtOi
         hYYauRHqjhXS7wsmZ3o3bYcvk+p4MP6Zt64sR5+v9yWMRRx9HlPZx7FVFF9tlcXsZjLF
         YiMLKrK46zCZLEg1R9a2qBfVGTq4Bi2cvYjfeePI39FCUb5e876TYv65kR/IdMxQ+6Y8
         INWQ==
X-Gm-Message-State: AOAM53223XQBQmhA+7GW6+mFwoZ9Civ6f28HVcW+9tAesu85TJeReOSp
        LYkU+5bfAxDWB/XeP9iKLySO4ahPuEMGNA==
X-Google-Smtp-Source: ABdhPJwR/kfpu5EHkt6lqhvqu5Ly7EbCJzHmr7xbETCpJJ2qx0IJpnewhq3/CtEnp8o/Z9Opk7iWdQ==
X-Received: by 2002:a1c:5f86:: with SMTP id t128mr10062978wmb.165.1623246446830;
        Wed, 09 Jun 2021 06:47:26 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-37-119-128-179.cust.vodafonedsl.it. [37.119.128.179])
        by smtp.gmail.com with ESMTPSA id o5sm13882351wrw.65.2021.06.09.06.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 06:47:26 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: [PATCH net-next 0/2] mvpp2: prefetch data early
Date:   Wed,  9 Jun 2021 15:47:12 +0200
Message-Id: <20210609134714.13715-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

These two patches prefetch some data from RAM so to reduce stall
and speedup the packet processing.

Matteo Croce (2):
  mvpp2: prefetch right address
  mvpp2: prefetch page

 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

-- 
2.31.1

