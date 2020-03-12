Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFD3182939
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387869AbgCLGkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:40:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56294 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387932AbgCLGkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:40:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C32AE14DA8B9E;
        Wed, 11 Mar 2020 23:40:00 -0700 (PDT)
Date:   Wed, 11 Mar 2020 23:40:00 -0700 (PDT)
Message-Id: <20200311.234000.1671360774348542429.davem@davemloft.net>
To:     paulb@mellanox.com
Cc:     saeedm@mellanox.com, ozsh@mellanox.com,
        jakub.kicinski@netronome.com, vladbu@mellanox.com,
        netdev@vger.kernel.org, jiri@mellanox.com, roid@mellanox.com
Subject: Re: [PATCH net-next ct-offload v3 05/15] net/sched: act_ct:
 Support restoring conntrack info on skbs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583937238-21511-6-git-send-email-paulb@mellanox.com>
References: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
        <1583937238-21511-6-git-send-email-paulb@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 23:40:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>
Date: Wed, 11 Mar 2020 16:33:48 +0200

> +void tcf_ct_flow_table_restore_skb(struct sk_buff *skb, unsigned long cookie)
> +{
> +	enum ip_conntrack_info ctinfo = cookie & NFCT_INFOMASK;
> +	struct nf_conn *ct = (struct nf_conn *)(cookie & NFCT_PTRMASK);

Reverse christmas tree here please, thank you.
