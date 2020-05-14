Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EF11D3266
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgENOOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:14:17 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:45270 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgENOOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:14:17 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49ND7C4ywLz1r56H;
        Thu, 14 May 2020 16:14:15 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49ND7C4Txpz1qspc;
        Thu, 14 May 2020 16:14:15 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id Y3cyn2FzUYOF; Thu, 14 May 2020 16:14:13 +0200 (CEST)
X-Auth-Info: v8ojN3NFMeStFOk2Kk4i5/I89J668xK8EHCcLrfVQXU=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 14 May 2020 16:14:13 +0200 (CEST)
Subject: Re: [PATCH V5 18/19] net: ks8851: Implement Parallel bus operations
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-19-marex@denx.de> <20200514015753.GL527401@lunn.ch>
 <5dbab44d-de45-f8e2-b4e4-4be15408657e@denx.de>
 <20200514131527.GN527401@lunn.ch>
 <16f60604-f3e9-1391-ff47-37c40ab9c6f7@denx.de>
 <20200514140722.GQ499265@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <b810e344-8a6c-a3dc-cfd3-1eba116bfcd7@denx.de>
Date:   Thu, 14 May 2020 16:14:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200514140722.GQ499265@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 4:07 PM, Andrew Lunn wrote:
>> All right
>>
>> btw is jiffies-based timeout OK? Like this:
> 
> If you can, make use of include/linux/iopoll.h

I can't, because I need those weird custom accessors, see
ks8851_wrreg16_par(), unless I'm missing something there?
