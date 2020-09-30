Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235BC27DD94
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 03:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbgI3BHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 21:07:52 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14782 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728943AbgI3BHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 21:07:52 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 225AAD9D0A17AE456A33;
        Wed, 30 Sep 2020 09:07:51 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Wed, 30 Sep 2020
 09:07:40 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH 0/2] Fix inconsistent of format with argument type
Date:   Wed, 30 Sep 2020 09:08:36 +0800
Message-ID: <20200930010838.1266872-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ye Bin (2):
  pktgen: Fix inconsistent of format with argument type in pktgen.c
  net-sysfs: Fix inconsistent of format with argument type in 
    net-sysfs.c

 net/core/net-sysfs.c |  4 ++--
 net/core/pktgen.c    | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

-- 
2.25.4

