Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E65D14A40C
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 13:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbgA0MmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 07:42:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729224AbgA0MmJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 07:42:09 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C26C20702;
        Mon, 27 Jan 2020 12:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580128929;
        bh=QSiwMTnrKStIiwbBdNCBKmEROVzIlGdH2uV0Kubp2vU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LXCqkbDBHNDfKpmnGwp3dm/47Km2U+pH/T4c840RrU+g/BO4z/BUxw3rkS1PDgA0Y
         /h/gIapdwaWu0JmTnJ4GXWEnTc05hXQZCGRz3E0KKV9UwMnWFqblcDxdOCWdJfsMmA
         7EINLqbB+dTHxeMHj9WBmDjIVc3MVqSylTSEYwYk=
Date:   Mon, 27 Jan 2020 14:42:05 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, snelson@pensando.io, michal.kalderon@marvell.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200127124205.GO3870@unreal>
References: <20200126210850.GB3870@unreal>
 <20200126133353.77f5cb7e@cakuba>
 <20200127054955.GG3870@unreal>
 <20200127.132114.1673510566926844794.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127.132114.1673510566926844794.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 01:21:14PM +0100, David Miller wrote:
> From: Leon Romanovsky <leon@kernel.org>
> Date: Mon, 27 Jan 2020 07:49:55 +0200
>
> > We, RDMA and many other subsystems mentioned in that ksummit thread,
> > removed MODULE_VERSION() a long time ago and got zero complains from
> > the real users.
>
> Changes to RDMA have a disproportionate level of impact compared to
> all of netdev.
>
> So comparing the level of real or perceived potential impact is quite
> intellectually dishonest.

This whole discussion was more emotional than intellectual :).

Anyway, I sent v4 https://lore.kernel.org/linux-rdma/20200127072028.19123-1-leon@kernel.org
and that variant provides default version value without harming
out-of-tree modules.

I have a plan to start and remove ethtool version and MODULE_VERSION()
calls from the drivers/net/* modules after merge window completes.

Does this plan sound right to you?

Thanks
