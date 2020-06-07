Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B091F0A3C
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 08:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgFGG0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 02:26:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgFGG0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 02:26:00 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51C7920663;
        Sun,  7 Jun 2020 06:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591511160;
        bh=V9qtjJLfIO+4GB+/S+9etJyw4EY0jJTHsM6kojnTHsA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wQa9MEkRCMw77MupfpWTLkWbaLz46EPlNRXWrZKWldlTTTW2eGfaqSjyyJsoAsmON
         x2nRUonNguv5cP1D96AkJLHpiRXPynor+0qc8QcmBVvbA9JdIsAd19MQUpG8VUgmNy
         WJIf8XuXaFfZYSZyroowQ6t1SCwL0jMpztnaKVwc=
Date:   Sun, 7 Jun 2020 09:25:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: E-Switch, Fix some error pointer dereferences
Message-ID: <20200607062555.GC164174@unreal>
References: <20200603175436.GD18931@mwanda>
 <20200604103255.GA8834@unreal>
 <20200605105203.GK22511@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605105203.GK22511@kadam>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 05, 2020 at 01:52:03PM +0300, Dan Carpenter wrote:
> On Thu, Jun 04, 2020 at 01:32:55PM +0300, Leon Romanovsky wrote:
> > + netdev
> >
>
> This is sort of useless.  What's netdev going to do with a patch they
> can't apply?  I assumed that mellanox was going to take this through
> their tree...

Right, but it will be picked by Saeed who will send it to netdev later
as PR. CCing netdev saves extra review at that stage.

>
> Should I resend the other mlx5 patch as well?

I don't think so.

>
> regards,
> dan carpenter
>
