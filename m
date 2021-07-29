Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0167D3DA9EF
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 19:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhG2RTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 13:19:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhG2RTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 13:19:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7242960EE6;
        Thu, 29 Jul 2021 17:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627579171;
        bh=arYapJH7q0fJMzqXsXtCNxKxTHssMuD32zfJObe/ADU=;
        h=From:To:Cc:Subject:Date:From;
        b=fI8YvfLiAyqRGQReOy8KWQuAHF26SpR3uia5WPqJhfYXhzkBoqaHI35lmt0plabZM
         iHER+PyIM23+jRvN3w/j6P3gGeBBN8vWhzNhkjBLZRrkf2r1P3/GhQcRcZJyRhCusa
         2eVvVt16EHUpNGnNVXQxqYpVBwyQ3JUN44kzgcR3dwefC8HfIALQhk2koSt4j+e9bL
         +eqeF6L9uG8Y3MkvYfaTr84ti1SRlPzDA+v59JViP6PN3TD2yo+o10X4qtACoB3Lx3
         4g55isuMfBJI6HKhScC2cOy95CDMHlo970TIY24KRjTXCPX0KZaLgIVHTMWDtXEMLM
         ahtCd899APL4Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next v2 0/2] Clean devlink net namespace operations
Date:   Thu, 29 Jul 2021 20:19:23 +0300
Message-Id: <cover.1627578998.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v2:
 * Patch 1: Dropped cmd argument
v1: https://lore.kernel.org/lkml/cover.1627564383.git.leonro@nvidia.com
 * Patch 1:
   * Renamed function name
   * Added bool parameter to the notifier function
 * Patch 2:
   * added Jiri's ROB and dropped word "RAW" from the comment"
v0: https://lore.kernel.org/lkml/cover.1627545799.git.leonro@nvidia.com

-----------------------------------------------------------------------------
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

