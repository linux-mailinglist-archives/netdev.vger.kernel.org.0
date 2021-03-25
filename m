Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58E13487A8
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 04:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhCYDvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 23:51:42 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14866 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhCYDv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 23:51:28 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F5WLs1c6Sz9sjM;
        Thu, 25 Mar 2021 11:49:25 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 11:51:16 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kiyin@tencent.com>,
        <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sameo@linux.intel.com>, <linville@tuxdriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <mkl@pengutronix.de>,
        <stefan@datenfreihafen.org>, <matthieu.baerts@tessares.net>,
        <netdev@vger.kernel.org>
CC:     <nixiaoming@huawei.com>, <wangle6@huawei.com>,
        <xiaoqian9@huawei.com>
Subject: [PATCH resend 0/4] nfc: fix Resource leakage and endless loop
Date:   Thu, 25 Mar 2021 11:51:09 +0800
Message-ID: <20210325035113.49323-1-nixiaoming@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <YFnwiFmgejk/TKOX@kroah.com>
References: <YFnwiFmgejk/TKOX@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.189.174]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix Resource leakage and endless loop in net/nfc/llcp_sock.c,
 reported by "kiyin(尹亮)".

Link: https://www.openwall.com/lists/oss-security/2020/11/01/1

Xiaoming Ni (4):
  nfc: fix refcount leak in llcp_sock_bind()
  nfc: fix refcount leak in llcp_sock_connect()
  nfc: fix memory leak in llcp_sock_connect()
  nfc: Avoid endless loops caused by repeated llcp_sock_connect()

 net/nfc/llcp_sock.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

-- 
2.27.0

