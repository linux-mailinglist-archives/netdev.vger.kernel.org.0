Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867373DEEB5
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 15:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbhHCNFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 09:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235895AbhHCNFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 09:05:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9064560F9C;
        Tue,  3 Aug 2021 13:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627995935;
        bh=CXFFeL4rSCiB02SPYYtouqHmBZqV14eLkT+/JjPpifU=;
        h=From:To:Cc:Subject:Date:From;
        b=L/T2HlNSXpGLQcloFOdRCjgVVT856xTPtC6aG9cWJDXKGLxbVFB6v26FRW3ZkHfES
         hUX2KN2rNN4Bue6G6r825p5iv/o4nvKEw6G6ZdifJc9ex1VO+G8ZDy4R2qbsJhEeuc
         xSjIJIdbQXUFHnvTgWl4Wyq9KDYtKvXyeij7LmPn5+vSRJgwXlbeMBRaLcF2hFiy3l
         znf1SoJef2O36X5iFZ5NmA1QDOl+D5scK7O177gVW39hjN84YjwQ0xazTUQTZEzHWG
         cy7Hn7a5N3DkRP3SiBOiThsXFos/cp3DLF+HpbbM6c6H0jl85z5AiSFp8y7o2Ulcpn
         EqRmz41sU6Q/g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, simon.horman@corigine.com,
        alexanderduyck@fb.com, oss-drivers@corigine.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/2] net: add netif_set_real_num_queues() for device reconfig
Date:   Tue,  3 Aug 2021 06:05:25 -0700
Message-Id: <20210803130527.2411250-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This short set adds a helper to make the implementation of
two-phase NIC reconfig easier.

Jakub Kicinski (2):
  net: add netif_set_real_num_queues() for device reconfig
  nfp: use netif_set_real_num_queues()

 .../ethernet/netronome/nfp/nfp_net_common.c   | 11 ++---
 include/linux/netdevice.h                     |  2 +
 net/core/dev.c                                | 44 +++++++++++++++++++
 3 files changed, 49 insertions(+), 8 deletions(-)

-- 
2.31.1

