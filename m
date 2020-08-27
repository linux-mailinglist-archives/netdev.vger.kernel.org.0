Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA0B254A3E
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 18:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgH0QK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 12:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgH0QK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 12:10:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC76C061264;
        Thu, 27 Aug 2020 09:10:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD567127EA615;
        Thu, 27 Aug 2020 08:54:07 -0700 (PDT)
Date:   Thu, 27 Aug 2020 09:10:50 -0700 (PDT)
Message-Id: <20200827.091050.1588833851658460752.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Add 'else' to split mutually exclusive case
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200827111552.38789-1-linmiaohe@huawei.com>
References: <20200827111552.38789-1-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Aug 2020 08:54:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Date: Thu, 27 Aug 2020 07:15:52 -0400

> Add else to split mutually exclusive case and avoid unnecessary check.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

I see no value to this, the compiler is doing the right thing already
and this does not add to code readability either.

I'm not applying this, sorry.
