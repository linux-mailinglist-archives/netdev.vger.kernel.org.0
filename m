Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFD5F4B0F0
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 06:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfFSEqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 00:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbfFSEqC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 00:46:02 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C4CB20823;
        Wed, 19 Jun 2019 04:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560919561;
        bh=5BTuBy9YVjrxjv+yDE+KCK0JHPWkTZ8Js5bgz0TTidI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nihXwFPbEgbNsPC8YD5DgfMuzoUSYVKM5oifKDWMAo0yYbCXaoloePkZG2GFCi4Yy
         IJyYHttRGTcUTUsZi284Xoi6btVYWxcPrkYCMqFDT8JsrzKHnjt0SK7Yek3E+j9BQW
         Mdy79sfoqvf4fSJ0SfHcKKsjLXETzAs46tpV6gHc=
Date:   Wed, 19 Jun 2019 07:45:57 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 00/12] DEVX asynchronous events
Message-ID: <20190619044557.GA11611@mtr-leonro.mtl.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <19107c92279cf4ad4d870fa54514423c5e46b748.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19107c92279cf4ad4d870fa54514423c5e46b748.camel@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 06:51:45PM +0000, Saeed Mahameed wrote:
> On Tue, 2019-06-18 at 20:15 +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Changelog:
> >  v0 -> v1:
>
> Normally 1st submission is V1 and 2nd is V2.
> so this should have been v1->v2.

"Normally" depends on the language you are using. In C, everything
starts from 0, including version of patches :).

>
> For mlx5-next patches:
>
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>

Thanks
