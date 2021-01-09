Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1E22EFC7D
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbhAIAyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:54:31 -0500
Received: from linux.microsoft.com ([13.77.154.182]:41670 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbhAIAyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 19:54:31 -0500
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id B3DE320B7192; Fri,  8 Jan 2021 16:53:50 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B3DE320B7192
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1610153630;
        bh=k3T4DMBXsImTUP3gT7PgRVmoiGDaelg25OyJmX8AQ+0=;
        h=From:To:Cc:Subject:Date:From;
        b=CeTfIWVslTX7pn26LvqoAzpkzjy/h3owgLcSGlRAPs/gfzgnX+67qorCuJ7bpnfzW
         fIvSqa9nLofukWjf0D4aLsGmrJFBQIOZgA6bKS1yBmzlPXhACJs3s2mNlckloENvRN
         E7EIvxD/n0OHibHFMiCY9izsR2bN/6zRNXLwq+iE=
From:   Long Li <longli@linuxonhyperv.com>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH v2 0/3] hv_netvsc: Prevent packet loss during VF add/remove
Date:   Fri,  8 Jan 2021 16:53:40 -0800
Message-Id: <1610153623-17500-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Long Li <longli@microsoft.com>

This patch set fixes issues with packet loss on VF add/remove.

Long Li (3):
  hv_netvsc: Check VF datapath when sending traffic to VF
  hv_netvsc: Wait for completion on request SWITCH_DATA_PATH
  hv_netvsc: Process NETDEV_GOING_DOWN on VF hot remove

 drivers/net/hyperv/netvsc.c     | 37 ++++++++++++++++++++++++++++++---
 drivers/net/hyperv/netvsc_drv.c | 14 ++++++++-----
 2 files changed, 43 insertions(+), 8 deletions(-)

-- 
2.27.0

