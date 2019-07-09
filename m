Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA86762EF2
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfGIDby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:31:54 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51602 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727294AbfGIDbe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 23:31:34 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 914E36710C36FFFF234A;
        Tue,  9 Jul 2019 11:31:29 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Tue, 9 Jul 2019
 11:31:20 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <mark.rutland@arm.com>, <dingtianhong@huawei.com>,
        <xiaojiangfeng@huawei.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <leeyou.li@huawei.com>,
        <nixiaoming@huawei.com>, <jianping.liu@huawei.com>,
        <xiekunxun@huawei.com>
Subject: [PATCH v2 00/10] net: hisilicon: Add support for HI13X1 to hip04_eth
Date:   Tue, 9 Jul 2019 11:31:01 +0800
Message-ID: <1562643071-46811-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.167]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main purpose of this patch series is to extend the
hip04_eth driver to support HI13X1_GMAC.

The offset and bitmap of some registers of HI13X1_GMAC
are different from hip04_eth common soc. In addition,
the definition of send descriptor and parsing descriptor
are different from hip04_eth common soc. So the macro
of the register offset is redefined to adapt the HI13X1_GMAC.

Clean up the sparse warning by the way.

Change since v1:
* Add a cover letter.

Jiangfeng Xiao (10):
  net: hisilicon: Add support for HI13X1 to hip04_eth
  net: hisilicon: Cleanup for got restricted __be32
  net: hisilicon: Cleanup for cast to restricted __be32
  net: hisilicon: HI13X1_GMAX skip write LOCAL_PAGE_REG
  net: hisilicon: HI13X1_GMAX need dreq reset at first
  net: hisilicon: dt-bindings: Add an field of port-handle
  net: hisilicon: Add group field to adapt HI13X1_GMAC
  net: hisilicon: Offset buf address to adapt HI13X1_GMAC
  net: hisilicon: Add an rx_desc to adapt HI13X1_GMAC
  net: hisilicon: Add an tx_desc to adapt HI13X1_GMAC

 .../bindings/net/hisilicon-hip04-net.txt           |   7 +-
 drivers/net/ethernet/hisilicon/Kconfig             |  10 ++
 drivers/net/ethernet/hisilicon/hip04_eth.c         | 142 ++++++++++++++++++---
 3 files changed, 136 insertions(+), 23 deletions(-)

-- 
1.8.5.6

