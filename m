Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932B51FB95
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 22:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfEOUlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 16:41:44 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40842 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfEOUln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 16:41:43 -0400
Received: by mail-qt1-f194.google.com with SMTP id k24so1339420qtq.7
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 13:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fj95LpG/T5lp9QUHcKy9Zc7wFXy6v5uz96uLnf8ta0c=;
        b=G924ggcDRUT1SLpBQ6qWFkbMgisr9JdV7w77CT50YZIV95QZg66skm9B+4vnSWrz/5
         SkElprZaobmaFJK9o7+OnJP85J8wz6KO9gjHXu+iLBV7PMCoOQeE74rffpIC745GC3pP
         G7u66Gu29NJNDmqDHUvEoTV10X3WVQnex5uH5dxFNTh6LHkUTnZod9fV37PL9pIEgWdK
         19rLNQcXG+D8uY+iDC5/4V18HBUnHLsB/S2zI71S5ayGhcAn8jQaH7jVZGN3AjndmpC9
         0EReim2/S9dHbCFzZO2IL/gbo9nEdwFfIQqbaE2JvXBJODc7SdDaVeynvEj0OVx6CFul
         SoiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fj95LpG/T5lp9QUHcKy9Zc7wFXy6v5uz96uLnf8ta0c=;
        b=RidvmcrpVZhVvkMNY7sHyWBKfBWhQTrPdqN/73afU7FnmE21u/URBOM8MzJmVnmlBp
         wdKpgwmJ2VPYSUjy2rUiu0Hs6G3Ap53iNS17OZfosfHS/UTOSgooQWzHl5WfGtEotlEr
         MOyvOtDOwU1Pv/lEpFp92ipO/wQ2xLo7/C3ffCHe1fHRFlonhHkVaIrW32icw8qwRSy3
         DQzpEnNyUMdDY2rj8HrMZ3vlMxpg9Dfawm4K+JFIkWo4IyDSI4PuMrvqBAwBSLtzmmYk
         z+88xIb6CE7tQp/QbZbVzU2LJoz5MmVLf059GRmVp9ARFA35ES0IzXKlRp9U35z4MZkL
         b8Yg==
X-Gm-Message-State: APjAAAWXRwtS6GhMT3mX6NW2ptLT7KluUpsXQC4ZvbTke1jS5/jlvWNy
        WtyZP5aKcqw/y4LUxRwQ2HNNzw==
X-Google-Smtp-Source: APXvYqx7N9OFhcR6LhdIiDnN44tRMVFofFSW6zrhbHSQvAam7CrbvA02T5aG1JXvjsVteIMYC20K0w==
X-Received: by 2002:ac8:338a:: with SMTP id c10mr38701775qtb.41.1557952902891;
        Wed, 15 May 2019 13:41:42 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t6sm1732172qkt.25.2019.05.15.13.41.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 13:41:42 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        john.fastabend@gmail.com, vakul.garg@nxp.com, borisp@mellanox.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 0/3] Documentation: tls: add offload documentation
Date:   Wed, 15 May 2019 13:41:20 -0700
Message-Id: <20190515204123.5955-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set adds documentation for TLS offload. It starts
by making the networking documentation a little easier
to navigate by hiding driver docs a little deeper.
It then RSTifys the existing Kernel TLS documentation.
Last but not least TLS offload documentation is added.
This should help vendors navigate the TLS offload, and
help ensure different implementations stay aligned from
user perspective.

---
Dave, this just documents existing code, so I ventured
to post during the merge window, not 100% sure it is
appropriate at this stage..

Jakub Kicinski (3):
  Documentation: net: move device drivers docs to a submenu
  Documentation: tls: RSTify the ktls documentation
  Documentation: add TLS offload documentation

 .../networking/device_drivers/index.rst       |  30 ++
 Documentation/networking/index.rst            |  16 +-
 .../networking/tls-offload-layers.svg         |   1 +
 .../networking/tls-offload-reorder-bad.svg    |   1 +
 .../networking/tls-offload-reorder-good.svg   |   1 +
 Documentation/networking/tls-offload.rst      | 438 ++++++++++++++++++
 Documentation/networking/{tls.txt => tls.rst} |  44 +-
 7 files changed, 505 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/index.rst
 create mode 100644 Documentation/networking/tls-offload-layers.svg
 create mode 100644 Documentation/networking/tls-offload-reorder-bad.svg
 create mode 100644 Documentation/networking/tls-offload-reorder-good.svg
 create mode 100644 Documentation/networking/tls-offload.rst
 rename Documentation/networking/{tls.txt => tls.rst} (88%)

-- 
2.21.0

