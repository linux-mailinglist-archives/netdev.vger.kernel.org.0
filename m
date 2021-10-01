Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A282E41F5A6
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 21:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355973AbhJATS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 15:18:27 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:57276 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355887AbhJATSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 15:18:09 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru AB04B20A4E71
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 0/8] Fillup stubs for Gigabit Ethernet driver support
To:     Jakub Kicinski <kuba@kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20211001164305.8999-1-biju.das.jz@bp.renesas.com>
 <20211001114559.376cbf19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <05d50e0b-d075-2b53-4a9f-4ecdca1c2207@omp.ru>
Date:   Fri, 1 Oct 2021 22:16:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211001114559.376cbf19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/1/21 9:45 PM, Jakub Kicinski wrote:

>> This patch series depend upon [1]
>> [1] https://lore.kernel.org/linux-renesas-soc/20211001150636.7500-1-biju.das.jz@bp.renesas.com/T/#t
> 
> Post it as an RFC, then, please.

   Please don't merge the above 10 patches until I have a chance to review them. I'll try to start reviewing
them today.

MBR, Sergey
