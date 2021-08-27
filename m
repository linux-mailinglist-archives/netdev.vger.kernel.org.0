Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD05F3F9FB9
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 21:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhH0TRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 15:17:45 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:45112 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhH0TRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 15:17:44 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 739E12094596
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 10/13] ravb: Factorise ravb_set_features
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
 <20210825070154.14336-11-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <e08a1cf0-aac6-3ae2-fead-9b1f916fc27b@omp.ru>
Date:   Fri, 27 Aug 2021 22:16:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210825070154.14336-11-biju.das.jz@bp.renesas.com>
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

> RZ/G2L supports HW checksum on RX and TX whereas R-Car supports on RX.
> Factorise ravb_set_features to support this feature.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 15 +++++++++++++--
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 1f9d9f54bf1b..1789309c4c03 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -1901,8 +1901,8 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
>  	spin_unlock_irqrestore(&priv->lock, flags);
>  }
>  
> -static int ravb_set_features(struct net_device *ndev,
> -			     netdev_features_t features)
> +static int ravb_set_features_rx_csum(struct net_device *ndev,
> +				     netdev_features_t features)

   How about ravb_set_features_rcar() or s/th alike?

[...]

   Other than that:

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
   Let's see the TOC code now...

MBR, Sergey
