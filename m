Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9E5419F8F
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 21:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236547AbhI0T4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 15:56:13 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:55350 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235711AbhI0T4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 15:56:11 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 2B2E62063EC5
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 01/18] ravb: Rename "ravb_set_features_rx_csum"
 function to "ravb_set_features_rcar"
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
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-2-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <218bf6af-beec-7afe-8cb6-321e9da2841a@omp.ru>
Date:   Mon, 27 Sep 2021 22:54:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923140813.13541-2-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 5:07 PM, Biju Das wrote:

> Rename "ravb_set_features_rx_csum" function to "ravb_set_features_rcar" and
> replace the function pointer "set_rx_csum_feature" with "set_feature".
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

MBR, Sergey
