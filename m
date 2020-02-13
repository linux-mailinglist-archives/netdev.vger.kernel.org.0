Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95B3215BAE4
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 09:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgBMIkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 03:40:09 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34481 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729485AbgBMIkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 03:40:09 -0500
Received: by mail-wr1-f66.google.com with SMTP id n10so3613918wrm.1
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 00:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jj6IL3uoOW6O/Dds8hVOuDjOtm4PzGXqbiZewKiQWhk=;
        b=kY/3cw+stscbPKmIOoyWlHw0uwh4Um5iiftiTtHFXoaMjeNA/lTWRIlxSiUdvSwVW+
         ebFE6uyp8xfZ+V8x7NXlBVc2dT/EqJAUz4WbHc/CYrLXaZdAbgdF9HTi5mxOX/AORxPb
         eME+aPQvIU5azXJ4t6FrK9YNLXqIYs8NwH2Vol8sI8gQUoxLBN+nj0PdkPRDLvYp4VRi
         DusM5rQThRGM5v69sljoiao/z4Wqv7+tnh6vI/RO7eQpFS9kVHerpmKOu2rKDZNbuv73
         JwkHZdwRZlC57JSrJjeS9hbi2R+U1Sbny+0VQMGhH6UBfTxk+9uZsGD2CtbIqzkZPPZN
         azKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jj6IL3uoOW6O/Dds8hVOuDjOtm4PzGXqbiZewKiQWhk=;
        b=mhyYGrax64MmVeWmnN34oQKYOUR8R1czygIbqxVTxyd1to3VIr1vK6QYYzvVnWH2M4
         eZ+r3qFOF6lGnfPxC0dlK7A5vns1PH6QvAcbCVOu6Q8NdoPy/BtNTGGaVKbAxqezFsnn
         q+pMfvMpeapXFNluEETvKSiVDA6oI7+0dw0IAEa90Mwp037rr92EkZH97semSFRjB6ZC
         7ttsfttHsvnZ5ff6Zv6IwnRsDYM7vDa6NyAqcI/OZNvbDLwWerDH7lgijnsEjWAVxwdl
         yYXi30mIvZP1POzmcjs31UUolsJ3h+LbzfLDbOd0GA5c9JMWlUpDm/sulaLmxPenSFVN
         spAg==
X-Gm-Message-State: APjAAAVNtity619/Vl6uYJwm5gX4eZqauwViYRLixUOUANIRZQTxVBG4
        CCRqa+DilLoUXmpcTPnWBJ7/ew==
X-Google-Smtp-Source: APXvYqyx7gEfcTMsnd+nLBb8Fdy9LVsbZSzlDPjgHgAZKKWvjuO6cBc0Imxl++hGthzpgzxq2dbN+Q==
X-Received: by 2002:a5d:474b:: with SMTP id o11mr21254953wrs.255.1581583207232;
        Thu, 13 Feb 2020 00:40:07 -0800 (PST)
Received: from localhost (ip-89-177-128-209.net.upcbroadband.cz. [89.177.128.209])
        by smtp.gmail.com with ESMTPSA id q124sm14397420wme.2.2020.02.13.00.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 00:40:06 -0800 (PST)
Date:   Thu, 13 Feb 2020 09:40:05 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Keiya Nobuta <nobuta.keiya@fujitsu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: sched: Add sysfs_notify for /sys/class/net/*/carrier
Message-ID: <20200213084005.GF22610@nanopsycho>
References: <20200213052111.19595-1-nobuta.keiya@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213052111.19595-1-nobuta.keiya@fujitsu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 13, 2020 at 06:21:11AM CET, nobuta.keiya@fujitsu.com wrote:
>This patch makes /sys/class/<iface>/carrier pollable and allows
>application to monitor current physical link state changes.
>
>Signed-off-by: Keiya Nobuta <nobuta.keiya@fujitsu.com>
>---
> net/sched/sch_generic.c | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
>index 6c9595f..67e4190 100644
>--- a/net/sched/sch_generic.c
>+++ b/net/sched/sch_generic.c
>@@ -493,6 +493,7 @@ void netif_carrier_on(struct net_device *dev)
> 		linkwatch_fire_event(dev);
> 		if (netif_running(dev))
> 			__netdev_watchdog_up(dev);
>+		sysfs_notify(&dev->dev.kobj, NULL, "carrier");

This would be the only use of sysfs notify in net. I wonder, what makes
the carrier different comparing to other attributes that might change
during runtime?

Also, in net, we have RTNETLINK that app can listen to and react.
Carrier change is propagated through that as well.


> 	}
> }
> EXPORT_SYMBOL(netif_carrier_on);
>@@ -510,6 +511,7 @@ void netif_carrier_off(struct net_device *dev)
> 			return;
> 		atomic_inc(&dev->carrier_down_count);
> 		linkwatch_fire_event(dev);
>+		sysfs_notify(&dev->dev.kobj, NULL, "carrier");
> 	}
> }
> EXPORT_SYMBOL(netif_carrier_off);
>-- 
>2.7.4
>
