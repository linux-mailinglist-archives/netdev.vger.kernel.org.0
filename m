Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE6A29BAD2
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1807527AbgJ0QLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 12:11:31 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43346 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1807511AbgJ0QL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 12:11:27 -0400
Received: by mail-io1-f68.google.com with SMTP id h21so2107280iob.10
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 09:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xb76KyILmdJFbmaWhbSs9tpwNsTwpQlcVNvykjcxVSo=;
        b=b43xlUbeIZk6LA0meZcp4ZPyKd4el3pxHd3dkEWrD/I9HbHm3/Xs5sxVdS07xzzVoD
         LK/D9qkB7lh3D5rsAfYyvUuZRLnpp5zBjrZMriodJOxQL5tMNJ1fZA1U/GqlpEuTzzDu
         xl/dgDfHO8tIpksFNu+iJPcMaQJzxYVZl4NkuwbKS1jz0Xet73F8vnU+kIfNcOln97ED
         Jtsx5xy0AtEfzRUB9QLfp99r6c30TtZkSukXi5eFChQiE3QXLgqOhfFEKyCwxu0LMrGq
         abE9ZrBstFms2mUiwuSVYtvxioIPOSLPxI3d6yI49XfFtSZeVih7DgT/yFrXWYdIrsVb
         tDfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xb76KyILmdJFbmaWhbSs9tpwNsTwpQlcVNvykjcxVSo=;
        b=QeVI92KL5WFJiUb/h1GV13F0Nzt0uUfLSg1Vz988rsECOyT+2R6AlKhXnPc120IxRr
         QqMUEIbj+Tf9i3FP14OKZLhZX7HL6Sbo4d0RBHoEE+UGjgoT9PvblTmP33atvhvu8wFT
         v1hibp+jwkA7u3DRcN7ZBnYa6TDPMEIB3CddaxvA5j9GvrmOyVwZvWn8i4/Zu6MkTU3y
         yJJpWjg8TllOKlMzEsWZ8yqrFRPwR0eylwy4mGIYz7PMUAV7Mr9MdXiNOYDIoPQrHa+3
         bwL+vHyP9t5a6TwWsqIop6zbMlxxyipfe1/DB+kFn4v+9uspLIXtZuKCSxVgmLOmOouN
         FZAQ==
X-Gm-Message-State: AOAM533tKjlQEg9AXTScWpWmAGH//jDF3IZDR1HCpMzlGlVm1NDIUwQR
        cVfsK94feKpYENhJd65Kzlh6ozvMY91ZPIyO
X-Google-Smtp-Source: ABdhPJzRp0TILW2fK8ihc2iCmrGI8kKwZJquUw4rJBOm8m29R5Wr11HBZxOAfy4iqjhOZGmqz9voGQ==
X-Received: by 2002:a5d:8543:: with SMTP id b3mr2875836ios.15.1603815087037;
        Tue, 27 Oct 2020 09:11:27 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w15sm1082264iom.6.2020.10.27.09.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 09:11:25 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/5] net: ipa: minor bug fixes
Date:   Tue, 27 Oct 2020 11:11:15 -0500
Message-Id: <20201027161120.5575-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes several bugs.  They are minor, in that the code
currently works on supported platforms even without these patches
applied, but they're bugs nevertheless and should be fixed.

					-Alex

Alex Elder (5):
  net: ipa: assign proper packet context base
  net: ipa: fix resource group field mask definition
  net: ipa: assign endpoint to a resource group
  net: ipa: distinguish between resource group types
  net: ipa: avoid going past end of resource group array

 drivers/net/ipa/ipa_data-sc7180.c |   4 +
 drivers/net/ipa/ipa_data-sdm845.c |   4 +
 drivers/net/ipa/ipa_data.h        |  12 +--
 drivers/net/ipa/ipa_endpoint.c    |  11 +++
 drivers/net/ipa/ipa_main.c        | 121 +++++++++++++++---------------
 drivers/net/ipa/ipa_mem.c         |   2 +-
 drivers/net/ipa/ipa_reg.h         |  48 +++++++++++-
 7 files changed, 136 insertions(+), 66 deletions(-)

-- 
2.20.1

