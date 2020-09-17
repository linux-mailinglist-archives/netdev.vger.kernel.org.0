Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DE926E6C9
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgIQUbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgIQUbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:31:18 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E7BC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:31:18 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id g96so3153903otb.12
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vdm1PLELc+oVS75UCMimtSMdlf1mnLUv4mb4lJv0HiY=;
        b=AU9w16Tr9upR/pmOasRCsXd13zyRCAa7Cr1J2L62dSk//tbshR2sAhHLQlWhMSlHXb
         dZNDeh/V7GEd+Pqv5OFEqd8GLo0JaJ5z2MuO+w+OT7uRQYrGvtnSOsIoRi11PXc3Vm9c
         iTjIyo4tVvXtxVwxNj1g69wwJMl48O/l8y3BJUGk9TzYr/1OXACBC9AHlm8SZKFpdUuB
         5R5ITd8sxLI6iffeSmNsbOzrDkYckIFMXD0/Qxwv1I8ko0r53tPl1GnNP/m4vZzleMza
         ce3Zi72vLvtIRvmJasPt3FtnQ4jqqpZQAX4fCZmogaKKaPsdZVfvjGwAuRX4zOdRqKtc
         SRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vdm1PLELc+oVS75UCMimtSMdlf1mnLUv4mb4lJv0HiY=;
        b=Ma/aHUNzH6lq4en84FP8Y6917TyoQupJo8YwbzAUPegrDn/6BGxvPC++teU0pUrTS4
         9qe09ltXsdV02tqvIBwQo9Jk0GcjDPR0IYJ1d6Js+IBBat63DMOqemcWfE2/D5Ahvfpx
         Ev/26WyoGdmZr5zLCpQuy+WdHbQ1mJM8R9yERrRIwVVTObnCGQrY3gAYbGRM+t73YnMu
         OtfPQhf8E59zZosSzqPDQuL2sshjDhaPyPZv8HDLFhnakjG94pQpt0kR/UiXBKNWvuU+
         zolyHI0hyp/i+sM6+VsDUJ4azOTyNzQ0tNUpLHh+1UFodEo6MsPScTkEMfEoDXVZqBub
         GBfA==
X-Gm-Message-State: AOAM530dgCVWqwJIXsu9EJv9FMzfVef1rs20lzpqXzANc67qk8IDJyR6
        yBf7yxw4b1MT3JCPLe6+aUo=
X-Google-Smtp-Source: ABdhPJw1EZgR37yyNSZKGASst9PZLT9hckMzNAfBSGkazw49o3Y/9G6Vn2uUPcMxi6bTSwcbbswxwQ==
X-Received: by 2002:a9d:578d:: with SMTP id q13mr19502995oth.136.1600374677925;
        Thu, 17 Sep 2020 13:31:17 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:b5c4:4acf:b5cf:24fe])
        by smtp.googlemail.com with ESMTPSA id e30sm691227otf.49.2020.09.17.13.31.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 13:31:17 -0700 (PDT)
Subject: Re: [PATCH net-next v2 8/8] netdevsim: Add support for add and delete
 PCI SF port
To:     Parav Pandit <parav@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-9-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e14f216f-19d9-7b4a-39ff-94ea89cd36c0@gmail.com>
Date:   Thu, 17 Sep 2020 14:31:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200917172020.26484-9-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 11:20 AM, Parav Pandit wrote:
> Simulate PCI SF ports. Allow user to create one or more PCI SF ports.
> 
> Examples:
> 
> Create a PCI PF and PCI SF port.
> $ devlink port add netdevsim/netdevsim10/10 flavour pcipf pfnum 0
> $ devlink port add netdevsim/netdevsim10/11 flavour pcisf pfnum 0 sfnum 44
> $ devlink port show netdevsim/netdevsim10/11
> netdevsim/netdevsim10/11: type eth netdev eni10npf0sf44 flavour pcisf controller 0 pfnum 0 sfnum 44 external true splittable false
>   function:
>     hw_addr 00:00:00:00:00:00 state inactive
> 
> $ devlink port function set netdevsim/netdevsim10/11 hw_addr 00:11:22:33:44:55 state active
> 
> $ devlink port show netdevsim/netdevsim10/11 -jp
> {
>     "port": {
>         "netdevsim/netdevsim10/11": {
>             "type": "eth",
>             "netdev": "eni10npf0sf44",

I could be missing something, but it does not seem like this patch
creates the netdevice for the subfunction.


>             "flavour": "pcisf",
>             "controller": 0,
>             "pfnum": 0,
>             "sfnum": 44,
>             "external": true,
>             "splittable": false,
>             "function": {
>                 "hw_addr": "00:11:22:33:44:55",
>                 "state": "active"
>             }
>         }
>     }
> }
> 
> Delete newly added devlink port
> $ devlink port add netdevsim/netdevsim10/11
> 
> Add devlink port of flavour 'pcisf' where port index and sfnum are
> auto assigned by driver.
> $ devlink port add netdevsim/netdevsim10 flavour pcisf controller 0 pfnum 0
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  drivers/net/netdevsim/netdevsim.h     |  1 +
>  drivers/net/netdevsim/port_function.c | 95 +++++++++++++++++++++++++--
>  2 files changed, 92 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
> index 0ea9705eda38..c70782e444d5 100644
> --- a/drivers/net/netdevsim/netdevsim.h
> +++ b/drivers/net/netdevsim/netdevsim.h
> @@ -222,6 +222,7 @@ struct nsim_dev {
>  		struct list_head head;
>  		struct ida ida;
>  		struct ida pfnum_ida;
> +		struct ida sfnum_ida;
>  	} port_functions;
>  };
>  
> diff --git a/drivers/net/netdevsim/port_function.c b/drivers/net/netdevsim/port_function.c
> index 99581d3d15fe..e1812acd55b4 100644
> --- a/drivers/net/netdevsim/port_function.c
> +++ b/drivers/net/netdevsim/port_function.c
> @@ -13,10 +13,12 @@ struct nsim_port_function {
>  	unsigned int port_index;
>  	enum devlink_port_flavour flavour;
>  	u32 controller;
> +	u32 sfnum;
>  	u16 pfnum;
>  	struct nsim_port_function *pf_port; /* Valid only for SF port */
>  	u8 hw_addr[ETH_ALEN];
>  	u8 state; /* enum devlink_port_function_state */
> +	int refcount; /* Counts how many sf ports are bound attached to this pf port. */
>  };
>  
>  void nsim_dev_port_function_init(struct nsim_dev *nsim_dev)
> @@ -25,10 +27,13 @@ void nsim_dev_port_function_init(struct nsim_dev *nsim_dev)
>  	INIT_LIST_HEAD(&nsim_dev->port_functions.head);
>  	ida_init(&nsim_dev->port_functions.ida);
>  	ida_init(&nsim_dev->port_functions.pfnum_ida);
> +	ida_init(&nsim_dev->port_functions.sfnum_ida);
>  }
>  
>  void nsim_dev_port_function_exit(struct nsim_dev *nsim_dev)
>  {
> +	WARN_ON(!ida_is_empty(&nsim_dev->port_functions.sfnum_ida));
> +	ida_destroy(&nsim_dev->port_functions.sfnum_ida);
>  	WARN_ON(!ida_is_empty(&nsim_dev->port_functions.pfnum_ida));
>  	ida_destroy(&nsim_dev->port_functions.pfnum_ida);
>  	WARN_ON(!ida_is_empty(&nsim_dev->port_functions.ida));
> @@ -119,9 +124,24 @@ nsim_devlink_port_function_alloc(struct nsim_dev *dev, const struct devlink_port
>  			goto fn_ida_err;
>  		port->pfnum = ret;
>  		break;
> +	case DEVLINK_PORT_FLAVOUR_PCI_SF:
> +		if (attrs->sfnum_valid)
> +			ret = ida_alloc_range(&dev->port_functions.sfnum_ida, attrs->sfnum,
> +					      attrs->sfnum, GFP_KERNEL);
> +		else
> +			ret = ida_alloc(&dev->port_functions.sfnum_ida, GFP_KERNEL);
> +		if (ret < 0)
> +			goto fn_ida_err;
> +		port->sfnum = ret;
> +		port->pfnum = attrs->pfnum;
> +		break;
>  	default:
>  		break;
>  	}
> +	/* refcount_t is not needed as port is protected by port_functions.mutex.
> +	 * This count is to keep track of how many SF ports are attached a PF port.
> +	 */
> +	port->refcount = 1;
>  	return port;
>  
>  fn_ida_err:
> @@ -137,6 +157,9 @@ static void nsim_devlink_port_function_free(struct nsim_dev *dev, struct nsim_po
>  	case DEVLINK_PORT_FLAVOUR_PCI_PF:
>  		ida_simple_remove(&dev->port_functions.pfnum_ida, port->pfnum);
>  		break;
> +	case DEVLINK_PORT_FLAVOUR_PCI_SF:
> +		ida_simple_remove(&dev->port_functions.sfnum_ida, port->sfnum);
> +		break;
>  	default:
>  		break;
>  	}
> @@ -170,6 +193,11 @@ nsim_dev_port_port_exists(struct nsim_dev *nsim_dev, const struct devlink_port_n
>  		if (attrs->flavour == DEVLINK_PORT_FLAVOUR_PCI_PF &&
>  		    tmp->flavour == DEVLINK_PORT_FLAVOUR_PCI_PF && tmp->pfnum == attrs->pfnum)
>  			return true;
> +
> +		if (attrs->flavour == DEVLINK_PORT_FLAVOUR_PCI_SF &&
> +		    tmp->flavour == DEVLINK_PORT_FLAVOUR_PCI_SF &&
> +		    tmp->sfnum == attrs->sfnum && tmp->pfnum == attrs->pfnum)
> +			return true;
>  	}
>  	return false;
>  }
> @@ -183,21 +211,71 @@ nsim_dev_devlink_port_index_lookup(const struct nsim_dev *nsim_dev, unsigned int
>  	list_for_each_entry(port, &nsim_dev->port_functions.head, list) {
>  		if (port->port_index != port_index)
>  			continue;
> +		if (port->refcount > 1) {
> +			NL_SET_ERR_MSG_MOD(extack, "Port is in use");
> +			return ERR_PTR(-EBUSY);
> +		}
>  		return port;
>  	}
>  	NL_SET_ERR_MSG_MOD(extack, "User created port not found");
>  	return ERR_PTR(-ENOENT);
>  }
>  
> +static struct nsim_port_function *
> +pf_port_get(struct nsim_dev *nsim_dev, struct nsim_port_function *port)
> +{
> +	struct nsim_port_function *tmp;
> +
> +	/* PF port addition doesn't need a parent. */
> +	if (port->flavour == DEVLINK_PORT_FLAVOUR_PCI_PF)
> +		return NULL;
> +
> +	list_for_each_entry(tmp, &nsim_dev->port_functions.head, list) {
> +		if (tmp->flavour != DEVLINK_PORT_FLAVOUR_PCI_PF || tmp->pfnum != port->pfnum)
> +			continue;
> +
> +		if (tmp->refcount + 1 == INT_MAX)
> +			return ERR_PTR(-ENOSPC);
> +
> +		port->pf_port = tmp;
> +		tmp->refcount++;
> +		return tmp;
> +	}
> +	return ERR_PTR(-ENOENT);
> +}
> +
> +static void pf_port_put(struct nsim_port_function *port)
> +{
> +	if (port->pf_port) {
> +		port->pf_port->refcount--;
> +		WARN_ON(port->pf_port->refcount < 0);
> +	}
> +	port->refcount--;
> +	WARN_ON(port->refcount != 0);
> +}
> +
>  static int nsim_devlink_port_function_add(struct devlink *devlink, struct nsim_dev *nsim_dev,
>  					  struct nsim_port_function *port,
>  					  struct netlink_ext_ack *extack)
>  {
> +	struct nsim_port_function *pf_port;
>  	int err;
>  
> -	list_add(&port->list, &nsim_dev->port_functions.head);
> +	/* Keep all PF ports at the start, so that when driver is unloaded
> +	 * All SF ports from the end of the list can be removed first.
> +	 */
> +	if (port->flavour == DEVLINK_PORT_FLAVOUR_PCI_PF)
> +		list_add(&port->list, &nsim_dev->port_functions.head);
> +	else
> +		list_add_tail(&port->list, &nsim_dev->port_functions.head);
> +
> +	pf_port = pf_port_get(nsim_dev, port);
> +	if (IS_ERR(pf_port)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Fail to get pf port");
> +		err = PTR_ERR(pf_port);
> +		goto pf_err;
> +	}
>  
> -	port->state = DEVLINK_PORT_FUNCTION_STATE_INACTIVE;
>  	err = devlink_port_register(devlink, &port->dl_port, port->port_index);
>  	if (err)
>  		goto reg_err;
> @@ -213,6 +291,8 @@ static int nsim_devlink_port_function_add(struct devlink *devlink, struct nsim_d
>  	devlink_port_type_clear(&port->dl_port);
>  	devlink_port_unregister(&port->dl_port);
>  reg_err:
> +	pf_port_put(port);
> +pf_err:
>  	list_del(&port->list);
>  	return err;
>  }
> @@ -224,12 +304,14 @@ static void nsim_devlink_port_function_del(struct nsim_dev *nsim_dev,
>  	unregister_netdev(port->netdev);
>  	devlink_port_unregister(&port->dl_port);
>  	list_del(&port->list);
> +	pf_port_put(port);
>  }
>  
>  static bool nsim_dev_port_flavour_supported(const struct nsim_dev *nsim_dev,
>  					    const struct devlink_port_new_attrs *attrs)
>  {
> -	return attrs->flavour == DEVLINK_PORT_FLAVOUR_PCI_PF;
> +	return attrs->flavour == DEVLINK_PORT_FLAVOUR_PCI_PF ||
> +	       attrs->flavour == DEVLINK_PORT_FLAVOUR_PCI_SF;
>  }
>  
>  int nsim_dev_devlink_port_new(struct devlink *devlink, const struct devlink_port_new_attrs *attrs,
> @@ -266,7 +348,11 @@ int nsim_dev_devlink_port_new(struct devlink *devlink, const struct devlink_port
>  	       nsim_dev->switch_id.id_len);
>  	port->dl_port.attrs.switch_id.id_len = nsim_dev->switch_id.id_len;
>  
> -	devlink_port_attrs_pci_pf_set(&port->dl_port, port->controller, port->pfnum, false);
> +	if (attrs->flavour == DEVLINK_PORT_FLAVOUR_PCI_PF)
> +		devlink_port_attrs_pci_pf_set(&port->dl_port, port->controller, port->pfnum, false);
> +	else
> +		devlink_port_attrs_pci_sf_set(&port->dl_port, port->controller, port->pfnum,
> +					      port->sfnum, false);
>  
>  	err = nsim_devlink_port_function_add(devlink, nsim_dev, port, extack);
>  	if (err)
> @@ -333,6 +419,7 @@ void nsim_dev_port_function_disable(struct nsim_dev *nsim_dev)
>  	 * ports.
>  	 */
>  
> +	/* Remove SF ports first, followed by PF ports. */
>  	list_for_each_entry_safe_reverse(port, tmp, &nsim_dev->port_functions.head, list) {
>  		nsim_devlink_port_function_del(nsim_dev, port);
>  		nsim_devlink_port_function_free(nsim_dev, port);
> 

