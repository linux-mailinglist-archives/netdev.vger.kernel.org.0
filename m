Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF15958B20
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 21:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfF0Txl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 15:53:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59482 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfF0Txl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 15:53:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 08BE113CB348B;
        Thu, 27 Jun 2019 12:53:39 -0700 (PDT)
Date:   Thu, 27 Jun 2019 12:53:39 -0700 (PDT)
Message-Id: <20190627.125339.707372206595841703.davem@davemloft.net>
To:     paulb@mellanox.com
Cc:     jiri@mellanox.com, roid@mellanox.com, yossiku@mellanox.com,
        ozsh@mellanox.com, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, aconole@redhat.com, wangzhike@jd.com,
        ronye@mellanox.com, nst-kernel@redhat.com,
        john.hurley@netronome.com, simon.horman@netronome.com,
        jpettit@ovn.org
Subject: Re: [PATCH net-next v2 1/4] net/sched: Introduce action ct
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561038141-31370-2-git-send-email-paulb@mellanox.com>
References: <1561038141-31370-1-git-send-email-paulb@mellanox.com>
        <1561038141-31370-2-git-send-email-paulb@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 12:53:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>
Date: Thu, 20 Jun 2019 16:42:18 +0300

> +struct tcf_ct_params {
 ...
> +	struct rcu_head rcu;
> +
> +};

Please get ride of that empty line after the 'rcu' member.

> +	switch (skb->protocol) {
> +	case htons(ETH_P_IP):
> +		family = NFPROTO_IPV4;
> +		break;
> +	case htons(ETH_P_IPV6):
> +		family = NFPROTO_IPV6;
> +		break;
> +	default:
> +	break;

Break statement is not indented properly.

> +static __net_init int ct_init_net(struct net *net)
> +{
> +	struct tc_ct_action_net *tn = net_generic(net, ct_net_id);
> +	unsigned int n_bits = FIELD_SIZEOF(struct tcf_ct_params, labels) * 8;

Reverse christmas tree here please.
