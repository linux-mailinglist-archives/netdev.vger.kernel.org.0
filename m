Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36441485857
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243003AbiAESbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242995AbiAESbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:31:17 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB05C0611FD
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 10:31:17 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id s15so126113pfk.6
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 10:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i/O9AdWK5YYZzrUHl+3wniYor2pQinQNogOqvNMXt0I=;
        b=jfhvqBPCNMsYM00EokT4/NiLbgpds2S4mCYwFoqWXIorSp3vicw4TDxaRWja97jxlN
         7VxPVemDUkMCE/+ekInFSzA3BCfN4l21DnZqEYsFlRhvPtDcT2ZYKdQ7ZOe2aNvhFnaV
         Mha84RXoCIHMTWadbQBohRZ1i1xSwqwxA5ERmK28y3p4MInCqdW1keYn/cCILUg4cOXK
         Ug0BThAHr8Q8/kO0zUGFnuXRU3idax9BUCCjxhp0pR9lVcRlzX+8UjcxBC9McD430L0E
         Y6gpu0+IUvg/93Vo3eJBIpqDxxSyV8Er1C7O2UwFaP33KHVQMLhb4lY7dE3yeI9BTllj
         mjbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i/O9AdWK5YYZzrUHl+3wniYor2pQinQNogOqvNMXt0I=;
        b=NCGfoG4Gf/3N+lHlMmX8Dqm82YhYI0cAF4iCJGlYZhdlDXqwC7kGSlXkKzDzSJE35J
         GCodYTpA1ZWt2ISmE36/dQLS07aKFaj+5k4x/ammk2tQezgG0PPaq2YhOKnRP1LTT9Cf
         gXEXXBS0ZjC63Rpqopg8S5rM0bfp9TjtLd1085QSMX7OOgxZ+pho/hmU5rWnsMGzGm31
         q12vePvFFOxmzVs1ms0itnkFstu04lOAm2AyJxuqYUOFAFgahIj+xeMQf65v68R7PF1v
         feGtK1CKtPf/smrfIEha3Y797DmIqagsc7DLz+8Ll1UB6Ub4NX/JXN2SThEJmH2qgyfX
         gi8A==
X-Gm-Message-State: AOAM533TqwZVeJNTs09Lb4rwtWgkpIaBBEomcs7tJMvHzP4Loj3NAloD
        1jfWZoyx0AZnO8qvzpldAtI=
X-Google-Smtp-Source: ABdhPJwU86gJev+lLYy/Iil3FsUruFxR4H6G0JAAlrH1qIY/cBM9ao5QXegHwHodkAtWi2rgV/bOQg==
X-Received: by 2002:a63:6b81:: with SMTP id g123mr50792604pgc.140.1641407476878;
        Wed, 05 Jan 2022 10:31:16 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l18sm3337082pjy.6.2022.01.05.10.31.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 10:31:16 -0800 (PST)
Subject: Re: [PATCH v2 net-next 3/7] net: dsa: move dsa_port :: type near
 dsa_port :: index
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <20220105132141.2648876-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a98f915a-3bb4-5b46-7905-af722acf0437@gmail.com>
Date:   Wed, 5 Jan 2022 10:31:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220105132141.2648876-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 5:21 AM, Vladimir Oltean wrote:
> Both dsa_port :: type and dsa_port :: index introduce a 4 octet hole
> after them, so we can group them together and the holes would be
> eliminated, turning 16 octets of storage into just 8. This makes the
> cpu_dp pointer fit in the first cache line, which is good, because
> dsa_slave_to_master(), called by dsa_enqueue_skb(), uses it.
> 
> Before:
> 
> pahole -C dsa_port net/dsa/slave.o
> struct dsa_port {
>         union {
>                 struct net_device * master;              /*     0     8 */
>                 struct net_device * slave;               /*     0     8 */
>         };                                               /*     0     8 */
>         const struct dsa_device_ops  * tag_ops;          /*     8     8 */
>         struct dsa_switch_tree *   dst;                  /*    16     8 */
>         struct sk_buff *           (*rcv)(struct sk_buff *, struct net_device *); /*    24     8 */
>         enum {
>                 DSA_PORT_TYPE_UNUSED = 0,
>                 DSA_PORT_TYPE_CPU    = 1,
>                 DSA_PORT_TYPE_DSA    = 2,
>                 DSA_PORT_TYPE_USER   = 3,
>         } type;                                          /*    32     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         struct dsa_switch *        ds;                   /*    40     8 */
>         unsigned int               index;                /*    48     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         const char  *              name;                 /*    56     8 */
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         struct dsa_port *          cpu_dp;               /*    64     8 */
>         u8                         mac[6];               /*    72     6 */
>         u8                         stp_state;            /*    78     1 */
>         u8                         vlan_filtering:1;     /*    79: 0  1 */
>         u8                         learning:1;           /*    79: 1  1 */
>         u8                         lag_tx_enabled:1;     /*    79: 2  1 */
>         u8                         devlink_port_setup:1; /*    79: 3  1 */
>         u8                         setup:1;              /*    79: 4  1 */
> 
>         /* XXX 3 bits hole, try to pack */
> 
>         struct device_node *       dn;                   /*    80     8 */
>         unsigned int               ageing_time;          /*    88     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         struct dsa_bridge *        bridge;               /*    96     8 */
>         struct devlink_port        devlink_port;         /*   104   288 */
>         /* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
>         struct phylink *           pl;                   /*   392     8 */
>         struct phylink_config      pl_config;            /*   400    40 */
>         struct net_device *        lag_dev;              /*   440     8 */
>         /* --- cacheline 7 boundary (448 bytes) --- */
>         struct net_device *        hsr_dev;              /*   448     8 */
>         struct list_head           list;                 /*   456    16 */
>         const struct ethtool_ops  * orig_ethtool_ops;    /*   472     8 */
>         const struct dsa_netdevice_ops  * netdev_ops;    /*   480     8 */
>         struct mutex               addr_lists_lock;      /*   488    32 */
>         /* --- cacheline 8 boundary (512 bytes) was 8 bytes ago --- */
>         struct list_head           fdbs;                 /*   520    16 */
>         struct list_head           mdbs;                 /*   536    16 */
> 
>         /* size: 552, cachelines: 9, members: 30 */
>         /* sum members: 539, holes: 3, sum holes: 12 */
>         /* sum bitfield members: 5 bits, bit holes: 1, sum bit holes: 3 bits */
>         /* last cacheline: 40 bytes */
> };
> 
> After:
> 
> pahole -C dsa_port net/dsa/slave.o
> struct dsa_port {
>         union {
>                 struct net_device * master;              /*     0     8 */
>                 struct net_device * slave;               /*     0     8 */
>         };                                               /*     0     8 */
>         const struct dsa_device_ops  * tag_ops;          /*     8     8 */
>         struct dsa_switch_tree *   dst;                  /*    16     8 */
>         struct sk_buff *           (*rcv)(struct sk_buff *, struct net_device *); /*    24     8 */
>         struct dsa_switch *        ds;                   /*    32     8 */
>         unsigned int               index;                /*    40     4 */
>         enum {
>                 DSA_PORT_TYPE_UNUSED = 0,
>                 DSA_PORT_TYPE_CPU    = 1,
>                 DSA_PORT_TYPE_DSA    = 2,
>                 DSA_PORT_TYPE_USER   = 3,
>         } type;                                          /*    44     4 */
>         const char  *              name;                 /*    48     8 */
>         struct dsa_port *          cpu_dp;               /*    56     8 */
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         u8                         mac[6];               /*    64     6 */
>         u8                         stp_state;            /*    70     1 */
>         u8                         vlan_filtering:1;     /*    71: 0  1 */
>         u8                         learning:1;           /*    71: 1  1 */
>         u8                         lag_tx_enabled:1;     /*    71: 2  1 */
>         u8                         devlink_port_setup:1; /*    71: 3  1 */
>         u8                         setup:1;              /*    71: 4  1 */
> 
>         /* XXX 3 bits hole, try to pack */
> 
>         struct device_node *       dn;                   /*    72     8 */
>         unsigned int               ageing_time;          /*    80     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         struct dsa_bridge *        bridge;               /*    88     8 */
>         struct devlink_port        devlink_port;         /*    96   288 */
>         /* --- cacheline 6 boundary (384 bytes) --- */
>         struct phylink *           pl;                   /*   384     8 */
>         struct phylink_config      pl_config;            /*   392    40 */
>         struct net_device *        lag_dev;              /*   432     8 */
>         struct net_device *        hsr_dev;              /*   440     8 */
>         /* --- cacheline 7 boundary (448 bytes) --- */
>         struct list_head           list;                 /*   448    16 */
>         const struct ethtool_ops  * orig_ethtool_ops;    /*   464     8 */
>         const struct dsa_netdevice_ops  * netdev_ops;    /*   472     8 */
>         struct mutex               addr_lists_lock;      /*   480    32 */
>         /* --- cacheline 8 boundary (512 bytes) --- */
>         struct list_head           fdbs;                 /*   512    16 */
>         struct list_head           mdbs;                 /*   528    16 */
> 
>         /* size: 544, cachelines: 9, members: 30 */
>         /* sum members: 539, holes: 1, sum holes: 4 */
>         /* sum bitfield members: 5 bits, bit holes: 1, sum bit holes: 3 bits */
>         /* last cacheline: 32 bytes */
> };
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
