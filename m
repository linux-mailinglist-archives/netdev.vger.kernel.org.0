Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B271336F5F
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 10:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhCKJ4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 04:56:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231991AbhCKJzi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 04:55:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7995164E04;
        Thu, 11 Mar 2021 09:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615456538;
        bh=9wEgtYJxwFrFRjLiQajWmNSfLrWwcoVi6KN3QRm2d5M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eU1L6/5/U94bb351eFjcy9XB1cEq8MbuONF3gVia+LqsNbv+pHIkMTjCiiOyQZMb+
         ADGGVxPnyV+qWYIAanEWsnqrjzd192N07G6EW6qNd9AWvG4N2cTvssRt9ulWGSwoun
         19pRsC1CeQWx+ew+cdzvBvdeHhmU1W5WGfLDoBkI=
Date:   Thu, 11 Mar 2021 10:55:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shubhankar Kuranagatti <shubhankarvk@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, bkkarthik@pesu.pes.edu
Subject: Re: [PATCH] net: core: bpf_sk_storage.c: Fix bare usage of unsigned
Message-ID: <YEnpF8AfvS7b/wln@kroah.com>
References: <20210311094349.5q76vsxuqk3riwyq@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311094349.5q76vsxuqk3riwyq@kewl-virtual-machine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 03:13:49PM +0530, Shubhankar Kuranagatti wrote:
> Changed bare usage of unsigned to unsigned int

That says _what_ you did, but not _why_ you did it :(

thanks,

greg k-h
