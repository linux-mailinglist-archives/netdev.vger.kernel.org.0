Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C949F77C03
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 23:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfG0VYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 17:24:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40372 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfG0VYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 17:24:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A5681534E7B5;
        Sat, 27 Jul 2019 14:24:02 -0700 (PDT)
Date:   Sat, 27 Jul 2019 14:24:01 -0700 (PDT)
Message-Id: <20190727.142401.1604681145641848490.davem@davemloft.net>
To:     jonathan.lemon@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next] ipv6: remove printk
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190726191609.3601197-1-jonathan.lemon@gmail.com>
References: <20190726191609.3601197-1-jonathan.lemon@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 14:24:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>
Date: Fri, 26 Jul 2019 12:16:09 -0700

> ipv6_find_hdr() prints a non-rate limited error message
> when it cannot find an ipv6 header at a specific offset.
> This could be used as a DoS, so just remove it.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Applied.
