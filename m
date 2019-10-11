Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE5DD38B8
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 07:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfJKFia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 01:38:30 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46134 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfJKFia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 01:38:30 -0400
Received: by mail-ed1-f67.google.com with SMTP id t3so7523887edw.13
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 22:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=sx1bj19NEv6IpbiCrguHwoL1VpsxdRk7Yar5uIZ1It0=;
        b=EbDJhGqOVfLcrFf+Rxoy2ermIfzKpcAluw5m+tv5XrYZuIpGyEtxvq6LH9ZPVJsg7L
         Wqt4TwF0s4YE9X0UuidVNoREy/AgLVTpkhxq94j4f3kWHnO2kTHKbn/eI0v5a9BF+iB6
         uwk6VkMr/P4BI+S4QVBoSCsKN4guBbaPBzTme9kSjIAVt8tgFUME9HOHJCBhNaKI2S7J
         s7kq1cSLtbX5rCDwOSGX6AE6LtxwBULsphfJ3tDilABFcn2poBxJjadw0avC/rp8ct0t
         pie8Yy4B1oi8G3C+yeP3wxqvgMhXCgD6Hv/OahCcoW3u4ugDpweVhvT0zOlTzgYMrhcL
         cZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=sx1bj19NEv6IpbiCrguHwoL1VpsxdRk7Yar5uIZ1It0=;
        b=fZEjmtvDX+JZrVdVVu1n+FCkurnpajoO0Hbf1ZJBCHTBA6mtcIYCmn4EgdYOW5SEn2
         LovI8tqwcTiXQWjca8+cqiNyq8ySjMZ5GscYpDIxPiJATeqmInokOZ0iXz0x1SNbA5kt
         Nw5eT41vvRtfNryHWx+RuVgOxmxmCcM+gFdUm8q7aPCWRaHLcG0XoZp5fbIvTHb3NT5e
         +eGIDsY8CjWVRW73IYR93Dx8s5CcyOKK/VH0U/p39AD2wbZOtups2hqu7fX9gN+bZPa5
         li3r9WFK6sVyyKTpzE568VuNa7BvFnW+sfr8Yz7OmNuVGmE+kIq7NOsSfBOaRR7yjT/x
         i2Pw==
X-Gm-Message-State: APjAAAWmC74B5itb3pWHO11yh7OmI53/EeV1ziobz4rYWyO2fNSiYCDq
        GeDCYhm+cu8OaWoQ+C58OGTp3ehg94Q=
X-Google-Smtp-Source: APXvYqypf66TDQVfrWstIHps9hn3m3sIxSwDhPjNw9FephK9kWBEj+5EAlrLoVW0rKsJPD8C7CfBDA==
X-Received: by 2002:a17:906:8308:: with SMTP id j8mr12229166ejx.29.1570772308913;
        Thu, 10 Oct 2019 22:38:28 -0700 (PDT)
Received: from netronome.com (penelope-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:c685:8ff:fe7c:9971])
        by smtp.gmail.com with ESMTPSA id m1sm1281966edq.83.2019.10.10.22.38.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Oct 2019 22:38:28 -0700 (PDT)
Date:   Fri, 11 Oct 2019 07:38:27 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 1/4] net: aquantia: temperature retrieval fix
Message-ID: <20191011053826.d3mppta6xzw7wx6j@netronome.com>
References: <cover.1570708006.git.igor.russkikh@aquantia.com>
 <8167dd20577261b78fbbd8bcad6c9605f510508b.1570708006.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8167dd20577261b78fbbd8bcad6c9605f510508b.1570708006.git.igor.russkikh@aquantia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 02:01:22PM +0000, Igor Russkikh wrote:
> Chip temperature is a two byte word, colocated internally with cable
> length data. We do all readouts from HW memory by dwords, thus
> we should clear extra high bytes, otherwise temperature output
> gets weird as soon as we attach a cable to the NIC.
> 
> Fixes: 8f8940118654 ("net: aquantia: add infrastructure to readout chip temperature")
> Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
> ---
>  .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c   | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
> index da726489e3c8..08b026b41571 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
> @@ -337,7 +337,7 @@ static int aq_fw2x_get_phy_temp(struct aq_hw_s *self, int *temp)
>  	/* Convert PHY temperature from 1/256 degree Celsius
>  	 * to 1/1000 degree Celsius.
>  	 */
> -	*temp = temp_res  * 1000 / 256;
> +	*temp = (temp_res & 0xFFFF)  * 1000 / 256;

Perhaps while the extra space before '*' could be dropped at the same time.

>  
>  	return 0;
>  }
> -- 
> 2.17.1
> 
