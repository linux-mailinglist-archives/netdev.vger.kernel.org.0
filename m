Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E779FE7A28
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387455AbfJ1UfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:35:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44604 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfJ1UfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:35:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C96914B79EA3;
        Mon, 28 Oct 2019 13:35:02 -0700 (PDT)
Date:   Mon, 28 Oct 2019 13:35:02 -0700 (PDT)
Message-Id: <20191028.133502.1532748858682850578.davem@davemloft.net>
To:     lirongqing@baidu.com
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com, leon@kernel.org
Subject: Re: [PATCH][net-next] net/mlx5: rate limit alloc_ent error messages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571905413-28405-1-git-send-email-lirongqing@baidu.com>
References: <1571905413-28405-1-git-send-email-lirongqing@baidu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 13:35:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>
Date: Thu, 24 Oct 2019 16:23:33 +0800

> when debug a bug, which triggers TX hang, and kernel log is
> spammed with the following info message
> 
>     [ 1172.044764] mlx5_core 0000:21:00.0: cmd_work_handler:930:(pid 8):
>     failed to allocate command entry
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Saeed, please pick this up if you haven't already.

Thank you.
