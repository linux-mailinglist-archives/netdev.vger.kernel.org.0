Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E66A26ED8E
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 05:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfGTD7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 23:59:19 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39414 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfGTD7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 23:59:19 -0400
Received: by mail-pl1-f196.google.com with SMTP id b7so16549974pls.6
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 20:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ZCPhQWRTCauaUHXksN+o22GnCz7Vk1EldgsNPP7Tjd0=;
        b=ZGWTIpIDD4l40BeFzzId3LP9kqRGW5NDhmAkhBNJtXSqNomTWoWWXYqwpqT2XiPrYY
         oJtppmACKO5uw08Cq6w3gOGPG2GCMNJMbwRCb7E5CzJBf6kkwM2Bi4KOAyPkLDfKlAaT
         ZoNi/GRfZfPlqK32K6TTDOOO/NmA92bRHqBJehYas+YzfCBJ/sdz+fmV6hMD2CWXPYfa
         Y0sk1cQfNgo75RH79WpaPCqoH/5zj6vX5v53Bng0jl8kpaermeOxmg6w7eiZm9kp99z0
         MtAsxUa1WBy2fuEixKU7IjdjG6fgOd1Yn9LoxH04ttjvW1SmyivnUbCctKjWJb0XUuHn
         oKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ZCPhQWRTCauaUHXksN+o22GnCz7Vk1EldgsNPP7Tjd0=;
        b=ZN2hGLpjyWErqk9+f9bIBEUOxDhVsOVkvLpIxlnJfKWPrLUZnbKNKJNRVlX66o06nK
         RMaRuMIlyk0A26hqBCnXgZMveHkRrDgIfQrELIJnH3kGInmyA5bRa2xIyA/nu+aNoogj
         6b94O9xPMsKsrHuNBmSydowGSUAono6HGK4QNCbhacrvAb0PLk6pf4swZxes0AFZGp6q
         27tsiHl5TzdpxmcKLkhj0HxgFXdkP6CTqdLWGISZtWF6upjHdYVdgQK0CtbTkq//Nujm
         IQy9KYT1PYBpo3kdJISZS/5S5pZ+h/76DQZdGOJOLnnyjOJqHyy9/GA9MPTg79adzqKA
         WzpA==
X-Gm-Message-State: APjAAAXjVDNuk/oXeW0BLhZqFTF5mP0/kxJUYa2gtCAAixYm9imera9i
        wZ4qyY0kwro2XVQ00DxVI2FYzA==
X-Google-Smtp-Source: APXvYqwoJ7PJ/nwKtIPMdd+PUVsGPuBRULsDhFPGGzhk19N2NkV9YaktBFikXfaKqBx8dZgpBzjt9w==
X-Received: by 2002:a17:902:be03:: with SMTP id r3mr61546066pls.156.1563595158807;
        Fri, 19 Jul 2019 20:59:18 -0700 (PDT)
Received: from cakuba ([156.39.10.47])
        by smtp.gmail.com with ESMTPSA id c8sm7350234pfd.46.2019.07.19.20.59.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 20:59:18 -0700 (PDT)
Date:   Fri, 19 Jul 2019 20:59:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 4/7] net: rtnetlink: put alternative names
 to getlink message
Message-ID: <20190719205914.3fc786f6@cakuba>
In-Reply-To: <20190719110029.29466-5-jiri@resnulli.us>
References: <20190719110029.29466-1-jiri@resnulli.us>
        <20190719110029.29466-5-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Jul 2019 13:00:26 +0200, Jiri Pirko wrote:
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 7a2010b16e10..f11a2367037d 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -980,6 +980,18 @@ static size_t rtnl_xdp_size(void)
>  	return xdp_size;
>  }
>  
> +static size_t rtnl_alt_ifname_list_size(const struct net_device *dev)
> +{
> +	struct netdev_name_node *name_node;
> +	size_t size = nla_total_size(0);
> +
> +	if (list_empty(&dev->name_node->list))
> +		return 0;

Nit: it would make the intent a tiny bit clearer if 

	size = nla_total_size(0);

was after this early return.

> +	list_for_each_entry(name_node, &dev->name_node->list, list)
> +		size += nla_total_size(ALTIFNAMSIZ);

Since we have the structure I wonder if it would be worthwhile to store
the exact size in it?

> +	return size;
> +}
> +
