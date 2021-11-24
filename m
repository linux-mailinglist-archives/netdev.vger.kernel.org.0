Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCEF45CDDC
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242701AbhKXUTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:19:41 -0500
Received: from mxout03.lancloud.ru ([45.84.86.113]:43884 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241088AbhKXUTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:19:40 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru E56CC20A4737
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC 0/2] Add Rx checksum offload support
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
Message-ID: <50544d12-01f1-2ec0-a9e1-992a307cc781@omp.ru>
Date:   Wed, 24 Nov 2021 23:16:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211123133157.21829-1-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/21 4:31 PM, Biju Das wrote:

> TOE has hw support for calculating IP header checkum for IPV4 and
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
> 
> we can test this functionality by the below commands
> 
> ethtool -K eth0 rx on --> to turn on Rx checksum offload
> ethtool -K eth0 rx off --> to turn off Rx checksum offload
> 
> Biju Das (2):
>   ravb: Fillup ravb_set_features_gbeth() stub
>   ravb: Add Rx checksum offload support

   That's all fine but why in the world did you separate these patches?

MBR, Sergey
