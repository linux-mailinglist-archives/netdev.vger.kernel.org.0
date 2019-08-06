Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115C982C1B
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731853AbfHFGyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:54:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731557AbfHFGya (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 02:54:30 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C09C20B1F;
        Tue,  6 Aug 2019 06:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565074470;
        bh=pyVxYgohHivhCdo5ABbyvluZXu8xqR26zeMmrmn39/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kkctbqIjB1SUdWuOZXUQFXfIUc5mG0X2WrLEqF906oOv5JPGWB5MCvwxZy6K0RfUc
         5off1MdXrKanyK1SLJAogQGHeU8ieMlMpzNWJLyGjkqu1JAJe74NlDwgDXItfm3Dxt
         uFqVgsP1NWk91j0FDP0AR4IBITkc4vHBpIA+GH7k=
Date:   Tue, 6 Aug 2019 09:54:25 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH iproute2-next] rdma: Add driver QP type string
Message-ID: <20190806065425.GP4832@mtr-leonro.mtl.com>
References: <20190804080756.58364-1-galpress@amazon.com>
 <fd623a4e-d076-3eea-2d1e-7702812b0dfc@gmail.com>
 <d156ece6-79bf-f9a4-8b79-a5abf738476d@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d156ece6-79bf-f9a4-8b79-a5abf738476d@amazon.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 09:41:37AM +0300, Gal Pressman wrote:
> On 05/08/2019 22:08, David Ahern wrote:
> > On 8/4/19 2:07 AM, Gal Pressman wrote:
> >> RDMA resource tracker now tracks driver QPs as well, add driver QP type
> >> string to qp_types_to_str function.
> >
> > "now" means which kernel release? Leon: should this be in master or -next?
>
> Now means the patch is merged to RDMA's for-rc branch (5.3).

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/infiniband?id=52e0a118a20308dd6aa531e20a5ab5907d2264c8

David,

I think that it is better to apply this patch to iproute2-rc just
to be on the same page with kernel patch.

Thanks
