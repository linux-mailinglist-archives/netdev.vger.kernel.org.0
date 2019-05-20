Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9809B23FE1
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 20:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbfETSEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 14:04:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727242AbfETSEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 14:04:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 73F3514EC6985;
        Mon, 20 May 2019 11:04:48 -0700 (PDT)
Date:   Mon, 20 May 2019 11:04:47 -0700 (PDT)
Message-Id: <20190520.110447.451570638406811414.davem@davemloft.net>
To:     maximmi@mellanox.com
Cc:     jakub.kicinski@netronome.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        leonro@mellanox.com
Subject: Re: [PATCH net] Validate required parameters in
 inet6_validate_link_af
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190520080755.2542-1-maximmi@mellanox.com>
References: <20190520080755.2542-1-maximmi@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 11:04:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>
Date: Mon, 20 May 2019 08:08:07 +0000

> +static int inet6_validate_link_af(const struct net_device *dev,
> +				  const struct nlattr *nla)
> +{
> +	struct inet6_dev *idev = NULL;
> +	struct nlattr *tb[IFLA_INET6_MAX + 1];
> +	int err;

Reverse christmas tree.

Otherwise patch looks good to me.

Thanks.
