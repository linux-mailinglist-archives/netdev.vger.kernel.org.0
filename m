Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDA33A7B9E
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 12:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhFOKTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 06:19:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231152AbhFOKTW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 06:19:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E26461426;
        Tue, 15 Jun 2021 10:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623752236;
        bh=h/OhBuRJp1n80pXmzsW7V7YT5v9wdMx+nLtKRZZvje4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tflOmO1j3m7wSBM1cbG1DaCU1L5jL8vr3Ef4oR3cSFPARYnd+jdUitN81uSmlVkzt
         PJOs9J/gyjoXly3yK+wdLUEml+9HRDdKiwyr0CDuw0G6y63pwe4XvxNPQQK4jYvVfB
         667TCKpXc9x4l+20h1fmYd4CcoaAiY9rAr5l63wc=
Date:   Tue, 15 Jun 2021 12:17:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] cxgb4: fix wrong shift.
Message-ID: <YMh+KitE/UXqidNn@kroah.com>
References: <20210615095651.GA7479@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615095651.GA7479@duo.ucw.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 11:56:51AM +0200, Pavel Machek wrote:
> While fixing coverity warning, commit
> dd2c79677375c37f8f9f8d663eb4708495d595ef introduced typo in shift
> value. Fix that.
>     
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
> index 22c9ac922eba..6260b3bebd2b 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
> @@ -198,7 +198,7 @@ static void set_nat_params(struct adapter *adap, struct filter_entry *f,
>  				      WORD_MASK, f->fs.nat_lip[3] |
>  				      f->fs.nat_lip[2] << 8 |
>  				      f->fs.nat_lip[1] << 16 |
> -				      (u64)f->fs.nat_lip[0] << 25, 1);
> +				      (u64)f->fs.nat_lip[0] << 24, 1);
>  		}
>  	}
>  
> 


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
