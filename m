Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D4ECE85F
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 17:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbfJGPyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 11:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbfJGPyl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 11:54:41 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9183620679;
        Mon,  7 Oct 2019 15:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570463680;
        bh=A6Hck1SO3IpFeLsQFU+3wiLlAr7I+9JrSXX1SV7ibHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YJzzUSCEdmGMe4UvckKgE4QMK2r8U3ebyLk6UQBmYTph11XzWKfbtsGEWHxjC9fPC
         VzOgMtnPIqITzdqa1AZz6PnPbLe1rCJ2sDIKgiNeNJUqP0LJP4SDuS/5t+rZzmnnQZ
         t33uW1/T+hP7FSKXQ//OtUZGdxladYzp37OE8OWk=
Date:   Mon, 7 Oct 2019 18:54:34 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next v2 1/3] net/mlx5: Expose optimal performance
 scatter entries capability
Message-ID: <20191007155434.GY5855@unreal>
References: <20191007135933.12483-1-leon@kernel.org>
 <20191007135933.12483-2-leon@kernel.org>
 <cfae2979-1ba4-e20d-ed20-1cb8f26b78f6@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfae2979-1ba4-e20d-ed20-1cb8f26b78f6@acm.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 08:02:50AM -0700, Bart Van Assche wrote:
> On 10/7/19 6:59 AM, Leon Romanovsky wrote:
> > -	u8         reserved_at_c0[0x8];
> > +	u8         max_sgl_for_optimized_performance[0x8];
>
> Should the name of this member variable perhaps be changed into
> "max_sgl_for_optimal_performance"?

We don't want to force our internal HW/FW names on all uverbs users
and drivers. So, the answer is no, it is used for optimized performance,
but it is not the proper name for uverbs.

Thanks

>
> Thanks,
>
> Bart.
