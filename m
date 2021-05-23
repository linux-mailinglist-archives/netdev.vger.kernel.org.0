Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D658238DBAF
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 17:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhEWPzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 11:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbhEWPzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 11:55:44 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4481C061574;
        Sun, 23 May 2021 08:54:16 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c17so18809720pfn.6;
        Sun, 23 May 2021 08:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b7Fi8Tgw3/EGwzBuNTdXnQY8qPAFscbMTJSOz3ZIkdQ=;
        b=mpBlodu2A+CJ34Dl1pnuiszec02Kr2XM7/2zc4V8QgaljDRruj8SlC2zHaRUbPW+O1
         hrP5IT+DQkKTpM+Eem4VVC4ie/Gwc2RVkj5XYSBCB6fseCqudiE7JjabLRQmCXYRARvv
         3+LNMIuTCiDLVe1MySiIwMcdnOE/cnX9bDXwbn4XzvF647lADOvZXpbJU9eaulMmhuDV
         hPF3qf4hZhZyhES/Tj+SvqljB0AQTQ1HQGMXZRqyY2pSS9EFuMx4gVNajR5UPOx9B98B
         84S1GWVLPkYxhDLK6Fw0GD7/mD5DMJhX0VQriQ9w2hH+Xfose/oeKBPsBfvx99jR2J7W
         TNug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b7Fi8Tgw3/EGwzBuNTdXnQY8qPAFscbMTJSOz3ZIkdQ=;
        b=Kng1fB1azas24IJRf7BixushN4QMj5tnJEmR/eglM/Mep9bjECwJAz3ydNPU0C/zep
         VgoE52fj1za8XSXic0Bwiv1m0YjJJcfddZw/6fy8zYPenXWLpsk5crz2erVdW99Pf30n
         d5ZAkYbVSeGAzTxq4g4bLcqnTxwCS8t2lgfj14IGl3VwlLiityNeCVckCkypDz+vai8C
         a1MrYUZYbhFT17LfCL3AIOBp1WLCoT2DPcYjNxsooRTudoLxCb8xlmyiiQS4aT0Wl/Yw
         Daw9g1K+pXX+EH9nw24WldckFisI+b+rF2BnfAzUbK+1SAyI3PPnsTh6/EmV7Y3E7YCn
         GdMA==
X-Gm-Message-State: AOAM530S9Lt9RQzHQICoN9dz5zQ8XuLPTVLNKuLAP7D+53r5iMMeZmYD
        kUCuTbAPuLl3Jcf9WIg0cZ+bt5pGsSUl2A==
X-Google-Smtp-Source: ABdhPJyRRWHjS9Uh27BTQbDIFvn5ooWhvQTvZAJ3fattwLnhtd3dSOP+tx0pLFMSHka+FTQLdz/4zg==
X-Received: by 2002:a63:5a5d:: with SMTP id k29mr9029740pgm.215.1621785256147;
        Sun, 23 May 2021 08:54:16 -0700 (PDT)
Received: from localhost.localdomain (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id t133sm10022765pgb.0.2021.05.23.08.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 08:54:15 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 0/2] net: r6040: Non-functional changes
Date:   Sun, 23 May 2021 08:54:09 -0700
Message-Id: <20210523155411.11185-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

These two patches clean up the r6040 driver a little bit in preparation
for adding additional features such as dumping MAC counters and properly
dealing with DMA-API mapping.

Thanks

Florian Fainelli (2):
  net: r6040: Use logical or for MDIO operations
  net: r6040: Use ETH_FCS_LEN

 drivers/net/ethernet/rdc/r6040.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.25.1

