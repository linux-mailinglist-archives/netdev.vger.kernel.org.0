Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771C634FB71
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhCaIVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:21:31 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15831 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbhCaIVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:21:11 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F9K3D3MfQz9v1W;
        Wed, 31 Mar 2021 16:19:04 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Wed, 31 Mar 2021 16:21:03 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 0/7] net: fix some coding style issues
Date:   Wed, 31 Mar 2021 16:18:27 +0800
Message-ID: <1617178714-14031-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do some cleanups according to the coding style of kernel, including wrong
print type, redundant and missing spaces and so on.

Yangyang Li (1):
  net: lpc_eth: fix format warnings of block comments

Yixing Liu (6):
  net: ena: fix inaccurate print type
  net: ena: remove extra words from comments
  net: amd8111e: fix inappropriate spaces
  net: amd: correct some format issues
  net: ocelot: fix a trailling format issue with block comments
  net: toshiba: fix the trailing format of some block comments

 drivers/net/ethernet/amazon/ena/ena_com.c    |   4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c |   2 +-
 drivers/net/ethernet/amd/amd8111e.c          | 362 +++++++++++++--------------
 drivers/net/ethernet/amd/hplance.c           |   3 +
 drivers/net/ethernet/mscc/ocelot.c           |   3 +-
 drivers/net/ethernet/nxp/lpc_eth.c           |   9 +-
 drivers/net/ethernet/toshiba/spider_net.c    |  42 ++--
 drivers/net/ethernet/toshiba/tc35815.c       |   3 +-
 8 files changed, 221 insertions(+), 207 deletions(-)

-- 
2.8.1

