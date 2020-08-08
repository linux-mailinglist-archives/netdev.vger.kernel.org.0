Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C00823F91C
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 23:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgHHVZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 17:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgHHVZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 17:25:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0ECC061756;
        Sat,  8 Aug 2020 14:25:19 -0700 (PDT)
Received: from localhost (50-47-102-2.evrt.wa.frontiernet.net [50.47.102.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EAEF812733530;
        Sat,  8 Aug 2020 14:08:32 -0700 (PDT)
Date:   Sat, 08 Aug 2020 14:25:17 -0700 (PDT)
Message-Id: <20200808.142517.298909034090859573.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuba@kernel.org, pshelar@ovn.org, martin.varghese@nokia.com,
        fw@strlen.de, willemb@google.com, edumazet@google.com,
        dcaratti@redhat.com, steffen.klassert@secunet.com,
        pabeni@redhat.com, shmulik@metanetworks.com,
        kyk.segfault@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] net: Use helper function ip_is_fragment()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596715038-25429-1-git-send-email-linmiaohe@huawei.com>
References: <1596715038-25429-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 08 Aug 2020 14:08:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: linmiaohe <linmiaohe@huawei.com>
Date: Thu, 6 Aug 2020 19:57:18 +0800

> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> Use helper function ip_is_fragment() to check ip fragment.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied.
