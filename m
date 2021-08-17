Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E753EED61
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239910AbhHQN3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbhHQN3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 09:29:07 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC17C061764;
        Tue, 17 Aug 2021 06:28:34 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so5212327pjr.1;
        Tue, 17 Aug 2021 06:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OzNUm8hN1AEsHQGtDta7OSeQVgR7GVTLDRlUoY7wuUY=;
        b=nz1+0HpqWM7CXmGnMuDOtCz/0d9QhZJdet+zPgDQsTWVAYZQmRB1bdJW+L8Km8dgbX
         M4jSA0ura8Gg6qK8XmNVt0bKOeH5cWWz/eU3lZy92okhsOUH5HnsvJUgj+vEDB7sgold
         aplY+rmi00PBCVcdo2qClNXDIAB/yy6n4xzxgmlkeYASNiT8g2RkqtY4thbEGz1KYo18
         4ZqbxAWB0z+/ydZgzB640i4d6R+RCP2lzod6KxZm14/38wdR1qrNtHBTe3Jnspkt721Y
         PUlifTcJ2BGJI+mhw3Vn+Xu4C79GcujCgan57vqiExOxVrPa2w3kUs/XBG4r8KZ9rpM7
         3GKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OzNUm8hN1AEsHQGtDta7OSeQVgR7GVTLDRlUoY7wuUY=;
        b=kyDE/ZxjvOHcnH8mAkaOVVRCFTYiMgjuclUjS5PalbJTRjbamwkEg/8rqr3U38RXOW
         vm/kCWgt5Jts5BDFiCjmpB7UJAV/ddfCV640dp9Og92YLx2fbxtvhCJ4+gIp2YUq1F1v
         4N6edYaqKzrf3bGTRWTHql7BnmFbQeTZ2bKJYKQ9IVuNHmbOKEePspFpvhTIRhVlqCXN
         ltfCgN2OTBrVkN1nA58RDAjnQIy0Lu2bDjeq/Z1FT6dhukt9QZkqVzuUfd43Gz9HLmn+
         9L9t/lxxuWQF1qF+4Uh47EZn5GhW8Zh3TA7YrxWWKz+VboqwKp2YTUn3dz3zNGU1Hp0R
         Fu0Q==
X-Gm-Message-State: AOAM531F/GfuNUMsQyHxz1pURJ88Q9gweGGxUuqGEjRrZ/wX8UJ1FM8c
        cNyvQhO3j8PZyk0DYDF0j5Q=
X-Google-Smtp-Source: ABdhPJyI8pt16zmUi71MCy0jpKoWpUkAdRvoLlsd+zvpPOCIQJK4+08tlGKUoAxiMpMSeBl/XEQHBg==
X-Received: by 2002:a17:902:da8a:b029:12c:6f0:fe3c with SMTP id j10-20020a170902da8ab029012c06f0fe3cmr2819657plx.41.1629206913694;
        Tue, 17 Aug 2021 06:28:33 -0700 (PDT)
Received: from ubuntu.localdomain ([182.226.226.37])
        by smtp.gmail.com with ESMTPSA id j6sm2791577pfi.220.2021.08.17.06.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 06:28:32 -0700 (PDT)
From:   bongsu.jeon2@gmail.com
To:     shuah@kernel.org, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 0/8] Update the virtual NCI device driver and add the NCI testcase
Date:   Tue, 17 Aug 2021 06:28:10 -0700
Message-Id: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

This series updates the virtual NCI device driver and NCI selftest code
and add the NCI test case in selftests.

1/8 to use wait queue in virtual device driver.
2/8 to remove the polling code in selftests.
3/8 to fix a typo.
4/8 to fix the next nlattr offset calculation.
5/8 to fix the wrong condition in if statement.
6/8 to add a flag parameter to the Netlink send function.
7/8 to extract the start/stop discovery function.
8/8 to add the NCI testcase in selftests.

v2:
 1/8
 - change the commit message.
 - add the dfense code while reading a frame.
 3/8
 - change the commit message.
 - separate the commit into 3/8~8/8.

Bongsu Jeon (8):
  nfc: virtual_ncidev: Use wait queue instead of polling
  selftests: nci: Remove the polling code to read a NCI frame
  selftests: nci: Fix the typo
  selftests: nci: Fix the code for next nlattr offset
  selftests: nci: Fix the wrong condition
  selftests: nci: Add the flags parameter for the send_cmd_mt_nla
  selftests: nci: Extract the start/stop discovery function
  selftests: nci: Add the NCI testcase reading T4T Tag

 drivers/nfc/virtual_ncidev.c          |   9 +-
 tools/testing/selftests/nci/nci_dev.c | 416 ++++++++++++++++++++++----
 2 files changed, 362 insertions(+), 63 deletions(-)

-- 
2.32.0

