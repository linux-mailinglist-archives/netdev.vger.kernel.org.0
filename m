Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7CA4380CC
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhJWAAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 20:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbhJWAAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 20:00:40 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D00C061767
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 16:58:22 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id h10so6017970ilq.3
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 16:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=squareup.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zag9BI4WnzwDMKirvs2JgqIo0CDKPVykBXhBbv4X39Y=;
        b=esMSn5hJb8IItHgig97yRqtzEPLjQ5wvKy21dsq93D/9KdO5VckJBLoUjO6OKQn3nT
         sjn/zPdbJbqZnBvCbkO0ga/S5+gs+MJxGh8knw2SyqQD9f4bZda4Jh/opwtwps8Zs8iZ
         iDWlunooI0AvB6g2PubmbSUAa1aI+n4mDVSNw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zag9BI4WnzwDMKirvs2JgqIo0CDKPVykBXhBbv4X39Y=;
        b=0gMqiz5oc8W/bpou3dJUrxqyHfmcjXvZS1tKR/TIjKtdBiATgxsk72dMAKWsREPVxF
         43l6VDgZCBvBWcic1yu23OM9uHvFrMMAjcN5Z4++Mz4XEnN4QhjqIcTMRp7+O3UihuEO
         0OP+BO4L7AflkBpfDuB67zYfVfXNf8sfW1ub6MVOKf9lHIJcho4QJkO7uWxvhiCDsKAV
         B6WsZAWXGcX6PtukVIxpJadHlj3sV1aEHmEzNFpO03b48Rmrxri6wdz2PaC44QB8D+MP
         GHkQRN3D9Il5xQb3+wwQbBTcBPq/a+SLZ78P+LuM3t84a/+/QRjBVHnYn9TAVlHf86cj
         dTHw==
X-Gm-Message-State: AOAM532Y6LpH6RLdCvO97zXa9XMDAMwq2GssbJss4uXxVEl0QMtM0jal
        eT1kYYjZCdf22oZmCdLx+/aL1Q==
X-Google-Smtp-Source: ABdhPJyfL1SYIYp4iGWUhti94T+a/ZkkCY5DCwSKnOOb5IenpW3zYjR6X0q/mPfbnsxuNMOTOgM8uA==
X-Received: by 2002:a05:6e02:156b:: with SMTP id k11mr1766148ilu.115.1634947101373;
        Fri, 22 Oct 2021 16:58:21 -0700 (PDT)
Received: from localhost ([2600:6c50:4d00:cd01::382])
        by smtp.gmail.com with ESMTPSA id g1sm5163277ild.86.2021.10.22.16.58.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 16:58:20 -0700 (PDT)
From:   Benjamin Li <benl@squareup.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] wcn36xx: add missing 5GHz channels 136 and 144
Date:   Fri, 22 Oct 2021 16:57:36 -0700
Message-Id: <20211022235738.2970167-1-benl@squareup.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Think Bryan's commit was accidentally lost during upstreaming of his original
WCN3680 support patches, so I've included it here.

Omitted Fixes: tag as this was a regression from downstream prima, but not a
regression from previous versions of wcn36xx.

Benjamin Li (1):
  wcn36xx: add missing 5GHz channels 136 and 144

Bryan O'Donoghue (1):
  wcn36xx: Switch on Antenna diversity feature bit

 drivers/net/wireless/ath/wcn36xx/main.c | 2 ++
 drivers/net/wireless/ath/wcn36xx/smd.c  | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

-- 
2.25.1

