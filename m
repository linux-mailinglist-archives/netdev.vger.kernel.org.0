Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557E344CF40
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 02:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhKKBwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 20:52:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233115AbhKKBwp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 20:52:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8999D61872;
        Thu, 11 Nov 2021 01:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636595396;
        bh=f/yC4ondW0QTs5CCN9edd7WOeQSC0/GyJBYH/SEXbpQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ehasmTh0v/BzH7yJ9PDwFpx/tpNK/9DIlLC+yQPe9HXagiWaVMpaPFYqFm+b4+ybW
         GtMI6dkofWMPwT2izWu0hbn4X8kFtxdQYWtpDzb+kWAFh4VBiynRgR2pUHKWlzjflx
         b5NpUaH8z/rYzjC7wmXSY8eyCnyINWwofDsDl6yyh9aDb0vr+MLPWCT+Uge+uP8jjb
         fOQlufF85b7MafgIfOmKKspFwaT0ocUONIJxrhR10Qt4qJTsV0JpiOpuu/fnyLWX/h
         MEmb4lj1iAfpRuMRQWKrHYg01DK7GD1IYKSTinpcmiqxj/9m8LKWwbFMEhB6b6GpLR
         I6/x6326hC5Yw==
Date:   Wed, 10 Nov 2021 17:49:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Min Li <min.li.xe@renesas.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ptp: ptp_clockmatrix: repair non-kernel-doc comment
Message-ID: <20211110174955.3fb02cde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211110225306.13483-1-rdunlap@infradead.org>
References: <20211110225306.13483-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Nov 2021 14:53:06 -0800 Randy Dunlap wrote:
> Do not use "/**" to begin a comment that is not in kernel-doc format.
> 
> Prevents this docs build warning:
> 
> drivers/ptp/ptp_clockmatrix.c:1679: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>     * Maximum absolute value for write phase offset in picoseconds
> 
> Fixes: 794c3dffacc16 ("ptp: ptp_clockmatrix: Add support for FW 5.2 (8A34005)")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Min Li <min.li.xe@renesas.com>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/ptp/ptp_clockmatrix.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20211110.orig/drivers/ptp/ptp_clockmatrix.c
> +++ linux-next-20211110/drivers/ptp/ptp_clockmatrix.c
> @@ -1699,7 +1699,7 @@ static int initialize_dco_operating_mode
>  
>  /* PTP Hardware Clock interface */
>  
> -/**
> +/*
>   * Maximum absolute value for write phase offset in picoseconds
>   *
>   * @channel:  channel

Looks like it documents parameters to the function, should we either
fix it to make it valid kdoc or remove the params (which TBH aren't
really adding much value)?
