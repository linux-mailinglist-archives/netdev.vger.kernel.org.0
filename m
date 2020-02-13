Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAB415CB34
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 20:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgBMTem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 14:34:42 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35751 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728034AbgBMTel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 14:34:41 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so2744060plt.2
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 11:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1+V4C+cB7hBRnQEbO1uO61GqEsde2iDEAuVo8aCexFE=;
        b=czJUVrJ9KZ4KBXkyHtBaK1Vs9U3HFmipVcARZWF2TrniEVVZR5hQsWjShnL7Rl3dnP
         lAu/Zxg/BLFeHpOop4nS2ORbuVD3vGnYUis95MjFlX4SwzrWzVtLe4I0nWjQ2Q2vXF3U
         /jwOLDQIh0HbjFLQBJvhHx8crWZlLQOg3W5yRNxpl2pz9NoQj7CLrT0Tc2JXvN2oWOUn
         XX60B8aFkm0N6/E/g/TWdD/OlMMXLmPU7QCtCNKdTLTeRED0SU5+3KLORgEf+FMVFpP4
         VkdWXuBm6g+tF80At54Xvc5bceJDTxeR+kUR7yuODlfeRECXyxwe0JeYM7l1a1hupd86
         kLbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1+V4C+cB7hBRnQEbO1uO61GqEsde2iDEAuVo8aCexFE=;
        b=o8O24ZAD9zxsh+dAZbxLv2cjf8YaseqbSeeE7xasDfWmo2c/CNRSsqAFyHyGzYvNDO
         qedwKn3KaJUpQl4LtrarRWcVHgKe9Qcqgv6Xm8YJkTI0vsL35YVTK8B+of/Xyy160YWs
         2pe6knZ99DNOc/hra/7MC7nYcJ6qyCgCH4SKfx9rIQ6qeKFObB1+CwlxM4xfj5ark7Vc
         GStDBvY8jgyYm+GQ6EGxYHYO2pia/JpSyVrnJn2X2QL/C1+OfWst3P3Pq98TCgiu4f6N
         NzE+UpoIe1n+CA4UWrDVZRSn2Qha6BCbmOmtMquM/ufDmcZD6N+GCJgo7/BLPFH1+0cs
         poBg==
X-Gm-Message-State: APjAAAW+BMYwOIja3bpuicdTtFSJga6ANjnypGG0N3XvJf4CbbUK+8Ct
        W5RMwYR8EWAXlPuGo6hO9bB4Gf8w
X-Google-Smtp-Source: APXvYqy+SXnRk4ytDSD67ylzzSjONGyq2t6eOmapd3g8Ed8Z+TdZRYvXENpj3odeQQLBYEn733zakg==
X-Received: by 2002:a17:902:ff07:: with SMTP id f7mr28937696plj.52.1581622479456;
        Thu, 13 Feb 2020 11:34:39 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id c68sm4206027pfc.156.2020.02.13.11.34.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 11:34:38 -0800 (PST)
Subject: Re: [PATCH net 2/2] bonding: do not collect slave's stats
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
References: <20200213192129.16104-1-ap420073@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a86bb353-f20c-115e-27f1-568773360496@gmail.com>
Date:   Thu, 13 Feb 2020 11:34:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213192129.16104-1-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/20 11:21 AM, Taehee Yoo wrote:
> When stat query is requested(dev_get_stats()), bonding interfaces
> collect stats of slave interfaces.
> Then, it prints delta value, which is "new_stats - old_stats" and
> updates bond->bond_stats.
> But, this mechanism has some problems.
> 
> 1. It needs a lock for protecting "bond->bond_stats".
> Bonding interfaces would be nested. So this lock would also be nested.
> So, spin_lock_nested() or dynamic lockdep class key was used.
> In the case of spin_lock_nested(), it needs correct nested level value
> and this value will be changed when master/nomaster operations
> (ip link set bond0 master bond1) are being executed.
> This value is protected by RTNL mutex lock, but "dev_get_stats()" would
> be called outside of RTNL mutex.
> So, imbalance lock/unlock would be happened.
> Another case, which is to use dynamic lockdep class key has same problem.
> dynamic lockdep class key is protected by RTNL mutex lock
> and if master/nomaster operations are executed, updating lockdep class
> key is needed.
> But, dev_get_stats() would be called outside of RTNL mutex, so imbalance
> lock/unlock would be happened too.
> 
> 2. Couldn't show correct stats value when slave interfaces are used
> directly.
> 
> Test commands:
>     ip netns add nst
>     ip link add veth0 type veth peer name veth1
>     ip link set veth1 netns nst
>     ip link add bond0 type bond
>     ip link set veth0 master bond0
>     ip netns exec nst ip link set veth1 up
>     ip netns exec nst ip a a 192.168.100.2/24 dev veth1
>     ip a a 192.168.100.1/24 dev bond0
>     ip link set veth0 up
>     ip link set bond0 up
>     ping 192.168.100.2 -I veth0 -c 10
>     ip -s link show bond0
>     ip -s link show veth0
> 
> Before:
> 26: bond0:
> RX: bytes  packets  errors  dropped overrun mcast
> 656        8        0       0       0       0
> TX: bytes  packets  errors  dropped carrier collsns
> 1340       22       0       0       0       0
> ~~~~~~~~~~~~
> 
> 25: veth0@if24:
> RX: bytes  packets  errors  dropped overrun mcast
> 656        8        0       0       0       0
> TX: bytes  packets  errors  dropped carrier collsns
> 1340       22       0       0       0       0
> ~~~~~~~~~~~~
> 
> After:
> 19: bond0:
> RX: bytes  packets  errors  dropped overrun mcast
> 544        8        0       0       0       8
> TX: bytes  packets  errors  dropped carrier collsns
> 746        9        0       0       0       0
> ~~~~~~~~~~~
> 
> 18: veth0@if17:
> link/ether 76:14:ee:f1:7d:8e brd ff:ff:ff:ff:ff:ff link-netns nst
> RX: bytes  packets  errors  dropped overrun mcast
> 656        8        0       0       0       0
> TX: bytes  packets  errors  dropped carrier collsns
> 1250       21       0       0       0       0
> ~~~~~~~~~~~~
> 
> Only veth0 interface is used by ping process directly. bond0 interface
> isn't used. So, bond0 stats should not be increased.
> But, bond0 collects stats value of slave interface.
> So bond0 stats will be increased.
> 
> In order to fix the above problems, this patch makes bonding interfaces
> record own stats data like other interfaces.
> This patch is made based on team interface stats logic.
> 
> There is another problem.
> When master/nomaster operations are being executed, updating a dynamic
> lockdep class key is needed.
> But, bonding doesn't update dynamic lockdep key.
> So, lockdep warning message occurs.
> But, this problem will be disappeared by this patch.
> Because this patch removes stats_lock and a dynamic lockdep class key
> for stats_lock, which is stats_lock_key.
> 
> Test commands:
>     ip link add bond0 type bond
>     ip link add bond1 type bond
>     ip link set bond0 master bond1
>     ip link set bond0 nomaster
>     ip link set bond1 master bond0
> 
> Splat looks like:

This is way too invasive patch IMO for net tree.

We do not want adding costs in bonding fast path, for stats accounting.

We do not care of glitches causes by slaves being added/deleted, this usually happens
when we do not need stats (boot time, and before reboot)

BTW, skb->len in RX path is different than the stats provided by hw usually
(because of things like GRO)

Maybe revert the prior patches instead, they have caused a lot of churn.

Or just fix the lockdep issue, and leave stats being what they are.

> Fixes: 089bca2caed0 ("bonding: use dynamic lockdep key instead of subclass")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---



