Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54363DE316
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 01:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbhHBXad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 19:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbhHBXac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 19:30:32 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985E9C061764
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 16:30:22 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id 185so22274931iou.10
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 16:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=op3PyaJRoHyyueBpTrCno9Zdd5F5AqkxWOll78YzH7I=;
        b=CBNttCRZfwAae3XbPFiOhRaWKcN9FIfxVNyj4IvT4tQxmPDx2Cyd4G4h1Y8mmY5cxV
         bCvPBsBu3mmz4F9koOqS0kAlYaZiexAFCMpfvpSqlzFjTTLDyYBfu2gQsmeJr727lWc8
         w4BNFKl9Y6J+xKIeHMwORkLHUEbwXp+dqfEzUol+4EYQEPG8C/u+X2gU3AAhR3zPFDsn
         AP7B7V6q1Xd/+F+nL8Yikilg+1Ljm35rK8WBPsC15I1zdCUse/IhMdrkdm1+aEstYsfA
         lZ/10PcAc9tvEw+AkydPJRsi+yzQueyfLcr4gX2Xneqhk+VF0xiQTu2+TYh8aBKozVP9
         /b2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=op3PyaJRoHyyueBpTrCno9Zdd5F5AqkxWOll78YzH7I=;
        b=LuBw35bzhQi7Ul0iPR7zWebEOPljMi5V61WATYdodQ8WYN0ybo6LJFF+GNLAuX3hwK
         6ML2+yda+nds/zXv6mRsylsG9Rei5KXJzwMVZAoioxjCdluNbWfHtjKC3es60OodEDc+
         ZSW2HoFqwLzYcFw8j0jZY38mTy5H541WAFd+p7XbM3pAC0SP3w8fi69cNZLneA/peo1K
         F7UBe9AGwUmTUNLGORLcuFI0UzwWcVke2ecf+gQ9XZviicixEivxIHy9WMca0OIWW161
         c6xwuto3bGuBktLTHvs6+oND+Z7tImZYohKngZrvK2WGrHUItm9piZGhrkrrLkZlVXCP
         sPpQ==
X-Gm-Message-State: AOAM532+YpEOI9ajt1w81WbJhyiN3bB4hgzhJTuwa4KJq9i4oWxS6bcA
        w7ylC5c2c/hO8Q9DebniDdX6EA==
X-Google-Smtp-Source: ABdhPJx1fsU0oGnfzWvUepv8E3UYK7bcTVPwR54Lput3O9xuMtSjgvYVhjLSJfSMh6Ttp6/qkTuo7g==
X-Received: by 2002:a05:6638:381e:: with SMTP id i30mr16990000jav.17.1627947022075;
        Mon, 02 Aug 2021 16:30:22 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y17sm460883ilm.0.2021.08.02.16.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 16:30:21 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, bjorn.andersson@linaro.org, agross@kernel.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/1] REVERT: arm64: dts: qcom: DTS updates
Date:   Mon,  2 Aug 2021 18:30:18 -0500
Message-Id: <20210802233019.800250-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David, Jakub, I'd like for three patches merged into net-next to
be reverted.  Bjorn Andersson requested this without success a while
back (and I followed up on his message).
  https://lore.kernel.org/netdev/YPby3eJmDmNlESC8@yoga/
I'm now trying it this way, hoping this is the easiest way to get it
done.

If you prefer doing this differently, please let me know how.

Thank you.

					-Alex

Alex Elder (1):
  Revert "Merge branch 'qcom-dts-updates'"

 .../devicetree/bindings/net/qcom,ipa.yaml     | 18 ++++----
 arch/arm64/boot/dts/qcom/sc7180.dtsi          |  5 ---
 arch/arm64/boot/dts/qcom/sc7280.dtsi          | 43 -------------------
 3 files changed, 8 insertions(+), 58 deletions(-)

-- 
2.27.0

