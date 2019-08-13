Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13708ABEF
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 02:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfHMAYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 20:24:44 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38226 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfHMAYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 20:24:44 -0400
Received: by mail-pl1-f194.google.com with SMTP id m12so9904416plt.5
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 17:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RYp+uZfiIw+OgT6HIW2QqibOHsAWq/WVbcyYl02Q9/8=;
        b=HcVi5VxBQDgSxSdczrLzxTS2VC0Z9ncSKeMl/XgWCyXblBtLkcbuO8eyaxxyIyhBdM
         CKjmM/V9bxedenj0j9/1nTf0rXzkBgS1tXCh6nRleCOcSCwEExQFgUiWCm98Bx/b2pGw
         ISnhMhXk0rOZS9YOuJ5eFm9MtArRzoONR3b5V7pBca/+YkaaikIdrzbixuWDUWLniB0g
         Asmi6l1iEUMvxGjAlbRxkdFl6jMbzFNkNKc9FPpcV5mYrWN4MqQ6evHrp454V9Nz2i1c
         kPw+oHEz9smRA9jChVOSJtiBOxEJTdQXQmQMHinDzpo+MnExJ2IutAHc40xfTiTZw2VU
         r+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RYp+uZfiIw+OgT6HIW2QqibOHsAWq/WVbcyYl02Q9/8=;
        b=e5iNGVKrYVsk8mxIEi9qrsFpOtgjvpRt/IGRW6pe3OiHi5UdWbaJO2amn5rpeu9bCy
         KV2r9m/n9yAnjFSb2BVZsLAchVE0bW7mYfyVU2WsvMBYLsQ3Ia/1gU5EbxdbKZg1OQo+
         IZRQ2N73stlQgRitmP/Iw0pKGZgfeD2HD0rGiCZTBQivvOsx/Fki4IhpzVLB//mH4JFx
         BCJawdF4JseR1ekz071ApucB2vt34lGFwVfFgrlWlP+DVrn8fZy1ysZUgJLiJQJFThNF
         YhOXyJEfbnvBPZvoTLrGooZdVxC7oup3px2JWmp9Vnq97J/M69jj0CJjSe27FnV4CI1W
         VSZg==
X-Gm-Message-State: APjAAAUpXy5R9tYf4u2uOAi/P91/PWDETn7YuLjzuZxJbf8MH3qBe4fu
        qZStHHiH9GneXXSFVrPjWsH60ku6
X-Google-Smtp-Source: APXvYqwYI0vA/BV8CY0NGOnHR9MI/IKRZn0fNIs2UOUHYtiJysxjt8oHFn3K4IT8WqNyigLHhEdwZw==
X-Received: by 2002:a17:902:9b81:: with SMTP id y1mr36770683plp.194.1565655883487;
        Mon, 12 Aug 2019 17:24:43 -0700 (PDT)
Received: from [172.27.227.188] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id 67sm767174pjo.29.2019.08.12.17.24.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 17:24:42 -0700 (PDT)
Subject: Re: [patch net-next v3 0/3] net: devlink: Finish network namespace
 support
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        stephen@networkplumber.org, mlxsw@mellanox.com
References: <20190812134751.30838-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bfb879be-a232-0ef1-1c40-3a9c8bcba8f8@gmail.com>
Date:   Mon, 12 Aug 2019 18:24:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190812134751.30838-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/19 7:47 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Devlink from the beginning counts with network namespaces, but the
> instances has been fixed to init_net. The first patch allows user
> to move existing devlink instances into namespaces:
> 
> $ devlink dev
> netdevsim/netdevsim1
> $ ip netns add ns1
> $ devlink dev set netdevsim/netdevsim1 netns ns1
> $ devlink -N ns1 dev
> netdevsim/netdevsim1
> 
> The last patch allows user to create new netdevsim instance directly
> inside network namespace of a caller.

The namespace behavior seems odd to me. If devlink instance is created
in a namespace and never moved, it should die with the namespace. With
this patch set, devlink instance and its ports are moved to init_net on
namespace delete.

The fib controller needs an update to return the namespace of the
devlink instance (on top of the patch applied to net):

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 89795071f085..fa7e876f2d3b 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -114,11 +114,6 @@ static void nsim_dev_port_debugfs_exit(struct
nsim_dev_port *nsim_dev_port)
        debugfs_remove_recursive(nsim_dev_port->ddir);
 }

-static struct net *nsim_devlink_net(struct devlink *devlink)
-{
-       return &init_net;
-}
-
 static u64 nsim_dev_ipv4_fib_resource_occ_get(void *priv)
 {
        struct net *net = priv;
@@ -154,7 +149,7 @@ static int nsim_dev_resources_register(struct
devlink *devlink)
                .size_granularity = 1,
                .unit = DEVLINK_RESOURCE_UNIT_ENTRY
        };
-       struct net *net = nsim_devlink_net(devlink);
+       struct net *net = devlink_net(devlink);
        int err;
        u64 n;

@@ -309,7 +304,7 @@ static int nsim_dev_reload(struct devlink *devlink,
                NSIM_RESOURCE_IPV4_FIB, NSIM_RESOURCE_IPV4_FIB_RULES,
                NSIM_RESOURCE_IPV6_FIB, NSIM_RESOURCE_IPV6_FIB_RULES
        };
-       struct net *net = nsim_devlink_net(devlink);
+       struct net *net = devlink_net(devlink);
        int i;

        for (i = 0; i < ARRAY_SIZE(res_ids); ++i) {

