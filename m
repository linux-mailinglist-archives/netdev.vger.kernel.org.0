Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8242F3ECD6B
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 06:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhHPEGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 00:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhHPEGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 00:06:43 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0347AC061764;
        Sun, 15 Aug 2021 21:06:13 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id w14so24408652pjh.5;
        Sun, 15 Aug 2021 21:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CntWjWrVI+9wJAIhsJHxIdINWHX6K7GTLyHrHWRCF08=;
        b=e1znWAlUSSTgSiqnm1x3W0BvHryyHeUABmR4Yua0EnOEqllg1EyMg1FfXA5e11oqOI
         f5xuqOPj1wpYVGQ48CcAW7f3q2ZqodUF9CUu6dxgVzbpYL27qrf7INw1bWAFmQKAJ1Mi
         JFqpKOtL3jHteCZWHH8KVkctbhDkWIK0Fnj1Zjcb6TOctzU8OMXNvIGJOXXdGHxqueHA
         gT0iOjOI8vFtKtvLX83eOSdVJ6oX7FQtygmB75Kcfb0K6HrMz6qxHjLeZDC1BcD+n5Th
         Ojt7FXAJSN4SyzWv3JMSG1SWUJimN5CCFw0rPJqtCmlGNOJxNCk4hsRfNyNsPENoTF68
         hseQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CntWjWrVI+9wJAIhsJHxIdINWHX6K7GTLyHrHWRCF08=;
        b=NX2l7jyxZZNXisJdzfXJ6XRn4h203hXdZZ2Isc5AwBtso+EoSda39NSLfdOr1OMNfa
         LwgPDNlOUFSp0ntbB+18Yy1r/RPj8j+2b1XrOnx1QzTE7dPFM4hpgmwLzFRM0zLphDMV
         BoF9dseOVoNL5W1Uwo1RMT2K5Nj9YOtUVBC/ezgWnRaA10V6EpfZz7Qyla8JyAk7Bizf
         oYs/M4qF4XcmURLVrmSQRV7xUraYwWIg46w/KCNRF6bIP7DCF2Bs/e/+mOa77F1pG+pY
         kzD82Yi3uWL4o012UJ8n0KGWSrIETuY+A9/QjRx06HX+UyjmicjMW+8be47jVnAHTdsc
         2dQA==
X-Gm-Message-State: AOAM530HWJuoinzmhqWY2nzYiXBTvTBu0uXqiqVarFtDTpiGmEUTVoBS
        oGz9KffQhAYFTyaN1zlhv0A=
X-Google-Smtp-Source: ABdhPJzfmnPrEr1G6tjCFgUBixkUlgzS1mc8hBLf656um/VClXoPZe0tY2Sh931MohkQIC4G/8TKLw==
X-Received: by 2002:a17:90a:7aca:: with SMTP id b10mr14848504pjl.172.1629086772531;
        Sun, 15 Aug 2021 21:06:12 -0700 (PDT)
Received: from ubuntu.localdomain ([182.226.226.37])
        by smtp.gmail.com with ESMTPSA id i6sm9436998pfa.44.2021.08.15.21.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 21:06:12 -0700 (PDT)
From:   bongsu.jeon2@gmail.com
To:     shuah@kernel.org, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next 0/3] Update the virtual NCI driver and the NCI selftests
Date:   Sun, 15 Aug 2021 21:05:57 -0700
Message-Id: <20210816040600.175813-1-bongsu.jeon2@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

This series updates the virtual NCI device driver and NCI selftest code
and add the NCI test case in selftests.
1/3 is the patch to use wait queue in virtual device driver.
2/3 is the patch to remove the polling code in selftests.
3/3 is the patch to add the NCI testcase in selftests.

Bongsu Jeon (3):
  nfc: Change the virtual NCI device driver to use Wait Queue
  selftests: Remove the polling code to read a NCI frame
  selftests: Add the NCI testcase reading T4T Tag

 drivers/nfc/virtual_ncidev.c          |  10 +-
 tools/testing/selftests/nci/nci_dev.c | 417 ++++++++++++++++++++++----
 2 files changed, 362 insertions(+), 65 deletions(-)

-- 
2.32.0

