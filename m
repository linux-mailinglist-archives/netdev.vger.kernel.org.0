Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98F1E127465
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 04:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfLTD61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 22:58:27 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42337 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727221AbfLTD61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 22:58:27 -0500
Received: by mail-pf1-f195.google.com with SMTP id 4so4458996pfz.9
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 19:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H7W5ryLb0kOflCSwxuS+upfkTZ1TNUoEgZ4PgIcQ8mc=;
        b=KSsknwoajjrCC5wwge/5JbI3X2s9oi3jL/mbUaDTXn/GELrgYQ/ZjOD54KHbdNCbX9
         GAo5ifjzpTT6T0D9cSQkcjluibNDBdbxTsGwsCcCjdXuiYQ+8fHbk3MP0cuJWgkzIyHr
         +alc2qqULFx0ClTkBHAlHxwh5AEtNpa1agy77rykOut/TZiJQtnUbl5BYf7ERGKfkCI4
         WFjyrom8bsVj03Eoo0JeAytaCuzH8jEL9D8Xn4UbRkPrz78VYTZf0/9ijYCoZ4cUr3Nu
         0u7MGZGSDgQNRn/PTikc/URwIDaGxoq4f4ljOAhiwpeeXkAJT90f43aF6OrmnbS0jCSW
         vQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H7W5ryLb0kOflCSwxuS+upfkTZ1TNUoEgZ4PgIcQ8mc=;
        b=HCiIHpmw4TNTTbeG3gPTj+F30eBzE68SrJnT7qvStBC7Cm172LiOo5xsFSGIrGoUqz
         aonf4J8DhLqUjDOonKkTDISIeCna0fOe2mXFwlCoVglbHZIY5emBNXyPtKHHBE097dqr
         dTNgEhnaUzB8e/oZad7ZaQQFlVs5dRpbCBeXej76xO9IzW2YdPyYKFoyw+dSrm4JDzmC
         ISrTp3AbXVm4EHOG0OMp5ozyeds2hDBf4XEfNfdUZ7KFpVKVpczBDusl9eNOoGphswTy
         RykhyRSf45c2ciaK+ra6GMTREP2u9tuY5mumaE1uX3oX/5YS0oPgrHXpoafxeaEL17bu
         8Ecw==
X-Gm-Message-State: APjAAAX8NibDSqT9o5A33WcJrST8iSMgkB/6/kQQLDGN29u4TEa+CGdW
        fd+Pchnjk2QYV4EJX0JkQuS/jQ==
X-Google-Smtp-Source: APXvYqwC4bqiM/lstBvHRsesOgC+cOc913hHeVTd2U773eXTr5FZqU1VLKHDaz4aOV7diODWErLg+A==
X-Received: by 2002:aa7:9556:: with SMTP id w22mr13760072pfq.198.1576814306550;
        Thu, 19 Dec 2019 19:58:26 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d65sm10328576pfa.159.2019.12.19.19.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 19:58:26 -0800 (PST)
Date:   Thu, 19 Dec 2019 19:58:18 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Miller <davem@davemloft.net>
Cc:     cforno12@linux.vnet.ibm.com, netdev@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com
Subject: Re: [PATCH, net-next, v3, 0/2] net/ethtool: Introduce
 link_ksettings API for virtual network devices
Message-ID: <20191219195818.62501eea@hermes.lan>
In-Reply-To: <20191219.141619.1840874136750249908.davem@davemloft.net>
References: <20191219194057.4208-1-cforno12@linux.vnet.ibm.com>
        <20191219131156.21332555@hermes.lan>
        <20191219.141619.1840874136750249908.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Dec 2019 14:16:19 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <stephen@networkplumber.org>
> Date: Thu, 19 Dec 2019 13:11:56 -0800
> 
> > I don't think this makes sense for netvsc. The speed and duplex have no
> > meaning, why do you want to allow overriding it? If this is to try and make
> > some dashboard look good; then you aren't seeing the real speed which is
> > what only the host knows. Plus it does take into account the accelerated
> > networking path.  
> 
> Maybe that's the point, userspace has extraneous knowledge it might
> use to set it accurately.
> 
> This helps for bonding/team etc. as well.
> 
> I don't think there is any real harm in allowing to set this, and
> we've done this in the past I think.

The most widely used case with netvsc is using VF to get accelerated networking
in that case real speed and duplex value is reported by the VF device.

Maybe something like the following (COMPLETELY UNTESTED):


diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index eff8fef4f775..111847ca7e8c 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1083,11 +1083,14 @@ static int netvsc_get_link_ksettings(struct net_device *dev,
 				     struct ethtool_link_ksettings *cmd)
 {
 	struct net_device_context *ndc = netdev_priv(dev);
+	struct net_device *vf_netdev = rtnl_dereference(ndc->vf_netdev);
+
+	if (vf_netdev)
+		return __ethtool_get_link_ksettings(vf_netdev, cmd);
 
 	cmd->base.speed = ndc->speed;
 	cmd->base.duplex = ndc->duplex;
 	cmd->base.port = PORT_OTHER;
-
 	return 0;
 }
 
@@ -1095,8 +1098,17 @@ static int netvsc_set_link_ksettings(struct net_device *dev,
 				     const struct ethtool_link_ksettings *cmd)
 {
 	struct net_device_context *ndc = netdev_priv(dev);
+	struct net_device *vf_netdev = rtnl_dereference(ndc->vf_netdev);
 	u32 speed;
 
+	if (vf_netdev) {
+		if (!vf_netdev->ethtool_ops->set_link_ksettings)
+			return -EOPNOTSUPP;
+
+		return vf_netdev->ethtool_ops->set_link_ksettings(vf_netdev,
+								  cmd);
+	}
+
 	speed = cmd->base.speed;
 	if (!ethtool_validate_speed(speed) ||
 	    !ethtool_validate_duplex(cmd->base.duplex) ||
-- 
2.20.1

