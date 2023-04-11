Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA71D6DD970
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjDKLdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjDKLdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:33:10 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24A135A6;
        Tue, 11 Apr 2023 04:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681212789; x=1712748789;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Z8s5H2R2JPvyJImDdoa6/+E68sq74qjYjSO+8uO7l7Y=;
  b=YHUe8TwtEhgAOqJn0U62TEfHWQVnjNmbtybwc5i6CWmfOzdPqfLaropK
   ZRD1TpZkGACOQXv3H3P+pcEYxZr4k04Y2ZAPFjqc9VrnvQ/znZYrJ6ZDs
   EBSbmKCi2fXu+EDrJFFw07FfuYRT6Q/TwjFCZhd6TmZ6FTPnG0R5uGezW
   WmYunKE3XxckWArF6XZvsFKJXdq4JTy/NWhsBHYBunQJ1wcayzj4bcHOw
   GBiW79M1bMRXzbHxbYNxkv/WW0TlDZt393DqU8NN2oqub3oV5blFm2w3T
   37OHZBfEYZ//WtoY428ounOmlCS2Q8gGus0lMBO8hG0mQpzLrggwGsXwQ
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,336,1673938800"; 
   d="scan'208";a="209823278"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Apr 2023 04:33:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 11 Apr 2023 04:33:07 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 11 Apr 2023 04:33:06 -0700
Date:   Tue, 11 Apr 2023 13:33:06 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Simon Horman <horms@kernel.org>
CC:     Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <lvs-devel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>
Subject: Re: [PATCH nf-next v2 4/4] ipvs: Correct spelling in comments
Message-ID: <20230411113306.ydzhynl243o6mncz@soft-dev3-1>
References: <20230409-ipvs-cleanup-v2-0-204cd17da708@kernel.org>
 <20230409-ipvs-cleanup-v2-4-204cd17da708@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230409-ipvs-cleanup-v2-4-204cd17da708@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/11/2023 09:10, Simon Horman wrote:
> 
> Correct some spelling errors flagged by codespell and found by inspection.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Signed-off-by: Simon Horman <horms@kernel.org>
> ---
>  include/net/ip_vs.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index a3adc246ee31..ff406ef4fd4a 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -584,7 +584,7 @@ struct ip_vs_conn {
>         spinlock_t              lock;           /* lock for state transition */
>         volatile __u16          state;          /* state info */
>         volatile __u16          old_state;      /* old state, to be used for
> -                                                * state transition triggerd
> +                                                * state transition triggered
>                                                  * synchronization
>                                                  */
>         __u32                   fwmark;         /* Fire wall mark from skb */
> @@ -635,7 +635,7 @@ struct ip_vs_service_user_kern {
>         u16                     protocol;
>         union nf_inet_addr      addr;           /* virtual ip address */
>         __be16                  port;
> -       u32                     fwmark;         /* firwall mark of service */
> +       u32                     fwmark;         /* firewall mark of service */
> 
>         /* virtual service options */
>         char                    *sched_name;
> @@ -1036,7 +1036,7 @@ struct netns_ipvs {
>         struct ipvs_sync_daemon_cfg     bcfg;   /* Backup Configuration */
>         /* net name space ptr */
>         struct net              *net;            /* Needed by timer routines */
> -       /* Number of heterogeneous destinations, needed becaus heterogeneous
> +       /* Number of heterogeneous destinations, needed because heterogeneous
>          * are not supported when synchronization is enabled.
>          */
>         unsigned int            mixed_address_family_dests;
> 
> --
> 2.30.2
> 

-- 
/Horatiu
