Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9D7127390
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfEWAtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:49:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36886 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbfEWAtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:49:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7EF814577860;
        Wed, 22 May 2019 17:49:00 -0700 (PDT)
Date:   Wed, 22 May 2019 17:49:00 -0700 (PDT)
Message-Id: <20190522.174900.1131085766956464107.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, idosch@mellanox.com, dsahern@gmail.com
Subject: Re: [PATCH v2 net-next 0/8] net: Export functions for nexthop code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522190446.15486-1-dsahern@kernel.org>
References: <20190522190446.15486-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:49:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed, 22 May 2019 12:04:38 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> This set exports ipv4 and ipv6 fib functions for use by the nexthop
> code. It also adds new ones to send route notifications if a nexthop
> configuration changes.
> 
> v2
> - repost of patches dropped at the end of the last dev window
>   added patch 8 which exports nh_update_mtu since it is inline with
>   the other patches

Series applied, thanks David.
