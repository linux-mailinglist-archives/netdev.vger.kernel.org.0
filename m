Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70C548E8CD
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 12:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240645AbiANLDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 06:03:22 -0500
Received: from mxout03.lancloud.ru ([45.84.86.113]:39450 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240381AbiANLDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 06:03:19 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 6EF2020EF23D
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH] bcmgenet: add WOL IRQ check
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>
References: <2b49e965-850c-9f71-cd54-6ca9b7571cc3@omp.ru>
 <YeCS6Ld93zCK6aWh@lunn.ch>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <bf2cff36-9452-59bb-49e9-d5c2285eeb2a@omp.ru>
Date:   Fri, 14 Jan 2022 14:03:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YeCS6Ld93zCK6aWh@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 1/14/22 12:00 AM, Andrew Lunn wrote:

>> The driver neglects to check the result of platform_get_irq_optional()'s
>> call and blithely passes the negative error codes to devm_request_irq()
>> (which takes *unsigned* IRQ #), causing it to fail with -EINVAL.
>> Stop calling devm_request_irq() with the invalid IRQ #s.
>>
>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>>
>> ---
>> This patch is against DaveM's 'net.git' repo.
> 
> Since this is for net, it needs a Fixes: tag.
> 
> Fixes: 8562056f267d ("net: bcmgenet: request Wake-on-LAN interrupt")

   Indeed, I completely forgot about it. Thanks! :-)

>        Andrew

MBR, Sergey
