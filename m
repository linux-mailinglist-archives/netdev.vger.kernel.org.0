Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C9D49F1C1
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 04:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345690AbiA1DWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 22:22:10 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:16930 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345661AbiA1DWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 22:22:09 -0500
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JlN2B6RQkzZfWY
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 11:18:10 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 28 Jan 2022 11:22:07 +0800
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 28 Jan 2022 11:22:07 +0800
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        Zhang Changzhong <zhangchangzhong@huawei.com>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Subject: [Question] memory leaks related to TCP internal pacing in old kernel
Message-ID: <a691ee96-4be3-a0dc-fadf-a14e4c0aed2f@huawei.com>
Date:   Fri, 28 Jan 2022 11:22:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

We encountered a memory leak issue related to TCP internal pacing in linux-4.19.

After some searching, we found the discussion about same question [1], the fix you suggested
solved our problem, but this patch seems to have been forgotten.

I wonder if there are any other issues with this patch? If not, would you mind submitting it
for stable branch?

[1] https://lore.kernel.org/all/20200602080425.93712-1-kerneljasonxing@gmail.com/

Thanks,
Changzhong
