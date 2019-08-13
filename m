Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF208AF44
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 08:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfHMGKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 02:10:03 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40401 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbfHMGKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 02:10:02 -0400
Received: by mail-wr1-f67.google.com with SMTP id r1so7518991wrl.7
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 23:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=syZXQNkZxi4FUicTKItmccLXeWwPTXrxUUHuYt4tPqU=;
        b=C3ny5Y/9GIKMOiqErvEzuG00HM5VeygLKIBHt6Q9Vm5KeZZ43q41kO3FfxpTbbZHDw
         GGdnstRwD7pfDq9ytRJ14QLx37L/N7I48rvaRvWsn5A9wydy/OsYn1ujuQsXzy/9cgt/
         WLP3OSA2aY17CNllQsKhAjOskq4M6YGRuXQciKLZdMGXCpklzGTqRx14q1IoEzStg5QM
         Ol5GxqHp0tfHqyPMZ6Vl5rC+SxZmsfwFSybVXCQ5D4q83hxvp0pZEnUaOnsURpJnz01t
         Wl5hT7/vP65I0TrJ/uQMXM/48aqkewymvXHup3DeaTngilP+7wcJVqFD+hNhK1ErVfDZ
         DcFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=syZXQNkZxi4FUicTKItmccLXeWwPTXrxUUHuYt4tPqU=;
        b=aDR65fL0KHtVhJLxhN2Jqe0Unl73CNadfqWn+uyJ+G0jBh2gPBPu592hHhleuBhB/R
         yMaRtZlJhr52HPbYVFqQsPqNpxal1fKk9pWeKCpoNJWuqPlhsfaXiSW51cnGeNJCdsoT
         vsCdq//4gnbqn4wA4akf5+u9KBALS2c44GtCZjyKNWp0j/tKHYMWTaG+zz8xfwjiTWqK
         yIIkz4fFWxeTTA3HMnUgpA9+1VIurIWHPbaAfLIf5S++pVXm8uP67PUnys0aAzMWDc6+
         SFZLDOlsi7IjSjRx4fSK0R/fZFMfCaERdDTJu/JecPYx8BKPmKkiERiSAnk9sPJ7qnj+
         kmgQ==
X-Gm-Message-State: APjAAAWu1KHXoVuxgVCgFHjaSl1UBgb3t9CTX4coK1bthgXIhAvY0Dh0
        wUuerYy2cMNi95UwACSm0fQ51A==
X-Google-Smtp-Source: APXvYqzLBoEBEh3f0U5qGaIhM0TuwUkK0wOEs5SieJf8beuHzGVL4nCRYt5bM+vpjMBzEKv0ACWnwQ==
X-Received: by 2002:adf:dd0f:: with SMTP id a15mr26048723wrm.265.1565676600608;
        Mon, 12 Aug 2019 23:10:00 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id d1sm190123wrs.71.2019.08.12.23.10.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 23:10:00 -0700 (PDT)
Date:   Tue, 13 Aug 2019 08:09:59 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, stephen@networkplumber.org,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v3 0/3] net: devlink: Finish network namespace
 support
Message-ID: <20190813060959.GE2428@nanopsycho>
References: <20190812134751.30838-1-jiri@resnulli.us>
 <bfb879be-a232-0ef1-1c40-3a9c8bcba8f8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfb879be-a232-0ef1-1c40-3a9c8bcba8f8@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 13, 2019 at 02:24:41AM CEST, dsahern@gmail.com wrote:
>On 8/12/19 7:47 AM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Devlink from the beginning counts with network namespaces, but the
>> instances has been fixed to init_net. The first patch allows user
>> to move existing devlink instances into namespaces:
>> 
>> $ devlink dev
>> netdevsim/netdevsim1
>> $ ip netns add ns1
>> $ devlink dev set netdevsim/netdevsim1 netns ns1
>> $ devlink -N ns1 dev
>> netdevsim/netdevsim1
>> 
>> The last patch allows user to create new netdevsim instance directly
>> inside network namespace of a caller.
>
>The namespace behavior seems odd to me. If devlink instance is created
>in a namespace and never moved, it should die with the namespace. With
>this patch set, devlink instance and its ports are moved to init_net on
>namespace delete.
>
>The fib controller needs an update to return the namespace of the
>devlink instance (on top of the patch applied to net):

I have really no clue what your fib abomination should behave. The
devlink controls device config, that's it. No relation to netns it is
in.


>
>diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>index 89795071f085..fa7e876f2d3b 100644
>--- a/drivers/net/netdevsim/dev.c
>+++ b/drivers/net/netdevsim/dev.c
>@@ -114,11 +114,6 @@ static void nsim_dev_port_debugfs_exit(struct
>nsim_dev_port *nsim_dev_port)
>        debugfs_remove_recursive(nsim_dev_port->ddir);
> }
>
>-static struct net *nsim_devlink_net(struct devlink *devlink)
>-{
>-       return &init_net;
>-}
>-
> static u64 nsim_dev_ipv4_fib_resource_occ_get(void *priv)
> {
>        struct net *net = priv;
>@@ -154,7 +149,7 @@ static int nsim_dev_resources_register(struct
>devlink *devlink)
>                .size_granularity = 1,
>                .unit = DEVLINK_RESOURCE_UNIT_ENTRY
>        };
>-       struct net *net = nsim_devlink_net(devlink);
>+       struct net *net = devlink_net(devlink);
>        int err;
>        u64 n;
>
>@@ -309,7 +304,7 @@ static int nsim_dev_reload(struct devlink *devlink,
>                NSIM_RESOURCE_IPV4_FIB, NSIM_RESOURCE_IPV4_FIB_RULES,
>                NSIM_RESOURCE_IPV6_FIB, NSIM_RESOURCE_IPV6_FIB_RULES
>        };
>-       struct net *net = nsim_devlink_net(devlink);
>+       struct net *net = devlink_net(devlink);
>        int i;
>
>        for (i = 0; i < ARRAY_SIZE(res_ids); ++i) {
>
