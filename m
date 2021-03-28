Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9096634BDA2
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 19:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhC1RbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 13:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhC1RbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 13:31:16 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AFEC061762
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:31:16 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id b10so10479865iot.4
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qvSgj8I9eDaxPdP5e7vVuXr6s/TxuUun1zKDOzJcOiA=;
        b=q63jiTFFAg+757VY0epSDOwFLNmmsE8Bd8vnUx+sVU5Jx3CBBnI6l4s1oJexqlLb6z
         QZgX8EnoqHwXEUJBfJRdo7EZAJhmQ9NvezghZamQFYSMWhbSTyaLwkikyXExaG/V+Hcd
         zHZZdiOeV1efIR+bHMcuCN+FNhSuBgXSGx85pAXwc75OWpMyQ79NSC/R3fYh7PqN6iXd
         +kP6ktoPhUsIxA2P3f0+Cbhi9cX1Q0yDv4zt2Cy39zbUvM+7sufOLxFfpgWUAf3ztN19
         ElTg6zkQftVADXhEs1T/tTAIu34oH2up/PkBtvB0m1yJ27AE/MJ3EXpCrvuBl9KNW8Pq
         BLlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qvSgj8I9eDaxPdP5e7vVuXr6s/TxuUun1zKDOzJcOiA=;
        b=sNe/A9y1U1QigzmQocsVvcwZhU/lLxQB3vi4TgHVuLNu9UL3ZXfIEVg4q6n9xCp5mT
         Xm9rS4ZCxdyBKBESr2nAzplOMmEMrmCdp2P44Iw0XXBjfFL2HNbKC0J/QtXAocwQlJJX
         HfD913qMmoVE8vNEBbtEGUn6opuCrNRh4IrZ6IKd/bIncCGIdH0sToePPTDdDYYuqDl+
         iLwEqU9shk3gciEPcsB/XrTHmPQ1WAGPhFkXaBESJA4GIERW2bZZ7ALWrTlARMhl9P62
         P0JmsDPyANjpbjgarnpWM7Rupy+kw/RhuDj0gv1jc2EeSRalCJZWT2JQyoh/pZ6BC5vq
         dRzQ==
X-Gm-Message-State: AOAM533LpQUl1iAhJmS3KcpIq+Oh5Frhl8UTkYBoO4SQ/tKzIvs5ieEW
        HDUuGfG6+gTMvLnWNGe5lIeDSA==
X-Google-Smtp-Source: ABdhPJy9SjCyW/f3/Gm6hvNFC0dav3D1Ar0K/RbuECoG+4W7PkQKMCIORXesB3yrnXTwj69ma9qpig==
X-Received: by 2002:a5d:9b18:: with SMTP id y24mr17229437ion.24.1616952675452;
        Sun, 28 Mar 2021 10:31:15 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d22sm8014422iof.48.2021.03.28.10.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 10:31:14 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/7] net: ipa: a few last bits
Date:   Sun, 28 Mar 2021 12:31:04 -0500
Message-Id: <20210328173111.3399063-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series incorporates a few last things that didn't fit neatly
with patches I've posted recently.

The first patch eliminates all remaining kernel-doc warnings.
There's still room for kernel-doc improvement, but at least what's
there will no longer produce warnings.

The next moves the definition of the value to store in the backward
compatibility register (when present) into platform data files.

The third removes two endpoint definitions that do not need to be
defined.

The next two switch the naming convention used for configuration
data files to be based on the IPA version rather than the specific
platform.  I was skeptical about this at first (i.e., I thought a
platform might have quirks separate from the IPA version).  But
I'm now convinced the IPA version is enough to define the details
of the hardware block.  If any exceptions to this are found, we can
treat those differently.  Note:  these two patches produce warnings
from checkpatch.pl about updating MAINTAINERS: these can be ignored.

The sixth removes unnecessary checks for alignment of DMA memory
allocations, based comments from David Laight.

And the last removes a symbol representing the size of a table
entry, using sizeof(__le64) in its place.

					-Alex

Alex Elder (7):
  net: ipa: fix all kernel-doc warnings
  net: ipa: store BCR register values in config data
  net: ipa: don't define endpoints unnecessarily
  net: ipa: switch to version based configuration
  net: ipa: use version based configuration for SC7180
  net: ipa: DMA addresses are nicely aligned
  net: ipa: kill IPA_TABLE_ENTRY_SIZE

 drivers/net/ipa/Kconfig                       |  3 +-
 drivers/net/ipa/Makefile                      |  2 +-
 drivers/net/ipa/gsi.c                         | 13 +--
 drivers/net/ipa/gsi_private.h                 |  4 +-
 drivers/net/ipa/gsi_trans.c                   |  9 +-
 drivers/net/ipa/gsi_trans.h                   |  5 +-
 drivers/net/ipa/ipa.h                         |  7 +-
 drivers/net/ipa/ipa_cmd.c                     |  2 +-
 drivers/net/ipa/ipa_cmd.h                     | 19 +++--
 .../{ipa_data-sdm845.c => ipa_data-v3.5.1.c}  | 39 ++++-----
 .../{ipa_data-sc7180.c => ipa_data-v4.2.c}    | 25 +++---
 drivers/net/ipa/ipa_data.h                    | 10 ++-
 drivers/net/ipa/ipa_endpoint.h                | 29 +++++--
 drivers/net/ipa/ipa_interrupt.h               |  1 +
 drivers/net/ipa/ipa_main.c                    |  8 +-
 drivers/net/ipa/ipa_mem.h                     |  2 +-
 drivers/net/ipa/ipa_qmi.c                     | 10 +--
 drivers/net/ipa/ipa_qmi.h                     | 14 ++--
 drivers/net/ipa/ipa_reg.h                     | 21 -----
 drivers/net/ipa/ipa_smp2p.h                   |  2 +-
 drivers/net/ipa/ipa_table.c                   | 83 +++++++++----------
 drivers/net/ipa/ipa_table.h                   |  6 +-
 22 files changed, 153 insertions(+), 161 deletions(-)
 rename drivers/net/ipa/{ipa_data-sdm845.c => ipa_data-v3.5.1.c} (90%)
 rename drivers/net/ipa/{ipa_data-sc7180.c => ipa_data-v4.2.c} (90%)

-- 
2.27.0

