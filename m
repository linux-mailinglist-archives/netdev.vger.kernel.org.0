Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6AF79A5A
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387976AbfG2UyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:54:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39300 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387869AbfG2UyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:54:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 08D541464AEB9;
        Mon, 29 Jul 2019 13:54:00 -0700 (PDT)
Date:   Mon, 29 Jul 2019 13:53:58 -0700 (PDT)
Message-Id: <20190729.135358.73050411709673267.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     wenxu@ucloud.cn, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5e: Fix unnecessary flow_block_cb_is_busy
 call
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b7a5de0ae2464df31ed39fee71020ba063a7a90f.camel@mellanox.com>
References: <1564239595-23786-1-git-send-email-wenxu@ucloud.cn>
        <b7a5de0ae2464df31ed39fee71020ba063a7a90f.camel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 13:54:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Mon, 29 Jul 2019 18:25:26 +0000

> Dave let me know if you want me to take it to my branch.

Please do, thanks Saeed.
