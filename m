Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB29259EF7
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 21:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731628AbgIATJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 15:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgIATJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 15:09:27 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD7AC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 12:09:26 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id y4so2885566ljk.8
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 12:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IWbBBOFh9y1LodzWhVlcj9kDNUA4o1ASXsC4hboghNg=;
        b=dIETVfDV3xARTLW4e7f0WlYW99eubq7ms7RXSeqIb5/eTr7NUDWD/sGpnN7tszX5Ao
         CET4DhWAKEvgKOqcdPNde7HKi/1mqVvkH+Pc6WE+Gf+5st4FDcYvU6eIhcjit5d31WDE
         3UV1qTtmFnol5WTRDg/AKulHo9hQx7MSF6KFknWb66vqHVYSiyzEM0pMFLixwjgr8i+X
         K6yysojOR4zxw/i/+58+oNLR7uO/Fq4dbeLUPofjR9/BHOfXzcR7iaddT0y5WymEcxjT
         XfXc6YITCkXgRVMn/pNj1rlW90cQwYVZcmVemydU1kEY/GP4fQnZuDinoRy+LByoYFos
         SAFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IWbBBOFh9y1LodzWhVlcj9kDNUA4o1ASXsC4hboghNg=;
        b=V4jwEXX1QG3CSEOa8OF3xn6fw5+VeOT9o6qtDnrXHKMIsNmpB3REhuLC9pIj3LeuB5
         dORJQOhtI3Kjb7TeNE691/GHIJmwd5NIm9GKGTjiBaETzK3FWgy0Ht4WzrNg7WJudK/b
         nVNtn+zJelaxixue6X87rD5ire41/TkKOjwHREZmHDjwr8BX3vUGynJussAr8Lo/gwyQ
         5vb9OdwBdaSwfnMiEbx6dt+L1XnPof6k6VW3v0DEuiL6+5ByFHQBi4aNxMkoLfxwrukV
         FepFL6DC5BLV01pE6rjVjg/6ySiXGHpp+vjOBbt8xfBy52SJBP2CYbFRLVVaucO+TAO7
         462A==
X-Gm-Message-State: AOAM531n4xhtunnJhmXnCm1zccgh06uYvF2RbhgfeiJYAddykd2kpITl
        ixtLEF+4LP6x5alFOVBp8sr73Q==
X-Google-Smtp-Source: ABdhPJzrdM06UOmWnBKEX1a/a2qCSiE3BFIVDfPlZoCsRHy+nGGdesTs2Po4Pyo20PqnnNHhRhjeTg==
X-Received: by 2002:a2e:a304:: with SMTP id l4mr1339828lje.35.1598987365012;
        Tue, 01 Sep 2020 12:09:25 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id j12sm256945lfj.5.2020.09.01.12.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 12:09:24 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH 0/2 v2] RTL8366 stabilization
Date:   Tue,  1 Sep 2020 21:08:52 +0200
Message-Id: <20200901190854.15528-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This stabilizes the RTL8366 driver by checking validity
of the passed VLANs and refactoring the member config
(MC) code so we do not require strict call order and
de-duplicate some code.

Changes from v1: incorporate review comments on patch
2.

Linus Walleij (2):
  net: dsa: rtl8366: Check validity of passed VLANs
  net: dsa: rtl8366: Refactor VLAN/PVID init

 drivers/net/dsa/realtek-smi-core.h |   4 +-
 drivers/net/dsa/rtl8366.c          | 277 +++++++++++++++--------------
 2 files changed, 151 insertions(+), 130 deletions(-)

-- 
2.26.2

