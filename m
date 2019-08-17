Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77202912BC
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 21:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfHQTlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 15:41:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55578 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfHQTlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 15:41:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3864914DB6E1C;
        Sat, 17 Aug 2019 12:41:12 -0700 (PDT)
Date:   Sat, 17 Aug 2019 12:41:11 -0700 (PDT)
Message-Id: <20190817.124111.708318885882893287.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next v3 00/16] Add drop monitor for offloaded data
 paths
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190817132825.29790-1-idosch@idosch.org>
References: <20190817132825.29790-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 17 Aug 2019 12:41:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sat, 17 Aug 2019 16:28:09 +0300

> Users have several ways to debug the kernel and understand why a packet
> was dropped. For example, using drop monitor and perf. Both utilities
> trace kfree_skb(), which is the function called when a packet is freed
> as part of a failure. The information provided by these tools is
> invaluable when trying to understand the cause of a packet loss.
> 
> In recent years, large portions of the kernel data path were offloaded
> to capable devices. Today, it is possible to perform L2 and L3
> forwarding in hardware, as well as tunneling (IP-in-IP and VXLAN).
> Different TC classifiers and actions are also offloaded to capable
> devices, at both ingress and egress.
> 
> However, when the data path is offloaded it is not possible to achieve
> the same level of introspection since packets are dropped by the
> underlying device and never reach the kernel.
> 
> This patchset aims to solve this by allowing users to monitor packets
> that the underlying device decided to drop along with relevant metadata
> such as the drop reason and ingress port.
 ...

Looks great, series applied, thanks.
