Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE39120EA17
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgF3APU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgF3APT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:15:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4436C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:15:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0FA0D127BE19B;
        Mon, 29 Jun 2020 17:15:19 -0700 (PDT)
Date:   Mon, 29 Jun 2020 17:15:18 -0700 (PDT)
Message-Id: <20200629.171518.1550876065840430180.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, xiyou.wangcong@gmail.com,
        eric.dumazet@gmail.com, jiri@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next v1 0/5] TC: Introduce qevents
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1593209494.git.petrm@mellanox.com>
References: <cover.1593209494.git.petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jun 2020 17:15:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Sat, 27 Jun 2020 01:45:24 +0300

> The Spectrum hardware allows execution of one of several actions as a
> result of queue management decisions: tail-dropping, early-dropping,
> marking a packet, or passing a configured latency threshold or buffer
> size. Such packets can be mirrored, trapped, or sampled.
> 
> Modeling the action to be taken as simply a TC action is very attractive,
> but it is not obvious where to put these actions. At least with ECN marking
> one could imagine a tree of qdiscs and classifiers that effectively
> accomplishes this task, albeit in an impractically complex manner. But
> there is just no way to match on dropped-ness of a packet, let alone
> dropped-ness due to a particular reason.
> 
> To allow configuring user-defined actions as a result of inner workings of
> a qdisc, this patch set introduces a concept of qevents. Those are attach
> points for TC blocks, where filters can be put that are executed as the
> packet hits well-defined points in the qdisc algorithms. The attached
> blocks can be shared, in a manner similar to clsact ingress and egress
> blocks, arbitrary classifiers with arbitrary actions can be put on them,
> etc.
 ...

Series applied, thank you.
