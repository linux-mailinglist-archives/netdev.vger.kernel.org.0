Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0D28841A
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 22:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfHIUfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 16:35:15 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46402 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfHIUfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 16:35:14 -0400
Received: by mail-qt1-f195.google.com with SMTP id j15so3508738qtl.13
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 13:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=eGij1FbB9MgvxaYppuZV1K7DcJdfdX5GiLALsqu+zdk=;
        b=gR+D6iiBjbY6YUZdGyZSpYq3ujV9tCsEJVukL2O0IdzzyuHe+EoZtV0j+KDbWLGkU6
         O/TH5Vh7YTJ/CAJ4WOiS2sN9CWLV8Ciw/IWZMgC24j+qcm2LvpAWvGPV87CToa3hrgJG
         TqRqqr2rc4MmuPWhzW5Auh5CBZ5K9cW//N6WLcy3lXYj2oagweuhosojSclSMOZNYgHj
         M5Fh1OMFRoRr5j+ODXWdTQC7nL9m62n5Gxy6HEHM3FcoJqHTARiZHMDLK6KRUGiHwD+y
         sbRlwP9FPuw+DFBQklflbCGzHZuq0eQmmkmmFGrDvC6n8TCUIUznjZ5rPMmnZWU9W0kK
         p8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=eGij1FbB9MgvxaYppuZV1K7DcJdfdX5GiLALsqu+zdk=;
        b=rfsvXmYp2LhCOj/OtAm1gj6JgnWqhjY0n7URd6EFN8P/ZgKvfkEPbXDsALxMwkTY+p
         EnsQL32s5ZyxLfxofrpl4BYYIKsagVASxHgxUEtOb2phXrAoWHS6RgNjqA6TYEpwGsa/
         8b085Sb7IZBI4IiY34z3d0R/is97Z+oTmfEHmBfAcejd0xoJMvAmUSbeioDmM2TuXGFs
         +g0uRCgik8UlQrAoNWgdK2/kaFsAOUVvLLHn4uvn7s/aRl2OjE/xzS93JqijkjflIDuu
         Lb0ySQ8T2I3rHhY+7pi/0nz+7NuUwCFDHDvj9un9cmntXbcr2xlNyGseMUuUdwa5KvRt
         jzjg==
X-Gm-Message-State: APjAAAVSRe4YRhEwCYwKsVi6B0oD3YMDxSP20iQ5GSXFNoT2tmPVJvXr
        y3NhtqGSQTeLs/6e8nuDJOYjVcaZ+1g=
X-Google-Smtp-Source: APXvYqwr4RA/ml4OIp/H+H4m4sminido+4Cokq14wHQ7nQRkY2KrDRMMK2dmVoaw65H4T3SbYRgMpQ==
X-Received: by 2002:ac8:53c7:: with SMTP id c7mr19537664qtq.162.1565382913830;
        Fri, 09 Aug 2019 13:35:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s58sm5731144qth.59.2019.08.09.13.35.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 13:35:13 -0700 (PDT)
Date:   Fri, 9 Aug 2019 13:35:09 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com
Subject: Re: [PATCH net-next v2 4/9] net: introduce MACsec ops and add a
 reference in net_device
Message-ID: <20190809133509.12dbead1@cakuba.netronome.com>
In-Reply-To: <20190808140600.21477-5-antoine.tenart@bootlin.com>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
        <20190808140600.21477-5-antoine.tenart@bootlin.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Aug 2019 16:05:55 +0200, Antoine Tenart wrote:
> This patch introduces MACsec ops for drivers to support offloading
> MACsec operations. A reference to those ops is added in net_device.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> ---
>  include/linux/netdevice.h | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 88292953aa6f..59ff123d62e3 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -53,6 +53,7 @@ struct netpoll_info;
>  struct device;
>  struct phy_device;
>  struct dsa_port;
> +struct macsec_context;
>  
>  struct sfp_bus;
>  /* 802.11 specific */
> @@ -910,6 +911,29 @@ struct xfrmdev_ops {
>  };
>  #endif
>  
> +#if defined(CONFIG_MACSEC)
> +struct macsec_ops {

I think it'd be cleaner to have macsec_ops declared in macsec.h
and forward declare macsec_ops rather than macsec_context.

> +	/* Device wide */
> +	int (*mdo_dev_open)(struct macsec_context *ctx);
> +	int (*mdo_dev_stop)(struct macsec_context *ctx);
> +	/* SecY */
> +	int (*mdo_add_secy)(struct macsec_context *ctx);
> +	int (*mdo_upd_secy)(struct macsec_context *ctx);
> +	int (*mdo_del_secy)(struct macsec_context *ctx);
> +	/* Security channels */
> +	int (*mdo_add_rxsc)(struct macsec_context *ctx);
> +	int (*mdo_upd_rxsc)(struct macsec_context *ctx);
> +	int (*mdo_del_rxsc)(struct macsec_context *ctx);
> +	/* Security associations */
> +	int (*mdo_add_rxsa)(struct macsec_context *ctx);
> +	int (*mdo_upd_rxsa)(struct macsec_context *ctx);
> +	int (*mdo_del_rxsa)(struct macsec_context *ctx);
> +	int (*mdo_add_txsa)(struct macsec_context *ctx);
> +	int (*mdo_upd_txsa)(struct macsec_context *ctx);
> +	int (*mdo_del_txsa)(struct macsec_context *ctx);
> +};
> +#endif
> +
>  struct dev_ifalias {
>  	struct rcu_head rcuhead;
>  	char ifalias[];
> @@ -1755,6 +1779,8 @@ enum netdev_priv_flags {
>   *
>   *	@wol_enabled:	Wake-on-LAN is enabled
>   *
> + *	@macsec_ops:    MACsec offloading ops
> + *
>   *	FIXME: cleanup struct net_device such that network protocol info
>   *	moves out.
>   */
> @@ -2036,6 +2062,11 @@ struct net_device {
>  	struct lock_class_key	*qdisc_running_key;
>  	bool			proto_down;
>  	unsigned		wol_enabled:1;
> +
> +#if IS_ENABLED(CONFIG_MACSEC)
> +	/* MACsec management functions */
> +	const struct macsec_ops *macsec_ops;
> +#endif
>  };
>  #define to_net_dev(d) container_of(d, struct net_device, dev)
>  

