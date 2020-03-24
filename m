Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1792F19035C
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 02:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgCXBlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 21:41:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55256 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbgCXBlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 21:41:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15DC415B487A8;
        Mon, 23 Mar 2020 18:41:37 -0700 (PDT)
Date:   Mon, 23 Mar 2020 18:41:36 -0700 (PDT)
Message-Id: <20200323.184136.2138892627319154558.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 0/5] Mellanox, mlx5 fixes 2020-03-05
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2495edeb580e5a4b072bda6e72e4808c281b0f2e.camel@mellanox.com>
References: <20200305231739.227618-1-saeedm@mellanox.com>
        <20200306.224333.609016114112242678.davem@davemloft.net>
        <2495edeb580e5a4b072bda6e72e4808c281b0f2e.camel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 18:41:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Mon, 23 Mar 2020 22:57:32 +0000

> i don't see this pull request merged into your net tree, 
> what am i missing ? 
> 
> I am preparing a new fixes pull request, should i re-include these
> patches and start over ? I don't mind .. 

I left it build tested on my laptop but not pushed out, sorry :-)

It's in the tree now.

Thanks.
