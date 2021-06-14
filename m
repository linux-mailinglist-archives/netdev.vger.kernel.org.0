Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8569A3A70AB
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbhFNUpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235085AbhFNUpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 16:45:30 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37116C061767;
        Mon, 14 Jun 2021 13:43:15 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id l184so9650720pgd.8;
        Mon, 14 Jun 2021 13:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=04fKBF/G5jmFZI7Y1FxKGTBq9pW+tI6feysH2UKZE6g=;
        b=fRJOUJkoFBLVcRv8DyyX29rTvAzYBsF86t0lRkCVgRXRzMtbm7NhPr8FqzVfWbDABl
         Hl4PvgH/MhICOxCMlWtmXC7Pvw1LfyMi8Sb6IV9dk124fPA8N/aEc3pPkuLlcAQTUh9w
         mJQ1fBEljJLbmLxdEHwSVE678uoAPrF52aIuu16JkoYuzUsWs2bY/kuhPT3+0eZxZOqa
         /rru1r/TwAgsE7dL/W4+MClXygTxHzI1UrEzIo2EltzEzschFsrWLsA1QR0+7N+WcJQq
         axY5T1TUISCHpiUOsvN5nEYNp8roNtYmJ4grnV1Zpi5pJLzM0e5LlKWPyePv2QRLqJUf
         xVRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=04fKBF/G5jmFZI7Y1FxKGTBq9pW+tI6feysH2UKZE6g=;
        b=RKQ1qPq0FHlQPE6dYaQFAxRvhOwbieUJqONUEvF3alZ4tcGQYBdimN0JI2Eyje+Fe1
         PNHnArBm76xnCuumQcMg7XK/WHJv4+lLmUvYaITZNHdad3HI4qsrWAY7FJfXYKx/6kb/
         0lDyGuZkooovOY9Cb/JIVRcS3oiMEKv8q5djRKOj4Op5nsIDKvcXkneCLHYRiHkIjqy/
         HrtcefB57CEMVtbZLXYC/lUAZ5FInO6FSXrFKcNwSMA1pt8kvO/k7vrG3ZOyFuO6+29U
         g+6ipgDEhyyCTtXS+EivSxMj7UzF/+fC/fxy/liaBB/QU4QcFMO1M9cVNKKjBwYwyKX5
         L56A==
X-Gm-Message-State: AOAM530QhJpd2GjRazQjFHIOnvlzd/Dj5JKlM+I9yHSxe8DdGbrMfvLS
        Nag4Dzm0+8RE8aATY+YqXpg7MZUkFL76xg==
X-Google-Smtp-Source: ABdhPJy/ibbMA3gDHiNDK5Zw8huOuuSVWjvUkjktKUqOSZOQZyaLYEjJMsAVYt7SJRZyqunRVKUOLw==
X-Received: by 2002:a62:1547:0:b029:2e9:f6d7:776a with SMTP id 68-20020a6215470000b02902e9f6d7776amr908547pfv.14.1623703394541;
        Mon, 14 Jun 2021 13:43:14 -0700 (PDT)
Received: from localhost.localdomain (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id 18sm13089785pfx.71.2021.06.14.13.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 13:43:13 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2021-06-14
Date:   Mon, 14 Jun 2021 13:43:11 -0700
Message-Id: <20210614204311.1284512-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit ad9d24c9429e2159d1e279dc3a83191ccb4daf1d:

  net: qrtr: fix OOB Read in qrtr_endpoint_post (2021-06-14 13:01:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2021-06-14

for you to fetch changes up to 995fca15b73ff8f92888cc2d5d95f17ffdac74ba:

  Bluetooth: SMP: Fix crash when receiving new connection when debug is enabled (2021-06-14 22:16:27 +0200)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix crash on SMP when debug is enabled

----------------------------------------------------------------
Luiz Augusto von Dentz (1):
      Bluetooth: SMP: Fix crash when receiving new connection when debug is enabled

 net/bluetooth/smp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)
