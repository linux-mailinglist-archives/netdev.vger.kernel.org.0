Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8110D4D8019
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 11:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238627AbiCNKo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 06:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbiCNKoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 06:44:24 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FBFB7CC
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 03:43:14 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id r13so32847509ejd.5
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 03:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=A7EqDn+Rvpx8UXeNB7ju/W8rAWMhJLZzf0YL/c7EbsM=;
        b=R9FlibjV7YbRYHtNtmZ8gtRoaI/OqgLDDsvIOf3Nna/kMrJKoO2Diw1xJYXOdFMzNe
         eVfypM8Up5u0iHhizU6sIocI0SNbPJbzdQv8Ij8W7wpXkCKeh84v4GmDoVgvHii5FWT3
         GdN6qq+nsKIYd0xgNHR41sr8NQUoSMz6Tofd9TsZXuGYp/bqCEt20UZK70YOM0qaL3lu
         Woy8tXCsY4dC5ScaFoePtavo0uiax78Jfoat3ahD9sOSepgUJZvvsZbvxT7XDlZ8xAwI
         kWe/+9uPXcsL9avWiyXaxxwl40n29bgAFDocnLoaPo5x2IvO5vKoO9+6CMwmWW3l+ouS
         ozMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=A7EqDn+Rvpx8UXeNB7ju/W8rAWMhJLZzf0YL/c7EbsM=;
        b=GRBZgR/dc9dI7XLNRtnwa/hjTqZoCA+1cYmM5o1DpDLrOWD3m1ag6et5HDK+kIOK0k
         GpHSiQscqh3G3yLFEfJO99TM5hfilrbcdMna/nKLwMEFKhmyg4oIAYQLI9lci1/eN2EX
         IWm8H2Xq8AXT6VeStUKRL0cWNLsCZYWn4ozpfwVEk7/OPBbvIO8nNOFKNyytlBJ1CK3X
         gZMJui9G/51Om5HO4jL+JcHOzFF5r9/v+ZVJvFiII3IQWisZZf1Mvsfnqv7qeJZeGV6w
         OP2iIUu8BN5mm4tZQ053Z3zFQ5e2rlDJ/B5A0k3h+eWTjgbJH7yJXlS/3E83hrd5qFx9
         N/2g==
X-Gm-Message-State: AOAM530etsoGiWmF+LKZMCbCWfT07WkBtslyUXvqlWuQgrql3hm+Mxfs
        BR9xfi5bVsSBouJDFYd51cQdiw==
X-Google-Smtp-Source: ABdhPJxTHRTQNFE5kKAa4DCdyAQWIglAKntXNPflLiu//qCYFNVof0yRClCccCCCjGwXKUlnQCWMvQ==
X-Received: by 2002:a17:906:1613:b0:6cf:1161:eab6 with SMTP id m19-20020a170906161300b006cf1161eab6mr17257995ejd.315.1647254593012;
        Mon, 14 Mar 2022 03:43:13 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id f15-20020a50e08f000000b004134a121ed2sm8023894edl.82.2022.03.14.03.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 03:43:12 -0700 (PDT)
Message-ID: <ace79051-0f73-8e04-5ac6-6098ffb15acd@blackwall.org>
Date:   Mon, 14 Mar 2022 12:43:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 net-next 08/14] net: bridge: mst: Add helper to check
 if MST is enabled
Content-Language: en-US
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <20220314095231.3486931-1-tobias@waldekranz.com>
 <20220314095231.3486931-9-tobias@waldekranz.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220314095231.3486931-9-tobias@waldekranz.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2022 11:52, Tobias Waldekranz wrote:
> This is useful for switchdev drivers that might want to refuse to join
> a bridge where MST is enabled, if the hardware can't support it.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/linux/if_bridge.h | 5 +++++
>  net/bridge/br_mst.c       | 9 +++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 46e6327fef06..5dbab0a280a6 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -119,6 +119,7 @@ int br_vlan_get_info(const struct net_device *dev, u16 vid,
>  		     struct bridge_vlan_info *p_vinfo);
>  int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
>  			 struct bridge_vlan_info *p_vinfo);
> +bool br_mst_enabled(struct net_device *dev);
>  int br_mst_get_info(struct net_device *dev, u16 msti, unsigned long *vids);
>  #else
>  static inline bool br_vlan_enabled(const struct net_device *dev)
> @@ -152,6 +153,10 @@ static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
>  {
>  	return -EINVAL;
>  }
> +static inline bool br_mst_enabled(struct net_device *dev)
> +{
> +	return false;
> +}
>  static inline int br_mst_get_info(struct net_device *dev, u16 msti,
>  				  unsigned long *vids)
>  {
> diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
> index eb18dbd5838f..e5ab2ce451c2 100644
> --- a/net/bridge/br_mst.c
> +++ b/net/bridge/br_mst.c
> @@ -13,6 +13,15 @@
>  
>  DEFINE_STATIC_KEY_FALSE(br_mst_used);
>  
> +bool br_mst_enabled(struct net_device *dev)

const dev

> +{
> +	if (!netif_is_bridge_master(dev))
> +		return false;
> +
> +	return br_opt_get(netdev_priv(dev), BROPT_MST_ENABLED);
> +}
> +EXPORT_SYMBOL(br_mst_enabled);

EXPORT_SYMBOL_GPL

> +
>  int br_mst_get_info(struct net_device *dev, u16 msti, unsigned long *vids)
>  {
>  	struct net_bridge_vlan_group *vg;

