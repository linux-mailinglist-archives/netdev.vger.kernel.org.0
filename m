Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB2812DC3D
	for <lists+netdev@lfdr.de>; Wed,  1 Jan 2020 00:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfLaXBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 18:01:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbfLaXBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 18:01:22 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C93F2206DA;
        Tue, 31 Dec 2019 23:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577833282;
        bh=5PSVQVMJwAZEcbk4g8uRnQsHkkdsZNVyarptzACKuaI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rIjODME4v2nVQqa2B5i49LUuq7PS7JL4arbLZGIhTsshh3cmP84L3vHP14LEFahf6
         Hg8xBAjly92r9eMsZXwgS9w+4DKtkc6UZD8NqbTlxV+RcCUWH01RQJbBPBjn7i8BEv
         zwKpqsImGFaOjKX9IudBVIizpPCK0XqWTAlnwwMk=
Date:   Tue, 31 Dec 2019 15:01:21 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] proc: convert everything to "struct proc_ops"
Message-Id: <20191231150121.5b09e34205444f6c65277b73@linux-foundation.org>
In-Reply-To: <20191225172546.GB13378@avx2>
References: <20191225172228.GA13378@avx2>
        <20191225172546.GB13378@avx2>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Dec 2019 20:25:46 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> The most notable change is DEFINE_SHOW_ATTRIBUTE macro split in
> seq_file.h.
> 
> Conversion rule is:
> 
> 	llseek		=> proc_lseek
> 	unlocked_ioctl	=> proc_ioctl
> 
> 	xxx		=> proc_xxx
> 
> 	delete ".owner = THIS_MODULE" line
> 
> ...
>
>  drivers/staging/isdn/hysdn/hysdn_procconf.c           |   15 +-
>  drivers/staging/isdn/hysdn/hysdn_proclog.c            |   17 +-

These seem to have disappeared in linux-next.
