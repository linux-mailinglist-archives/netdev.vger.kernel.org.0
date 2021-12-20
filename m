Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504AF47A6C2
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 10:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhLTJXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 04:23:13 -0500
Received: from mx1.tq-group.com ([93.104.207.81]:58435 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhLTJXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 04:23:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1639992192; x=1671528192;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=J/N6T0XS+9+Kg7P0fo6srIGD9A0kKRp7rVd/nxwC3qQ=;
  b=KefvCXagENmhUvdR/dncF+inrrTNNb+ft9tJ1il6jpKgb9MnCYF4TCSB
   3NEINno1v7hPXw47f//km3hBKHtHlgqRiQASHYdk9OLYgsK/UAp+ytDy0
   R5v4II5lpWjPV5doA+CliOcihO9Qq82sasbzMcLGhowa+IPwIN3eCNuNc
   znPrG5LXEOM3wteQLKMjDOpy7c1DBzSHymSs/72u4nlZ3cnUA4hbx8gAQ
   hFyHRgyrLrDKxyNd7FiXuT8n0X+G4btB2ANqVWx4fHgAtXL4dA3vQNatP
   VcrQGr+CEa1UnnEaROSTOURHbBkKoRJDVhlhvT4Pgejh9H9qBrWQ7O+Me
   w==;
X-IronPort-AV: E=Sophos;i="5.88,220,1635199200"; 
   d="scan'208";a="21148419"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 20 Dec 2021 10:23:10 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 20 Dec 2021 10:23:11 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 20 Dec 2021 10:23:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1639992191; x=1671528191;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=J/N6T0XS+9+Kg7P0fo6srIGD9A0kKRp7rVd/nxwC3qQ=;
  b=px8jZd1U8bfWm+1f0Q1Jc/SUiPowqmviJITT8EZ2t+WertlFaVfvENkd
   2lcfYftcINmuntSlGrZGIAB62bOAXWTAz4yMKcmG+r5GjJWtXNwAXzny/
   euqhbbUDFdVJAkkS+yhc0P9ldQ+4/g1/KXlRtWpOMKQgITmaEIg47SOhm
   3zvOEGGX+mY7wqWcNoa0Y1O/KFZwsez9ZaqnqbijWyAUKtJel4crBfUfv
   WoH11PooEy4++Yvm9MkfD90PELTePvmbzywwxNJ7hWOLyvsFs1iVDCQAi
   7jfda71wF610X80XQDoTQZCpjc4YNTjNfZzCItRLxBN1d7o+Ol+O10GBo
   w==;
X-IronPort-AV: E=Sophos;i="5.88,220,1635199200"; 
   d="scan'208";a="21148418"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 20 Dec 2021 10:23:10 +0100
Received: from localhost.localdomain (SCHIFFERM-M2.tq-net.de [10.121.201.15])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id B0C83280065;
        Mon, 20 Dec 2021 10:23:10 +0100 (CET)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        davem@davemloft.net, kuba@kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH 5.15 0/3] m_can_pci bit timings for Elkhart Lake
Date:   Mon, 20 Dec 2021 10:22:14 +0100
Message-Id: <cover.1639990483.git.matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The automated backport of "can: m_can: pci: use custom bit timings for
Elkhart Lake" failed because I neglected to add Fixes tags to the other
two patches it depends on.

Matthias Schiffer (3):
  Revert "can: m_can: remove support for custom bit timing"
  can: m_can: make custom bittiming fields const
  can: m_can: pci: use custom bit timings for Elkhart Lake

 drivers/net/can/m_can/m_can.c     | 24 ++++++++++++----
 drivers/net/can/m_can/m_can.h     |  3 ++
 drivers/net/can/m_can/m_can_pci.c | 48 ++++++++++++++++++++++++++++---
 3 files changed, 65 insertions(+), 10 deletions(-)

-- 
2.25.1

