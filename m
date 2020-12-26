Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71D52E2F32
	for <lists+netdev@lfdr.de>; Sat, 26 Dec 2020 22:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgLZViX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 16:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgLZViW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 16:38:22 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41136C0613C1
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 13:37:42 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id u12so6426721ilv.3
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 13:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jwrBklnpFrL91S6j28ouuHbOiPE4otk/2BurGfWgjtg=;
        b=o0OdlNJf9xnd/Eajm4lzE2BKLNJC9CiHQUyTOC7DjGLC+MQIcHsum2lsX+IC7VfjMc
         s0wKqnuN7cvTl63rMXnQ/wPQ2d6hcRHPJIFd6TX42UTwoOrpS+qBeEmpFyC1lAG2U/0u
         UQnIQxu627aioPvOxhvfUJjtP3wXCzUcUlcjpHamSFv0AEwppehHuUx3SGxL6my69vRe
         AoQL3KVOPhPLh0WWaDi47XLjeGd6GzL6NI5JXaMCZsO36q6cQSTkhDvOXQaV7ybHhRY4
         hY2CgseBf8kkrMK4dcXy9hxNPhiyMXPHVmczQRHEiJ+DCZl6mUbSQ8NpoIVNaINQ1mgm
         9ToQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jwrBklnpFrL91S6j28ouuHbOiPE4otk/2BurGfWgjtg=;
        b=UMhCmfJt+9/kNaAW3qgGW9zaWea4LhZ4UK75qwV97QDLJ6UlK7fPXnLXHxgq6mmddi
         yX1CaMBHAQlCaKHznnRlJeZbMGKAHfJbvgbGtB+ICYLQa198ISlZUW5sBJDqQsmy/+7T
         mUNCyiQ0+YV+d/kKMvlgGfy8mW7ohiOQ8dXyg5XepgfRxuoDf/iNZosWzyCp9af7ZQLC
         thrZRLHqRdGhOmfpvn5BM2VL52e7LSSbrB3doBwu240LpfEmlZ3qLmSd24zZ1q4ldLH5
         TZAp4p+EoKERUDBz2xQ9lDASHBLpNfKowr8ZNmFDt9SyKesZAwxMs/YgpWMnjXszd6LX
         DGuw==
X-Gm-Message-State: AOAM533NeBY9rX0sVZD/pptTNF9Bt5JjsVF3AUMWlXLX//rqF88xuYgI
        632Y8/V/yr7Nvu73/5zNBDX8bw==
X-Google-Smtp-Source: ABdhPJzZ+l2Sckv3oIUGmpFbKZcO9FJlXU2aOjd7ktzXiAAsC4QBNEDHffNrYLpTtWm3xg4szzrtpQ==
X-Received: by 2002:a92:dc03:: with SMTP id t3mr39190018iln.215.1609018661440;
        Sat, 26 Dec 2020 13:37:41 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u8sm30582763iom.22.2020.12.26.13.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Dec 2020 13:37:40 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] net: ipa: fix some new build warnings
Date:   Sat, 26 Dec 2020 15:37:35 -0600
Message-Id: <20201226213737.338928-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got a super friendly message from the Intel kernel test robot that
pointed out that two patches I posted last week caused new build
warnings.  I already had these problems fixed in my own tree but
the fix was not included in what I sent out last week.

I regret the error.

					-Alex

Alex Elder (2):
  net: ipa: don't return a value from gsi_channel_command()
  net: ipa: don't return a value from evt_ring_command()

 drivers/net/ipa/gsi.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

-- 
2.27.0

