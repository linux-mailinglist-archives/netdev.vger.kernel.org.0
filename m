Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176CF2F0F10
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 10:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbhAKJ1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 04:27:33 -0500
Received: from saphodev.broadcom.com ([192.19.232.172]:43048 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727819AbhAKJ1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 04:27:32 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id B35FD4E1AA;
        Mon, 11 Jan 2021 01:26:40 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com B35FD4E1AA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1610357201;
        bh=ZZ2dSNRKfDM6bGVhZZZVZw+kkteR44eGttMPSVkjkmQ=;
        h=From:To:Cc:Subject:Date:From;
        b=R5NYT/famhX1eAAu4alxQ0nPhk27KpKpxXpqTyHrXdq6WFjYh9o4Yf8I43DoztxoK
         QNM8Nv/BJvk18B/10bH+Nh7OvBK3WbkIGiSv/wuHOh+Dxt9EplQ6ZjTiYgK0v9Pmk8
         Ivt+6NuQEfwojAmradzszQDOq4PnJwKxr+U/Q/2w=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 0/2] bnxt_en: Bug fixes.
Date:   Mon, 11 Jan 2021 04:26:38 -0500
Message-Id: <1610357200-30755-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series has 2 fixes.  The first one fixes a resource accounting error
with the RDMA driver loaded and the second one fixes the firmware
flashing sequence after defragmentation.

Please queue the 1st one for -stable.  Thanks.

Michael Chan (1):
  bnxt_en: Improve stats context resource accounting with RDMA driver
    loaded.

Pavan Chebbi (1):
  bnxt_en: Clear DEFRAG flag in firmware message when retry flashing.

 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 3 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c     | 8 ++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

-- 
2.18.1

