Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC4645A645
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 16:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236182AbhKWPM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 10:12:59 -0500
Received: from mxout04.lancloud.ru ([45.84.86.114]:46796 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238358AbhKWPM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 10:12:56 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 428FD2097CBC
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Message-ID: <b43b2323-e83f-209b-bdff-33c6800d27e3@omp.ru>
Date:   Tue, 23 Nov 2021 18:09:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC 0/2] Add Rx checksum offload support
Content-Language: en-US
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "Biju Das" <biju.das@bp.renesas.com>
References: <20211123133157.21829-1-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
In-Reply-To: <20211123133157.21829-1-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 23.11.2021 16:31, Biju Das wrote:

> TOE has hw support for calculating IP header checkum for IPV4 and

    hw == hardware? And checksum. :-)

> TCP/UDP/ICMP checksum for both IPV4 and IPV6.
> 
> This patch series aims to adds Rx checksum offload supported by TOE.
> 
> For RX, The result of checksum calculation is attached to last 4byte
> of ethernet frames. First 2bytes is result of IPV4 header checksum
> and next 2 bytes is TCP/UDP/ICMP.
> 
> if frame does not have error "0000" attached to checksum calculation
> result. For unsupported frames "ffff" is attached to checksum calculation
> result. Cases like IPV6, IPV4 header is always set to "FFFF".

    You just said IPv4 header checksum is supported?

> we can test this functionality by the below commands
> 
> ethtool -K eth0 rx on --> to turn on Rx checksum offload
> ethtool -K eth0 rx off --> to turn off Rx checksum offload
> 
> Biju Das (2):
>    ravb: Fillup ravb_set_features_gbeth() stub
>    ravb: Add Rx checksum offload support
> 
>   drivers/net/ethernet/renesas/ravb.h      | 20 +++++++++
>   drivers/net/ethernet/renesas/ravb_main.c | 55 +++++++++++++++++++++++-
>   2 files changed, 74 insertions(+), 1 deletion(-)

    Dave, Jakub, I'll try reviewing these later today.

MBR, Sergey
