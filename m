Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E5126E947
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgIQXM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgIQXM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:12:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930DBC06174A;
        Thu, 17 Sep 2020 16:12:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EEC6113659C88;
        Thu, 17 Sep 2020 15:55:38 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:12:04 -0700 (PDT)
Message-Id: <20200917.161204.1375552873412345194.davem@davemloft.net>
To:     fruggeri@arista.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, ap420073@gmail.com, andriin@fb.com,
        edumazet@google.com, jiri@mellanox.com, ast@kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH v2] net: use exponential backoff in netdev_wait_allrefs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200917221922.A5D3D95C0A57@us180.sjc.aristanetworks.com>
References: <20200917221922.A5D3D95C0A57@us180.sjc.aristanetworks.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 15:55:39 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: fruggeri@arista.com (Francesco Ruggeri)
Date: Thu, 17 Sep 2020 15:19:22 -0700

>  static void netdev_wait_allrefs(struct net_device *dev)
>  {
>  	unsigned long rebroadcast_time, warning_time;
>  	int refcnt;
> +	unsigned int wait = MIN_MSLEEP;

Please preserve the reverse christmas tree ordering of local
variables here, thank you.
