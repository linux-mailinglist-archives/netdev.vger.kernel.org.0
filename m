Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFA201982F9
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgC3SHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:07:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40452 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgC3SHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:07:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D0A415C45304;
        Mon, 30 Mar 2020 11:07:06 -0700 (PDT)
Date:   Mon, 30 Mar 2020 11:07:05 -0700 (PDT)
Message-Id: <20200330.110705.1840847675396461402.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, idosch@mellanox.com,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, pablo@netfilter.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, paulb@mellanox.com,
        alexandre.belloni@bootlin.com, ozsh@mellanox.com,
        roid@mellanox.com, john.hurley@netronome.com,
        simon.horman@netronome.com, pieter.jansenvanvuuren@netronome.com
Subject: Re: [patch net-next 0/2] net: sched: expose HW stats types per
 action used by drivers 
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200328153743.6363-1-jiri@resnulli.us>
References: <20200328153743.6363-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 11:07:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Sat, 28 Mar 2020 16:37:41 +0100

> From: Jiri Pirko <jiri@mellanox.com>
> 
> The first patch is just adding a helper used by the second patch too.
> The second patch is exposing HW stats types that are used by drivers.
> 
> Example:
> 
> $ tc filter add dev enp3s0np1 ingress proto ip handle 1 pref 1 flower dst_ip 192.168.1.1 action drop
> $ tc -s filter show dev enp3s0np1 ingress
> filter protocol ip pref 1 flower chain 0
> filter protocol ip pref 1 flower chain 0 handle 0x1
>   eth_type ipv4
>   dst_ip 192.168.1.1
>   in_hw in_hw_count 2
>         action order 1: gact action drop
>          random type none pass val 0
>          index 1 ref 1 bind 1 installed 10 sec used 10 sec
>         Action statistics:
>         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>         backlog 0b 0p requeues 0
>         used_hw_stats immediate     <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Series applied, thanks Jiri.
