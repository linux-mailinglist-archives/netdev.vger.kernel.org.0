Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E8A4D65FA
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349322AbiCKQXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbiCKQXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:23:04 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F053B1D17A3
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 08:22:00 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id jq9so7377990qvb.0
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 08:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=d1dW+c04tmiBVE54INtZyAe/7stzwoFDQlNWxy+B994=;
        b=E6sJOsrIHocNx776aDKMRiWNgJqcJU5HoD5EbjNdZEBlE1zfwXgi1tFMUY9u3XuG/i
         qPk8wSzK0omcGpTzmr8/yJw+RCgKk5iYj8tpt8XWfpCT/6IpECn5cPyShWfwkzqKKq8e
         1K+gbZMsp6HGboyxHn2nOVMjAM0jasD42BbRT0R5ENDr4KVuWVGDIfVd7Xj0R/v2rYAS
         nDKcA/M9HfDlZWl8yU4eV5H2SpMPdHzhcDOhIiIWUCkYOErm2rUdUcOabG8Du4g7tDft
         Lkiggc/j7xsYbGBDK8lHRoWjLX7jvonbt/OZQszdqSlELajkftCoAxyJXz5DXCurTzXr
         Q1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=d1dW+c04tmiBVE54INtZyAe/7stzwoFDQlNWxy+B994=;
        b=XjTAnAqzn0xFXgkwPuokZY321K7GUE9dhAC/60ANi05JL2Zfg0uNxtSezp4gCAwIE9
         PEjiGAlBUztNxqsuOGqaOf4lNSvdMGpwlTsKdEbVl28zzGQVUHCPK142hcFNUe2XelEp
         Zr2Di4jmjpAdaheF9/31aYoDEewXBTjkMC4lRBH3LCXWiKln8ClYC+8s9RqKFSYljNoX
         zflr49q29XXc2A1RYEXgBjJeszn/vj1xjT9zY7dORS5JrXitrmLxaWMMleT9DlnxEjwa
         2q4VC9GnXcWf1AYOzGPchmKinmnzVWAPhkFW/GcW6lR3paa6PZETiFTbDilXNFHxTUd1
         pmSQ==
X-Gm-Message-State: AOAM5339IlhEexzD3u4fpQ0vjslvgBevHWe+JQUre8zdf5LFwbUvYYRf
        jrBHxpVDzrXxNQFwXJDIho0=
X-Google-Smtp-Source: ABdhPJwE+SdIegjyGS5z1cXr9hpne0qBs/jPSCWTKZMmS26Y8U6XsdNgi7aqZt7zwhpB5JY/BDBDqA==
X-Received: by 2002:ad4:5ca4:0:b0:435:c219:772d with SMTP id q4-20020ad45ca4000000b00435c219772dmr8500610qvh.60.1647015719896;
        Fri, 11 Mar 2022 08:21:59 -0800 (PST)
Received: from ?IPv6:2001:470:b:9c3:82ee:73ff:fe41:9a02? ([2001:470:b:9c3:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id v12-20020a05622a130c00b002e1b3ccd9adsm3300308qtk.79.2022.03.11.08.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 08:21:58 -0800 (PST)
Message-ID: <52affdb45efe4d08b0ae13ba69097e712182af3e.camel@gmail.com>
Subject: Re: [PATCH v4 net-next 02/14] ipv6: add dev->gso_ipv6_max_size
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>
Date:   Fri, 11 Mar 2022 08:21:57 -0800
In-Reply-To: <20220310054703.849899-3-eric.dumazet@gmail.com>
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
         <20220310054703.849899-3-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-03-09 at 21:46 -0800, Eric Dumazet wrote:
> From: Coco Li <lixiaoyan@google.com>
> 
> This enable TCP stack to build TSO packets bigger than
> 64KB if the driver is LSOv2 compatible.
> 
> This patch introduces new variable gso_ipv6_max_size
> that is modifiable through ip link.
> 
> ip link set dev eth0 gso_ipv6_max_size 185000
> 
> User input is capped by driver limit (tso_ipv6_max_size)
> added in previous patch.
> 
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/linux/netdevice.h          | 12 ++++++++++++
>  include/uapi/linux/if_link.h       |  1 +
>  net/core/dev.c                     |  1 +
>  net/core/rtnetlink.c               | 15 +++++++++++++++
>  net/core/sock.c                    |  6 ++++++
>  tools/include/uapi/linux/if_link.h |  1 +
>  6 files changed, 36 insertions(+)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 61db67222c47664c179b6a5d3b6f15fdf8a02bdd..9ed348d8b6f1195514c3b5f85fbe2c45b3fa997f 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1952,6 +1952,7 @@ enum netdev_ml_priv_type {
>   *					registered
>   *	@offload_xstats_l3:	L3 HW stats for this netdevice.
>   *	@tso_ipv6_max_size:	Maximum size of IPv6 TSO packets (driver/NIC limit)
> + *	@gso_ipv6_max_size:	Maximum size of IPv6 GSO packets (user/admin limit)
>   *
>   *	FIXME: cleanup struct net_device such that network protocol info
>   *	moves out.
> @@ -2291,6 +2292,7 @@ struct net_device {
>  	netdevice_tracker	dev_registered_tracker;
>  	struct rtnl_hw_stats64	*offload_xstats_l3;
>  	unsigned int		tso_ipv6_max_size;
> +	unsigned int		gso_ipv6_max_size;
>  };
>  #define to_net_dev(d) container_of(d, struct net_device, dev)
> 

Rather than have this as a device specific value would it be
advantageous to consider making this a namespace specific sysctl value
instead? Something along the lines of:
  net.ipv6.conf.*.max_jumbogram_size

It could also be applied generically to the GSO/GRO as the upper limit
for any frame assembled by the socket or GRO.

The general idea is that might be desirable for admins to be able to
basically just set the maximum size they want to see for IPv6 frames
and if we could combine the GRO/GSO logic into a single sysctl that
could be set on a namespace basis instead of a device basis which would
be more difficult to track down. We already have the per-device limits
in the tso_ipv6_max_size for the outgoing frames so it seems like it
might make sense to make this per network namespace and defaultable
rather than per device and requiring an update for each device
instance.

