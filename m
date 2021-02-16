Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF46831C7F1
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 10:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBPJV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 04:21:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbhBPJV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 04:21:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D176A64DA1;
        Tue, 16 Feb 2021 09:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613467248;
        bh=USVFaCTkHfp8hMrALvrjKjIQ9V+wGTJWnh0rlC+Gikg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OneRb18Tb6rgJW0FjlnMLlSnCn/CB4dBfj49T0iecMER4ZNzJJ53vzaoDMCpWIpgK
         23zFRBo2sMFCkBfe2R3dp6ZdqtSYEhkv2eUQ4l/LYztGJBI3sRgG8m+41XiwmB9Q0z
         WHkXcxiNniJBYamfdqMwEmWPCZzDAcl+J8xxzwks=
Date:   Tue, 16 Feb 2021 10:20:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Du Cheng <ducheng2@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] staging: fix coding style in
 driver/staging/qlge/qlge_main.c
Message-ID: <YCuObcmHwjqD52WN@kroah.com>
References: <20210216085326.178912-1-ducheng2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216085326.178912-1-ducheng2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 04:53:26PM +0800, Du Cheng wrote:
> align * in block comments on each line
> 
> changes v3:
> - add SUBSYSTEM in subject line
> - add explanation to past version of this patch
> 
> changes v2:
> - move closing of comment to the same line
> 
> changes v1:
> - align * in block comments

These "changes" should all go below the --- line, right?

And the subject shoudl be a bit more specific, look at how other commits
are done for this driver.  Something like:
	Subject: staging: qlge: fix comment style in qlge_main.c
matches much better, and conveys what is actually happening here, right?

v4 please?

thanks,

greg k-h
