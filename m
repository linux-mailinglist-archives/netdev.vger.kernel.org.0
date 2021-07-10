Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57C73C34B4
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 15:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhGJNQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 09:16:04 -0400
Received: from smtp-31-i2.italiaonline.it ([213.209.12.31]:46608 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229501AbhGJNQE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 09:16:04 -0400
Received: from oxapps-32-144.iol.local ([10.101.8.190])
        by smtp-31.iol.local with ESMTPA
        id 2CnFmjgNnzHnR2CnFmaFVK; Sat, 10 Jul 2021 15:13:17 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1625922797; bh=ullo8BqAmkQdn6aRHfUtxPDJWJ9hkv8fLYEZa+6OrcE=;
        h=From;
        b=LxUB5utbRDWISDmetb8oxdZsTE3EpXuRYF8C6Yx4rmSzl6jPxmHxxhzAXY93p1goA
         f3zb6c+Kji73GGaTp/HYF2mENcelAhe7O/DBOzFlSDYuxsqKITKCnyxWEX333p1DoJ
         bga0A1JLi/M62kG4KrOXOlhtfuPdhLyXX36zGjZavKev0YRuQNLV17o2VQpKb/WTY3
         Cplk29w3diHiUQKhq9K38DclLa4KueambNU+wic5JBp9Q17Vuqyw816P5IwsR8QARy
         e4IGiEm+NYObTTxuKmtQOh01Vyx33S6X8o4f3OL1vhBE/dcfW8uWVRmDs4z8ZatiT7
         M2rT0u/YRJ0oA==
X-CNFS-Analysis: v=2.4 cv=L6DY/8f8 c=1 sm=1 tr=0 ts=60e99ced cx=a_exe
 a=+LyvvGPX93CApvOVpnXrdQ==:117 a=f1OlDQwkpmUA:10 a=IkcTkHD0fZMA:10
 a=-Mcqfe5xleoA:10 a=pGLkceISAAAA:8 a=uO2AghNzcfEkKI0e3JQA:9 a=QEXdDO2ut3YA:10
Date:   Sat, 10 Jul 2021 15:13:17 +0200 (CEST)
From:   dariobin@libero.it
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, davem@davemloft.net,
        richardcochran@gmail.com
Cc:     kernel-team@fb.com, netdev@vger.kernel.org
Message-ID: <691638583.174057.1625922797445@mail1.libero.it>
In-Reply-To: <20210708180408.3930614-1-jonathan.lemon@gmail.com>
References: <20210708180408.3930614-1-jonathan.lemon@gmail.com>
Subject: Re: [PATCH net] ptp: Relocate lookup cookie to correct block.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev34
X-Originating-IP: 79.54.92.92
X-Originating-Client: open-xchange-appsuite
x-libjamsun: Tx5qI0NbhlZ5HsMPiAb2D87pvQCbyGOE
x-libjamv: UkBH6od/2eM=
X-CMAE-Envelope: MS4xfAbKeN5Vcmt8nP7vbYWIeGl9LJEvsOrPeF0uH3YB1NUwfyj+uwddWzdBGLnF4WtmDj8SF/CwzXbTV6sbya6m20oX5ZuBtJzh1jAao20NKog2Vw8e62sW
 dD3AblIuEYzCcGzcFwMYhWrRi0+Dl/ZSYYnXS7dMi25vKzssSuwG5b92Mbd6RyB8dMzFw9NZN+ZWY1/kBAWg7wtXMgpiIWEIfWNUAsLEK8RRFp8mVGGsxC5x
 EoTjjo+Gs5rPewz8O4Hcwdbwhf96oChPJEuCcGl4C3Nc/VHnkARLN8zDU0WB+v61O8qstDxa3Nd1VaWNXAF+5Fsu93qRwQQeADXen18UUP8=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonathan,
IMHO it is unfair that I am not the commit author of this patch.

Thanks and regards,
Dario

> Il 08/07/2021 20:04 Jonathan Lemon <jonathan.lemon@gmail.com> ha scritto:
> 
>  
> An earlier commit set the pps_lookup cookie, but the line
> was somehow added to the wrong code block.  Correct this.
> 
> Fixes: 8602e40fc813 ("ptp: Set lookup cookie when creating a PTP PPS source.")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> ---
>  drivers/ptp/ptp_clock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> index ce6d9fc85607..4dfc52e06704 100644
> --- a/drivers/ptp/ptp_clock.c
> +++ b/drivers/ptp/ptp_clock.c
> @@ -232,7 +232,6 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
>  			pr_err("failed to create ptp aux_worker %d\n", err);
>  			goto kworker_err;
>  		}
> -		ptp->pps_source->lookup_cookie = ptp;
>  	}
>  
>  	/* PTP virtual clock is being registered under physical clock */
> @@ -268,6 +267,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
>  			pr_err("failed to register pps source\n");
>  			goto no_pps;
>  		}
> +		ptp->pps_source->lookup_cookie = ptp;
>  	}
>  
>  	/* Initialize a new device of our class in our clock structure. */
> -- 
> 2.30.2
