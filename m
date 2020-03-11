Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99311181365
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 09:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgCKIiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 04:38:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:50092 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgCKIiD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 04:38:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 55668B18F;
        Wed, 11 Mar 2020 08:38:01 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 0/7] net: Use scnprintf() for avoiding potential buffer overflow
Date:   Wed, 11 Mar 2020 09:37:38 +0100
Message-Id: <20200311083745.17328-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here is a series of trivial patches just to convert suspicious
snprintf() usages with the more safer one, scnprintf().


Takashi

===

Takashi Iwai (7):
  net: caif: Use scnprintf() for avoiding potential buffer overflow
  i40e: Use scnprintf() for avoiding potential buffer overflow
  mlx4: Use scnprintf() for avoiding potential buffer overflow
  nfp: Use scnprintf() for avoiding potential buffer overflow
  ionic: Use scnprintf() for avoiding potential buffer overflow
  sfc: Use scnprintf() for avoiding potential buffer overflow
  netdevsim: Use scnprintf() for avoiding potential buffer overflow

 drivers/net/caif/caif_spi.c                        | 36 +++++++++++-----------
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 24 +++++++--------
 drivers/net/ethernet/mellanox/mlx4/mcg.c           | 24 +++++++--------
 .../ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c  |  6 ++--
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    | 12 ++++----
 drivers/net/ethernet/sfc/mcdi.c                    | 12 ++++----
 drivers/net/netdevsim/ipsec.c                      |  8 ++---
 7 files changed, 61 insertions(+), 61 deletions(-)

-- 
2.16.4

