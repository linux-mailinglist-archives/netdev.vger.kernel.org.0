Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4FFE3E32
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 23:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbfJXVbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 17:31:11 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46095 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729049AbfJXVbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 17:31:11 -0400
Received: by mail-lf1-f68.google.com with SMTP id t8so20304792lfc.13;
        Thu, 24 Oct 2019 14:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7Cs/9h6BQ5mr2xE5m4o+dl0v2QuQDBi9AGTiyIMVXlk=;
        b=X1XLD7ZVi/THIIQkm1GcpS3OiEV7oKkA+F0+6w2sHQDACDKhUNVeAUdcs1NHCF3Ikb
         nx9AXF8zig99Fz4BpkOQjJ8C1U2vLl16dVJIedjutjhjITpJgllU3YyZZFVZg/hRaiVh
         hUu66W/9tXCNwmtnD1RBxXIy7jQ7gZ9Mt2RbHzeHRx4Gi+gVQDvzguLm5IiRcHNJna06
         Qyzi1N0Hh9AVPjVVakFXwLZN953tr4RIUBS4F4ul0F/66RrunIRTW/DkRWDQTwbdlDzb
         inTz4fPxTeq6gR0735Y51aVj5VB2EQT8nzrvJNXQ0+0YZegrYX3YfaRoC1fzY0Kk1LiW
         dgdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7Cs/9h6BQ5mr2xE5m4o+dl0v2QuQDBi9AGTiyIMVXlk=;
        b=di0OGVOJtEzDRFjRLP6hlsgCQriSfcL0022TbtDYjFK1CzWvbmIHjijJYViucNj7rK
         rj2K1J0hpp3udYl8HPwrYHRGrRdE2LAW7ZZa08zFiQAHJ4RnVg2rzBPLFDYcUXwrb9AK
         F9zqdsdcYI2tuQMWHUu2NkInZZCGMd74caCVHbMvBs2qaAA9dvaYVh4YuRAfXXHUYhwt
         E9XacB96Ka2iYbelcEyv0rFNA2NxDv4pfaOsWaDq3cQEFfVt7n+ZK01QVG0HPC4fEmm0
         mo7v/q81bi5b1AXuUJupE/xPAT4mkKt4TAZVMLMhag1pjbykQft02f3uIjgNgDXTn3Ze
         Ia1A==
X-Gm-Message-State: APjAAAVFOLmVwUpFVmaUkAlChMkfHeo2eCd/cyEiAJHw1yCtniUZF5X2
        EiTBuDxoEbREh0TFmp4N3qSZKW5FLwZoLw==
X-Google-Smtp-Source: APXvYqz05umLa5MdbaOtFs2aXzGdOkSIoNg8smJyfE5Mzi2SvITTtJHnKyfu1y/butNtKpGnC94/PQ==
X-Received: by 2002:a19:3fcd:: with SMTP id m196mr207783lfa.118.1571952669248;
        Thu, 24 Oct 2019 14:31:09 -0700 (PDT)
Received: from localhost.localdomain ([93.152.168.243])
        by smtp.gmail.com with ESMTPSA id t8sm20228336ljd.18.2019.10.24.14.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 14:31:08 -0700 (PDT)
From:   Samuil Ivanov <samuil.ivanovbg@gmail.com>
To:     gregkh@linuxfoundation.org, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com
Cc:     samuil.ivanovbg@gmail.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Staging: qlge: Rename of function prefix ql_ to qlge_
Date:   Fri, 25 Oct 2019 00:29:38 +0300
Message-Id: <20191024212941.28149-1-samuil.ivanovbg@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In terms of namespace, the driver uses either qlge_, ql_ (used by
other qlogic drivers, with clashes, ex: ql_sem_spinlock) or nothing (with
clashes, ex: struct ob_mac_iocb_req). Rename everything to use the "qlge_"
prefix.

So I renamed three functions to the prefered namespace "qlge",
and updated the occurrences in the driver.

Samuil Ivanov (3):
  Staging: qlge: Rename prefix of a function to qlge
  Staging: qlge: Rename prefix of a function to qlge
  Staging: qlge: Rename prefix of a function to qlge

 drivers/staging/qlge/qlge.h      |  6 +++---
 drivers/staging/qlge/qlge_dbg.c  |  4 ++--
 drivers/staging/qlge/qlge_main.c |  2 +-
 drivers/staging/qlge/qlge_mpi.c  | 12 ++++++------
 4 files changed, 12 insertions(+), 12 deletions(-)

-- 
2.17.1

