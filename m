Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0832E191288
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgCXOMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:12:20 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:59049 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbgCXOMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:12:20 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48mtVV4Mlrz1rrL9;
        Tue, 24 Mar 2020 15:12:18 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48mtVV3Pw7z1r0bx;
        Tue, 24 Mar 2020 15:12:18 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id hz_WRuQqpEu1; Tue, 24 Mar 2020 15:12:17 +0100 (CET)
X-Auth-Info: 4Yt2k9m58DCRp5OZLoYVj3KV53hbjK+4xKZYeQrLu9k=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 24 Mar 2020 15:12:17 +0100 (CET)
Subject: Re: [PATCH 14/14] net: ks8851: Remove ks8851_mll.c
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-15-marex@denx.de>
 <20200324140812.e4xv6eelquzmm3bs@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <67ba6b45-6ef3-3175-fe2b-276b944f2575@denx.de>
Date:   Tue, 24 Mar 2020 15:12:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324140812.e4xv6eelquzmm3bs@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/20 3:08 PM, Lukas Wunner wrote:
> On Tue, Mar 24, 2020 at 12:43:03AM +0100, Marek Vasut wrote:
>> The ks8851_mll.c is replaced by ks8851_par.c, which is using common code
>> from ks8851.c, just like ks8851_spi.c . Remove this old ad-hoc driver.
> 
> Hm, have you checked whether ks8851_mll.c contains functionality
> that is currently missing in ks8851.c and which is worth salvaging?

There's 8bit and 32bit bus support. The former was broken and the later
I don't think is even supported by any chip in existence.

btw is there something which has the KS8851 SPI option, so I can test
that one too ?
