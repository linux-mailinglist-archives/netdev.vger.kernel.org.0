Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0896EE23
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 09:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfGTHPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 03:15:40 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54603 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbfGTHPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 03:15:39 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so30593677wme.4
        for <netdev@vger.kernel.org>; Sat, 20 Jul 2019 00:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2WwnPhlaBYbG8d+luGKSlml0C6NO/ZkS85/5uc6KoVw=;
        b=XF2jik+fiflRRCg6gdNH/yZAMNsybCHv+Gv8A0lXrfsn+OaROS2Rt/1mJmR9hHlwle
         iqF/R3NLPAeyhElKNGA91hBkUAubGoBTWVVCu6RAMyaqKcmjJibDpW18AUTyf4bWbh0q
         FDfdXD5AL0l9tIu0aOa9RTurH3gCYVJr3GGJ2o7QKboa7B29vJbH9vvY31JSyG985d4w
         Xp9pKFXWkoQuPxBwkMaYVKQEUqH6x/NIDPXFI+mTztoOGIH42v8Uf0hF/zKlSetJIQJ5
         ohqa9TIHRaSaDoZKhVcpvyliW/qea3y7k1iCr4XWPyZIzuz0phhePwUzq9gIAiaOSOxn
         0/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2WwnPhlaBYbG8d+luGKSlml0C6NO/ZkS85/5uc6KoVw=;
        b=OMQBe9HrcHErVWDkTBnD140ASkmyti+sQMJ9sYU59S1z/xWBRnf2qddy+oOV/cVnnn
         9A2c4zL7iYx0+9hHI+RaAqQf1YTyXX0hsCQ9GQUwmnYEKMy6p1nJAEMMDyNiJVUP5nQN
         vVTuH93kPC8+GjlnGtCKF85ZpbIXNqhsoA84Gcg3UnE9bNs4yx1KJk8IEXWleS3iBuGp
         6gMEP3oO5bmGUug6UPP+6QNEPSDThpW9tu44C4zWvshQcdwf1gVbLNuGTcMpBAY/gLYy
         Y0/p7R66TDkgE4/bTUluLrGgv2ZgVOJqVLSjMrzISKImiYHSSAWuZuymwlrxy0UZ8q5X
         X59g==
X-Gm-Message-State: APjAAAU7xdFBNVybhUnrwIzZS1+56xzk1A98kVYN6yREkS83EubU4Naj
        3enBlk1s1dvJneDERbQegK4=
X-Google-Smtp-Source: APXvYqzD+ya9/enYcgTD+uOqKZ7RmFdetBUwIcW/ovPsRMzO556d3SJ4CzB7SzB+dwjuZbMLyV/E1w==
X-Received: by 2002:a7b:c144:: with SMTP id z4mr54149146wmi.50.1563606929769;
        Sat, 20 Jul 2019 00:15:29 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id h14sm32178092wrs.66.2019.07.20.00.15.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 20 Jul 2019 00:15:29 -0700 (PDT)
Date:   Sat, 20 Jul 2019 09:15:28 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, dcbw@redhat.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 2/7] net: introduce name_node struct to be
 used in hashlist
Message-ID: <20190720071528.GG2230@nanopsycho>
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
>
>> >Do you want to add __rcu to this list?  
>> 
>> Which list?
>> 
>
>       struct netdev_name_node __rcu *name_node;
>
>You might also want to explictly init the hlist node rather
>than relying on the fact that zero is an empty node ptr.

Okay. Will process this in. Thanks!


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
>        name_node->dev = dev;
>        name_node->name = name;
>        return name_node;
>
