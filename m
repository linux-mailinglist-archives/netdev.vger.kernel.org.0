Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB7C342E0A
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 16:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhCTP5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 11:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhCTP5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 11:57:11 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D191C061762
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 08:57:11 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id d10so4075313ils.5
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 08:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ESDsxRDTaFLNjqDsrRszfzPZy9cZaxe1guwoXNvOfY4=;
        b=iyu19g25d2qWZhmtZfHy8sJ8fNayzfAr1lKE+VwgrxCn0K8bpTUL3KMYQPGtIaayV/
         8xirY0uJ7ebUHAQSJgo5LQX/2P7RpUBtcqCGZOwiT29xvWgW9+W5JR50BorIlsksaPS+
         JdfxFUiBhos/p4zCxdMd4TeoyLQDYWnkLpQ4hLaJafUBFbCIGpMRz4PSXH8nyAVH9mMb
         3sC9KimgB1lMnkFIIWhJF+iIREeDqwcn31ocf+TcK9veqHO4Xh4hM63BIPpoCVWZSIUE
         k/QRBhCZCSPfq9GdVeuOFRmjr6sUR/S5+wbGmRde2wbcTDsuzsL0aGqAgeCRQxqbhUqs
         O8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ESDsxRDTaFLNjqDsrRszfzPZy9cZaxe1guwoXNvOfY4=;
        b=M8ya306ztuAK6+s6N6wWEn5t/xPPJRSD7vJQpP+PPXEijOVpYkHkXL3vRZwsZK9ZLx
         qnireBD88XZz2kOBXyavI8OWAbpoRugqsmsjF3wUhfpeHCVWOtLBnKplvJD473NKWQj8
         sgcPwR6iEU4oYel9uWfIajrbotg/I8S9TRwnH6LfIm1OPnpEV2hi14oJb31U/Ymvsy6B
         PcXa2Qm6SEDzfAcbnce6xbILoPythH3y1SNWuxnKwIJ7F7SZR37ea9NbeTLEdmOm7o0V
         e39SUZiPgSPijRO9+/3qIG9W9g4ibhbqPbXlaSQd0+Wcmp1KOU/HSyyp9FUhOcsQ3I8+
         7yZg==
X-Gm-Message-State: AOAM5319jdeGI6wM7lov0NI0VAASQpbVF82dZHQUiMcPd0qJ5/4a/KPq
        ul7j12+aaWOk1gg7Y8uXu3nEqw==
X-Google-Smtp-Source: ABdhPJygpZPb2IEhDwJgNj3LRY354Gjh2xE+bSD1ycmFNu9RyUxhJHBFmbocP8HJqgImAkGIGQYwDA==
X-Received: by 2002:a92:5214:: with SMTP id g20mr6066444ilb.260.1616255830715;
        Sat, 20 Mar 2021 08:57:10 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n16sm4501698ilq.71.2021.03.20.08.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 08:57:10 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] net: ipa: more configuration data updates
Date:   Sat, 20 Mar 2021 10:57:02 -0500
Message-Id: <20210320155707.2009962-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series starts with two patches that should have been included
in an earlier series.  With these in place, QSB settings are
programmed from information found in the data files rather than
being embedded in code.  Support is then added for reprenting
another QSB property (supported for IPA v4.0+).

The third patch updates the definition of the sequencer type used
for an endpoint.  Previously a set of 2-byte symbols with fairly
long names defined the sequencer type, but now those are broken into
1-byte halves whose names are a little more informative.

The fourth patch moves the sequencer type definition so it only
applies to TX endpoints (they aren't valid for RX endpoints).  And
the last makes some minor documentation updates.

					-Alex

Alex Elder (5):
  net: ipa: use configuration data for QSB settings
  net: ipa: implement MAX_READS_BEATS QSB data
  net: ipa: split sequencer type in two
  net: ipa: sequencer type is for TX endpoints only
  net: ipa: update some comments in "ipa_data.h"

 drivers/net/ipa/ipa_data-sc7180.c | 11 +++--
 drivers/net/ipa/ipa_data-sdm845.c |  9 ++--
 drivers/net/ipa/ipa_data.h        | 36 ++++++++-------
 drivers/net/ipa/ipa_endpoint.c    | 14 +++---
 drivers/net/ipa/ipa_endpoint.h    |  1 -
 drivers/net/ipa/ipa_main.c        | 77 +++++++++++++------------------
 drivers/net/ipa/ipa_reg.h         | 46 +++++++++++-------
 7 files changed, 97 insertions(+), 97 deletions(-)

-- 
2.27.0

