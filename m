Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A1B1D4F9B
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 15:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgEONyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 09:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgEONyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 09:54:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B248220728;
        Fri, 15 May 2020 13:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589550841;
        bh=uSZuCKTI8X0CVgaJfgeo7/SP3mbua+v/7wQh3rBjeSQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mCFpSBUcYU1s4a1dzjlhEVZKKeXDmCKw3ZGXTLUcUn1C6rCFB0W3yY3be35QSPsXP
         bKZluBiQicwsHO00LCtrw3LvofDvRLALLfhtUN/3u3sZMAomu+YC/hH7az5b+cDXsW
         rkTmHWxO9Afm66Vy/Fct/j1aTVnipQ3AMAEdn4gc=
Date:   Fri, 15 May 2020 15:53:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 05/19] staging: wfx: fix coherency of hif_scan() prototype
Message-ID: <20200515135359.GA2162457@kroah.com>
References: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
 <20200515083325.378539-6-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200515083325.378539-6-Jerome.Pouiller@silabs.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 10:33:11AM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> The function hif_scan() return the timeout for the completion of the
> scan request. It is the only function from hif_tx.c that return another
> thing than just an error code. This behavior is not coherent with the
> rest of file. Worse, if value returned is positive, the caller can't
> make say if it is a timeout or the value returned by the hardware.
> 
> Uniformize API with other HIF functions, only return the error code and
> pass timeout with parameters.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/hif_tx.c | 6 ++++--
>  drivers/staging/wfx/hif_tx.h | 2 +-
>  drivers/staging/wfx/scan.c   | 6 +++---
>  3 files changed, 8 insertions(+), 6 deletions(-)

This patch fails to apply to my branch, so I've stopped here in the
patch series.

Can you rebase and resend the remaining ones?

thanks,

greg k-h
