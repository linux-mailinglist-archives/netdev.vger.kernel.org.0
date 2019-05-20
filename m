Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD93F23E39
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 19:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403965AbfETRRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 13:17:31 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40508 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392788AbfETRRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 13:17:30 -0400
Received: by mail-pf1-f195.google.com with SMTP id u17so7539587pfn.7
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 10:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kLaahNyJDteVyYuPA7Hla97IH5sQOygePiHnSOoUkeI=;
        b=Gtvzu97z445O6uGMv89N2dLIETQ6JHu7Eiq7PzToKyLQWKd6wkhHcrBk9W92NMFlA4
         kaOWpbZQVcmdUezlkfmTeOOWYhPmSdJcghDhT5g52EXJpVKuTnSiN4AM72bigV+4lGml
         QHytfAYDR1ehxN+QQLnLAqEycy6gthhkkXmWO6cF3rC5S/VtffoEH5eGJqMfh2Bf2bgm
         TxbSb//JuVfke9SWMtaeFOH4sxXrEgmw4LsnRjOUJ+5vELTlwrGUy4UDjWUysfMvuPFu
         PUYwNuunDIRwfF7jiPhjSxy/BaKYD9GTZr91pPrbmNj0QnJKukztFzH2vh7Btx+L8TGR
         iK1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kLaahNyJDteVyYuPA7Hla97IH5sQOygePiHnSOoUkeI=;
        b=Y9+vC76K5JrPBev+S5IyYRmFRtHr+myS1ZEXZI4dMJ3BX4t7yU450WA5OJfJX4tAOx
         JhKm0fjQbH4O24D2ZNL2wQu6/DRa6vWj6hi63EuSi1QjlEusSBLSbX4UAcihwCPVovZq
         vS2iumJWs+FGovmxdS/db749ZTze56047RJK62TyAO58NAtudqoE8mNCv7uzfOBMRWXs
         eqvBLYCP0gw+vjT+S7jlp8y9vLWGsQ5MvXr9eR71bBYapXfTFjhIgxa8EygPMDHNLjPG
         6dQV2yx3HgWQXSF5GfJ/O7UTK/UIzOc6iNQjd6K+NMquAijI9zgME2zYmtq7n7M4o25a
         3EmQ==
X-Gm-Message-State: APjAAAWibcKPfsx0GD9znD18+tRtbvt0JCqJ91d7fgRmRv7YoaeAemj8
        uvJAadqfzJ4dvjgoSP1fDIqEbA==
X-Google-Smtp-Source: APXvYqzruiPOXwGzgF8V1G8Uxb9II5ATN51r8f8i36ba81jTt8MDQUaa04iy6oDfh4Yo19Y5yJ412g==
X-Received: by 2002:a62:75d8:: with SMTP id q207mr49266275pfc.35.1558372649589;
        Mon, 20 May 2019 10:17:29 -0700 (PDT)
Received: from tuxbook-pro (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id t25sm30364229pfq.91.2019.05.20.10.17.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 10:17:28 -0700 (PDT)
Date:   Mon, 20 May 2019 10:17:55 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     arnd@arndb.de, subashab@codeaurora.org, david.brown@linaro.org,
        agross@kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, cpratapa@codeaurora.org,
        syadagir@codeaurora.org, evgreen@chromium.org, benchan@google.com,
        ejcaruso@google.com, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] net: qualcomm: rmnet: mark endianness of struct
 rmnet_map_dl_csum_trailer fields
Message-ID: <20190520171755.GV2085@tuxbook-pro>
References: <20190520135354.18628-1-elder@linaro.org>
 <20190520135354.18628-8-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520135354.18628-8-elder@linaro.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 20 May 06:53 PDT 2019, Alex Elder wrote:

> Two 16-bit fields (csum_start_offset and csum_length) in the
> rmnet_map_dl_csum_trailer structure are currently defined to have
> type u16.  But they are in fact big endian values, so should be
> properly represented as __be16 values.
> 
> No existing code actually references these fields (they're ignored by
> rmnet_map_ipv4_dl_csum_trailer() and rmnet_map_ipv6_dl_csum_trailer()).
> Changing their type therefore causes no harm, so just fix them.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> ---
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> index fb1cdb4ec41f..775b98d34e94 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> @@ -52,8 +52,8 @@ struct rmnet_map_header {
>  struct rmnet_map_dl_csum_trailer {
>  	u8  reserved1;
>  	u8  flags;		/* RMNET_MAP_DL_* */
> -	u16 csum_start_offset;
> -	u16 csum_length;
> +	__be16 csum_start_offset;
> +	__be16 csum_length;
>  	__be16 csum_value;
>  } __aligned(1);
>  
> -- 
> 2.20.1
> 
