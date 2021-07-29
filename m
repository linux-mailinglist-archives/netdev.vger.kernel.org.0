Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797A83D9F3F
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 10:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbhG2IPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 04:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234758AbhG2IPe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 04:15:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB03760EBB;
        Thu, 29 Jul 2021 08:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627546531;
        bh=DFBlHPm/bf7vQ3w1NRoI1dt9uFHlynm3vsqIQrPCViw=;
        h=From:To:Cc:Subject:Date:From;
        b=J2vpOvZeNb6fTpqf6vGHaXT/LfkYPIBHudsS483rN++TThQ4OVWEdObBvn+vcQQe8
         d1NvFEB4BtHCEu/3jgLyphaKq4YZnFc045SI5Xa73ZiFUAsHQHGWSK/Sj2sQ7j1nF0
         pdGYzaSqWZ3Ren5MjotNkij7yyKtwQCkzFI0Jmdr2TJ8FzLTwWQfHfl/IvhJB+k1/6
         jRTHLlW4p5CDTtfW+XH14+R3dZ72PY3z6NqiJIjLIYrPbC2rhuMQ0nUs0C7DQsc7v8
         icjmRW+ryluYOTFq93x2MK+qK20ESTxzKfmZlJGdXX8j1u1Sv8mdVnxso3Y4mQ7zP4
         /FDPTnmt8wBeg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 0/2] Clean devlink net namespace operations
Date:   Thu, 29 Jul 2021 11:15:24 +0300
Message-Id: <cover.1627545799.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi Dave, Jakub and Jiri

This short series continues my work on devlink core code to make devlink
reload less prone to errors and harden it from API abuse.

Despite first patch being a clear fix, I would ask you to apply it to net-next
anyway, because the fixed patch is anyway old and it will help us to eliminate
merge conflicts that will arise for following patches or even for the second one.

Thanks

Leon Romanovsky (2):
  devlink: Break parameter notification sequence to be before/after
    unload/load driver
  devlink: Allocate devlink directly in requested net namespace

 drivers/net/netdevsim/dev.c |  4 +--
 include/net/devlink.h       | 14 ++++++++--
 net/core/devlink.c          | 56 ++++++++++++++++++-------------------
 3 files changed, 41 insertions(+), 33 deletions(-)

-- 
2.31.1

