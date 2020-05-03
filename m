Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7561C3029
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 00:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgECWpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 18:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729164AbgECWps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 18:45:48 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7226AC061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 15:45:48 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f13so18687484wrm.13
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 15:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gncide7nR+f9DGZ4c1LscOuOXyzKCtbqtDnwXWICXCQ=;
        b=ZSrV89B0+S9+eIJcYeQ7L2E9LNTD0K9mE7ko+MEfBTL5pUG75ThRq++cf+o4sKQhbx
         hKmLgcPnLWtjHLnbW3XcuxEqTvFwj61VSecXP8cTnb97Xu3JkOJt2MlqmH/GCt92xTbP
         SYwgTD+4id0KzMAFioXFr1mhk8IxXBIJUSzc0fA97LssRNy+kTKeCOEIcsX7QQR5EOze
         fn+cenlCstzn4e0ypgnBeUSuO0GAVEcy/CrHsoQzG8dx+ssRuVXx9ibocrFr8X0kOUMp
         JkJVOw8Ux9JYssgX3Fdb7S6zrHmCCdBt+UFq6zmRjJr+BKvL7utxVuxmZRNxBgInpOiJ
         JzXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gncide7nR+f9DGZ4c1LscOuOXyzKCtbqtDnwXWICXCQ=;
        b=WEHV2hzzAY6F1JWzWXNXs4JsujHN+AvprvCSsBkZccl9zRi619Z5JjcnA+MLvKVohC
         JXKkHXwD6u1xnzLuzeB3ij5ncq1gDdJ2OxJ+OvN8kRXyiD7ofSaWibqS7qawCdqdWjcU
         7gzjPsPyGKr7uYXObAW0NDNR9BYTx8SY48BCyewMO+TcZARNLZt3rIaoP4nDM2AfRMSA
         PE3xClTP02LKk0o8EUCTM1iwkU4UlR0HQnWunJ0robFDDy/a/0635VDbLa5Fha9oPJ28
         xDCFTiAhka6OSV1vF8Yr3DKeWeCDdLMBHuLP2+WJWJQahpIwcJxEq40kyc6QoybD1C0q
         OMYg==
X-Gm-Message-State: AGi0PuY5F34Eymuag+sIGXWBWdQWgIrLmB8arY3Tq6Mz1C4IGpEts/t0
        krY8bDXBlLadmfqIyZDVWrE=
X-Google-Smtp-Source: APiQypKb+sF76jI3fGOM9ovcen1vZVVsja+cSqMM0Ir/OY2ObTEDaLYovr0Ur/yOSIn6Gl/IoUwqiw==
X-Received: by 2002:adf:e9d2:: with SMTP id l18mr11720439wrn.34.1588545947011;
        Sun, 03 May 2020 15:45:47 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x16sm9245954wrn.76.2020.05.03.15.45.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2020 15:45:46 -0700 (PDT)
Subject: Re: [PATCH net-next 1/6] net: dsa: export dsa_slave_dev_check and
 dsa_slave_to_port
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, vinicius.gomes@intel.com,
        po.liu@nxp.com, xiaoliang.yang@nxp.com, mingkai.hu@nxp.com,
        christian.herber@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        vlad@buslov.dev, jiri@mellanox.com, idosch@mellanox.com,
        kuba@kernel.org
References: <20200503211035.19363-1-olteanv@gmail.com>
 <20200503211035.19363-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <71b974ca-66b4-b697-28fc-106cad586fba@gmail.com>
Date:   Sun, 3 May 2020 15:45:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200503211035.19363-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2020 2:10 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> To be able to perform mirroring and redirection through tc-flower
> offloads (the implementation of which is given raw access to the
> flow_cls_offload structure), switch drivers need to be able to call
> these functions on act->dev.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes from RFC:
> None.
> 
>  include/net/dsa.h  | 2 ++
>  net/dsa/dsa_priv.h | 8 --------
>  net/dsa/slave.c    | 9 +++++++++
>  3 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index fb3f9222f2a1..62beaa4c234e 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -739,6 +739,8 @@ int dsa_port_get_phy_strings(struct dsa_port *dp, uint8_t *data);
>  int dsa_port_get_ethtool_phy_stats(struct dsa_port *dp, uint64_t *data);
>  int dsa_port_get_phy_sset_count(struct dsa_port *dp);
>  void dsa_port_phylink_mac_change(struct dsa_switch *ds, int port, bool up);
> +bool dsa_slave_dev_check(const struct net_device *dev);
> +struct dsa_port *dsa_slave_to_port(const struct net_device *dev);
>  
>  struct dsa_tag_driver {
>  	const struct dsa_device_ops *ops;
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 6d9a1ef65fa0..32bf570fd71c 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -173,19 +173,11 @@ extern const struct dsa_device_ops notag_netdev_ops;
>  void dsa_slave_mii_bus_init(struct dsa_switch *ds);
>  int dsa_slave_create(struct dsa_port *dp);
>  void dsa_slave_destroy(struct net_device *slave_dev);
> -bool dsa_slave_dev_check(const struct net_device *dev);
>  int dsa_slave_suspend(struct net_device *slave_dev);
>  int dsa_slave_resume(struct net_device *slave_dev);
>  int dsa_slave_register_notifier(void);
>  void dsa_slave_unregister_notifier(void);
>  
> -static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
> -{
> -	struct dsa_slave_priv *p = netdev_priv(dev);
> -
> -	return p->dp;
> -}
> -
>  static inline struct net_device *
>  dsa_slave_to_master(const struct net_device *dev)
>  {
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index ba8bf90dc0cc..4eeb5b47ef99 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -62,6 +62,14 @@ static int dsa_slave_get_iflink(const struct net_device *dev)
>  	return dsa_slave_to_master(dev)->ifindex;
>  }
>  
> +struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
> +{
> +	struct dsa_slave_priv *p = netdev_priv(dev);
> +
> +	return p->dp;
> +}
> +EXPORT_SYMBOL_GPL(dsa_slave_to_port);

You could probably make this a static inline in net/dsa.h, too. With or
without doing that:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
