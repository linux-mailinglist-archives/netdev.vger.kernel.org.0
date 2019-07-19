Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 772856EB8D
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 22:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387569AbfGSU0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 16:26:53 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37947 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbfGSU0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 16:26:53 -0400
Received: by mail-pg1-f195.google.com with SMTP id f5so6110143pgu.5
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 13:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SqxG6KbP53LSxrTTqGcTzW8dubAel1anQJC7lHgf4bY=;
        b=uiTj/NdOSrqUeV5NBmrL3Eq2hxfbySMk15j63S0PKM1c9kk/paVvC+UW7UzgzzMHx1
         /6STfsuF1cok9gz26lpqxPrGzSLPn0H1kTiWACnq6D3VEqgnyAsfnEJWmbfBShnv1POD
         t4uaBgkIQnBI0MFLZ/IDfGmW9OpEBwmpUdcBnpxlaEGNlvklAnCfo4oOHrrBO9g9Kc60
         zWQE0GqSliizmQr1cC+btnqf96OBHtU7MdF/psLpASxcrXgCi56imxHyMUQ3x5Luu8HZ
         MyJhJGb6mIegEFKx27rhiEMpgYvpPbN2Pp5wjwjimGlgMdiSZrpme9me2sucrf2+VVZc
         pfHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SqxG6KbP53LSxrTTqGcTzW8dubAel1anQJC7lHgf4bY=;
        b=bb6SoOOTaciMT1IKI2tSNCXKEJqGVSdMaHhQxA8AOVsBQ593cyOLRgt4WadZ5GBY7Z
         /kjaTpvLnPa48CMHxafTqlcHpLm+NtG8+VsA+BWRMe+GJNbS8yu4PJGgwG8RSvV0iEkG
         lcGwRIfXwfHa3WK4DgRuxDiVfd6VxKupqdCGhw/Elui6afJ60MD+moksvdxzDjRH3u80
         OCkfoLAeocsmjP9OAXD43coibY9zNPvwZ1q8UNbLFQQhSew0CN1WaRSGvvQAitUfivbZ
         PtW4WVYbs6dD02a3KkHVFjqw4UpEmwpa+IX6F3ltJYsVNNjTxUcrNd0UWlzTisvlKezI
         Ei0A==
X-Gm-Message-State: APjAAAXIs9Rg+8Eb7O4UGvzv2hxYhxYkqxZh8hKv1vZtkJgVVw3HjHkT
        OWxVyiELOjad+scNuqIpYAQ=
X-Google-Smtp-Source: APXvYqwD/Dvc/2hJQI4dkxP6t/TiOJGwhc0izbeQ2nM59zq7z69DXE5IG8cn6aSx7tr0mAvRpcVjSQ==
X-Received: by 2002:a63:784c:: with SMTP id t73mr57593151pgc.268.1563568012340;
        Fri, 19 Jul 2019 13:26:52 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p19sm38766392pfn.99.2019.07.19.13.26.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 13:26:52 -0700 (PDT)
Date:   Fri, 19 Jul 2019 13:26:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, dcbw@redhat.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 2/7] net: introduce name_node struct to be
 used in hashlist
Message-ID: <20190719132649.700e6a5c@hermes.lan>
In-Reply-To: <20190719191740.GF2230@nanopsycho>
References: <20190719110029.29466-1-jiri@resnulli.us>
        <20190719110029.29466-3-jiri@resnulli.us>
        <20190719092936.60c2d925@hermes.lan>
        <20190719191740.GF2230@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Jul 2019 21:17:40 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> Fri, Jul 19, 2019 at 06:29:36PM CEST, stephen@networkplumber.org wrote:
> >On Fri, 19 Jul 2019 13:00:24 +0200
> >Jiri Pirko <jiri@resnulli.us> wrote:
> >  
> >> From: Jiri Pirko <jiri@mellanox.com>
> >> 
> >> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> >> ---
> >>  include/linux/netdevice.h | 10 +++-
> >>  net/core/dev.c            | 96 +++++++++++++++++++++++++++++++--------
> >>  2 files changed, 86 insertions(+), 20 deletions(-)
> >> 
> >> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> >> index 88292953aa6f..74f99f127b0e 100644
> >> --- a/include/linux/netdevice.h
> >> +++ b/include/linux/netdevice.h
> >> @@ -918,6 +918,12 @@ struct dev_ifalias {
> >>  struct devlink;
> >>  struct tlsdev_ops;
> >>  
> >> +struct netdev_name_node {
> >> +	struct hlist_node hlist;
> >> +	struct net_device *dev;
> >> +	char *name  
> >
> >You probably can make this const char *  

Don't bother, it looks ok as is. the problem is you would have
to cast it when calling free.

> >Do you want to add __rcu to this list?  
> 
> Which list?
> 

       struct netdev_name_node __rcu *name_node;

You might also want to explictly init the hlist node rather
than relying on the fact that zero is an empty node ptr.

 
 static struct netdev_name_node *netdev_name_node_alloc(struct net_device *dev,
-                                                      char *name)
+                                                      const char *name)
 {
        struct netdev_name_node *name_node;
 
-       name_node = kzalloc(sizeof(*name_node), GFP_KERNEL);
+       name_node = kmalloc(sizeof(*name_node));
        if (!name_node)
                return NULL;
+
+       INIT_HLIST_NODE(&name_node->hlist);
        name_node->dev = dev;
        name_node->name = name;
        return name_node;

