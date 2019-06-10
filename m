Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7F23BB9B
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 20:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388542AbfFJSG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 14:06:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59558 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388052AbfFJSG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 14:06:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C984150738FC;
        Mon, 10 Jun 2019 11:06:57 -0700 (PDT)
Date:   Mon, 10 Jun 2019 11:06:55 -0700 (PDT)
Message-Id: <20190610.110655.452387337378630657.davem@davemloft.net>
To:     weiwan@google.com
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, idosch@mellanox.com,
        kafai@fb.com, sbrivio@redhat.com, dsahern@gmail.com
Subject: Re: [PATCH v4 net-next 00/20] net: Enable nexthop objects with
 IPv4 and IPv6 routes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAEA6p_DgAX1sk0CM7gJ2n9hN=iUyoNqOAzMOt=_EGjF80A6sog@mail.gmail.com>
References: <20190608215341.26592-1-dsahern@kernel.org>
        <CAEA6p_DgAX1sk0CM7gJ2n9hN=iUyoNqOAzMOt=_EGjF80A6sog@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Jun 2019 11:06:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>
Date: Sun, 9 Jun 2019 22:11:33 -0700

> On Sat, Jun 8, 2019 at 2:53 PM David Ahern <dsahern@kernel.org> wrote:
>>
>> From: David Ahern <dsahern@gmail.com>
>>
>> This is the final set of the initial nexthop object work. When I
>> started this idea almost 2 years ago, it took 18 seconds to inject
>> 700k+ IPv4 routes with 1 hop and about 28 seconds for 4-paths. Some
>> of that time was due to inefficiencies in 'ip', but most of it was
>> kernel side with excessive synchronize_rcu calls in ipv4, and redundant
>> processing validating a nexthop spec (device, gateway, encap). Worse,
>> the time increased dramatically as the number of legs in the routes
>> increased; for example, taking over 72 seconds for 16-path routes.
 ...
> For all ipv6 patches:
> Reviewed-By: Wei Wang <weiwan@google.com>

Series applied, thanks.
