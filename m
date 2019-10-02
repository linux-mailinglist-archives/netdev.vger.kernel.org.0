Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C5EC8B57
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 16:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbfJBOf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 10:35:58 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38627 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728135AbfJBOf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 10:35:57 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 2 Oct 2019 17:35:54 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x92EZsEZ000653;
        Wed, 2 Oct 2019 17:35:54 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH V2 iproute2 0/3] Devlink health FMSG fixes and enhancements
Date:   Wed,  2 Oct 2019 17:35:13 +0300
Message-Id: <1570026916-27592-1-git-send-email-tariqt@mellanox.com>
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

Series generated against master commit:
8c2093e5d20c ip vrf: Add json support for show command

Thanks,
Tariq

V2:
- Dropped 4th patch, similar one is already accepted:
  4fb98f08956f devlink: fix segfault on health command

Aya Levin (3):
  devlink: Add helper for left justification print
  devlink: Left justification on FMSG output
  devlink: Fix inconsistency between command input and output

 devlink/devlink.c | 62 +++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

-- 
2.21.0

