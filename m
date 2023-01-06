Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B6E66080E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 21:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbjAFUS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 15:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235773AbjAFUSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 15:18:10 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F81B7A38B;
        Fri,  6 Jan 2023 12:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673036190; x=1704572190;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=E59BVbXIk3cH9wxRO5cqBkZUsUNdLee72ymZRqWEtYo=;
  b=l37ts5+S7+V6zHoBbFD5BP3IM/5Zbln9aXAzHAbj5O3Jj1ACoJqveUw6
   d3ktlGnrw+uyqpB7V6FZYyBSZ/XaxsfTUInWucA0vBlMkiAlzqbpanjcr
   8uwLI1SU2OWyapMofXsnGehorKDHRlNEMBP/kESAPPJ7oYtime68lyUE8
   9CW7sEpYOOt9RWKybaGlGOFDbRIYrZWlg2HKAYUpNo0mWikeo96P2UQoi
   CsjGRhzBU9/tYcRfqa+gCquj1l/S9kBZhHaI/+YoAkEydCiS7Ofo8wX2W
   pP0O7MnLxXV/9ZrjpgL/x9opqnEV5hAzLb1YOU3fKE5gHDyLXNL0CI9cq
   A==;
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="195636436"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jan 2023 13:16:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 13:16:29 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 6 Jan 2023 13:16:29 -0700
Date:   Fri, 6 Jan 2023 21:21:48 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
CC:     <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: lan966x: check for ptp to be enabled in
 lan966x_ptp_deinit()
Message-ID: <20230106202148.77gkauaikjhyjcvi@soft-dev3-1>
References: <20230106134830.333494-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230106134830.333494-1-clement.leger@bootlin.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/06/2023 14:48, Clément Léger wrote:

Hi Clement,

> 
> If ptp was not enabled due to missing IRQ for instance,
> lan966x_ptp_deinit() will dereference NULL pointers.
> 
> Fixes: d096459494a8 ("net: lan966x: Add support for ptp clocks")
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

You forgot to mark the patch to target the net tree.  But other
than that looks good.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> index f9ebfaafbebc..a8348437dd87 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> @@ -1073,6 +1073,9 @@ void lan966x_ptp_deinit(struct lan966x *lan966x)
>         struct lan966x_port *port;
>         int i;
> 
> +       if (!lan966x->ptp)
> +               return;
> +
>         for (i = 0; i < lan966x->num_phys_ports; i++) {
>                 port = lan966x->ports[i];
>                 if (!port)
> --
> 2.38.1
> 

-- 
/Horatiu
