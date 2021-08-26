Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83473F8F9E
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 22:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243119AbhHZU2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 16:28:30 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:60448 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhHZU23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 16:28:29 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 0B9572077525
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 07/13] ravb: Factorise ravb_ring_init function
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-8-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <07c7fe9c-6b72-0603-c9b0-f23bc249b573@omp.ru>
Date:   Thu, 26 Aug 2021 23:27:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210825070154.14336-8-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 10:01 AM, Biju Das wrote:

> The ravb_ring_init function uses an extended descriptor in RX for
> R-Car and normal descriptor for RZ/G2L. Add a helper function
> for RX ring buffer allocation to support later SoC.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
   Here as well...
[...]

   Seems sane, so:

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

MBR, Sergey
