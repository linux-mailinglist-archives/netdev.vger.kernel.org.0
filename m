Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C831277C73
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 01:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgIXXtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 19:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgIXXtQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 19:49:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D828239EC;
        Thu, 24 Sep 2020 23:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600991356;
        bh=u4ono8E4e7UDytDwrQkF2In6/6f3FfL8R4Lf9wNkgIA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FgLsnYnzuLECv2vox/JvVLmoXM/Ydg9IWUeSnP0iAm1hA5urZo6tzynzHbOVCL7t5
         sHNcOOcAGFFO/z50cDC2kmbi17NqBj5NHpHBNrw6jspqaZ3IJqLL8s+dPesnC8sk4e
         4Is343OgMYJO7BLoS5YmKOB3xZRzwWydBPlsMTcQ=
Date:   Thu, 24 Sep 2020 16:49:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: usb: ax88179_178a: add Toshiba usb 3.0 adapter
Message-ID: <20200924164914.24ff02a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200924062722.GA20280@monster.powergraphx.local>
References: <20200924062722.GA20280@monster.powergraphx.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020 08:27:22 +0200 Wilken Gottwalt wrote:
> Reposted and added netdev as suggested by Jakub Kicinski.

Thanks!

> ---

If you want to add a comment like the above you need to place it under
the '---' which git generates. Git removes everything after those lines.
With the patch as posted your real commit message would get cut off.
(You can try applying it with git am and see.)

You'll need to fix this and repost again.

> Adds the driver_info and usb ids of the AX88179 based Toshiba USB 3.0
> ethernet adapter.
> 
> Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
> ---
>  drivers/net/usb/ax88179_178a.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
