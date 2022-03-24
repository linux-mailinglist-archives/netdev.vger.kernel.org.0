Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6AF4E6553
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 15:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351004AbiCXOgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 10:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348570AbiCXOgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 10:36:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0751024
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 07:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648132474; x=1679668474;
  h=message-id:subject:from:to:date:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=CPUeDxRcLjxnthD3Bcb4XgAg40kR0HUyUGSkE5Waaes=;
  b=WvVvGstDSr6jE7sQNCgONIXvxm6Ew+jWwUBke+gYnpZCjGoePLmXFJj/
   1GrQyEEvuszAYapDoDuQGXnt9IXUCNrIQiFmi1gyY//gmLF+sMKNAgnMh
   qH9PtZe0N0nK8g3CL8yroxeoJjfSk9KHpaJ6FEiVg+If22ymVov4h0YxY
   LaizrVWLTiOOqJq/f1MLor/bgvS7937SE7fsDW1Q+bQZoPafTiixc10QS
   TQEc8iTW+9BdYTesMgmsaJ8jucztjKakAk4p3sdL/G5+dIjd+aHMhCoJu
   XukoN4lwDdOVbXgRJu6IyBLxhlDW3kwE5IZzZAxV1dxbuhSopX07enrzs
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,207,1643698800"; 
   d="scan'208";a="153136973"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Mar 2022 07:34:33 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 24 Mar 2022 07:34:33 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 24 Mar 2022 07:34:31 -0700
Message-ID: <c126074bed96fb4c553af9e402211e596df5124d.camel@microchip.com>
Subject: Re: [PATCH net-next 1/2] net: sparx5: Remove unused GLAG handling
 in PGID
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>
Date:   Thu, 24 Mar 2022 15:33:09 +0100
In-Reply-To: <20220324113853.576803-2-casper.casan@gmail.com>
References: <20220324113853.576803-1-casper.casan@gmail.com>
         <20220324113853.576803-2-casper.casan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Casper,

On Thu, 2022-03-24 at 12:38 +0100, Casper Andersson wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Removes PGID handling for GLAG since it is not used
> yet. According to feedback on previous patch.
> https://lore.kernel.org/netdev/20220322081823.wqbx7vud4q7qtjuq@wse-c0155/T/#t
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> ---
>  .../net/ethernet/microchip/sparx5/sparx5_main.h |  4 ----
>  .../net/ethernet/microchip/sparx5/sparx5_pgid.c | 17 -----------------
>  2 files changed, 21 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> index 7a04b8f2a546..8e77d7ee8e68 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> @@ -69,9 +69,6 @@ enum sparx5_vlan_port_type {
>  #define PGID_TABLE_SIZE               3290
> 
>  #define PGID_MCAST_START 65
> -#define PGID_GLAG_START 833
> -#define PGID_GLAG_END 1088
> -
>  #define IFH_LEN                9 /* 36 bytes */
>  #define NULL_VID               0
>  #define SPX5_MACT_PULL_DELAY   (2 * HZ)
> @@ -374,7 +371,6 @@ enum sparx5_pgid_type {
>         SPX5_PGID_FREE,
>         SPX5_PGID_RESERVED,
>         SPX5_PGID_MULTICAST,
> -       SPX5_PGID_GLAG
>  };
> 
>  void sparx5_pgid_init(struct sparx5 *spx5);
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
> b/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
> index 90366fcb9958..851a559269e1 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
> @@ -15,28 +15,11 @@ void sparx5_pgid_init(struct sparx5 *spx5)
>                 spx5->pgid_map[i] = SPX5_PGID_RESERVED;
>  }
> 
> -int sparx5_pgid_alloc_glag(struct sparx5 *spx5, u16 *idx)
> -{
> -       int i;
> -
> -       for (i = PGID_GLAG_START; i <= PGID_GLAG_END; i++)
> -               if (spx5->pgid_map[i] == SPX5_PGID_FREE) {
> -                       spx5->pgid_map[i] = SPX5_PGID_GLAG;
> -                       *idx = i;
> -                       return 0;
> -               }
> -
> -       return -EBUSY;
> -}
> -
>  int sparx5_pgid_alloc_mcast(struct sparx5 *spx5, u16 *idx)
>  {
>         int i;
> 
>         for (i = PGID_MCAST_START; i < PGID_TABLE_SIZE; i++) {
> -               if (i == PGID_GLAG_START)
> -                       i = PGID_GLAG_END + 1;
> -
>                 if (spx5->pgid_map[i] == SPX5_PGID_FREE) {
>                         spx5->pgid_map[i] = SPX5_PGID_MULTICAST;
>                         *idx = i;
> --
> 2.30.2
> 

Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>

-- 
Best Regards
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com

