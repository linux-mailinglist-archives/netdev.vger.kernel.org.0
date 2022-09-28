Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FC45EE441
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 20:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbiI1SXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 14:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbiI1SXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 14:23:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8665C101956;
        Wed, 28 Sep 2022 11:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664389422; x=1695925422;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mafWaAJGdDQya+zyqgkZLQXkrmmI+H/d5whBuw3Clpc=;
  b=ZPqP4ywHwEq1tnXQG1V70Zygp00jrgOz9gxGEzH8R/LIWxx5YzTJkMSp
   9x3zyxVtwbXqUxrWHALG85jq0FLdfaVaiY5p1V+cpMn/2UZgrubmz3YDB
   jN3NAs/TCcVbgEbI4eg4BXKOH/TYvIyTnrk6l+JAaLgdciSr6/wAdegFz
   YSUXGvq1nVintWssTSVohHmhuDtPacYNl7JWkPMX5m1olwQT7Fmn+c2qB
   /omNM/TGsOkH8lDq2clwXT3eXlQRnZ/Pqonm0F+KnG9j75q7hTaGqxdPc
   eyeYLy7r0LD+tPOhQl6974tPka7bqEZ6v7ynnvFW9SgFd0n9M3rfwowPk
   A==;
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="115880602"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2022 11:23:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 28 Sep 2022 11:23:39 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Wed, 28 Sep 2022 11:23:39 -0700
Date:   Wed, 28 Sep 2022 20:28:08 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Colin Ian King <colin.i.king@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] net: lan966x: Fix spelling mistake "tarffic" ->
 "traffic"
Message-ID: <20220928182808.gsfwyjlmunxl7k6z@soft-dev3-1.localhost>
References: <20220928143618.34947-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220928143618.34947-1-colin.i.king@gmail.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/28/2022 15:36, Colin Ian King wrote:
> 
> There is a spelling mistake in a netdev_err message. Fix it.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c
> index 950ea4807eb6..7fa76e74f9e2 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c
> @@ -7,7 +7,7 @@ int lan966x_mqprio_add(struct lan966x_port *port, u8 num_tc)
>         u8 i;
> 
>         if (num_tc != NUM_PRIO_QUEUES) {
> -               netdev_err(port->dev, "Only %d tarffic classes supported\n",
> +               netdev_err(port->dev, "Only %d traffic classes supported\n",
>                            NUM_PRIO_QUEUES);
>                 return -EINVAL;
>         }
> --
> 2.37.1
> 

-- 
/Horatiu
