Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25310349F53
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhCZCHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230013AbhCZCHd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 22:07:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE85B61A3F;
        Fri, 26 Mar 2021 02:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616724453;
        bh=NsV9gJGGjimA9XIR6H1BnS98rY/5v64Tsff2XZMG7xw=;
        h=From:To:Cc:Subject:Date:From;
        b=IauMTypgpV+AyBjdZ3BdAWkiEORLo1CMAQ7Bc+u7OQNUshNeNX8q5ED6WaBMIIsig
         A6W8bWRVI22WA/ZD1GRLXjcSMNsIs0whnK5gPG8zEoboNZ5Iv5bHUk7/Q3CkebG6/B
         Uhp+LyLTqpSCVH1RV9p2vRwNpwSIwSm8zLW/VCzQ8NurPvbKNlgRLaYPtCl8ggJSLt
         mguCm/kWRofD8TD6DMAdrK9DdN3N7XYmWrv60Y6XdC9E1J5UBZlK+QNjLMGq7sZOIK
         KRe+7pvEB+Ulq49ERhnttKpW92tSLGkUXAaSk2mdvh3iVdR+NvFwAMdYFecBxj6Eh9
         2Cpx3SCpjgaiA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        michael.chan@broadcom.com, paul.greenwalt@intel.com,
        rajur@chelsio.com, jaroslawx.gawin@intel.com, vkochan@marvell.com,
        alobakin@pm.me, snelson@pensando.io, shayagr@amazon.com,
        ayal@nvidia.com, shenjian15@huawei.com, saeedm@nvidia.com,
        mkubecek@suse.cz, andrew@lunn.ch, roopa@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/6] ethtool: clarify the ethtool FEC interface
Date:   Thu, 25 Mar 2021 19:07:21 -0700
Message-Id: <20210326020727.246828-1-kuba@kernel.org>
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

v2: 
 - fix patch 5
 - adjust kdoc in patches 3 and 6

Jakub Kicinski (6):
  ethtool: fec: fix typo in kdoc
  ethtool: fec: remove long structure description
  ethtool: fec: sanitize ethtool_fecparam->reserved
  ethtool: fec: sanitize ethtool_fecparam->active_fec
  ethtool: fec: sanitize ethtool_fecparam->fec
  ethtool: clarify the ethtool FEC interface

 include/uapi/linux/ethtool.h | 45 +++++++++++++++++++++++++++---------
 net/ethtool/ioctl.c          |  9 ++++++++
 2 files changed, 43 insertions(+), 11 deletions(-)

-- 
2.30.2

