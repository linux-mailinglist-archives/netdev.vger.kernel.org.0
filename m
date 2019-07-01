Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4665C5E9
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 01:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfGAX04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 19:26:56 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39978 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfGAX0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 19:26:55 -0400
Received: by mail-qk1-f193.google.com with SMTP id c70so12489483qkg.7
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 16:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=46nWsHRTwWbYn6VFSdRypR/YSUCjUcJ3X1oTDue+L6k=;
        b=0yI4onF2SodUx448DMqNaUkamyKAH05iPoXUF9fllxX/7w4eX5nmAnkiAVSaadlO8j
         qcGIbhYIe7pOP2RUg9hQQaiLxM88UkQN7j6r0v8t9HFBFQI5vk5OyQ55CbBIz4K1w4V3
         eZ3Y2fwsrMzT0vRpyDPEJZ3/Qxgo5eqDM9NcTIFlF9ajNQp9Dmbz7zOWiB9J3rHnzWjK
         7gxKYXQjpoifHUCmx6sEhZ/eF/tRwWFT592n+dTLq/7++7QkJ775dJyH3LE1YLieDn4K
         MAJ2vCbk4ScbekDB9tIwSMD0ATwKQvcrZckiksW6SdGDu0v6gCZi+iLXFHUjHZEWh7h7
         TeRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=46nWsHRTwWbYn6VFSdRypR/YSUCjUcJ3X1oTDue+L6k=;
        b=AVQL8v61nr2xjqBLhGBTx/efhhYX2B0QAtukCHDgv7WkjDoHEI8LoeewdnKoqqysNO
         mg6lA76KYs+g+kk6QzTUOAeMZErQK7zf4DT7N0GmoGp6VyZTg4hpDp/Fo67kkDctvo1A
         j5B6JqIgEcn5CbSoHCKYRSbO11+MrYgl7F4S5qMA2A/NX5vSV2gxJ/HOhKza7gyLiEDi
         FG7C5NjCFcj78PnPwxORoCgBELxH8YmJ4rv25RkrRbQukTnfA0P0+dXsBtUWZ4hF26c3
         x6IJwad3Wkq5XNljEMslECPcSeNSaZ+zPl8R5bE9nw912O9fIYts2azFaKFjWfzbDhy7
         1eng==
X-Gm-Message-State: APjAAAXZLZ0eBX20lvA6BCobr20TZbPzpY9D6Ny9aDRuV/hMkyCoEMlJ
        Pz3onXkfaugHpsZpaiIgr3FD8A==
X-Google-Smtp-Source: APXvYqxGu0LIFoWCDULJkOaxnmpSgIT8tiHKJljfOyU9BOwBT00wbDlZLzJJgEnw6fHgNn0G9rqI6g==
X-Received: by 2002:a37:86c4:: with SMTP id i187mr23253368qkd.464.1562023614385;
        Mon, 01 Jul 2019 16:26:54 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l4sm5816320qtd.25.2019.07.01.16.26.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 16:26:54 -0700 (PDT)
Date:   Mon, 1 Jul 2019 16:26:50 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     jiri@mellanox.com
Cc:     Parav Pandit <parav@mellanox.com>, netdev@vger.kernel.org,
        saeedm@mellanox.com
Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Message-ID: <20190701162650.17854185@cakuba.netronome.com>
In-Reply-To: <20190701122734.18770-2-parav@mellanox.com>
References: <20190701122734.18770-1-parav@mellanox.com>
        <20190701122734.18770-2-parav@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  1 Jul 2019 07:27:32 -0500, Parav Pandit wrote:
> In an eswitch, PCI PF may have port which is normally represented
> using a representor netdevice.
> To have better visibility of eswitch port, its association with
> PF, a representor netdevice and port number, introduce a PCI PF port
> flavour and port attriute.
> 
> When devlink port flavour is PCI PF, fill up PCI PF attributes of the
> port.
> 
> Extend port name creation using PCI PF number on best effort basis.
> So that vendor drivers can skip defining their own scheme.
> 
> $ devlink port show
> pci/0000:05:00.0/0: type eth netdev eth0 flavour pcipf pfnum 0
> 
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  include/net/devlink.h        | 11 ++++++
>  include/uapi/linux/devlink.h |  5 +++
>  net/core/devlink.c           | 71 +++++++++++++++++++++++++++++-------
>  3 files changed, 73 insertions(+), 14 deletions(-)
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 6625ea068d5e..8db9c0e83fb5 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -38,6 +38,10 @@ struct devlink {
>  	char priv[0] __aligned(NETDEV_ALIGN);
>  };
>  
> +struct devlink_port_pci_pf_attrs {

Why the named structure?  Anonymous one should be just fine?

> +	u16 pf;	/* Associated PCI PF for this port. */
> +};
> +
>  struct devlink_port_attrs {
>  	u8 set:1,
>  	   split:1,
> @@ -46,6 +50,9 @@ struct devlink_port_attrs {
>  	u32 port_number; /* same value as "split group" */
>  	u32 split_subport_number;
>  	struct netdev_phys_item_id switch_id;
> +	union {
> +		struct devlink_port_pci_pf_attrs pci_pf;
> +	};
>  };
>  
>  struct devlink_port {
> @@ -590,6 +597,10 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
>  			    u32 split_subport_number,
>  			    const unsigned char *switch_id,
>  			    unsigned char switch_id_len);
> +void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
> +				   u32 port_number,
> +				   const unsigned char *switch_id,
> +				   unsigned char switch_id_len, u16 pf);
>  int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
>  			u32 size, u16 ingress_pools_count,
>  			u16 egress_pools_count, u16 ingress_tc_count,
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index 5287b42c181f..f7323884c3fe 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -169,6 +169,10 @@ enum devlink_port_flavour {
>  	DEVLINK_PORT_FLAVOUR_DSA, /* Distributed switch architecture
>  				   * interconnect port.
>  				   */
> +	DEVLINK_PORT_FLAVOUR_PCI_PF, /* Represents eswitch port for
> +				      * the PCI PF. It is an internal
> +				      * port that faces the PCI PF.
> +				      */
>  };
>  
>  enum devlink_param_cmode {
> @@ -337,6 +341,7 @@ enum devlink_attr {
>  	DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,	/* u64 */
>  	DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,	/* u64 */
>  
> +	DEVLINK_ATTR_PORT_PCI_PF_NUMBER,	/* u16 */
>  	/* add new attributes above here, update the policy in devlink.c */
>  
>  	__DEVLINK_ATTR_MAX,
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 89c533778135..001f9e2c96f0 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -517,6 +517,11 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
>  		return -EMSGSIZE;
>  	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs->port_number))
>  		return -EMSGSIZE;

Why would we report network port information for PF and VF port
flavours?

> +	if (devlink_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_PCI_PF) {
> +		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
> +				attrs->pci_pf.pf))
> +			return -EMSGSIZE;
> +	}
>  	if (!attrs->split)
>  		return 0;
>  	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_GROUP, attrs->port_number))
