Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B024D8015
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 11:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbiCNKnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 06:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbiCNKnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 06:43:31 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E780C10B4
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 03:42:21 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id m12so19126028edc.12
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 03:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oMG0T9vcdOIb6WRbUJ5vRlSPE5rT2gbTg+vjg6aHM+o=;
        b=Bgv9nNrzSnDKRVZKbeGdd71L3Iiv4FIxcwNstK5Ia4cJNSsOwFWT5l72JNt+brFxig
         W7z2+gRIYUfsxp7M1DzYc/o6h1PaUxviTqtXMwgHnT1iWXPTXT/C+Rm9aFVJ5r+9KKmg
         UmCHq421Xsh/2OE0wRDQ60MwupTZdNx72CUaN+ufqe0ceeJ1z7QlMMVVmO/RpqJh8xIf
         EvdlHIkZsn6wMSzzvK/wjWWR9fuh/AkBBSKXnp7KwdDJ1sUnNEZ12lsBpAWafsxNCAyi
         E3BM3gmFXQ+GmkJ10qAbchg7YS+BdGz/mStPSKaCVEWvbl3eWZ2BK0h6sg/mPjvBL60Y
         ftdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oMG0T9vcdOIb6WRbUJ5vRlSPE5rT2gbTg+vjg6aHM+o=;
        b=AmEFAfsrl13jqr4XoWG2iH7gxey1wubLu0XIYQSnAB1CikLKhTmUMtjaS/O6J2w/k/
         NrIs57kj3Ixom0JR7D0s8HjRKtYuwJlrjsPKRpM7QBHgQGhXuBAWyUMmwJxikYbjrNBw
         LDNNPKeo45CAaexVd99J/8PtJ7sjFYiL4EMHqFrDgTfW3k6U7jRtji4iR1YWqwBvPU96
         Mh5aLRmLwM/+lANhAqs2zUK5gRKFROI+wEswoUGli1gXCOLYGVu9MaYuTTaV2zQhpLIw
         IAeNiML9o4+B2XrI6rqbzkTZi7g+F0c/b4AnLaEEDlMFrKLuDZihbTkhsegPowHtCOa6
         RR4Q==
X-Gm-Message-State: AOAM531XyqLKEnjOPXnrD/DBJw1TxeCyxGIBGxyRsIyR1ZS+nPC3PBmG
        T0Q0u3K4aSFnZSKUhfrzgoeEsg==
X-Google-Smtp-Source: ABdhPJxyti+ZZIBqAkD5R1g1ftKPfUvMSW2DqKLuBzw6ePGKI8J6QwFpwkKLPShUROCFJsNNtbrQTQ==
X-Received: by 2002:a05:6402:50cd:b0:418:5267:d8ba with SMTP id h13-20020a05640250cd00b004185267d8bamr11708559edb.68.1647254540354;
        Mon, 14 Mar 2022 03:42:20 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z11-20020a50e68b000000b00412ec8b2180sm7848448edm.90.2022.03.14.03.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 03:42:20 -0700 (PDT)
Message-ID: <bf9b90a5-63c7-ac9d-385f-cd0c60de7eee@blackwall.org>
Date:   Mon, 14 Mar 2022 12:42:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 net-next 07/14] net: bridge: mst: Add helper to map an
 MSTI to a VID set
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
 <20220314095231.3486931-8-tobias@waldekranz.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220314095231.3486931-8-tobias@waldekranz.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2022 11:52, Tobias Waldekranz wrote:
> br_mst_get_info answers the question: "On this bridge, which VIDs are
> mapped to the given MSTI?"
> 
> This is useful in switchdev drivers, which might have to fan-out
> operations, relating to an MSTI, per VLAN.
> 
> An example: When a port's MST state changes from forwarding to
> blocking, a driver may choose to flush the dynamic FDB entries on that
> port to get faster reconvergence of the network, but this should only
> be done in the VLANs that are managed by the MSTI in question.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/linux/if_bridge.h |  6 ++++++
>  net/bridge/br_mst.c       | 26 ++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 3aae023a9353..46e6327fef06 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -119,6 +119,7 @@ int br_vlan_get_info(const struct net_device *dev, u16 vid,
>  		     struct bridge_vlan_info *p_vinfo);
>  int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
>  			 struct bridge_vlan_info *p_vinfo);
> +int br_mst_get_info(struct net_device *dev, u16 msti, unsigned long *vids);
>  #else
>  static inline bool br_vlan_enabled(const struct net_device *dev)
>  {
> @@ -151,6 +152,11 @@ static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
>  {
>  	return -EINVAL;
>  }
> +static inline int br_mst_get_info(struct net_device *dev, u16 msti,
> +				  unsigned long *vids)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #if IS_ENABLED(CONFIG_BRIDGE)
> diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
> index 7d16926a3a31..eb18dbd5838f 100644
> --- a/net/bridge/br_mst.c
> +++ b/net/bridge/br_mst.c
> @@ -13,6 +13,32 @@
>  
>  DEFINE_STATIC_KEY_FALSE(br_mst_used);
>  
> +int br_mst_get_info(struct net_device *dev, u16 msti, unsigned long *vids)
> +{
> +	struct net_bridge_vlan_group *vg;
> +	struct net_bridge_vlan *v;
> +	struct net_bridge *br;

const dev, vg, v, br

> +
> +	ASSERT_RTNL();
> +
> +	if (!netif_is_bridge_master(dev))
> +		return -EINVAL;
> +
> +	br = netdev_priv(dev);
> +	if (!br_opt_get(br, BROPT_MST_ENABLED))
> +		return -EINVAL;
> +
> +	vg = br_vlan_group(br);
> +
> +	list_for_each_entry(v, &vg->vlan_list, vlist) {
> +		if (v->msti == msti)
> +			set_bit(v->vid, vids);

__set_bit()

> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(br_mst_get_info);

EXPORT_SYMBOL_GPL

> +
>  static void br_mst_vlan_set_state(struct net_bridge_port *p, struct net_bridge_vlan *v,
>  				  u8 state)
>  {

