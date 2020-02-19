Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3391640CC
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 10:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgBSJv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 04:51:29 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42164 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgBSJv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 04:51:29 -0500
Received: by mail-pg1-f193.google.com with SMTP id w21so12437521pgl.9
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 01:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vZLh34aYeVk+ibDO1zhZ9+7bSmQOzS+1Z8yizhlQwhI=;
        b=T4m1Qk/OzLIPtmlr6hAHUozl1cIwjjQFNWCcfvTQfu+FuWHLgmfwBXf0ErhEnK+/xx
         9Nl4uMgq47lbnEwgJFAmAZnRdoQre89Fn5RiWzlGNth5xWlqbGAgby5fAtAvqNS90sXN
         amOTgk8/3h7FevhmfHKlF9/SwC1qnogEG/P/u/SMUex5gpGD0ZjLOWgTGI2lVZ2BV27s
         GHTxszqFBCfVijR/ON2aabC1REbwfPgQr/PmlqrrkKVqRyBby7KTx71709qswRtujxJD
         plHYsMcCfM27Oo5f1ZIJcf3ZwAFiZ/PbjnWFbXoJEmlTY3xIwlMtNVcWjjezecgsCPNY
         DQMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vZLh34aYeVk+ibDO1zhZ9+7bSmQOzS+1Z8yizhlQwhI=;
        b=tGvyQfUamxpjJW1oAcatifpGL50nrvla1SJUveal4f8+ja97bcvvpfEGIBjX6gMfpU
         dRdFDou6zIQAd5Ws/rh29EkjiQRTfAp/iMTFFV72QseMw+cGwH2T/iTgW2Xf8U6Tvn6H
         3UOABY+7Cdh9xRJRS/ByzhjiDcuECyvYGJUTIgsKb7JHP82o2tQgL/ANL0W8Ovgr3cP0
         xTq6aDCrpWtajaDGrxokJ3p3pr8mP0TPv2GBVi7ItdKDgT3ERu1qCs6pSvahPxtTMpSE
         wKB21yVw8naOigldx7mF9eOuhF3W+rbMmeRsPvmlqJFCrL76jx5iVMbzrOppWKUKPMZr
         k6xA==
X-Gm-Message-State: APjAAAVBrjChdSndmyCpOXyQ9KQ6IN8PmiecXa4yyzFbi9B2ARxaVWkl
        iMIgwK3J5eFBkdyOclp3Ce+rUxCT1iQ=
X-Google-Smtp-Source: APXvYqzx2z+p0R5edAIfS/GEst+xCxr4uqFCynilqrms3BTkmhbl/j679SaDi6Ib5vQm+jxonykK1Q==
X-Received: by 2002:a65:424d:: with SMTP id d13mr28045532pgq.128.1582105886622;
        Wed, 19 Feb 2020 01:51:26 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id w11sm2023724pgh.5.2020.02.19.01.51.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 19 Feb 2020 01:51:25 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 0/3] octeontx2-af: Cleanup changes
Date:   Wed, 19 Feb 2020 15:21:05 +0530
Message-Id: <1582105868-29012-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

These patches cleanup AF driver by removing unnecessary function
exports and cleanup repititive logic.

Sunil Goutham (3):
  octeontx2-af: Remove unnecessary export symbols in CGX driver
  octeontx2-af: Cleanup CGX config permission checks
  octeontx2-af: Cleanup nixlf and blkaddr retrieval logic

 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  18 ---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  55 ++++-----
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 131 ++++++++-------------
 4 files changed, 74 insertions(+), 132 deletions(-)

-- 
2.7.4

