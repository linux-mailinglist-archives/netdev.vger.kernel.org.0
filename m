Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A0724070D
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 15:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgHJN5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 09:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgHJN5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 09:57:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62322C061756;
        Mon, 10 Aug 2020 06:57:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1k58I5-0002a7-W0; Mon, 10 Aug 2020 15:56:42 +0200
Date:   Mon, 10 Aug 2020 15:56:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pshelar@ovn.org,
        martin.varghese@nokia.com, fw@strlen.de, dcaratti@redhat.com,
        edumazet@google.com, steffen.klassert@secunet.com,
        pabeni@redhat.com, shmulik@metanetworks.com,
        kyk.segfault@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: eliminate meaningless memcpy to data in
 pskb_carve_inside_nonlinear()
Message-ID: <20200810135641.GE19310@breakpoint.cc>
References: <20200810122856.5423-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810122856.5423-1-linmiaohe@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Miaohe Lin <linmiaohe@huawei.com> wrote:
> The skb_shared_info part of the data is assigned in the following loop.

Where?
