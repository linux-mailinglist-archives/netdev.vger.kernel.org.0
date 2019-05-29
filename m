Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B445C2D4CE
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 06:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbfE2Eim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 00:38:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57090 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfE2Eim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 00:38:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 872A9145D4426;
        Tue, 28 May 2019 21:38:41 -0700 (PDT)
Date:   Tue, 28 May 2019 21:38:37 -0700 (PDT)
Message-Id: <20190528.213837.678862722500953103.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, sharpd@cumulusnetworks.com,
        sworley@cumulusnetworks.com, dsahern@gmail.com
Subject: Re: [PATCH net-next 0/6] net: API and initial implementation for
 nexthop objects
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190524214308.18615-1-dsahern@kernel.org>
References: <20190524214308.18615-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 21:38:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Fri, 24 May 2019 14:43:02 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> This set contains the API and initial implementation for nexthops as
> standalone objects.
> 
> Patch 1 contains the UAPI and updates to selinux struct.
> 
> Patch 2 contains the barebones code for nexthop commands, rbtree
> maintenance and notifications.
> 
> Patch 3 then adds support for IPv4 gateways along with handling of
> netdev events.
> 
> Patch 4 adds support for IPv6 gateways.
> 
> Patch 5 has the implementation of the encap attributes. 
> 
> Patch 6 adds support for nexthop groups.
> 
> At the end of this set, nexthop objects can be created and deleted and
> userspace can monitor nexthop events, but ipv4 and ipv6 routes can not
> use them yet. Once the nexthop struct is defined, follow on sets add it
> to fib{6}_info and handle it within the respective code before routes
> can be inserted using them.

Series applied, I'll push this out after compile testing.

Thanks David.
