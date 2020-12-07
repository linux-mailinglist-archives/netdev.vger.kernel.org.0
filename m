Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA892D0A49
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 06:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbgLGFhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 00:37:37 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:54574 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726601AbgLGFhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 00:37:36 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 7 Dec 2020 07:36:39 +0200
Received: from vnc1.mtl.labs.mlnx (vnc1.mtl.labs.mlnx [10.7.2.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0B75adlZ016149;
        Mon, 7 Dec 2020 07:36:39 +0200
Received: from vnc1.mtl.labs.mlnx (localhost [127.0.0.1])
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4) with ESMTP id 0B75acVO021238;
        Mon, 7 Dec 2020 07:36:38 +0200
Received: (from moshe@localhost)
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4/Submit) id 0B75aOTK021196;
        Mon, 7 Dec 2020 07:36:24 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH iproute2-net v2 0/3] devlink: Add devlink reload action limit and stats
Date:   Mon,  7 Dec 2020 07:35:19 +0200
Message-Id: <1607319322-20970-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new options on devlink reload API to enable the user to select
the reload action required and constrains limits on these actions that he
may want to ensure.

Add reload stats to show the history per reload action per limit.

Patch 1 adds the new API reload action and reload limit options to
        devlink reload command.
Patch 2 adds pr_out_dev() helper function and modify monitor function to
        use it.
Patch 3 adds reload stats and remote reload stats to devlink dev show.

Moshe Shemesh (3):
  devlink: Add devlink reload action and limit options
  devlink: Add pr_out_dev() helper function
  devlink: Add reload stats to dev show

 devlink/devlink.c      | 268 +++++++++++++++++++++++++++++++++++++++--
 man/man8/devlink-dev.8 |  34 ++++++
 2 files changed, 291 insertions(+), 11 deletions(-)

-- 
2.26.2

