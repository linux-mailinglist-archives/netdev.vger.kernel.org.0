Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2B02A5EE
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 20:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfEYSAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 14:00:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57478 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfEYSAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 14:00:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7345712B05D2E;
        Sat, 25 May 2019 11:00:29 -0700 (PDT)
Date:   Sat, 25 May 2019 11:00:29 -0700 (PDT)
Message-Id: <20190525.110029.1339691720534150701.davem@davemloft.net>
To:     blackgod016574@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6_sockglue: Fix a missing-check bug in
 ip6_ra_control()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190524031946.GA6463@zhanggen-UX430UQ>
References: <20190524031946.GA6463@zhanggen-UX430UQ>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 May 2019 11:00:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gen Zhang <blackgod016574@gmail.com>
Date: Fri, 24 May 2019 11:19:46 +0800

> In function ip6_ra_control(), the pointer new_ra is allocated a memory 
> space via kmalloc(). And it is used in the following codes. However, 
> when there is a memory allocation error, kmalloc() fails. Thus null 
> pointer dereference may happen. And it will cause the kernel to crash. 
> Therefore, we should check the return value and handle the error.
> 
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>

Applied.
