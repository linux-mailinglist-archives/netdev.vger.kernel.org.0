Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6635D3EB4FC
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 14:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239847AbhHMMIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 08:08:48 -0400
Received: from mx20.baidu.com ([111.202.115.85]:43728 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233780AbhHMMIr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 08:08:47 -0400
Received: from BC-Mail-Ex03.internal.baidu.com (unknown [172.31.51.43])
        by Forcepoint Email with ESMTPS id CE2E6E46BB4B0AC9917A;
        Fri, 13 Aug 2021 20:08:12 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex03.internal.baidu.com (172.31.51.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Fri, 13 Aug 2021 20:08:12 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Fri, 13 Aug 2021 20:08:11 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH 0/2] net: Remove the ipx network layer header files 
Date:   Fri, 13 Aug 2021 20:08:01 +0800
Message-ID: <20210813120803.101-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex16.internal.baidu.com (172.31.51.56) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit <47595e32869f> ("<MAINTAINERS: Mark some staging directories>")
indicated the ipx network layer as obsolete in Jan 2018,
updated in the MAINTAINERS file.

now, after being exposed for 3 years to refactoring, so to
remove the ipx network layer header files

additionally, there is no module that depends on ipx.h
except a broken staging driver(r8188eu)

Cai Huoqing (2):
  net: Remove net/ipx.h and uapi/linux/ipx.h header files
  MAINTAINERS: Remove the ipx network layer info

 MAINTAINERS              |   5 --
 include/net/ipx.h        | 171 ---------------------------------------
 include/uapi/linux/ipx.h |  87 --------------------
 3 files changed, 263 deletions(-)
 delete mode 100644 include/net/ipx.h
 delete mode 100644 include/uapi/linux/ipx.h

-- 
2.25.1

