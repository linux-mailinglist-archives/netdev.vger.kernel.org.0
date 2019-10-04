Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE69CC4C3
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387888AbfJDVZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:25:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59182 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387690AbfJDVZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 17:25:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2466714F0FA8D;
        Fri,  4 Oct 2019 14:25:30 -0700 (PDT)
Date:   Fri, 04 Oct 2019 14:25:29 -0700 (PDT)
Message-Id: <20191004.142529.870317230438336454.davem@davemloft.net>
To:     adobriyan@gmail.com
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, jon.maloy@ericsson.com,
        ying.xue@windriver.com, netdev@vger.kernel.org, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next] net, uapi: fix -Wpointer-arith warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191003202924.GA21016@avx2>
References: <20191003202924.GA21016@avx2>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 14:25:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Thu, 3 Oct 2019 23:29:24 +0300

> Add casts to fix these warnings:
> 
> ./usr/include/linux/netfilter_arp/arp_tables.h:200:19: error: pointer of type 'void *' used in arithmetic [-Werror=pointer-arith]
> ./usr/include/linux/netfilter_bridge/ebtables.h:197:19: error: pointer of type 'void *' used in arithmetic [-Werror=pointer-arith]
> ./usr/include/linux/netfilter_ipv4/ip_tables.h:223:19: error: pointer of type 'void *' used in arithmetic [-Werror=pointer-arith]
> ./usr/include/linux/netfilter_ipv6/ip6_tables.h:263:19: error: pointer of type 'void *' used in arithmetic [-Werror=pointer-arith]
> ./usr/include/linux/tipc_config.h:310:28: error: pointer of type 'void *' used in arithmetic [-Werror=pointer-arith]
> ./usr/include/linux/tipc_config.h:410:24: error: pointer of type 'void *' used in arithmetic [-Werror=pointer-arith]
> ./usr/include/linux/virtio_ring.h:170:16: error: pointer of type 'void *' used in arithmetic [-Werror=pointer-arith]
> 
> Those are theoretical probably but kernel doesn't control compiler flags
> in userspace.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Applied.
