Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8167B2AD324
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 11:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgKJKF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 05:05:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgKJKF7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 05:05:59 -0500
Received: from localhost (searspoint.nvidia.com [216.228.112.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6309520781;
        Tue, 10 Nov 2020 10:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605002759;
        bh=KyiZZNGCWirMY3RDzwcBHMG2nq8uijt2A2VGI534m3c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TzPhEGyWiQDqAd+44Ijt2ZRVNQ0wFMItCMteyFGSHwOV/2B898EEiQ+JpO6xtxcEt
         wOOfWUVmuG27scvLPAz2Rt7ELZBVq+pFFYSzKUrf9R2Vhp9rV+XcEoE3Ix7gGXvbnS
         9Dy1lgP8B825KkZP1HblwlIJgWnBd5zBbp03fDOg=
Date:   Tue, 10 Nov 2020 12:05:54 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Petr Machata <me@pmachata.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, john.fastabend@gmail.com,
        jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
Subject: Re: [PATCH iproute2-next v4 03/11] lib: json_print: Add
 print_on_off()
Message-ID: <20201110100554.GB371586@unreal>
References: <cover.1604869679.git.me@pmachata.org>
 <f9e1baac29bddcb406d41e06d8414a4b4d6bcf62.1604869679.git.me@pmachata.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9e1baac29bddcb406d41e06d8414a4b4d6bcf62.1604869679.git.me@pmachata.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 08, 2020 at 10:14:08PM +0100, Petr Machata wrote:
> The value of a number of booleans is shown as "on" and "off" in the plain
> output, and as an actual boolean in JSON mode. Add a function that does
> that.
>
> RDMA tool already uses a function named print_on_off(). This function
> always shows "on" and "off", even in JSON mode. Since there are probably
> very few if any consumers of this interface at this point, migrate it to
> the new central print_on_off() as well.
>
> Signed-off-by: Petr Machata <me@pmachata.org>
> ---
>
> Notes:
>     v3:
>     - Rename to print_on_off(). [David Ahern]
>     - Move over to json_print.c and make it a variant of print_bool().
>       Convert RDMA tool over to print_on_off(). [Leon Romanovsky]
>
>  include/json_print.h |  1 +
>  lib/json_print.c     | 34 +++++++++++++++++++++++++++-------
>  rdma/dev.c           |  2 +-
>  rdma/rdma.h          |  1 -
>  rdma/res-cq.c        |  2 +-
>  rdma/utils.c         |  5 -----
>  6 files changed, 30 insertions(+), 15 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
