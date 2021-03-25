Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90953348931
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 07:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhCYGhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 02:37:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14871 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbhCYGhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 02:37:06 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F5b1v6cFLz9spF;
        Thu, 25 Mar 2021 14:34:59 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Thu, 25 Mar 2021
 14:36:58 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <idryomov@gmail.com>, <jlayton@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ceph-devel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xiyou.wangcong@gmail.com>, <ap420073@gmail.com>,
        <linux-decnet-user@lists.sourceforge.net>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <olteanv@gmail.com>, <steffen.klassert@secunet.com>,
        <herbert@gondor.apana.org.au>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>
Subject: [PATCH -next 0/5]Fix some typos
Date:   Thu, 25 Mar 2021 14:38:20 +0800
Message-ID: <20210325063825.228167-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lu Wei (5):
  net: ceph: Fix a typo in osdmap.c
  net: core: Fix a typo in dev_addr_lists.c
  net: decnet: Fix a typo in dn_nsp_in.c
  net: dsa: Fix a typo in tag_rtl4_a.c
  net: ipv4: Fix some typos

 net/ceph/osdmap.c         | 2 +-
 net/core/dev_addr_lists.c | 2 +-
 net/decnet/dn_nsp_in.c    | 2 +-
 net/dsa/tag_rtl4_a.c      | 2 +-
 net/ipv4/esp4.c           | 4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.17.1

