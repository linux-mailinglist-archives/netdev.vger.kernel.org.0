Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2205B154E28
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 22:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgBFVkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 16:40:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36298 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727557AbgBFVkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 16:40:41 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87FDD15546467;
        Thu,  6 Feb 2020 13:40:38 -0800 (PST)
Date:   Thu, 06 Feb 2020 21:44:57 +0100 (CET)
Message-Id: <20200206.214457.162922909993331176.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, pshelar@ovn.org,
        bindiyakurle@gmail.com, simon.horman@netronome.com, blp@ovn.org,
        nikolay@cumulusnetworks.com, nicolas.dichtel@6wind.com,
        jgh@redhat.com
Subject: Re: [PATCH net-next v4] openvswitch: add TTL decrement action
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200206202949.6060-1-mcroce@redhat.com>
References: <20200206202949.6060-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Feb 2020 13:40:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Thu,  6 Feb 2020 21:29:49 +0100

> New action to decrement TTL instead of setting it to a fixed value.
> This action will decrement the TTL and, in case of expired TTL, drop it
> or execute an action passed via a nested attribute.
> The default TTL expired action is to drop the packet.
> 
> Supports both IPv4 and IPv6 via the ttl and hop_limit fields, respectively.
> 
> Tested with a corresponding change in the userspace:
> 
>     # ovs-dpctl dump-flows
>     in_port(2),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},1
>     in_port(1),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},2
>     in_port(1),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:2
>     in_port(2),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:1
> 
>     # ping -c1 192.168.0.2 -t 42
>     IP (tos 0x0, ttl 41, id 61647, offset 0, flags [DF], proto ICMP (1), length 84)
>         192.168.0.1 > 192.168.0.2: ICMP echo request, id 386, seq 1, length 64
>     # ping -c1 192.168.0.2 -t 120
>     IP (tos 0x0, ttl 119, id 62070, offset 0, flags [DF], proto ICMP (1), length 84)
>         192.168.0.1 > 192.168.0.2: ICMP echo request, id 388, seq 1, length 64
>     # ping -c1 192.168.0.2 -t 1
>     #
> 
> Co-developed-by: Bindiya Kurle <bindiyakurle@gmail.com>
> Signed-off-by: Bindiya Kurle <bindiyakurle@gmail.com>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

net-next is closed, please resubmit this when it opens back up.

Thank you.
