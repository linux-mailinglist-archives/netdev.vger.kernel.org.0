Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3BBB1B26
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 11:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387822AbfIMJwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 05:52:10 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39811 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387439AbfIMJwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 05:52:09 -0400
Received: by mail-wm1-f67.google.com with SMTP id v17so1507821wml.4
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 02:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KwafMFzxTL1i6ZljOty03WTir7NB3hVvP7haqWIlh7g=;
        b=ujRFW7PlkN5pfVo4HMN5N0WPzdCuc6egVb3+0VBi6tGQV0UXM/k1koWhTbvzdG9nM+
         Ui5d9V+6g2RDYZjlYK8xPtakkTPTaA6HgjdvVvepQd5ytBMJ5giKPOyHwNhAsCSyKf0C
         SQe4jC/C8N/MAYQE27gtDeFbZzPE+cS6bu8PXvleJ8hEKvzXLG8kwuucyKO3W+1kDOQk
         fvnAqXUz8T6HN7KQFYJq8bo1DSq/77S+ohrbIdJvJVdZHFLcO6tEZVqeQTj41RH7C11U
         1svo+6PoUkiTjXKjuZ1Y56HZf1zaYPqIqAVzEoJfCyIaY13hjg945xyZPa4kImxsgWx7
         4SMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KwafMFzxTL1i6ZljOty03WTir7NB3hVvP7haqWIlh7g=;
        b=tL5kiWNOgeYEyyLw+lo7xiL5UCNCtXVa9FoS2qGdVnuPlxfwftezzWDn0KNHBPTODI
         MSNTCu7CgRFeEQCoWq3zcgYSC56lQ0SeEBz6YR3RoAqHd92/ZnrlNc8lhOH8Bk5GLiyd
         AWISZombNgHZQ1frHi8rq0PMalFC4S/k2jbSsn41Ze1JEuhxe/wfKpvo3W5gM4SxsYQv
         uFEtVNhGympMjfgqnbyzp46aMESRAN4gBFDnTpiJpyiVjiwTivc9mfY30brxyOSGLxIW
         gLElH3KhUbaJ42Zcf7OpZH2/vPpjEuiUnIKbjZRj077+9f4fQTU5016/Uoo869vA1mkG
         OYpw==
X-Gm-Message-State: APjAAAWb5GT/nXV19W+hf5xu47vGX6NMedPkjL804+CrVHPTsw+Tjqgt
        xix/xhHsMxuHg7IuSJ2paETaTQ==
X-Google-Smtp-Source: APXvYqxu97YA+FcuDHLRt4wKWWvD4eOi2Wvqh1jMDryuH6sNC2oqqfVlwSNCLixOjqXzuznlaMIRYA==
X-Received: by 2002:a1c:7914:: with SMTP id l20mr1522293wme.155.1568368327446;
        Fri, 13 Sep 2019 02:52:07 -0700 (PDT)
Received: from localhost (89-24-42-127.nat.epc.tmcz.cz. [89.24.42.127])
        by smtp.gmail.com with ESMTPSA id s26sm48860598wrs.63.2019.09.13.02.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 02:52:06 -0700 (PDT)
Date:   Fri, 13 Sep 2019 11:52:06 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, dcbw@redhat.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 2/7] net: introduce name_node struct to be
 used in hashlist
Message-ID: <20190913095012.GA2422@nanopsycho>
References: <20190719110029.29466-1-jiri@resnulli.us>
 <20190719110029.29466-3-jiri@resnulli.us>
 <20190719092936.60c2d925@hermes.lan>
 <20190719191740.GF2230@nanopsycho>
 <20190719132649.700e6a5c@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719132649.700e6a5c@hermes.lan>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 19, 2019 at 10:26:49PM CEST, stephen@networkplumber.org wrote:
>On Fri, 19 Jul 2019 21:17:40 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> Fri, Jul 19, 2019 at 06:29:36PM CEST, stephen@networkplumber.org wrote:
>> >On Fri, 19 Jul 2019 13:00:24 +0200
>> >Jiri Pirko <jiri@resnulli.us> wrote:
>> >  
>> >> From: Jiri Pirko <jiri@mellanox.com>
>> >> 
>> >> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> >> ---
>> >>  include/linux/netdevice.h | 10 +++-
>> >>  net/core/dev.c            | 96 +++++++++++++++++++++++++++++++--------
>> >>  2 files changed, 86 insertions(+), 20 deletions(-)
>> >> 
>> >> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> >> index 88292953aa6f..74f99f127b0e 100644
>> >> --- a/include/linux/netdevice.h
>> >> +++ b/include/linux/netdevice.h
>> >> @@ -918,6 +918,12 @@ struct dev_ifalias {
>> >>  struct devlink;
>> >>  struct tlsdev_ops;
>> >>  
>> >> +struct netdev_name_node {
>> >> +	struct hlist_node hlist;
>> >> +	struct net_device *dev;
>> >> +	char *name  
>> >
>> >You probably can make this const char *  
>
>Don't bother, it looks ok as is. the problem is you would have
>to cast it when calling free.

Actually, it does not. So I'll make it const.


>
>> >Do you want to add __rcu to this list?  
>> 
>> Which list?
>> 
>
>       struct netdev_name_node __rcu *name_node;

This is stored in struct net_device for ifname. The pointer is never
accessed from rcu read.


>
>You might also want to explictly init the hlist node rather
>than relying on the fact that zero is an empty node ptr.
>
> 
> static struct netdev_name_node *netdev_name_node_alloc(struct net_device *dev,
>-                                                      char *name)
>+                                                      const char *name)
> {
>        struct netdev_name_node *name_node;
> 
>-       name_node = kzalloc(sizeof(*name_node), GFP_KERNEL);
>+       name_node = kmalloc(sizeof(*name_node));
>        if (!name_node)
>                return NULL;
>+
>+       INIT_HLIST_NODE(&name_node->hlist);

Will do. Thanks!

>        name_node->dev = dev;
>        name_node->name = name;
>        return name_node;
>
