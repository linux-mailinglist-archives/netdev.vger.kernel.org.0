Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA23AA362
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 14:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389464AbfIEMna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 08:43:30 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58418 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389448AbfIEMn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 08:43:29 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Sep 2019 15:43:23 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x85ChNGX021437;
        Thu, 5 Sep 2019 15:43:23 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH iproute2 0/4] Devlink health FMSG fixes and enhancements
Date:   Thu,  5 Sep 2019 15:43:03 +0300
Message-Id: <1567687387-12993-1-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset by Aya enhances FMSG output and fixes bugs in devlink health.

Patch 1 adds a helper function wrapping repeating code which determines
  whether left-hand-side space separator in needed or not. It's not
  needed after a newline.
Patch 2 fixes left justification of FMSG output. Prior to this patch
  the FMSG output had an extra space on the left-hand-side. This patch
  avoids this by looking at a flag turned on by pr_out_new_line.
Patch 3 fixes inconsistency between input and output in devlink health
  show command.
Patch 4 fixes ill setting of auto_recovery, prior to this patch setting
  auto_recovery zeroed grace_period.

Series generated against master commit:
84b9168328bf ip nexthop: Allow flush|list operations to specify a specific protocol

Thanks,
Tariq

Aya Levin (4):
  devlink: Add helper for left justification print
  devlink: Left justification on FMSG output
  devlink: Fix inconsistency between command input and output
  devlink: Fix devlink health set command

 devlink/devlink.c | 66 +++++++++++++++++++++++++++----------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

-- 
1.8.3.1

