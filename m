Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28461B345D
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 07:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfIPFZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 01:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbfIPFZN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 01:25:13 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28ADC2067B;
        Mon, 16 Sep 2019 05:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568611512;
        bh=bMnnzbxvuUKVBM8vJFYd8fDbtu3J2YV/zSzFCzqY7yM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DrvivrYSqn2xdiRLRKTT0Yvy2+lNeEH5RC5MQaRD9MlAFgiA3FYsdmJVE6pkJsrFQ
         //7e3Q8HAT0HahsrRdTczyJoO7TYjsZM01TzGrhbiqwdsygaF1HTO0BfxsGbXzZ7gL
         21ZHfHc1Hw+/uE4xvW/btWRQOjyHI2sot7lTE9vw=
Date:   Mon, 16 Sep 2019 08:25:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Mark Zhang <markz@mellanox.com>, netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2-next] rdma: Check comm string before print in
 print_comm()
Message-ID: <20190916052507.GA18203@unreal>
References: <20190911081243.28917-1-leon@kernel.org>
 <241c3bdf-53bf-a828-c57a-034b16f4839a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <241c3bdf-53bf-a828-c57a-034b16f4839a@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 15, 2019 at 11:47:19AM -0600, David Ahern wrote:
> On 9/11/19 2:12 AM, Leon Romanovsky wrote:
> > From: Mark Zhang <markz@mellanox.com>
> >
> > Broken kernels (not-upstream) can provide wrong empty "comm" field.
> > It causes to segfault while printing in JSON format.
> >
> > Fixes: 8ecac46a60ff ("rdma: Add QP resource tracking information")
>
> that commit is from 2018, so this should go to master; re-assigned in
> patchwork.

This is exactly why I sent it to -next, it is not urgent :)

Thanks
