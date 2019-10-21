Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF6A2DE3C1
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 07:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfJUFes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 01:34:48 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:36685 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfJUFes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 01:34:48 -0400
Received: by mail-pf1-f176.google.com with SMTP id y22so7678755pfr.3
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 22:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=5orW+RENL+KAdSeb6G37q4u0o6eSqB1B7YsGrzK1Kdg=;
        b=UVj3SLuPOzwtR28WBWdSNyaNFn/jvgOJjUgZWX0HdADs33SGa9mUfxshH4YEHoStLQ
         pgZIO08uaZo1LNrPyGQolqegcbOC5MIn2lYaPY/br98pLZ6VaVdyZ9IuSkE839Y1QXHT
         EpvZoP7GH6IqP9jY8uO/SUsRQ4EAs9ZUavbE0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5orW+RENL+KAdSeb6G37q4u0o6eSqB1B7YsGrzK1Kdg=;
        b=VcWNekSXt0RF3C5FR6SqJmiKe20N6ySyg7r6UPgpu5Icy0exQlpDQBnDp8q0IYTsh4
         Xe72FPgsJdRpr57GdLI71gp4org/u5Fd7uKMQDpAqdSQTY2KOimiq3TcfOQjcAtoXJQ1
         d4Hk+wMVQNk6QJWdkilIty2AqToifRna/7vLNiEvRSaYnAA3X/0RMq65XYLzfIkhzo69
         H7+YGeIB/kZT7lmnkm2SdbZOlxTxsBG8UHvBPRp2Dp3QwDEQg5DMdUmGSShDDPxYL/93
         Z0jSOmOm9BIHo95t8qOv1771eId4T2e1zqFsn1cXizcH9G7BnvqSERL1SlGAB0VB4hHv
         bCnQ==
X-Gm-Message-State: APjAAAWO/xwpcGu+w2Me6gL8OtAynGs8yqce6SiQXS9N5xrvdA7K3ug1
        3kaG/Y8GO+jz1rxx4GO0wSciuw==
X-Google-Smtp-Source: APXvYqwhvcDDa3ypAdxNvwcCbToouUtP8a4J01fNYo9Xf3OTtpRYTyQ1CHJYoyFMrrQlg5l40k5LuQ==
X-Received: by 2002:a63:c411:: with SMTP id h17mr11689403pgd.360.1571636087436;
        Sun, 20 Oct 2019 22:34:47 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w2sm14713255pfn.57.2019.10.20.22.34.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Oct 2019 22:34:46 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com
Subject: [PATCH net 0/5] bnxt_en: Bug fixes.
Date:   Mon, 21 Oct 2019 01:34:24 -0400
Message-Id: <1571636069-14179-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink and error recovery bug fix patches.  Most of the work is by
Vasundhara Volam.  Please queue patch 1 and 2 for -stable also.  Thanks.

Michael Chan (1):
  bnxt_en: Fix devlink NVRAM related byte order related issues.

Vasundhara Volam (4):
  bnxt_en: Fix the size of devlink MSIX parameters.
  bnxt_en: Adjust the time to wait before polling firmware readiness.
  bnxt_en: Minor formatting changes in FW devlink_health_reporter
  bnxt_en: Avoid disabling pci device in bnxt_remove_one() for already
    disabled device.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 112 +++++++++++++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |   3 +-
 3 files changed, 73 insertions(+), 52 deletions(-)

-- 
2.5.1

