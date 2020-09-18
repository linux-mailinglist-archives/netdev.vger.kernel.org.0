Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFAE26EA6C
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgIRBXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:23:01 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59246 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725886AbgIRBXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 21:23:01 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 54ECF222852D89EE1CDF;
        Fri, 18 Sep 2020 09:22:59 +0800 (CST)
Received: from [10.174.179.108] (10.174.179.108) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Fri, 18 Sep 2020 09:22:55 +0800
Subject: Re: [PATCH net-next] genetlink: Remove unused function
 genl_err_attr()
To:     Cong Wang <xiyou.wangcong@gmail.com>
References: <20200916141728.34796-1-yuehaibing@huawei.com>
 <CAM_iQpUgZo+xz8+iwma6FxLdoxXvdtq_tZc1aMipfqHEU3x6qA@mail.gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Jiri Pirko" <jiri@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <41b8d535-5c66-51ec-8865-d97d53868227@huawei.com>
Date:   Fri, 18 Sep 2020 09:22:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUgZo+xz8+iwma6FxLdoxXvdtq_tZc1aMipfqHEU3x6qA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/18 2:34, Cong Wang wrote:
> On Wed, Sep 16, 2020 at 9:33 AM YueHaibing <yuehaibing@huawei.com> wrote:
>>
>> It is never used, so can remove it.
> 
> This is a bit confusing, it was actually used before, see commit
> ab0d76f6823cc3a4e2.

Yes,thanks for reminding, will be careful later.
> .
> 
