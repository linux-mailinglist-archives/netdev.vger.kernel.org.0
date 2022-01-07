Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0F7486F00
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343968AbiAGAmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:42:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58554 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343865AbiAGAmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:42:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0768BB8240F;
        Fri,  7 Jan 2022 00:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE93C36AE0;
        Fri,  7 Jan 2022 00:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641516118;
        bh=Pd98R3goIk+E5okVr1q0OLtQzqo9FH4v6pbDvQnNilA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g5oheXA8hsFKxI2ZF2pVFv4yVXCt+dapX25W2D82mnCgc0n+wYrWhiQ4b+tBUpKCL
         uBFd7F4nM+C6gypfGz0Dd/QtZfmjx5nAesuWOQuLb/n9C0UqA6zpRUBWMYKE8Pns9c
         OZf8eXAcLQzhR4W9izNeZnbR2XZVp0VRksTj2fnH8o/tdO9kOvOnDkmBuprJWHjEns
         nBgRIXm0qUrOXedcQv56rAE3aKDLooWBc3JF2FHNJhaF4BJ42QyB2AhMdFxj4l5lRT
         1h3WKr8wtyhze1RmLAH4HHPIg+SufYrgu5d2Hy5QAS1hLhbQWgUGp1IlgJ4UAdzRL+
         D36Ow49DdLeYQ==
Date:   Thu, 6 Jan 2022 16:41:56 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20220107004156.ycgrmqesgtnvxzrp@sx1>
References: <20220107025749.35eaa2c2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220107025749.35eaa2c2@canb.auug.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 02:57:49AM +1100, Stephen Rothwell wrote:
>Hi all,
>
>After merging the net-next tree, today's linux-next build (htmldocs)
>produced this warning:
>
>Documentation/networking/devlink/mlx5.rst:13: WARNING: Error parsing content block for the "list-table" directive: uniform two-level bullet list expected, but row 2 does not contain the same number of items as row 1 (2 vs 3).
>

...

>Introduced by commit
>
>  0844fa5f7b89 ("net/mlx5: Let user configure io_eq_size param")
>

Thanks for the report, I just submitted a fix to net-next.


