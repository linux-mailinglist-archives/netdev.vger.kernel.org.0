Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F02D1ABDC4
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 12:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504808AbgDPKTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 06:19:16 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:59245 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504770AbgDPKSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 06:18:52 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 492wD76B9cz1qs0n;
        Thu, 16 Apr 2020 12:18:23 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 492wCz42dDz1qql2;
        Thu, 16 Apr 2020 12:18:23 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id kV0qKZZrGZqE; Thu, 16 Apr 2020 12:18:22 +0200 (CEST)
X-Auth-Info: RFRCOMQ8A+wI4xnZzg2DDUYeiucb8V+HdF7CHstUXs8=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 16 Apr 2020 12:18:22 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
Subject: Re: [PATCH V4 17/19] net: ks8851: Separate SPI operations into
 separate file
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200414182029.183594-1-marex@denx.de>
 <20200414182029.183594-18-marex@denx.de>
 <20200415145620.43mhdpqak7e36p23@wunner.de>
Message-ID: <88d884c9-84b1-ca31-17f2-a3769346e753@denx.de>
Date:   Thu, 16 Apr 2020 11:58:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200415145620.43mhdpqak7e36p23@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/20 4:56 PM, Lukas Wunner wrote:
> On Tue, Apr 14, 2020 at 08:20:27PM +0200, Marek Vasut wrote:
>> +static void __maybe_unused ks8851_done_tx(struct ks8851_net *ks,
> 
> If I'm not mistaken, the __maybe_unused is unnecessary here.
> Was added in v3.

It is necessary, because the header is included by the ks8851_common.c
as well as the ks8851_{par,spi,mll}.c, and it's only the later which use
that function. So this is needed to prevent a warning when building the
ks8851_common.c , where it is not used.

>> +#endif
> 
> A "/* __KS8851_H__ */" comment here would be nice.

OK
