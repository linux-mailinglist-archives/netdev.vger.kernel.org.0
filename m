Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8097A111
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 08:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfG3GG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 02:06:59 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37165 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbfG3GG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 02:06:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so39235452wrr.4
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 23:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XyKp8kIYD6G4+he2oyCZBHMm80zfs4JdCBJ8CPjvUM8=;
        b=jBnvljaglBwtVPiYwGAyx8Kwz0C0XJmx6TTRf0GspMvqWVNPqpcWGM4Ag/743k329H
         0out3CbfWdRNChFLYx4L4xDynKyMjF1TbhN0hab9bXFHZV2VU9PJKUIOLEe7ltWMRl2N
         63uAhFf61YXZY9b1N3PsotBd2MZ4iTQGIerL1XkeSIvPQgYibc1nhW1GdDcSStd2LQxn
         55v2D1WcSIFPUJwujjybNnWw3O6Xq6rpL8QWTdMGRoORJCInD36bdX+GiRtRCQrp3ZFU
         UeBrzXnjwdnron4FRsQ+zuf7ZKvMbabf4idSw19mKjGeXT/VEGWcGsg3sRsvoZeQnWey
         TxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XyKp8kIYD6G4+he2oyCZBHMm80zfs4JdCBJ8CPjvUM8=;
        b=GW0REgaijl2kv5zPnG2Zde6PsrUDvgWL3nOIc3FaN6JLDFM3GkoFbSVseV0UUJEwGZ
         2jX17ZHg6I7/QfFK9JJkHF+ajAxYwXXxdehYLSPzjNiFlSBZjzeBg6uDar3C+O4ewsXP
         4uD21Ioc/M5bSikGpxOp8brn6rIHAeBRJckdgIV0Mc1oM2rGRHeQD8cV8ykcY/XjgfTB
         xOsdcwoOqWSf8A2WiPWjuSUI1w7ybWlzbZ3iZdZRBxJ+1WhYhP//scXTmf3P5AZihM0o
         9gk215hOLgwZPKzqcWnjM9uA7KunBUes8374NCUSZAIaI/y90MGQRHsSIE51EURRE0Gk
         ADqA==
X-Gm-Message-State: APjAAAWsuuhljiTl9BfH5S3K426DIThjPqhtHi3lU/M3gENwtKp/ipWB
        R7iXrQFn69PRLnQDfeQIDfnS5aep
X-Google-Smtp-Source: APXvYqzOrVF9hBpWW/bg4TOb+mFy4HOrH2NGRo2dYb3EjupJOCIvwGFGMxB2BwGFXl6gGAXmzYDb7w==
X-Received: by 2002:a5d:4108:: with SMTP id l8mr4668464wrp.113.1564466816381;
        Mon, 29 Jul 2019 23:06:56 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y16sm64023955wrw.33.2019.07.29.23.06.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 23:06:56 -0700 (PDT)
Date:   Tue, 30 Jul 2019 08:06:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 3/3] netdevsim: create devlink and netdev
 instances in namespace
Message-ID: <20190730060655.GB2312@nanopsycho.orion>
References: <20190727094459.26345-1-jiri@resnulli.us>
 <20190727094459.26345-4-jiri@resnulli.us>
 <20190729115906.6bc2176d@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729115906.6bc2176d@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 29, 2019 at 08:59:06PM CEST, jakub.kicinski@netronome.com wrote:
>On Sat, 27 Jul 2019 11:44:59 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> When user does create new netdevsim instance using sysfs bus file,
>> create the devlink instance and related netdev instance in the namespace
>> of the caller.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>
>> diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
>> index 1a0ff3d7747b..6aeed0c600f8 100644
>> --- a/drivers/net/netdevsim/bus.c
>> +++ b/drivers/net/netdevsim/bus.c
>> @@ -283,6 +283,7 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count)
>>  	nsim_bus_dev->dev.bus = &nsim_bus;
>>  	nsim_bus_dev->dev.type = &nsim_bus_dev_type;
>>  	nsim_bus_dev->port_count = port_count;
>> +	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
>>  
>>  	err = device_register(&nsim_bus_dev->dev);
>>  	if (err)
>
>The saved initial_net is only to carry the net info from the adding
>process to the probe callback, because probe can be asynchronous?

Exactly.


>I'm not entirely sure netdevsim can probe asynchronously in practice
>given we never return EPROBE_DEFER, but would you mind at least adding
>a comment stating that next to the definition of the field, otherwise 
>I worry someone may mistakenly use this field instead of the up-to-date
>devlink's netns.

Will do.


>
>> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
>> index 79c05af2a7c0..cdf53d0e0c49 100644
>> --- a/drivers/net/netdevsim/netdevsim.h
>> +++ b/drivers/net/netdevsim/netdevsim.h
>> @@ -19,6 +19,7 @@
>>  #include <linux/netdevice.h>
>>  #include <linux/u64_stats_sync.h>
>>  #include <net/devlink.h>
>> +#include <net/net_namespace.h>
>
>You can just do a forward declaration, no need to pull in the header.

Sure, but why?


>
>>  #include <net/xdp.h>
>>  
>>  #define DRV_NAME	"netdevsim"
>
>> @@ -213,6 +215,7 @@ struct nsim_bus_dev {
>>  	struct device dev;
>>  	struct list_head list;
>>  	unsigned int port_count;
>> +	struct net *initial_net;
>>  	unsigned int num_vfs;
>>  	struct nsim_vf_config *vfconfigs;
>>  };
>
>Otherwise makes perfect sense, with the above nits addressed feel free
>to add:
>
>Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
