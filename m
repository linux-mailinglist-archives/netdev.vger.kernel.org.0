Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAC126D34C
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 07:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgIQFzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 01:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgIQFzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 01:55:31 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 01:55:30 EDT
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E39FC20770;
        Thu, 17 Sep 2020 05:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600321714;
        bh=20gsDW2nz+v7m2nFIV6bNS6H3RfN5o+XFf+IzDnesL0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MHGRVnC1oNOYrhYVYKyieXl037GO26PKJjI6XgwcrYj9O5SdLc+rqHuxa4k2uyoJH
         GAVuIgeBnHATvo/UhGieyKVntF6gXLzDSorrLZZvB53vyqfRjekSzTIG7N2IpEDzjw
         lacqCezXjMt/w8AxJ/cfcWuYksvp2SqmCpqR4Rfk=
Message-ID: <5682fc71f21c433037f6845c737dce7d4b557731.camel@kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commit in the net-next
 tree
From:   Saeed Mahameed <saeed@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Wed, 16 Sep 2020 22:48:33 -0700
In-Reply-To: <20200917083115.23fb84a0@canb.auug.org.au>
References: <20200917083115.23fb84a0@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-09-17 at 08:31 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Commits
> 
>   0d2ffdc8d400 ("net/mlx5: Don't call timecounter cyc2time directly
> from 1PPS flow")
>   87f3495cbe8d ("net/mlx5: Release clock lock before scheduling a PPS
> work")
>   aac2df7f022e ("net/mlx5: Rename ptp clock info")
>   fb609b5112bd ("net/mlx5: Always use container_of to find mdev
> pointer from clock struct")
>   ec529b44abfe ("net/mlx5: remove erroneous fallthrough")
> 
> are missing a Signed-off-by from their committer.
> 

Sorry for the mix-up, i overwrote the old mlnx email address with the
new nvidia one but didn't consider the committer email :S.



