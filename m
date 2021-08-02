Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57E33DCF29
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 06:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhHBENZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 00:13:25 -0400
Received: from lpdvsmtp11.broadcom.com ([192.19.166.231]:46080 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229828AbhHBENY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 00:13:24 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Aug 2021 00:13:24 EDT
Received: from dhcp-10-123-153-22.dhcp.broadcom.net (bgccx-dev-host-lnx2.bec.broadcom.net [10.123.153.22])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 71E13A2;
        Sun,  1 Aug 2021 21:06:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 71E13A2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1627877213;
        bh=B4pS463qdpSOc2Geyt6nQi7JodXBkLS4Uo7GYGI3iLY=;
        h=From:To:Cc:Subject:Date:From;
        b=S/GCMtbdMKfpTUv3SRxvQVh7hUtOZSS+1Nxgu16L9DdZDYon+W7YGuMD4+tYQ8gGF
         UNFJ6iKQ33g70jKavaSmLKJsK9X5+RG0JhnIbQQK2SbwKkNcqZq+aAEJcd6nZtJISi
         ZVamAhuDunjG+lyOEusSAzCGG1kXPo1e92Hk0wGA=
From:   Kalesh A P <kalesh-anakkur.purayil@broadcom.com>
To:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com
Cc:     netdev@vger.kernel.org, edwin.peer@broadcom.com,
        michael.chan@broadcom.com
Subject: [PATCH net-next 0/2] devlink enhancements
Date:   Mon,  2 Aug 2021 09:57:38 +0530
Message-Id: <20210802042740.10355-1-kalesh-anakkur.purayil@broadcom.com>
X-Mailer: git-send-email 2.10.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

This patchset adds device capability reporting to devlink info API.
It may be useful if we expose the device capabilities to the user
through devlink info API.

Kalesh AP (2):
  devlink: add device capability reporting to devlink info API
  bnxt_en: Add device capabilities to devlink info_get cb

 Documentation/networking/devlink/devlink-info.rst |  3 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 31 +++++++++++++++++++++--
 include/net/devlink.h                             |  2 ++
 include/uapi/linux/devlink.h                      |  3 +++
 net/core/devlink.c                                | 25 ++++++++++++++++++
 5 files changed, 62 insertions(+), 2 deletions(-)

-- 
2.10.1

