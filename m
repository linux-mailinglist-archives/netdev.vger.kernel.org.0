Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46F8185B84
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 10:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgCOJfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 05:35:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:57066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbgCOJfH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Mar 2020 05:35:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CDADAABC7
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 09:35:06 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Subject: [PATCH v2 0/6] net: Use scnprintf() for avoiding potential buffer overflow
Date:   Sun, 15 Mar 2020 10:34:57 +0100
Message-Id: <20200315093503.8558-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here is a respin of trivial patch series just to convert suspicious
snprintf() usages with the more safer one, scnprintf().

v1->v2: Align the remaining lines to the open parenthesis
        Excluded i40e patch that was already queued


Takashi

===

Takashi Iwai (6):
  net: caif: Use scnprintf() for avoiding potential buffer overflow
  net: mlx4: Use scnprintf() for avoiding potential buffer overflow
  net: nfp: Use scnprintf() for avoiding potential buffer overflow
  net: ionic: Use scnprintf() for avoiding potential buffer overflow
  net: sfc: Use scnprintf() for avoiding potential buffer overflow
  net: netdevsim: Use scnprintf() for avoiding potential buffer overflow

 drivers/net/caif/caif_spi.c                        | 72 +++++++++++-----------
 drivers/net/ethernet/mellanox/mlx4/mcg.c           | 62 +++++++++----------
 .../ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c  |  8 +--
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    | 14 ++---
 drivers/net/ethernet/sfc/mcdi.c                    | 32 +++++-----
 drivers/net/netdevsim/ipsec.c                      | 30 ++++-----
 6 files changed, 111 insertions(+), 107 deletions(-)

-- 
2.16.4

