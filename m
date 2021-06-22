Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C713AFE2E
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 09:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhFVHrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 03:47:43 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:60654 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbhFVHrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 03:47:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1624347927; x=1655883927;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LipJUG01p62MmPAyDQSw5ZiD/Qw8f8iwXq0EJ9uUIpk=;
  b=MUyg1gFvPiRzdZArsZEb0bvXhco/kI0P+jk+bTbGHFOP1HjzVuW8ILeO
   Xsp9+HqHLPbnC5YsrwCqahTEmBJHGqNbWjE4vjopn71fqRPNITkEFKEoD
   hfVsgvXDFjT0ByFTQy6swQBXkjXrKDik6DwZBQeWQrCn1wO5gu3uikoNk
   xmzL3mow3yf7yPWUfDB94qXD5RWKLNTZ4CFQG97nZOOZaSPmghv0gJsA6
   Gl3ei+f8gA4BHQZ2Nf0dfDQl3fam4/PmPYSc6XsbNGzl62H89ck8Udsp9
   al/yBSyDOK8GgeXKl2At5SfCSwi13K7/s3fNdNbZW8ysD9m/cuR9Uny9A
   A==;
IronPort-SDR: +QjNz5TMOQVfX6iS+0l0gEAI9YKTF8B5F477P/JxKa6I9IG+0EAKjUNWWe8gLpvsbEE2/fidZd
 DLdhmcUkwQFjr8uN3L9defc5PhjQ1WYtLyEZQUSednimmwZMSnhrIOeikjuE499IPkpxm0OlW/
 UqdE+XfGtohmnfV1N6SYdXhO8CapBCOrZx8bv5NUTU0Y3q7Ozx15dWfcRuhacfLmMHTc2jDuxm
 KgMVSu38ctpCES/hWZm+7eVuf5sCivhFq6vR3jOaf1X4PFJyj7liijuH+meoNE2ClrCbbqSrCN
 aFA=
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="132970151"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jun 2021 00:45:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 00:45:26 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 22 Jun 2021 00:45:26 -0700
Date:   Tue, 22 Jun 2021 09:46:17 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next 6/6] net: dsa: remove cross-chip support from
 the MRP notifiers
Message-ID: <20210622074617.4ny3xovptxtq64ce@soft-dev3-1.localhost>
References: <20210621164219.3780244-1-olteanv@gmail.com>
 <20210621164219.3780244-7-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210621164219.3780244-7-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 06/21/2021 19:42, Vladimir Oltean wrote:

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> With MRP hardware assist being supported only by the ocelot switch
> family, which by design does not support cross-chip bridging, the
> current match functions are at best a guess and have not been confirmed
> in any way to do anything relevant in a multi-switch topology.
> 
> Drop the code and make the notifiers match only on the targeted switch
> port.
> 
> Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> v1->v2: remove unused variable "err" in dsa_switch_mrp_add_ring_role()
> 
>  net/dsa/switch.c | 55 ++++++------------------------------------------
>  1 file changed, 7 insertions(+), 48 deletions(-)
> 
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 75f567390a6b..c1e5afafe633 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -346,36 +346,16 @@ static int dsa_switch_change_tag_proto(struct dsa_switch *ds,
>         return 0;
>  }
> 
> -static bool dsa_switch_mrp_match(struct dsa_switch *ds, int port,
> -                                struct dsa_notifier_mrp_info *info)
> -{
> -       if (ds->index == info->sw_index && port == info->port)
> -               return true;
> -
> -       if (dsa_is_dsa_port(ds, port))
> -               return true;
> -
> -       return false;
> -}
> -
>  static int dsa_switch_mrp_add(struct dsa_switch *ds,
>                               struct dsa_notifier_mrp_info *info)
>  {
> -       int err = 0;
> -       int port;
> -
>         if (!ds->ops->port_mrp_add)
>                 return -EOPNOTSUPP;
> 
> -       for (port = 0; port < ds->num_ports; port++) {
> -               if (dsa_switch_mrp_match(ds, port, info)) {
> -                       err = ds->ops->port_mrp_add(ds, port, info->mrp);
> -                       if (err)
> -                               break;
> -               }
> -       }
> +       if (ds->index == info->sw_index)
> +               return ds->ops->port_mrp_add(ds, info->port, info->mrp);
> 
> -       return err;
> +       return 0;
>  }
> 
>  static int dsa_switch_mrp_del(struct dsa_switch *ds,
> @@ -390,39 +370,18 @@ static int dsa_switch_mrp_del(struct dsa_switch *ds,
>         return 0;
>  }
> 
> -static bool
> -dsa_switch_mrp_ring_role_match(struct dsa_switch *ds, int port,
> -                              struct dsa_notifier_mrp_ring_role_info *info)
> -{
> -       if (ds->index == info->sw_index && port == info->port)
> -               return true;
> -
> -       if (dsa_is_dsa_port(ds, port))
> -               return true;
> -
> -       return false;
> -}
> -
>  static int
>  dsa_switch_mrp_add_ring_role(struct dsa_switch *ds,
>                              struct dsa_notifier_mrp_ring_role_info *info)
>  {
> -       int err = 0;
> -       int port;
> -
>         if (!ds->ops->port_mrp_add)
>                 return -EOPNOTSUPP;
> 
> -       for (port = 0; port < ds->num_ports; port++) {
> -               if (dsa_switch_mrp_ring_role_match(ds, port, info)) {
> -                       err = ds->ops->port_mrp_add_ring_role(ds, port,
> -                                                             info->mrp);
> -                       if (err)
> -                               break;
> -               }
> -       }
> +       if (ds->index == info->sw_index)
> +               return ds->ops->port_mrp_add_ring_role(ds, info->port,
> +                                                      info->mrp);
> 
> -       return err;
> +       return 0;
>  }
> 
>  static int
> --
> 2.25.1
> 

-- 
/Horatiu
