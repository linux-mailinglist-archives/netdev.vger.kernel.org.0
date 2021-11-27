Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2902745FE45
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 12:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbhK0L2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 06:28:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43950 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbhK0LZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 06:25:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F6D6B8216C;
        Sat, 27 Nov 2021 11:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499B5C53FAD;
        Sat, 27 Nov 2021 11:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638012162;
        bh=Z2iO990jnBa1aHgMo793U6xtseQx02BM9p+2ix1My9c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wkH8njxdcjEK6h/gL+v9holLd17r8VBjrtJ7KyIPXl/V4d1dnKj3OkBB5KCrundTI
         kOShgJNe/h7+9tfnL7+74cOjrjz2XDVuwCSUciE/caTM4xx6Lm4H5xzBc8cA6ZWjmz
         kDP7fA7/rIDYyiaO1ydgbDXCBAeM/BV3WqQrd4+c=
Date:   Sat, 27 Nov 2021 12:22:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH nf 2/2] selftests: netfilter: Add correctness test for
 mac,net set type
Message-ID: <YaIU/7LKgAJD/TSS@kroah.com>
References: <cover.1637976889.git.sbrivio@redhat.com>
 <142425004cc8d6bc6777fef933d3f290491f87c4.1637976889.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <142425004cc8d6bc6777fef933d3f290491f87c4.1637976889.git.sbrivio@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 27, 2021 at 11:33:38AM +0100, Stefano Brivio wrote:
> The existing net,mac test didn't cover the issue recently reported
> by Nikita Yushchenko, where MAC addresses wouldn't match if given
> as first field of a concatenated set with AVX2 and 8-bit groups,
> because there's a different code path covering the lookup of six
> 8-bit groups (MAC addresses) if that's the first field.
> 
> Add a similar mac,net test, with MAC address and IPv4 address
> swapped in the set specification.
> 
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  .../selftests/netfilter/nft_concat_range.sh   | 24 ++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
