Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E03047CE84
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 09:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243507AbhLVI4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 03:56:33 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:30160 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbhLVI4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 03:56:32 -0500
Received: from kwepemi500005.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JJnDx5lPqz8w15;
        Wed, 22 Dec 2021 16:54:09 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500005.china.huawei.com (7.221.188.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 16:56:30 +0800
Received: from compute.localdomain (10.175.112.70) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 16:56:29 +0800
From:   Xu Jia <xujia39@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/2] xfrm: Add support for SM3 and SM4
Date:   Wed, 22 Dec 2021 17:06:57 +0800
Message-ID: <1640164019-42341-1-git-send-email-xujia39@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches add xfrm support for SM3 and SM4 algorithms which are
cryptographic standards published by China State Cryptography 
Administration.

SM3 secure hash (OSCCA GM/T 0004-2012 SM3) is based on Merkle-Damgard 
with a thuncation of 256 bits. It could be used for authentication 
and random number generation.

SM4 symmetric ciper algorithm (OSCCA GB/T 32097-2016) has at least 128
bits packet length which is similar to AES ciper algorithm. It is 
suitable for the use of block ciphers in cryptographic applications.

As SM3 and SM4 have already been supported by Linux kernel,
after these patches, we can use them with "ip xfrm" tools easily.


Xu Jia (2):
  xfrm: Add support for SM3 secure hash
  xfrm: Add support for SM4 symmetric cipher algorithm

 include/uapi/linux/pfkeyv2.h |  2 ++
 net/xfrm/xfrm_algo.c         | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

-- 
1.8.3.1

