Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870806ED8D
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 05:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbfGTD6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 23:58:54 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:46153 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfGTD6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 23:58:54 -0400
Received: by mail-pf1-f182.google.com with SMTP id c73so14975433pfb.13
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 20:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/z4pxAIL/PRjynvmgBve4mUzVA8WI8aTM5WATQC5g7Q=;
        b=toJUbsjKMmtc1ghE2KsbJu4OX87pConX1QLW6sJaGxbrKdA2eFQextZtB05J3ua7nA
         cmI5Lc1XwwFHlNU0KmpP1wSsRd0nDKukI8SNUoKAwvFSAsqhUJ4Avqdsji4Ah9vF2/vU
         1qeFQmxF+OSpSoJmEvNnXvDHYEeZuyIkEFtKO2a7HNS1UUWet2iFC8yYh41gyi/BKOTd
         CeudOOjWb/8z/0H+gDVX5o/MbvLk501sEMahxyVTq0PZgaTXw3n0e3gNdq7pDs80+5ko
         5WxSOVaPGCzAIDjv/nFSZrkHjMoB7hKxbPGuxwmslB30PWcPYWj5UvwArljKI2eDwYTj
         0qMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/z4pxAIL/PRjynvmgBve4mUzVA8WI8aTM5WATQC5g7Q=;
        b=MBSIc/WeKgO5M8Nt1f64PEB4aDwLduyf59cLnuZ81P5E9ykpMynt0xwvsSIbOVDJhL
         cgLOnnzcKkMQvXbKA7vpMVDk9Xu7fAV76JmTo5yzLVe1FvmO4Gsg4q1xWUvz8gTQOI8Z
         /KjxHpdT4hHATggawzA4VUcndFz5FeEflTSeqwuxyZRQ/gThQ7IFg/NaTfYK7hAE/6Kb
         R8SOSseZTN027QvJmmsc1izv9y+hJXRshyzqRL2S14I7jmzcNob00ddjPErqtqIbpntW
         4etPJTzqYAybeidKWQg+M+SQEkEKQDpRoiQEalPfqWAzJBhLsy/xEWUCymVizzRXs5+k
         LOQQ==
X-Gm-Message-State: APjAAAVba7acB3Ate4rg28EpIYV2X+c7Z+/PFuDuQZP84561ZCd8OUqX
        r0UU8S3jWs+6QpM0pREQf+22AA==
X-Google-Smtp-Source: APXvYqy0h+nEloe6FwnqS3D8W2/Xf5v5cxCZfhYxk26BXXdckAdvc4mAIsUgb1CQDXNzq6Cq3AGFfQ==
X-Received: by 2002:a65:6406:: with SMTP id a6mr21728439pgv.393.1563595133285;
        Fri, 19 Jul 2019 20:58:53 -0700 (PDT)
Received: from cakuba ([156.39.10.47])
        by smtp.gmail.com with ESMTPSA id n98sm32837863pjc.26.2019.07.19.20.58.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 20:58:53 -0700 (PDT)
Date:   Fri, 19 Jul 2019 20:58:49 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add
 and delete alternative ifnames
Message-ID: <20190719205849.11d17192@cakuba>
In-Reply-To: <20190719110029.29466-4-jiri@resnulli.us>
References: <20190719110029.29466-1-jiri@resnulli.us>
        <20190719110029.29466-4-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Jul 2019 13:00:25 +0200, Jiri Pirko wrote:
> +int netdev_name_node_alt_destroy(struct net_device *dev, char *name)
> +{
> +	struct netdev_name_node *name_node;
> +	struct net *net = dev_net(dev);
> +
> +	name_node = netdev_name_node_lookup(net, name);
> +	if (!name_node)
> +		return -ENOENT;
> +	__netdev_name_node_alt_destroy(name_node);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(netdev_name_node_alt_destroy);

I was surprised to see the exports are they strictly necessary?
Just wondering..

> @@ -8258,6 +8313,7 @@ static void rollback_registered_many(struct list_head *head)
>  		dev_uc_flush(dev);
>  		dev_mc_flush(dev);
>  
> +		netdev_name_node_alt_flush(dev);
>  		netdev_name_node_free(dev->name_node);
>  
>  		if (dev->netdev_ops->ndo_uninit)
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 1ee6460f8275..7a2010b16e10 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1750,6 +1750,8 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
>  	[IFLA_CARRIER_DOWN_COUNT] = { .type = NLA_U32 },
>  	[IFLA_MIN_MTU]		= { .type = NLA_U32 },
>  	[IFLA_MAX_MTU]		= { .type = NLA_U32 },
> +	[IFLA_ALT_IFNAME_MOD]	= { .type = NLA_STRING,
> +				    .len = ALTIFNAMSIZ - 1 },

Should we set:

	.strict_start_type = IFLA_ALT_IFNAME_MOD

?

>  };
>  
>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
