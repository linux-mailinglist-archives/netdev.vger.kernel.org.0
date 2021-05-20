Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73462389C18
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 05:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhETDwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 23:52:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3612 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhETDwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 23:52:19 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Flwh907NBzmXQk;
        Thu, 20 May 2021 11:48:41 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 11:50:57 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 20 May 2021 11:50:57 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tanghui20@huawei.com>
Subject: [PATCH net-next 0/9] net: remove leading spaces before tabs
Date:   Thu, 20 May 2021 11:47:45 +0800
Message-ID: <1621482474-26903-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

        $ find . -name '*.[ch]' | xargs sed -r -i 's/^[ ]+\t/\t/'

Hui Tang (9):
  net: wan: remove leading spaces before tabs
  net: usb: remove leading spaces before tabs
  net: slip: remove leading spaces before tabs
  net: ppp: remove leading spaces before tabs
  net: hamradio: remove leading spaces before tabs
  net: fddi: skfp: remove leading spaces before tabs
  net: appletalk: remove leading spaces before tabs
  ifb: remove leading spaces before tabs
  mii: remove leading spaces before tabs

 drivers/net/appletalk/cops.c       | 30 +++++++++++++++---------------
 drivers/net/appletalk/ltpc.c       |  6 +++---
 drivers/net/fddi/skfp/ess.c        |  6 +++---
 drivers/net/fddi/skfp/h/supern_2.h |  2 +-
 drivers/net/hamradio/baycom_epp.c  |  4 ++--
 drivers/net/hamradio/hdlcdrv.c     |  2 +-
 drivers/net/hamradio/mkiss.c       |  6 +++---
 drivers/net/hamradio/scc.c         | 20 ++++++++++----------
 drivers/net/hamradio/yam.c         |  2 +-
 drivers/net/ifb.c                  |  4 ++--
 drivers/net/mii.c                  |  2 +-
 drivers/net/ppp/bsd_comp.c         |  2 +-
 drivers/net/slip/slhc.c            |  2 +-
 drivers/net/usb/mcs7830.c          |  2 +-
 drivers/net/wan/lmc/lmc.h          |  2 +-
 drivers/net/wan/wanxl.c            |  4 ++--
 drivers/net/wan/z85230.c           |  8 ++++----
 17 files changed, 52 insertions(+), 52 deletions(-)

--
2.8.1

