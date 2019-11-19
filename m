Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3E4102539
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfKSNOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:14:45 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7143 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725280AbfKSNOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 08:14:45 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5757D396F74BACAF5382;
        Tue, 19 Nov 2019 21:14:41 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 19 Nov 2019
 21:14:38 +0800
Subject: Re: [GIT] Networking
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>
References: <20191116.133321.709008936600873428.davem@davemloft.net>
 <CAMuHMdX8Fi1PDEcrPJ3frsg+LG04hCN2vbgJ=+NyEArnqmcb1Q@mail.gmail.com>
CC:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <32c02bd4-6c6a-5e55-7a47-1a42d2c9c1af@huawei.com>
Date:   Tue, 19 Nov 2019 21:14:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdX8Fi1PDEcrPJ3frsg+LG04hCN2vbgJ=+NyEArnqmcb1Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/11/19 21:01, Geert Uytterhoeven wrote:
> On Sat, Nov 16, 2019 at 10:37 PM David Miller <davem@davemloft.net> wrote:
>> YueHaibing (1):
>>       mdio_bus: Fix PTR_ERR applied after initialization to constant
> 
> FTR, this causes a boot regression if CONFIG_RESET_CONTROLLER=n.
> Patch sent
> https://lore.kernel.org/lkml/20191119112524.24841-1-geert+renesas@glider.be/

Sorry for this.

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 

