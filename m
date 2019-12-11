Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D288911BB35
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730209AbfLKSPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:15:05 -0500
Received: from mail-yw1-f54.google.com ([209.85.161.54]:46662 "EHLO
        mail-yw1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729753AbfLKSPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:05 -0500
Received: by mail-yw1-f54.google.com with SMTP id u139so9275159ywf.13;
        Wed, 11 Dec 2019 10:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q2LAtAr35fOxdHluyYQPMQ83B/l646nAWaVMX7Ww9lA=;
        b=svfgvcf5l0Q51QBfuqGqqVaa5t10/wiQRuxkxmKW7VSu244E0qnQHtPlbzdiqgvRQL
         XxpbD6bJiAqJmoO/h3tU1FOZ5XinalTLmNv9X/LreO/ci8L2j+D5KVri2/d39p+X6dSk
         ztDYX95hsMl0zcQlgQotcCrpHEEMDaRN3kDVeTLEQk+JhC3LkTYaPTtYvzEJskR6w3Kd
         hu9MMCLuSkVZhiAyvUgG7CB66L34grupVwcsvVp1btLbDAtL8VGOdYttDGrQTfFeAe5O
         SQP8NUL5QE+eP8y5ouPoqGqIv+prihfGe1uqeJuBbITrjKR6vmONidXB2uQ+rqAin4/0
         H8Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q2LAtAr35fOxdHluyYQPMQ83B/l646nAWaVMX7Ww9lA=;
        b=RdE2hkmDYDhOi59oLpnkA7k1Baab7atain+hAQaJwrmSMBkqE+Ky3CvMNRMdwo86Pi
         AXu0Xqx0tt5F2fCDQ01JyXgKz+1YiAsysWRIvgTZqsE4WSTESjiNHWrQPgTcFDK+iwUF
         7uFU6b/Jkf2hDfcafZ9JJkwH+o2gAXb4pN5XUIG0cGEA4dENkEqAb4Y7Gc9hPikyl8RZ
         0d59U0BZ1C4Tbir+Op69M52Zelb6xaVD8xaczzlMWdr5Jw9P4DgIBi6X919HFHKagSTd
         9aVJFJOOJSJf+gRBd8ujpzgfeewTVDz+4fSw6nSXFBQf4ZIu9UARRG/jOxQXNVZ5qPO7
         t2XA==
X-Gm-Message-State: APjAAAUB1T2uwHL8d8y9n5kHM+ikccHjLmK9hrh8TuLg/PN7dS9bIPmv
        0ZFsemNnODt9FHPdGgyoI7V+8mWpmE1SMg==
X-Google-Smtp-Source: APXvYqy9RUld3P5NVjS7SATFBqmbXZHrOlPh6/SxjKxntUcO348d/pvMz2XOAtbY+VfOVGc4qzEQ+g==
X-Received: by 2002:a81:af04:: with SMTP id n4mr883522ywh.319.1576088103847;
        Wed, 11 Dec 2019 10:15:03 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id l5sm1277409ywd.48.2019.12.11.10.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:03 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/23] V2: Break up from one patch to multiple
Date:   Wed, 11 Dec 2019 12:12:29 -0600
Message-Id: <cover.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I broke up the changes from one patch to many so each patch has more
defined changes. I also added a few other patches for formatting issues
I missed in the original patch. 

Scott Schafer (23):
  staging: qlge: Fix CHECK extra blank lines in many files
  staging: qlge: Fix CHECK: Alignment should match open parenthesis
  staging:qlge: Fix WARNING: Missing a blank line after declarations
  staging: qlge: Fix WARNING: Missing a blank line after declarations
  staging: qlge: Fix CHECK: Blank lines aren't necessary before a close
    brace '}'
  staging: qlge: Fix CHECK: Blank lines aren't necessary after an open
    brace '{'
  staging: qlge: Fix WARNING: quoted string split across lines
  staging: qlge: Fix CHECK: Unnecessary parentheses around
    mpi_coredump->mpi_global_header
  staging: qlge: Fix CHECK: No space is necessary after a cast
  staging: qlge: Fix CHECK: blank line after function/struct/union/enum
    declarations
  staging: qlge: Fix CHECK: braces {} should be used on all arms of this
    statement
  staging: qlge: Fix WARNING: please, no space before tabs in qlge.h
  staging: qlge: Fix CHECK: spaces preferred around that (ctx:VxV)
  staging: qlge: Fix WARNING: Unnecessary space before function pointer
    arguments
  staging: qlge: Fix WARNING: please, no spaces at the start of a line
  staging: qlge: Fix WARNING: Block comments use a trailing */ on a
    separate line
  staging: qlge: Fix WARNING: else is not generally useful after a break
    or return
  staging: qlge: Fix CHECK: Prefer using the BIT macro
  staging: qlge: Fix WARNING: msleep < 20ms can sleep for up to 20ms
  staging: qlge: Fix CHECK: usleep_range is preferred over udelay
  staging: qlge: Fix WARNING: suspect code indent for conditional
    statements
  staging: qlge: Fix CHECK: Unbalanced braces around else statement
  staging: qlge: Fix WARNING: Avoid multiple line dereference

 drivers/staging/qlge/qlge.h         |  43 ++--
 drivers/staging/qlge/qlge_dbg.c     |  97 ++++----
 drivers/staging/qlge/qlge_ethtool.c |  60 ++---
 drivers/staging/qlge/qlge_main.c    | 336 +++++++++++++---------------
 drivers/staging/qlge/qlge_mpi.c     |  71 +++---
 5 files changed, 293 insertions(+), 314 deletions(-)

-- 
2.20.1

