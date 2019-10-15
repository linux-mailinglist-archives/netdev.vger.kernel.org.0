Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF109D6F56
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 07:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfJOFwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 01:52:55 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34312 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfJOFwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 01:52:54 -0400
Received: by mail-ed1-f68.google.com with SMTP id j8so5132130eds.1
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 22:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=csqgidI2bOk/mXCkF4DsTI9lZ7KTpiRPbpvCvJu7wwo=;
        b=HiTVLpgN14/FBY28x2qN+/8wwo/6YLgy0JNPtMN/Q3aJIGH7OH/D0xb36quI/scylf
         B9MmJRmJJ3nz9h0+s6ptvL4Zo5JudTx5I558uy5haQvW4Dg5jKH9Inq6soe0vkfZcjPT
         2YFx1X6gosBdpQuZ3fE3SgpJn5wPJQae8B6QdkVAin+7s/A/n2b/QziSwWOkcVFwkFjn
         ds6p7YinLZ1NpKaNE+hjLQ5Yj8a+MLQseoyRnw03bzgrELsrdOXWHhnkTrCZ6VUkTGKz
         v7RdR5WTQ5zWn+qr4xM88JgPeY48eEN2A+H3AQvQTv5sxgHtrYpjzALFyjNN7m2Y8o35
         KxvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=csqgidI2bOk/mXCkF4DsTI9lZ7KTpiRPbpvCvJu7wwo=;
        b=jVb0e/TVMFL3IlzZ1LI8EZIQrjxjgQTAKRGKl+QbhUnYHtSAcppLkFZqRzfBRK+gyy
         Fr4Pr/BlSR8C76HCYZxEb1jEI6oDKbytyVTZm/HWhZAW3qy3gy9apL1n+lFcA2r7zIPw
         haWhIp/zUV779tRJn8apnBCVJEJD2CUeV6DBq/iJ2uFuhaaFRlnGHZMZhGAb1h0/msrb
         fOsbLx6FXo1fjs1H997Ji9dkxt/3GXg63YdJL6ji4DqIBtxe5QvAzWWILwu2zh/wh/zz
         MaaZdx/ajApMp4WH4+rNeOJb2XzJ6kL6RuKQqFpKDfyyYP/0t/S4STURsPDrx3s6br84
         dXZQ==
X-Gm-Message-State: APjAAAUwspa4jfvGUDf+4YWwv4zeTr9UkQk2An5dPgzxRahBNQtVipO3
        C1DKckqTCXp5ef/fhvCgHCDkivA1Log=
X-Google-Smtp-Source: APXvYqwtvGzXvlrIpnPQhM6pba34dsMJA4AsrwsUVBjNDPsQZEmOJ/CwnUd2ZTM+pgLnysEmFkAXFg==
X-Received: by 2002:a17:906:e090:: with SMTP id gh16mr32666281ejb.56.1571118772829;
        Mon, 14 Oct 2019 22:52:52 -0700 (PDT)
Received: from netronome.com (penelope-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:c685:8ff:fe7c:9971])
        by smtp.gmail.com with ESMTPSA id a20sm3556344edt.95.2019.10.14.22.52.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Oct 2019 22:52:52 -0700 (PDT)
Date:   Tue, 15 Oct 2019 07:52:49 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Vishal Kulkarni <vishal@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        Shahjada Abul Husain <shahjada@chelsio.com>
Subject: Re: [PATCH net] cxgb4: Fix panic when attaching to ULD fails
Message-ID: <20191015055241.hvzyj7klt5gehwpu@netronome.com>
References: <1571039435-22495-1-git-send-email-vishal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571039435-22495-1-git-send-email-vishal@chelsio.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 01:20:35PM +0530, Vishal Kulkarni wrote:
> Release resources when attaching to ULD fail. Otherwise, data
> mismatch is seen between LLD and ULD later on, which lead to
> kernel panic when accessing resources that should not even
> exist in the first place.
> 
> Fixes: 94cdb8bb993a ("cxgb4: Add support for dynamic allocation of resources for ULD")
> Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
> index 5b60224..0482ef8 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
> @@ -692,10 +692,10 @@ static void uld_init(struct adapter *adap, struct cxgb4_lld_info *lld)
>  	lld->write_cmpl_support = adap->params.write_cmpl_support;
>  }
>  
> -static void uld_attach(struct adapter *adap, unsigned int uld)
> +static int uld_attach(struct adapter *adap, unsigned int uld)
>  {
> -	void *handle;
>  	struct cxgb4_lld_info lli;
> +	void *handle;
>  
>  	uld_init(adap, &lli);
>  	uld_queue_init(adap, uld, &lli);
> @@ -705,7 +705,7 @@ static void uld_attach(struct adapter *adap, unsigned int uld)
>  		dev_warn(adap->pdev_dev,
>  			 "could not attach to the %s driver, error %ld\n",
>  			 adap->uld[uld].name, PTR_ERR(handle));
> -		return;
> +		return PTR_ERR(handle);
>  	}
>  
>  	adap->uld[uld].handle = handle;
> @@ -713,6 +713,8 @@ static void uld_attach(struct adapter *adap, unsigned int uld)
>  
>  	if (adap->flags & CXGB4_FULL_INIT_DONE)
>  		adap->uld[uld].state_change(handle, CXGB4_STATE_UP);
> +
> +	return 0;
>  }
>  
>  /**
> @@ -727,8 +729,8 @@ static void uld_attach(struct adapter *adap, unsigned int uld)
>  void cxgb4_register_uld(enum cxgb4_uld type,
>  			const struct cxgb4_uld_info *p)

Not part of this patch, but the comment above this function describes
it as returning -EBUSY and yet the return type is void. Also, the comment
seems to be in semi-kdoc format, perhaps converting it would be worthwhile.

>  {
> -	int ret = 0;
>  	struct adapter *adap;
> +	int ret = 0;
>  
>  	if (type >= CXGB4_ULD_MAX)
>  		return;
> @@ -760,7 +762,9 @@ void cxgb4_register_uld(enum cxgb4_uld type,
>  		if (ret)
>  			goto free_irq;
>  		adap->uld[type] = *p;
> -		uld_attach(adap, type);
> +		ret = uld_attach(adap, type);
> +		if (ret)
> +			goto free_irq;

Is it desired that the loop continues and that only the current iteration
is cleaned up?

>  		continue;
>  free_irq:
>  		if (adap->flags & CXGB4_FULL_INIT_DONE)
> -- 
> 1.8.3.1
> 
