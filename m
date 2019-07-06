Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B6360F3F
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 08:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfGFG0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 02:26:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44905 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGFG0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 02:26:16 -0400
Received: by mail-wr1-f67.google.com with SMTP id p17so664254wrf.11
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 23:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EFjKYCQnsRtvHVrgdTrsskg/RkgMb5H4xSD2yHUcGIY=;
        b=FDyoY0XgOkve28UXaqQ5GVMsTsb228RzTa7FfwAB6o8nPHAGkoDm1pHEDkK8GU+935
         fIqJ39/uvrPOyPST0X5GjyYHssJoG6nLoHSj+koGtmGe+92KZAw/i/8ngBLwjj1G9Ekn
         WGXBkeWxpI3MtsgUg0skPm8t2XPr9Kujh5lewnZFL5dG5sRZUI0qEFgGwV+bH09L2kki
         tk/fvc37IM8WiWTCjC8//q6RuTKHf/JzpL5iwbm0xzXYo8E7fc/4mFgw83V7z/yVZxor
         tN2KswPc9StDRVNF+TBlfln+1JP3mWCdK5fA0XcJYNldFECJlmm1PFRto2x536K23ZJJ
         ZKAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EFjKYCQnsRtvHVrgdTrsskg/RkgMb5H4xSD2yHUcGIY=;
        b=ZDq8HNUGNmhgHtFZ6Aq12hAijT3SKCBFJxT+AzERd+MN4Jcz35x6g/dICT1eD6wS+n
         zj42HqfedSowCrsn99p+0ZgkC2qvmiuMErSTP/IEyjhHqvEkX7uhR0gQNdPdfoWjL79X
         Iphy1SKm7kLgxg0nsJdaFUKaslY8yf+AN9M5yIbVgC8KyZ0k2qa7VeftRcTHNkoGtqIv
         bBK1cv7fk2IChYD+fxqlIOs2wXQwK13i0l3Jdxdma/01+R06VcnKl3qWiPxVxo/I+VR9
         3venkQm6FReydpdU13S0UZ+ND0aIXTRRIIy05A2a7i6bVK3LPNlffJFw1ZyfdNlDfPOd
         6pkg==
X-Gm-Message-State: APjAAAWVFT9G9OZUuVL9RihJS0R/cCG0fZiLI44wX+Q6HT5CyJqbOc1v
        MkOuCP/QCF0G622xMxrNu3aCVO256Q8=
X-Google-Smtp-Source: APXvYqwUDzpE1Ckw8deC6x/oKJAQ3j/mWmrY/oZy8KsKywpSpH1wAOJsuOF2RtJrtugUM5gJngsHFQ==
X-Received: by 2002:adf:f246:: with SMTP id b6mr7563715wrp.92.1562394372466;
        Fri, 05 Jul 2019 23:26:12 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id 91sm4327237wrp.3.2019.07.05.23.26.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 23:26:11 -0700 (PDT)
Date:   Sat, 6 Jul 2019 08:26:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v3 1/3] devlink: Introduce PCI PF port flavour
 and port attribute
Message-ID: <20190706062611.GA2264@nanopsycho>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190706061626.31440-1-parav@mellanox.com>
 <20190706061626.31440-2-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190706061626.31440-2-parav@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 06, 2019 at 08:16:24AM CEST, parav@mellanox.com wrote:
>In an eswitch, PCI PF may have port which is normally represented
>using a representor netdevice.
>To have better visibility of eswitch port, its association with
>PF and a representor netdevice, introduce a PCI PF port
>flavour and port attriute.
>
>When devlink port flavour is PCI PF, fill up PCI PF attributes of the
>port.
>
>Extend port name creation using PCI PF number on best effort basis.
>So that vendor drivers can skip defining their own scheme.
>
>$ devlink port show
>pci/0000:05:00.0/0: type eth netdev eth0 flavour pcipf pfnum 0
>
>Signed-off-by: Parav Pandit <parav@mellanox.com>
>
>---
>Changelog:
>v2->v3:
> - Address comments from Jakub.
> - Made port_number and split_port_number applicable only to
>   physical port flavours by having in union.
>v1->v2:
> - Limited port_num attribute to physical ports
> - Updated PCI PF attribute set API to not have port_number
>---
> include/net/devlink.h        | 21 +++++++-
> include/uapi/linux/devlink.h |  5 ++
> net/core/devlink.c           | 97 ++++++++++++++++++++++++++++--------
> 3 files changed, 100 insertions(+), 23 deletions(-)
>
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 6625ea068d5e..1455f60e4069 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -38,13 +38,27 @@ struct devlink {
> 	char priv[0] __aligned(NETDEV_ALIGN);
> };
> 
>+struct devlink_port_phys_attrs {
>+	u32 port_number; /* same value as "split group".

"Same" with capital letter.

>+			  * A physical port which is visible to the user
>+			  * for a given port flavour.
>+			  */
>+	u32 split_subport_number;
>+};
>+
>+struct devlink_port_pci_pf_attrs {
>+	u16 pf;	/* Associated PCI PF for this port. */
>+};
>+
> struct devlink_port_attrs {
> 	u8 set:1,
> 	   split:1,
> 	   switch_port:1;
> 	enum devlink_port_flavour flavour;
>-	u32 port_number; /* same value as "split group" */
>-	u32 split_subport_number;
>+	union {
>+		struct devlink_port_phys_attrs phys_port;
>+		struct devlink_port_pci_pf_attrs pci_pf;

Be consistent in naming: "phys", "pci_pf".


>+	};
> 	struct netdev_phys_item_id switch_id;
> };
> 
>@@ -590,6 +604,9 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
> 			    u32 split_subport_number,
> 			    const unsigned char *switch_id,
> 			    unsigned char switch_id_len);
>+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
>+				   const unsigned char *switch_id,
>+				   unsigned char switch_id_len, u16 pf);
> int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
> 			u32 size, u16 ingress_pools_count,
> 			u16 egress_pools_count, u16 ingress_tc_count,
>diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>index 5287b42c181f..f7323884c3fe 100644
>--- a/include/uapi/linux/devlink.h
>+++ b/include/uapi/linux/devlink.h
>@@ -169,6 +169,10 @@ enum devlink_port_flavour {
> 	DEVLINK_PORT_FLAVOUR_DSA, /* Distributed switch architecture
> 				   * interconnect port.
> 				   */
>+	DEVLINK_PORT_FLAVOUR_PCI_PF, /* Represents eswitch port for
>+				      * the PCI PF. It is an internal
>+				      * port that faces the PCI PF.
>+				      */
> };
> 
> enum devlink_param_cmode {
>@@ -337,6 +341,7 @@ enum devlink_attr {
> 	DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,	/* u64 */
> 	DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,	/* u64 */
> 
>+	DEVLINK_ATTR_PORT_PCI_PF_NUMBER,	/* u16 */
> 	/* add new attributes above here, update the policy in devlink.c */
> 
> 	__DEVLINK_ATTR_MAX,
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 89c533778135..9aa36104b471 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -506,6 +506,14 @@ static void devlink_notify(struct devlink *devlink, enum devlink_command cmd)
> 				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
> }
> 
>+static bool
>+is_devlink_phy_port_num_supported(const struct devlink_port *dl_port)
>+{
>+	return (dl_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_PHYSICAL ||
>+		dl_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_CPU ||
>+		dl_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_DSA);
>+}
>+
> static int devlink_nl_port_attrs_put(struct sk_buff *msg,
> 				     struct devlink_port *devlink_port)
> {
>@@ -515,14 +523,23 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
> 		return 0;
> 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
> 		return -EMSGSIZE;
>-	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs->port_number))
>+	if (devlink_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_PCI_PF) {
>+		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
>+				attrs->pci_pf.pf))
>+			return -EMSGSIZE;
>+	}
>+	if (!is_devlink_phy_port_num_supported(devlink_port))

Please do the check here. No need for helper (the name with "is" and
"supported" is weird anyway.


>+		return 0;
>+	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER,
>+			attrs->phys_port.port_number))
> 		return -EMSGSIZE;
> 	if (!attrs->split)
> 		return 0;
>-	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_GROUP, attrs->port_number))
>+	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_GROUP,
>+			attrs->phys_port.port_number))

Better to split this into 2 patches. One pushing phys things into
separate struct, the second the rest.


> 		return -EMSGSIZE;
> 	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_SUBPORT_NUMBER,
>-			attrs->split_subport_number))
>+			attrs->phys_port.split_subport_number))
> 		return -EMSGSIZE;
> 	return 0;
> }
>@@ -5738,6 +5755,30 @@ void devlink_port_type_clear(struct devlink_port *devlink_port)
> }
> EXPORT_SYMBOL_GPL(devlink_port_type_clear);
> 
>+static void __devlink_port_attrs_set(struct devlink_port *devlink_port,
>+				     enum devlink_port_flavour flavour,
>+				     u32 port_number,
>+				     const unsigned char *switch_id,
>+				     unsigned char switch_id_len)
>+{
>+	struct devlink_port_attrs *attrs = &devlink_port->attrs;
>+
>+	if (WARN_ON(devlink_port->registered))
>+		return;
>+	attrs->set = true;
>+	attrs->flavour = flavour;
>+	attrs->phys_port.port_number = port_number;
>+	if (switch_id) {
>+		attrs->switch_port = true;
>+		if (WARN_ON(switch_id_len > MAX_PHYS_ITEM_ID_LEN))
>+			switch_id_len = MAX_PHYS_ITEM_ID_LEN;
>+		memcpy(attrs->switch_id.id, switch_id, switch_id_len);
>+		attrs->switch_id.id_len = switch_id_len;
>+	} else {
>+		attrs->switch_port = false;
>+	}
>+}
>+
> /**
>  *	devlink_port_attrs_set - Set port attributes
>  *
>@@ -5761,25 +5802,34 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
> {
> 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
> 
>-	if (WARN_ON(devlink_port->registered))
>-		return;
>-	attrs->set = true;
>-	attrs->flavour = flavour;
>-	attrs->port_number = port_number;
>+	__devlink_port_attrs_set(devlink_port, flavour, port_number,
>+				 switch_id, switch_id_len);
> 	attrs->split = split;
>-	attrs->split_subport_number = split_subport_number;
>-	if (switch_id) {
>-		attrs->switch_port = true;
>-		if (WARN_ON(switch_id_len > MAX_PHYS_ITEM_ID_LEN))
>-			switch_id_len = MAX_PHYS_ITEM_ID_LEN;
>-		memcpy(attrs->switch_id.id, switch_id, switch_id_len);
>-		attrs->switch_id.id_len = switch_id_len;
>-	} else {
>-		attrs->switch_port = false;
>-	}
>+	attrs->phys_port.split_subport_number = split_subport_number;
> }
> EXPORT_SYMBOL_GPL(devlink_port_attrs_set);
> 
>+/**
>+ *	devlink_port_attrs_pci_pf_set - Set PCI PF port attributes
>+ *
>+ *	@devlink_port: devlink port
>+ *	@pf: associated PF for the devlink port instance
>+ *	@switch_id: if the port is part of switch, this is buffer with ID,
>+ *	            otwerwise this is NULL
>+ *	@switch_id_len: length of the switch_id buffer
>+ */
>+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
>+				   const unsigned char *switch_id,
>+				   unsigned char switch_id_len, u16 pf)
>+{
>+	struct devlink_port_attrs *attrs = &devlink_port->attrs;
>+
>+	__devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_PCI_PF,
>+				 0, switch_id, switch_id_len);

Please have this done differently. __devlink_port_attrs_set() sets
attrs->phys_port.port_number which does not make sense there.


>+	attrs->pci_pf.pf = pf;
>+}
>+EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_pf_set);
>+
> static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
> 					     char *name, size_t len)
> {
>@@ -5792,10 +5842,12 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
> 	switch (attrs->flavour) {
> 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
> 		if (!attrs->split)
>-			n = snprintf(name, len, "p%u", attrs->port_number);
>+			n = snprintf(name, len, "p%u",
>+				     attrs->phys_port.port_number);
> 		else
>-			n = snprintf(name, len, "p%us%u", attrs->port_number,
>-				     attrs->split_subport_number);
>+			n = snprintf(name, len, "p%us%u",
>+				     attrs->phys_port.port_number,
>+				     attrs->phys_port.split_subport_number);
> 		break;
> 	case DEVLINK_PORT_FLAVOUR_CPU:
> 	case DEVLINK_PORT_FLAVOUR_DSA:
>@@ -5804,6 +5856,9 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
> 		 */
> 		WARN_ON(1);
> 		return -EINVAL;
>+	case DEVLINK_PORT_FLAVOUR_PCI_PF:
>+		n = snprintf(name, len, "pf%u", attrs->pci_pf.pf);
>+		break;
> 	}
> 
> 	if (n >= len)
>-- 
>2.19.2
>
