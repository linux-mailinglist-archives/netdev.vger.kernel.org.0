Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286CC254881
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgH0PDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgH0PCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 11:02:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8962BC061264;
        Thu, 27 Aug 2020 08:02:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED8B0127A0563;
        Thu, 27 Aug 2020 07:45:30 -0700 (PDT)
Date:   Thu, 27 Aug 2020 08:02:16 -0700 (PDT)
Message-Id: <20200827.080216.426738327667957689.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, pabeni@redhat.com, fw@strlen.de,
        edumazet@google.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, rdunlap@infradead.org,
        pablo@netfilter.org, decui@microsoft.com, jakub@cloudflare.com,
        jeremy@azazel.net, kafai@fb.com, ast@kernel.org,
        keescook@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Fix some comments
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200827112749.47698-1-linmiaohe@huawei.com>
References: <20200827112749.47698-1-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Aug 2020 07:45:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Date: Thu, 27 Aug 2020 07:27:49 -0400

> Fix some comments, including wrong function name, duplicated word and so
> on.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied, thanks.
