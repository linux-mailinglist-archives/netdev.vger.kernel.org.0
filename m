Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D412B38D551
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 12:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhEVKzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 06:55:20 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5666 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhEVKzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 06:55:20 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FnKyd3Ngmz1BPjC;
        Sat, 22 May 2021 18:51:05 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 18:53:53 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 22 May
 2021 18:53:53 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>
Subject: [PATCH -next 0/2] fix missing error code on path err_unsupported
Date:   Sat, 22 May 2021 18:58:20 +0800
Message-ID: <20210522105822.1091848-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Yingliang (2):
  ath10k: go to path err_unsupported when chip id is not supported
  ath10k: add missing error return code in ath10k_pci_probe()

 drivers/net/wireless/ath/ath10k/pci.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

-- 
2.25.1

