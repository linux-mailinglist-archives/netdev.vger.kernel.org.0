Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA2213226D
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgAGJdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:33:14 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8229 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726485AbgAGJdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 04:33:14 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 476879CBD0B7BC2E67E0;
        Tue,  7 Jan 2020 17:33:12 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Tue, 7 Jan 2020 17:33:04 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <chenzhou10@huawei.com>
Subject: [PATCH next 0/2] net: ch9200: code cleanup
Date:   Tue, 7 Jan 2020 17:28:54 +0800
Message-ID: <20200107092856.97742-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch 1 introduce __func__ in debug message.
patch 2 remove unnecessary return.

Chen Zhou (2):
  net: ch9200: use __func__ in debug message
  net: ch9200: remove unnecessary return

 drivers/net/usb/ch9200.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

-- 
2.7.4

