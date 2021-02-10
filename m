Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8E0317369
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 23:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbhBJWea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 17:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhBJWeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 17:34:04 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC6FC0613D6
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 14:33:24 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id f2so3727742ioq.2
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 14:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jc0cKAaWwDGgmfaTk/UgFMkJLA66GM85PZScS2V+gQk=;
        b=AsV/JDL0H+XSIovRmupF23EzOLT3l99uwlVTF0UQ4Fk77n72M2Abjgp5pzhFYearBC
         2Q5/6+VZecf2ijlsEKAL95qAF9tYy5FqWvpPr/beakdWoBGTyGx5g1X249wmeJeYoEtt
         nF5SSN8Z+esyomp+A/ke39U2cn2yyDB5l0IsjTgQSSGC/7alKQ+OvmQEndEFEIml2ef6
         zKD0sqGafAUzU4PAr87nRV+NbBpm+VebuhxsWMWmTfe7YTavIl/cX+0Us91L7BASA4qw
         ftUwpt5CaV/69iywQDBAHE8DnGZx0LO/d1IT+lYBkotAoQ18OZFrsyYaivea7Ww8y8Mu
         ZjmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jc0cKAaWwDGgmfaTk/UgFMkJLA66GM85PZScS2V+gQk=;
        b=CgFJoW6pp7jBYNUnfT1CkMePP8A+GbAesAl5FuKkb7/GsfpK8U9rNxiW8Zt8ptPxrR
         IBpsnJ7w0650dj9+XjAIu4klmYJoTla7CCNmmsVC5K+lA6O+P5xYploUyUP388cHDcy7
         hqxpWNkXYJkvSsOCNHit8nW6gIZX2kGtiZCd+tWwHXQULQ3O3l6R2SsGfL++XE+txLHW
         ESnFc49BOIYTHrgrYbmUz/xLf7QXc7mnVhR6PPOsNHxsq9j3vfO6T5aMPS0xc2cKi5ef
         yN/CmEHxNA8C0PTgBcW0l+JAwdjkA5AtSQNaTzoD1iQRmguwyTVnBjMzuZFcGbmdXX0y
         BuOQ==
X-Gm-Message-State: AOAM5339yQT5HZmTjin17U0RWL5r/wRcwSbT3FkOHB/qJADQy/2YW9eu
        opV1LFfF1Md0SrZK915GqpRszA==
X-Google-Smtp-Source: ABdhPJwh/5mrknwGHGZd8XUrNCYgFjovnKFPoWo7Sa1TkpqUbuF+OUcHK9xRM3w9N2Ozm7c9Lzbs3A==
X-Received: by 2002:a6b:5404:: with SMTP id i4mr2685666iob.62.1612996403568;
        Wed, 10 Feb 2021 14:33:23 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e23sm1484525ioc.34.2021.02.10.14.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 14:33:23 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] net: ipa: some more cleanup
Date:   Wed, 10 Feb 2021 16:33:15 -0600
Message-Id: <20210210223320.11269-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is another fairly innocuous set of cleanup patches.

The first was motivated by a bug found that would affect IPA v4.5.
It maintain a new GSI address pointer; one is the "raw" (original
mapped) address, and the other will have been adjusted if necessary
for use on newer platforms.

The second just quiets some unnecessary noise during early probe.

The third fixes some errors that show up when IPA_VALIDATION is
enabled.

The last two just create helper functions to improve readability.

					-Alex

Alex Elder (5):
  net: ipa: use a separate pointer for adjusted GSI memory
  net: ipa: don't report EPROBE_DEFER error
  net: ipa: fix register write command validation
  net: ipa: introduce ipa_table_hash_support()
  net: ipa: introduce gsi_channel_initialized()

 drivers/net/ipa/gsi.c       | 48 +++++++++++++++++++------------------
 drivers/net/ipa/gsi.h       |  3 ++-
 drivers/net/ipa/gsi_reg.h   | 19 +++++++++------
 drivers/net/ipa/ipa_clock.c | 10 +++++---
 drivers/net/ipa/ipa_cmd.c   | 30 +++++++++++++++++------
 drivers/net/ipa/ipa_table.c | 14 ++++++-----
 drivers/net/ipa/ipa_table.h |  6 +++++
 7 files changed, 83 insertions(+), 47 deletions(-)

-- 
2.20.1

