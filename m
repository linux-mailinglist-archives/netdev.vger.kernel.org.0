Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBF441649E
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 19:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242633AbhIWRpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 13:45:03 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:45256 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242611AbhIWRpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 13:45:02 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru E818320C7AB8
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 00/18] Add Gigabit Ethernet driver support
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <c423d886-31f5-7ff2-c8d3-6612b2963972@omp.ru>
 <20210923083755.12186362@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <9475da86-96bb-cec3-d5a6-19ebc69aa9b0@omp.ru>
Date:   Thu, 23 Sep 2021 20:43:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923083755.12186362@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 6:37 PM, Jakub Kicinski wrote:

>>>  drivers/net/ethernet/renesas/ravb_main.c | 631 ++++++++++++++++++++---
>>>  2 files changed, 630 insertions(+), 92 deletions(-)  
>>
>>    There's a lot of new code....
> 
> TBH the patches look small an reasonably split to me.

    They only /look/ reasonably split. :-)

> Thanks for the "intending to review" note :)

   I was afraid DaveM would merge the series without any review. :-) 

MBR, Sergey
