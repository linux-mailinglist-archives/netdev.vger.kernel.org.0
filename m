Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 537AE4F926
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 01:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfFVX4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 19:56:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32944 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfFVX4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 19:56:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F0DA1540C181;
        Sat, 22 Jun 2019 16:56:13 -0700 (PDT)
Date:   Sat, 22 Jun 2019 16:56:12 -0700 (PDT)
Message-Id: <20190622.165612.953144135310679043.davem@davemloft.net>
To:     lirongqing@baidu.com
Cc:     netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH][net-next] netns: restore ops before calling
 ops_exit_list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561029880-1666-1-git-send-email-lirongqing@baidu.com>
References: <1561029880-1666-1-git-send-email-lirongqing@baidu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Jun 2019 16:56:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>
Date: Thu, 20 Jun 2019 19:24:40 +0800

> ops has been iterated to first element when call pre_exit, and
> it needs to restore from save_ops, not save ops to save_ops
> 
> Fixes: d7d99872c144 ("netns: add pre_exit method to struct pernet_operations")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Applied, thank you.
