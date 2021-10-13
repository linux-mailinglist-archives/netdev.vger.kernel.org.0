Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A66A42BA8C
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 10:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238747AbhJMIgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 04:36:33 -0400
Received: from out10.migadu.com ([46.105.121.227]:53414 "EHLO out10.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238667AbhJMIgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 04:36:32 -0400
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Oct 2021 04:36:31 EDT
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next 0/2] Combine nvmem_get_mac_address() and of_get_mac_addr_nvmem() together
Date:   Wed, 13 Oct 2021 16:25:07 +0800
Message-Id: <20211013082507.537-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch1: move nvmem_get_mac_address() into of_get_mac_addr_nvmem()
Patch2: remove nvmem_get_mac_address()

Yajun Deng (2):
  of: net: move nvmem_get_mac_address() into of_get_mac_addr_nvmem()
  ethernet: remove nvmem_get_mac_address()

 include/linux/etherdevice.h |  1 -
 net/core/of_net.c           | 17 +++++++++--------
 net/ethernet/eth.c          | 36 ------------------------------------
 3 files changed, 9 insertions(+), 45 deletions(-)

-- 
2.32.0

