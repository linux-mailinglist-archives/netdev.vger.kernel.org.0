Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7590C34B55E
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 09:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhC0IOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 04:14:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14631 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhC0IOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 04:14:30 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6s5Q1ZqCz1BGkh;
        Sat, 27 Mar 2021 16:12:26 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 16:14:19 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <dsahern@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <wangxiongfeng2@huawei.com>
Subject: [PATCH 0/9] net: Correct function names in the kerneldoc comments
Date:   Sat, 27 Mar 2021 16:15:47 +0800
Message-ID: <20210327081556.113140-1-wangxiongfeng2@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiongfeng Wang (9):
  l3mdev: Correct function names in the kerneldoc comments
  netlabel: Correct function name netlbl_mgmt_add() in the kerneldoc
    comments
  net: core: Correct function name dev_uc_flush() in the kerneldoc
  net: core: Correct function name netevent_unregister_notifier() in the
    kerneldoc
  net: 9p: Correct function name errstr2errno() in the kerneldoc
    comments
  9p/trans_fd: Correct function name p9_mux_destroy() in the kerneldoc
  net: 9p: Correct function names in the kerneldoc comments
  ip6_tunnel:: Correct function name parse_tvl_tnl_enc_lim() in the
    kerneldoc comments
  NFC: digital: Correct function name in the kerneldoc comments

 net/9p/client.c              | 4 ++--
 net/9p/error.c               | 2 +-
 net/9p/trans_fd.c            | 2 +-
 net/core/dev_addr_lists.c    | 2 +-
 net/core/netevent.c          | 2 +-
 net/ipv6/ip6_tunnel.c        | 2 +-
 net/l3mdev/l3mdev.c          | 4 ++--
 net/netlabel/netlabel_mgmt.c | 2 +-
 net/nfc/digital_core.c       | 2 +-
 9 files changed, 11 insertions(+), 11 deletions(-)

-- 
2.20.1

