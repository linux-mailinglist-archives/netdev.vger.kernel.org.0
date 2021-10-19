Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061F1432C1C
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhJSDPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:15:01 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:24356 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhJSDPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 23:15:00 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HYJbL27WQzcbX2;
        Tue, 19 Oct 2021 11:08:14 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 11:12:46 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 11:12:45 +0800
Subject: Re: [PATCH net] mwifiex: Fix possible memleak in probe and disconnect
To:     Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <shenyang39@huawei.com>,
        <marcelo@kvack.org>, <linville@tuxdriver.com>,
        <luisca@cozybit.com>, <libertas-dev@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <20211018063818.1895774-1-wanghai38@huawei.com>
 <163456107685.11105.13969946027999768773.kvalo@codeaurora.org>
 <CA+ASDXMQhjOCwjVUcstx3GoZeqsFJ4e_6FCFos6Kqb34N66axg@mail.gmail.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <39c2455a-8213-409c-22b9-89586cc43a44@huawei.com>
Date:   Tue, 19 Oct 2021 11:12:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+ASDXMQhjOCwjVUcstx3GoZeqsFJ4e_6FCFos6Kqb34N66axg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/10/19 1:02, Brian Norris 写道:
> On Mon, Oct 18, 2021 at 5:45 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>> mwifiex patches are applied to wireless-drivers, not to the net tree. Please be
>> careful how you mark your patches.
> Also, the driver being patched is "libertas" (a different Marvell
> driver), not "mwifiex" -- so the subject line is doubly wrong.
Sorry, I will send a v2 patch to fix this issue,
and I will pay more attention to this in the future.
> Brian
> .
>
-- 
Wang Hai

