Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA9458B06
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 21:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfF0Tng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 15:43:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59300 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0Tng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 15:43:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C3E5213CB3369;
        Thu, 27 Jun 2019 12:43:35 -0700 (PDT)
Date:   Thu, 27 Jun 2019 12:43:33 -0700 (PDT)
Message-Id: <20190627.124333.752901367217079007.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     dledford@redhat.com, jgg@mellanox.com, leonro@mellanox.com,
        ogerlitz@mellanox.com, sagi@grimberg.me, talgi@mellanox.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [pull request][for-next V2 0/7] Generic DIM lib for netdev and
 RDMA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190625205701.17849-1-saeedm@mellanox.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 12:43:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 25 Jun 2019 20:57:27 +0000

> Once we are all happy with the series, please pull to net-next and
> rdma-next trees.

Pulled into net-next, thanks.

I'll push it back out once I am done build testing.
