Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B643F76DE
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 16:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241162AbhHYOH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 10:07:29 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:55368 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240704AbhHYOH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 10:07:29 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru A1AF5205E50B
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 00/13] Add Factorisation code to support Gigabit
 Ethernet driver
To:     Andrew Lunn <andrew@lunn.ch>, Sergey Shtylyov <s.shtylyov@omp.ru>
CC:     <patchwork-bot+netdevbpf@kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        <geert+renesas@glider.be>, <aford173@gmail.com>,
        <yoshihiro.shimoda.uh@renesas.com>, <netdev@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <Chris.Paterson2@renesas.com>,
        <biju.das@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <162988740967.13655.14613353702366041003.git-patchwork-notify@kernel.org>
 <02fc27c2-a816-d60d-6611-162f3b70444a@omp.ru> <YSZJxdN/hkcz5Zmw@lunn.ch>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <ea8b767a-a620-798f-ecb0-a8775c60ad51@omp.ru>
Date:   Wed, 25 Aug 2021 17:06:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YSZJxdN/hkcz5Zmw@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 4:46 PM, Andrew Lunn wrote:

[...]
>>> This series was applied to netdev/net-next.git (refs/heads/master):
>>>
>>> On Wed, 25 Aug 2021 08:01:41 +0100 you wrote:
>>    Now this is super fast -- I didn't even have the time to promise
>> reviewing... :-/
> 
> 2 hours 30 minutes, i think.

   Took 3 hours 30 mins on my side. :-)

> Seems like reviews are no longer wanted in netdev.

   At least with merge window coming close? 

>       Andrew

MBR, Sergey
