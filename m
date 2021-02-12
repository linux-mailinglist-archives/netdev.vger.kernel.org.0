Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB5331A0AF
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 15:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhBLOfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 09:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbhBLOes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 09:34:48 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81619C061756
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 06:34:07 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id f6so9473073ioz.5
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 06:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GbtpEIXRgUa1i5gUQDSm0FSLWtb7T5/l4I8yduAZ2+8=;
        b=mBe7FwHYOyERl0kSHyu8x2WTruC+mSGQOqSJs/otfdn320EwDaKj09QJaU/Obj/hPv
         4OShkbtw0mQjuIQWU/uOKi8kAnjc1AaeFDtMd/XF1rqi0y+DdhB9ydtwx0eFSfkhFyED
         E+XOaz9UgHGXsXA8aWkGXt2Vxdm1Xkav2P2tROpfKMAia/NDMkdfOLfbf8j4qRn/Jo1O
         Mo+iwdee6uQK3j/l2M+2rGQUdad+doGvvpA0xrvVDrz8x6H/nL74NBdZrRoJ/rFlZCGZ
         uSDq1Qetf8sswWKf0GekXdItRBX4OHVhs+5RcAogbKs08v3vxJhr8h3+ajURMAQBMhaL
         0FfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GbtpEIXRgUa1i5gUQDSm0FSLWtb7T5/l4I8yduAZ2+8=;
        b=B6f1SO6gmnrwJuaLYWEjolngFxABwhxrNadqUCcYT+oxDelyevTXxI9W1h5HK+Trt0
         cSQ3wLj0rA1cC7Td2/xHyc37ybRqwBOM4ZeaMdHfk4VxEmDd7F24G7mkSgIUSvh9Hncn
         ggCi6eFg85Fq6lHEt3NLZvfvPLKNhdu4c98bHTdoXA+ne45cR2gTt8m/HufvwJJJArTa
         pqfLsjwZFIwT5no6dph842wrr0sTpLGvx6f+IrLqolsJ6Vl4h34tUVv4uIOd1B/cewtD
         +iYGUxettL6rrEnbUAAY36IBMv/cbnKAP6OLJRrju+tbb/hy6ZlUadwGpP8Ny/Ll+Fv7
         4VCQ==
X-Gm-Message-State: AOAM533hOHFFPKXJxKGsduMipmmjLmdi0rv9V8D+LgkcpXO7Gi5zcCvI
        H+ld6ieXtUsq4XT07XGouMA+Hw==
X-Google-Smtp-Source: ABdhPJz1/D8YRow1IawV2B9z3/U3YlcL82UH6EHnnPVC50wzq+AHgUwC2tGw7mMYnplAfTNFck3tyg==
X-Received: by 2002:a02:a90a:: with SMTP id n10mr3007078jam.7.1613140446931;
        Fri, 12 Feb 2021 06:34:06 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j12sm4387878ila.75.2021.02.12.06.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 06:34:06 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 0/5] net: ipa: some more cleanup
Date:   Fri, 12 Feb 2021 08:33:57 -0600
Message-Id: <20210212143402.2691-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Version 3 of this series uses dev_err_probe() in the second patch,
as suggested by Heiner Kallweit.

Version 2 was sent to ensure the series was based on current
net-next/master, and added copyright updates to files touched.

The original introduction is below.

					-Alex

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
  net: ipa: use dev_err_probe() in ipa_clock.c
  net: ipa: fix register write command validation
  net: ipa: introduce ipa_table_hash_support()
  net: ipa: introduce gsi_channel_initialized()

 drivers/net/ipa/gsi.c       | 50 +++++++++++++++++++------------------
 drivers/net/ipa/gsi.h       |  5 ++--
 drivers/net/ipa/gsi_reg.h   | 21 ++++++++++------
 drivers/net/ipa/ipa_clock.c |  9 ++++---
 drivers/net/ipa/ipa_cmd.c   | 32 ++++++++++++++++++------
 drivers/net/ipa/ipa_table.c | 16 ++++++------
 drivers/net/ipa/ipa_table.h |  8 +++++-
 7 files changed, 87 insertions(+), 54 deletions(-)

-- 
2.20.1

