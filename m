Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB06A348642
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239557AbhCYBM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239545AbhCYBMG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 21:12:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFEB961A14;
        Thu, 25 Mar 2021 01:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616634726;
        bh=352VrPUrx++UEr/czikRjEFB5U7juxq2H0+r7pGhxvQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Hg/nSlO3J0L4M0U7febI7T10Lypv6V/+iHykw2kJmqFi/pVt0+9DygdWm/ltMs3y9
         7jhtaBxJWXwkcPYXsy/arTQPeIGSokN4hIc1x6EsUd39JpoZGZiJBQJt2ezqAKGw2g
         VArNEaCYMq10ViNzt+rSarfOTyknN7lr867dcpYHPjPH03lsAbOs+AmFxYqa62CWwg
         qa2rAPSokMUAdFpYy3PEe/+mxIDzdwInvbiZ3vrnOZindjJRwSwjBOvnxUVKq41U60
         xQ8cIyeHApCG7yiQBnFPJnG2/i34Jfu5gm5gvPa8mX8x3oAZY1J/DxQqYOS4KKDeLM
         m7HDhv3MbP2pg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        michael.chan@broadcom.com, damian.dybek@intel.com,
        paul.greenwalt@intel.com, rajur@chelsio.com,
        jaroslawx.gawin@intel.com, vkochan@marvell.com, alobakin@pm.me,
        snelson@pensando.io, shayagr@amazon.com, ayal@nvidia.com,
        shenjian15@huawei.com, saeedm@nvidia.com, mkubecek@suse.cz,
        andrew@lunn.ch, roopa@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/6] ethtool: clarify the ethtool FEC interface
Date:   Wed, 24 Mar 2021 18:11:54 -0700
Message-Id: <20210325011200.145818-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Our FEC configuration interface is one of the more confusing.
It also lacks any error checking in the core. This certainly
shows in the varying implementations across the drivers.

Improve the documentation and add most basic checks. Sadly, it's
probably too late now to try to enforce much more uniformity.

Any thoughts & suggestions welcome. Next step is to add netlink
for FEC, then stats.

Jakub Kicinski (6):
  ethtool: fec: fix typo in kdoc
  ethtool: fec: remove long structure description
  ethtool: fec: sanitize ethtool_fecparam->reserved
  ethtool: fec: sanitize ethtool_fecparam->active_fec
  ethtool: fec: sanitize ethtool_fecparam->fec
  ethtool: clarify the ethtool FEC interface

 include/uapi/linux/ethtool.h | 39 +++++++++++++++++++++++++++---------
 net/ethtool/ioctl.c          |  9 +++++++++
 2 files changed, 38 insertions(+), 10 deletions(-)

-- 
2.30.2

