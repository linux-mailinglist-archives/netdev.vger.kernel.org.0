Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C583A4A8AB
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbfFRRkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:40:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50770 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729337AbfFRRkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 13:40:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4BFD215107498;
        Tue, 18 Jun 2019 10:40:38 -0700 (PDT)
Date:   Tue, 18 Jun 2019 10:40:37 -0700 (PDT)
Message-Id: <20190618.104037.359105025150148890.davem@davemloft.net>
To:     dledford@redhat.com
Cc:     kda@linux-powerpc.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, mkubecek@suse.cz
Subject: Re: [PATCH net-next v4 2/2] ipoib: show VF broadcast address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <bd0b0a87b8bc459e172ad9396931bb69697da6c9.camel@redhat.com>
References: <20190617085341.51592-4-dkirjanov@suse.com>
        <20190618.100801.2026737630386139646.davem@davemloft.net>
        <bd0b0a87b8bc459e172ad9396931bb69697da6c9.camel@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 10:40:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Ledford <dledford@redhat.com>
Date: Tue, 18 Jun 2019 13:29:59 -0400

> On Tue, 2019-06-18 at 10:08 -0700, David Miller wrote:
>> From: Denis Kirjanov <kda@linux-powerpc.org>
>> Date: Mon, 17 Jun 2019 10:53:41 +0200
>> 
>> > in IPoIB case we can't see a VF broadcast address for but
>> > can see for PF
>> 
>> I just want to understand why this need to see the VF broadcast
>> address is IPoIB specific?
> 
> A VF might or might not have the same security domain (P_Key) as the
> parent, and the P_Key is encoded in the broadcast address.  In the
> event that two vfs or a vf and a pf can't see each other over the IPoIB
> network, it is necessary to be able to see the broadcast address in use
> by each to make sure they are the same and not that they shouldn't be
> able to see each other because they are on different P_Keys and
> therefore different broadcast multicast groups.

Thanks for explaining.

I'll apply these to net-next right now then.

Thanks again.
