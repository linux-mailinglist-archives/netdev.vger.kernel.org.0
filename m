Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372B5FA771
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 04:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfKMDmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 22:42:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbfKMDmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 22:42:45 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 45D3C154FFAFB;
        Tue, 12 Nov 2019 19:42:44 -0800 (PST)
Date:   Tue, 12 Nov 2019 19:42:43 -0800 (PST)
Message-Id: <20191112.194243.2254807910110802454.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        paulb@mellanox.com, ozsh@mellanox.com, majd@mellanox.com,
        saeedm@mellanox.com
Subject: Re: [PATCH net-next 0/6] netfilter flowtable hardware offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191111232956.24898-1-pablo@netfilter.org>
References: <20191111232956.24898-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 19:42:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 12 Nov 2019 00:29:50 +0100

> The following patchset adds hardware offload support for the flowtable
> infrastructure [1]. This infrastructure provides a fast datapath for
> the classic Linux forwarding path that users can enable through policy,
> eg.
 ...

Series applied, thanks.
