Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A35F4558A4
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 11:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245499AbhKRKKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 05:10:51 -0500
Received: from mxout01.lancloud.ru ([45.84.86.81]:36494 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245491AbhKRKJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 05:09:27 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 7C2A320E66C1
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Message-ID: <733ea341-7105-e552-f562-4fb362543088@omp.ru>
Date:   Thu, 18 Nov 2021 13:06:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH -next v2] ethernet: renesas: Use div64_ul instead of
 do_div
Content-Language: en-US
To:     Yang Li <yang.lee@linux.alibaba.com>, <davem@davemloft.net>
CC:     <kuba@kernel.org>, <geert@linux-m68k.org>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1637228883-100100-1-git-send-email-yang.lee@linux.alibaba.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
In-Reply-To: <1637228883-100100-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.11.2021 12:48, Yang Li wrote:

> do_div() does a 64-by-32 division. Here the divisor is an
> unsigned long which on some platforms is 64 bit wide. So use
> div64_ul instead of do_div to avoid a possible truncation.
> 
> Eliminate the following coccicheck warning:
> ./drivers/net/ethernet/renesas/ravb_main.c:2492:1-7: WARNING:
> do_div() does a 64-by-32 division, please consider using div64_ul
> instead.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

    I haven't given you this tag, yet I was going to give you one, so
it's OK finally. :-)

[...]

MBR, Sergey
