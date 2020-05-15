Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DA11D426A
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgEOAvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbgEOAvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:51:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD20C061A0C;
        Thu, 14 May 2020 17:51:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C5C9B14DB4EA4;
        Thu, 14 May 2020 17:51:48 -0700 (PDT)
Date:   Thu, 14 May 2020 17:51:48 -0700 (PDT)
Message-Id: <20200514.175148.6555865022077330.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ipv6: move SIOCADDRT and SIOCDELRT handling into
 ->compat_ioctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514144535.3000410-3-hch@lst.de>
References: <20200514144535.3000410-1-hch@lst.de>
        <20200514144535.3000410-3-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 17:51:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Thu, 14 May 2020 16:45:33 +0200

> +int inet6_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
> +{
> +	struct sock *sk = sock->sk;
> +	void __user *argp = compat_ptr(arg);

Reverse chrstimas tree please.
