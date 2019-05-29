Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7732E60F
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 22:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfE2U12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 16:27:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41300 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfE2U12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 16:27:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C006B14A6BDA8;
        Wed, 29 May 2019 13:27:27 -0700 (PDT)
Date:   Wed, 29 May 2019 13:27:27 -0700 (PDT)
Message-Id: <20190529.132727.2126150171664299484.davem@davemloft.net>
To:     herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] rhashtable: Add rht_ptr_rcu and improve rht_ptr
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528070231.v3ajkzqshwkoyhcz@gondor.apana.org.au>
References: <20190528070231.v3ajkzqshwkoyhcz@gondor.apana.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 13:27:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 28 May 2019 15:02:31 +0800

> This patch moves common code between rht_ptr and rht_ptr_exclusive
> into __rht_ptr.  It also adds a new helper rht_ptr_rcu exclusively
> for the RCU case.  This way rht_ptr becomes a lock-only construct
> so we can use the lighter rcu_dereference_protected primitive.
>  
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied to net-next, thank you.
