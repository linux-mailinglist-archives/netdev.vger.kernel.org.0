Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2DD660BBE
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 21:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfGETR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 15:17:27 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38769 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfGETR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 15:17:27 -0400
Received: by mail-qk1-f194.google.com with SMTP id a27so8658428qkk.5
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 12:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=X/CSxc99IjhM7/EX4+2qDSEyX0btqwg+t1xgJc71t9s=;
        b=ZCmLJsuOsgrgqiJ8V25vLSsj8CQrJpDXClL/BLV4GjVpI+NVslLeOVp5/lEfELPgfn
         sb39MOMQa1tKVaZ3JdnGWjuezPIHx9VICP+tpaSbhiEPvliJWCgjMPc+1uOSZl7/TxLQ
         JAfYDHYZ7CowIAtzAmccXQo6bPAtvNbvy2dUZ/IPWnwsfGHn/eHxaf5OSucII45ca2js
         RNFvG8PpImbF8BtJhdvyT/97mRXf5DazHn0enhaKsSjOm822z4FKozEEhsVhRfsEp1CX
         Ui+rdMHDRhfEQ+J3Rg/UCJpI5QpcoGLyxxNdrFp+F6OJmka8rxR06YNpl3APMqB+DKoJ
         jITA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=X/CSxc99IjhM7/EX4+2qDSEyX0btqwg+t1xgJc71t9s=;
        b=Cl4G4GEOVq6LAkzu1oQdP2kIglsv4fgzArimgczip8hj3gGd48VBKbVgXEXZsbpMNa
         X84YQq7iIjz7muOua4LouC8qTJ61UXJoowWpM4sUtKCIozgPW5q3+qIznH75YmSVserE
         BG84cfwTdKwOAs/ng+9cInbhRFz6nMvvkBvByfzMLXvINcETad4NIheVnpkTsZrTTeQ6
         cSrSvD800CPUL7qn/suyXlzxJgTxdkwobb6WgjhSJRa9u71gAiYcOUW6Rp/o9E/dayke
         uWYTfvuGjVNmCaaC8QRUWQAiKhBfXU0Ol1se0PNH8oBlfgUKvNlL6j6a+ESSK4uB9/ZB
         cjng==
X-Gm-Message-State: APjAAAVexLBP0k65LNybpqcQIq6FKOUC0v8YoJqVPXrIspBPkjJkWtZl
        nQv9w3HAP3HVngpVQJjlg4Ogk4ShRgo=
X-Google-Smtp-Source: APXvYqzXm24ZqJvPJyPVu7lsI4giLgDtH49Aw4oLSjuAaCejkm0u4VyrkErQypZbDtp86QlgXAKQjg==
X-Received: by 2002:a05:620a:44:: with SMTP id t4mr4431480qkt.189.1562354246689;
        Fri, 05 Jul 2019 12:17:26 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q2sm3691239qkc.118.2019.07.05.12.17.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 12:17:26 -0700 (PDT)
Date:   Fri, 5 Jul 2019 12:17:22 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, saeedm@mellanox.com
Subject: Re: [PATCH net-next v2 1/3] devlink: Introduce PCI PF port flavour
 and port attribute
Message-ID: <20190705121722.269711ed@cakuba.netronome.com>
In-Reply-To: <20190705073711.37854-2-parav@mellanox.com>
References: <20190701122734.18770-1-parav@mellanox.com>
        <20190705073711.37854-1-parav@mellanox.com>
        <20190705073711.37854-2-parav@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Jul 2019 02:37:09 -0500, Parav Pandit wrote:
> @@ -38,14 +38,24 @@ struct devlink {
>  	char priv[0] __aligned(NETDEV_ALIGN);
>  };
>  
> +struct devlink_port_pci_pf_attrs {
> +	u16 pf;	/* Associated PCI PF for this port. */
> +};
> +
>  struct devlink_port_attrs {
>  	u8 set:1,
>  	   split:1,
>  	   switch_port:1;
>  	enum devlink_port_flavour flavour;
> -	u32 port_number; /* same value as "split group" */
> +	u32 port_number; /* same value as "split group".
> +			  * Valid only when a port is physical and visible
> +			  * to the user for a given port flavour.
> +			  */

port_number can be in the per-flavour union below.

>  	u32 split_subport_number;

As can split_subport_number.

>  	struct netdev_phys_item_id switch_id;
> +	union {
> +		struct devlink_port_pci_pf_attrs pci_pf;
> +	};
>  };
>  
>  struct devlink_port {

> @@ -515,8 +523,14 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
>  		return 0;
>  	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
>  		return -EMSGSIZE;
> -	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs->port_number))
> +	if (is_devlink_phy_port_num_supported(devlink_port) &&
> +	    nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs->port_number))
>  		return -EMSGSIZE;
> +	if (devlink_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_PCI_PF) {
> +		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
> +				attrs->pci_pf.pf))
> +			return -EMSGSIZE;
> +	}
>  	if (!attrs->split)
>  		return 0;
>  	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_GROUP, attrs->port_number))

Split attributes as well, please:

On Tue, 2 Jul 2019 16:42:52 -0700, Jakub Kicinski wrote:
> port_number, and split attributes should not be exposed for PCI ports.

We have no clear semantics for those, yet, and the phys_port_name
implementation in this patch doesn't handle split PCI, so let's leave
them out for now.
