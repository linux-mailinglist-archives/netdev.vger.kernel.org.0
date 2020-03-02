Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA19A175458
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 08:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCBHTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 02:19:44 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41211 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgCBHTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 02:19:44 -0500
Received: by mail-pg1-f195.google.com with SMTP id b1so4980061pgm.8
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 23:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Z44SEupakxWCCJLguIEe4pLR5s+KpUSprsApMB43W8g=;
        b=ZaFIQIHi44oq8xZHsyJC0pGcGKTWUuOI3m3DhgPTMzbqIWJR72+nDM9NAY6TlhefMl
         yJs4EmC9JAlUCVbto/6nNbliOZRjb9r3t853rZagog/DW0LTLkBapNwFt2OmjBBCIBAS
         Z6ZnRZlG8g1rsfa2x5s4Yb4ymqhh5L8wXjlaTqDpaRWYis5CEU+SapB7bvQzj+OrMa2V
         /qpTTugeLyBr/YCGWQ3Egud4ymEd9BD2B0Fh8qqzN++Qh8zOqFquwDsp19uL7JJ0k7yh
         lfEsKHrlAQ7fGM06iZfKvPSuK5Q58rQjnP1s1b3ThkK5D0aZwnBb+2WyUwEef85nGDhy
         jDJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Z44SEupakxWCCJLguIEe4pLR5s+KpUSprsApMB43W8g=;
        b=ADuGZL42iDHqGRqRLeG/voGCTEzWpBmdANMqPT8Yt01EZSPTuVKX4XkPyiCwBF0uKm
         mFedqwUiF7wOUvMTS8qd7pM9nhKySQjopzuxi8+Fv999aQrBQwYgxQmAAxXQKqZRUMSD
         XJ6snYqEn+OiKmKZVlswYmvWmRcouFV44S2z6tJVW824zP6POXj4oYA6TRIYIkSxx7ql
         /gRzAhuOBkDQHsUlbxWJEipuZgCzE8U2uD3ftbO9BLlX7mxzEbEcjQT2KmtERxiDJzB1
         fdS6jC09r7Jqc/0Vkh9ceo8Dih0BS7nE42hirxPbfUeyzGYujX0py+pv6jJRUWRcxsuJ
         INKw==
X-Gm-Message-State: APjAAAVRXj4EAudhJBW0JSkC76TvcMdYCPTea/6WY8rVbETyiEfzY8LQ
        DewTEEvWBUSlfzT52Ocjg4j3MokZBvI=
X-Google-Smtp-Source: APXvYqzCGYVIX2d3IDAge7yaeUXY1cIAojgqtJ4Z8TakG/GyQk+jQGLq9Yx+XMbl0Lhq8sNcw1vUPQ==
X-Received: by 2002:a65:65c8:: with SMTP id y8mr17647481pgv.36.1583133583164;
        Sun, 01 Mar 2020 23:19:43 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id j4sm19835042pfh.152.2020.03.01.23.19.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 01 Mar 2020 23:19:42 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 0/7] octeontx2: Flow control support and other misc changes
Date:   Mon,  2 Mar 2020 12:49:21 +0530
Message-Id: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

This patch series adds flow control support (802.3 pause frames) and
has other changes wrt generic admin function (AF) driver functionality.

Geetha sowjanya (3):
  octeontx2-af: Interface backpressure configuration
  octeontx2-af: Pause frame configuration at cgx
  octeontx2-pf: Support to enable/disable pause frames via ethtool

Linu Cherian (1):
  octeontx2-af: Optimize data retrieval from firmware

Sunil Goutham (3):
  octeontx2-af: Set discovery ID for RVUM block
  octeontx2-af: Enable PCI master
  octeontx2-af: Modify rvu_reg_poll() to check reg atleast twice

 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 174 ++++++++++++++-------
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  16 +-
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |   8 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  38 ++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 165 ++++++++++++++++---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  30 ++++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  24 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 156 +++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    |  13 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |   3 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  65 ++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   7 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  41 +++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  12 ++
 15 files changed, 671 insertions(+), 85 deletions(-)

-- 
2.7.4

