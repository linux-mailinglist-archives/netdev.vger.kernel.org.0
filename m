Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F056F3F1E7F
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhHSQ60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:58:26 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:41090 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbhHSQ6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 12:58:24 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 2DDAE20BEB46
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next v3 9/9] ravb: Add tx_counters to struct
 ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Adam Ford" <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
 <20210818190800.20191-10-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <bbdd24cd-8759-7e06-b790-6e1c8dc01169@omp.ru>
Date:   Thu, 19 Aug 2021 19:57:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210818190800.20191-10-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/21 10:08 PM, Biju Das wrote:

> The register for retrieving TX counters is present only on R-Car Gen3
> and RZ/G2L; it is not present on R-Car Gen2.
> 
> Add the tx_counters hw feature bit to struct ravb_hw_info, to enable this
> feature specifically for R-Car Gen3 now and later extend it to RZ/G2L.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> v2->v3:
>  * Retained Rb tag from Andrew, since change is just renaming the variable
>    and comment update.
> v2:
>  * Incorporated Andrew and Sergei's review comments for making it smaller patch
>    and provided detailed description.
[...]

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

[...]

MBR, Sergey
