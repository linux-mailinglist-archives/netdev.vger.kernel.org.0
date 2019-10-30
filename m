Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 884EDEA568
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfJ3Vey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:34:54 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38419 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfJ3Vey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:34:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id c13so2552225pfp.5
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 14:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=wG/eMIBSfg+1F4IKNrnr9DDrQHBDnZPSnIMchDwoCfw=;
        b=nb79l6nIb9JdJ/K2WDSOMx5Gw8FdtITAK4EgmxwE7uOZM2FzKibxRLH5k400JiQ9iw
         V2qvpSE6m4VPczMaRgCk1K8fh2pTdi76/3j8BhZ2AOogl6bYAUO7zn0d49DkQkTuyRiu
         mCdctDu87cMxduzrPpXdTKdEmnarlMr3BZyTq/jGPH5H7HLadVz04zsCJ72qDm7Fdn0t
         8O5yPGhILYsL6EfMPBMs0uSoT2ySlygFEP2wVpGwUUAh26eszy6HKqEbhALegw0aTH+9
         40G2nKwyUlh6oehm1MRRjLb1c7bpucw5ARgicAXMKKsPWUsOLbIiO0mQ8p7CULK/rDXU
         g47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=wG/eMIBSfg+1F4IKNrnr9DDrQHBDnZPSnIMchDwoCfw=;
        b=pyz4o5E65e7c5Ull+ysesxkH7I0g3pNzdpEPaZRRpujE+hyz9QEe68fc2/WV7WTGjo
         UMbLHA/2Ys9olmUxTEv/AllzqWgXFskjdOpjPNet1rgsKxZvdDth69+V4kb+A6xCx1I7
         vOuVyq+fW9aD0fxr4KjiHrtRTKusD3phXw4eqLXEOQ1CCkW5d97efeAap6J8ZvAJG+f4
         86Xr3V2pUarfrzRbrUItMmVaiywWQ5SzpvPcru2RMkAZsqiy9TzHCguawI0M35hfd3fm
         oyiHUQ1i2Hyx9Vc9tU0q2mu71JPWuSTXCok0DOeTz3aEXo3RVOVMETSCqzqhesnPvXsf
         Z7tA==
X-Gm-Message-State: APjAAAUbwF72GjyZYMrf+YE/hZ91wr2gNYy8pShk8WuAetZGEmkah+/x
        pjsuB3qPhotCpMpR84mpHBbCrA==
X-Google-Smtp-Source: APXvYqx8DyiHTlzOIvXs6hU74l3twLFFZ4m17LHV7VVvBYUyfMiw9LeLWWKnnXUSnGrXX9g7zbtYKA==
X-Received: by 2002:a62:6d81:: with SMTP id i123mr1558206pfc.57.1572471293318;
        Wed, 30 Oct 2019 14:34:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 6sm892945pfz.156.2019.10.30.14.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 14:34:53 -0700 (PDT)
Date:   Wed, 30 Oct 2019 14:34:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ariel Levkovich <lariel@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 2/3] net: Add SRIOV VGT+ support
Message-ID: <20191030143438.00b3ce1a@cakuba.netronome.com>
In-Reply-To: <1572468274-30748-3-git-send-email-lariel@mellanox.com>
References: <1572468274-30748-1-git-send-email-lariel@mellanox.com>
        <1572468274-30748-3-git-send-email-lariel@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 20:44:44 +0000, Ariel Levkovich wrote:
> VGT+ is a security feature that gives the administrator the ability of
> controlling the allowed vlan-ids list that can be transmitted/received
> from/to the VF.
> The allowed vlan-ids list is called "trunk".
> Admin can add/remove a range of allowed vlan-ids via iptool.
> Example:
> After this series of configuration :
> 1) ip link set eth3 vf 0 trunk add 10 100 (allow vlan-id 10-100, default tpid 0x8100)
> 2) ip link set eth3 vf 0 trunk add 105 proto 802.1q (allow vlan-id 105 tpid 0x8100)
> 3) ip link set eth3 vf 0 trunk add 105 proto 802.1ad (allow vlan-id 105 tpid 0x88a8)
> 4) ip link set eth3 vf 0 trunk rem 90 (block vlan-id 90)
> 5) ip link set eth3 vf 0 trunk rem 50 60 (block vlan-ids 50-60)
> 
> The VF 0 can only communicate on vlan-ids: 10-49,61-89,91-100,105 with
> tpid 0x8100 and vlan-id 105 with tpid 0x88a8.
> 
> For this purpose we added the following netlink sr-iov commands:
> 
> 1) IFLA_VF_VLAN_RANGE: used to add/remove allowed vlan-ids range.
> We added the ifla_vf_vlan_range struct to specify the range we want to
> add/remove from the userspace.
> We added ndo_add_vf_vlan_trunk_range and ndo_del_vf_vlan_trunk_range
> netdev ops to add/remove allowed vlan-ids range in the netdev.
> 
> 2) IFLA_VF_VLAN_TRUNK: used to query the allowed vlan-ids trunk.
> We added trunk bitmap to the ifla_vf_info struct to get the current
> allowed vlan-ids trunk from the netdev.
> We added ifla_vf_vlan_trunk struct for sending the allowed vlan-ids
> trunk to the userspace.
> Since the trunk bitmap needs to contain a bit per possible enabled
> vlan id, the size addition to ifla_vf_info is significant which may
> create attribute length overrun when querying all the VFs.
> 
> Therefore, the return of the full bitmap is limited to the case
> where the admin queries a specific VF only and for the VF list
> query we introduce a new vf_info attribute called ifla_vf_vlan_mode
> that will present the current VF tagging mode - VGT, VST or VGT+(trunk).
> 
> Signed-off-by: Ariel Levkovich <lariel@mellanox.com>

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 3207e0b..da79976 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1067,6 +1067,10 @@ struct netdev_name_node {
>   *      Hash Key. This is needed since on some devices VF share this information
>   *      with PF and querying it may introduce a theoretical security risk.
>   * int (*ndo_set_vf_rss_query_en)(struct net_device *dev, int vf, bool setting);
> + * int (*ndo_add_vf_vlan_trunk_range)(struct net_device *dev, int vf,
> + *				      u16 start_vid, u16 end_vid, __be16 proto);
> + * int (*ndo_del_vf_vlan_trunk_range)(struct net_device *dev, int vf,
> + *				      u16 start_vid, u16 end_vid, __be16 proto);
>   * int (*ndo_get_vf_port)(struct net_device *dev, int vf, struct sk_buff *skb);
>   * int (*ndo_setup_tc)(struct net_device *dev, enum tc_setup_type type,
>   *		       void *type_data);
> @@ -1332,6 +1336,14 @@ struct net_device_ops {
>  	int			(*ndo_set_vf_rss_query_en)(
>  						   struct net_device *dev,
>  						   int vf, bool setting);
> +	int			(*ndo_add_vf_vlan_trunk_range)(
> +						   struct net_device *dev,
> +						   int vf, u16 start_vid,
> +						   u16 end_vid, __be16 proto);
> +	int			(*ndo_del_vf_vlan_trunk_range)(
> +						   struct net_device *dev,
> +						   int vf, u16 start_vid,
> +						   u16 end_vid, __be16 proto);
>  	int			(*ndo_setup_tc)(struct net_device *dev,
>  						enum tc_setup_type type,
>  						void *type_data);

Is this official Mellanox patch submission or do you guys need time to
decide between each other if you like legacy VF ndos or not? ;-)
