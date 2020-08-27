Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D954254A40
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 18:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgH0QLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 12:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgH0QLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 12:11:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4796DC061264;
        Thu, 27 Aug 2020 09:11:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 418CA127EA615;
        Thu, 27 Aug 2020 08:55:03 -0700 (PDT)
Date:   Thu, 27 Aug 2020 09:11:49 -0700 (PDT)
Message-Id: <20200827.091149.1705977031921040660.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuba@kernel.org, pshelar@ovn.org, fw@strlen.de,
        martin.varghese@nokia.com, edumazet@google.com,
        dcaratti@redhat.com, steffen.klassert@secunet.com,
        pabeni@redhat.com, shmulik@metanetworks.com,
        kyk.segfault@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Call ip_hdrlen() when skbuff is not fragment
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200827111759.40336-1-linmiaohe@huawei.com>
References: <20200827111759.40336-1-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Aug 2020 08:55:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Date: Thu, 27 Aug 2020 07:17:59 -0400

> When skbuff is fragment, we exit immediately and leave ip_hdrlen() as
> unused. And remove the unnecessary local variable fragment.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

I don't think this is a useful optimization sorry, the common case
will be just as likely to be a fragment as not so it's arbitrary
whether we read this simple value or not.

I'm not applying this, sorry.
