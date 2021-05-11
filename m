Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48BF379DE7
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 05:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhEKDnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 23:43:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2616 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhEKDnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 23:43:20 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FfNtz2LxmzQlQq;
        Tue, 11 May 2021 11:38:51 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 11 May 2021 11:42:06 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 0/1] b43: phy_n: Delete some useless TODO code
Date:   Tue, 11 May 2021 11:42:02 +0800
Message-ID: <20210511034203.4122-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1 --> v2:
Fixes "W=1" warnings. That's because after removing the todo code,
the local variables 'noise' and 'tone' are not referenced.

Thanks to Andrew Lunn for his review.


Zhen Lei (1):
  b43: phy_n: Delete some useless TODO code

 drivers/net/wireless/broadcom/b43/phy_n.c | 47 -----------------------
 1 file changed, 47 deletions(-)

-- 
2.26.0.106.g9fadedd


