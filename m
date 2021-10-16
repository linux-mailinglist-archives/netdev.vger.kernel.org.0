Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DA8430070
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 07:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239419AbhJPFoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 01:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239417AbhJPFoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 01:44:18 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DCCC061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 22:42:10 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 5so16160823edw.7
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 22:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4Ve9yp/G25WGVQ9lTwderqeao7P0IgztY+IjSYCW8UE=;
        b=lbz1eYZyUhn0UWEygMnWjrFcv+JokqSwDfl28dQpx+i05Jei076D00in9Iae/fOaWR
         mKqO43iwPOwOlQ8xDEhW1BiIUcuHbE5DhoxgTTJd+DFbGcQghv4nubqs97FYhHfYic47
         Jl7hvnuXF+BpE6O+tPjzGPol5FZ0fW2OG3oYnMhNnHmSr8tt/UAic7pLKeqmIePm/18V
         cdJVmmwkwovm9xAtLBqgqUk8AWgDXwb/xNcSRfIZanpLkJCJrR3+qew9p0bHiq8h5332
         enuzYkrdhHCI01BgTPmlAoypVvUrVSEOyHDmhNEBx7AX2I09w92H5gCK9ebKcwR+lqOn
         Xmgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4Ve9yp/G25WGVQ9lTwderqeao7P0IgztY+IjSYCW8UE=;
        b=uSZ5VH26wefslp8B77gFUCa+dKfBSzmaMnK7cEtctUe0IHAF10WBPAbMM53HrSzmN2
         SAlQNa/+6E0mn15V7kOHiI/ODkjOIw+7B8euwErZKTcQBaCrbDDteX3cq2PvBy4O5imO
         FAGakJOpCSlaoU0B+q9kQuj/2kXC4/5QarZ3+jq14kd4L2zuZLD4ydqWmZCSbP35C6U6
         JEUiJXlUwhRLr85Y50sxL365fPLCw0kVYsWxLz7zjYvPPwmoTmVb45x54cvgTdT1CtcK
         dB5xZVaSVp61qi8W5dlMPyKxxCReHKlz+YUlG4cx5TtOesF7gFP7ISjhUtp0ZGSiCjvN
         coQA==
X-Gm-Message-State: AOAM533N/Ci856u7gjE75oSE6p/XgkUi4iDFQ3Kig+cOMCaZoEfrXq/t
        xNtk9c+nT0tzLVs5BJYSzv/hNbWeAFdZvg==
X-Google-Smtp-Source: ABdhPJy2TS7E4x2/70j2sW8cp9KPimqEYj0pFHnSoZ7tSroDCsjjlbD0AelNKtPNb28FzAKRI6x5Mg==
X-Received: by 2002:a17:906:b19:: with SMTP id u25mr11851256ejg.36.1634362929379;
        Fri, 15 Oct 2021 22:42:09 -0700 (PDT)
Received: from localhost (tor-exit-relay-8.anonymizing-proxy.digitalcourage.de. [185.220.102.254])
        by smtp.gmail.com with ESMTPSA id lm14sm5589548ejb.24.2021.10.15.22.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 22:42:09 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] Small fixes for both macvtap and ipvtap
Date:   Fri, 15 Oct 2021 23:41:36 -0600
Message-Id: <20211016054136.13286-3-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

This series fixes the common errors in both macvtap and ipvtap.

Jean Sacren (2):
  net: macvtap: fix template string argument of device_create() call
  net: ipvtap: fix template string argument of device_create() call

 drivers/net/ipvlan/ipvtap.c | 2 +-
 drivers/net/macvtap.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

