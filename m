Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FAEEB88A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbfJaUox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:44:53 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33770 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728257AbfJaUow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:44:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id 6so7416884wmf.0
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 13:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dB1uRfPpjGptkM5fp/8f4cg3SEJ+eKF9+60Aj4sYSy0=;
        b=ikZQGogropp//1C+/WLErHx7xuoazyHJ3FCwA1XShxPcW7ykRtvd+YIrQjlxhYqNf3
         mGx33+ZkyKxS8ldN+ZGuCgRgILMKo+AFKL7/o4Anr9B9DzFTMnwOAyWhE3XZjTR/rjat
         i1lOULrt+nEmyFfL1eISxSDkP0evC8+9A09+1gvSqdjl6uL7XzS1NstgSHl/pdxN967u
         axuQY7g/Jz7elJdUYSO+LzJS+UWr5whhCSlEEmf5i5ETYS9pyjNeG8gt7EKqIFB4oztE
         0RctP9yJMfdWtwF7c4oVuRd5vQD2j2ZdRdVDsQwK0lgoC6ufHDffFGbbFqFoyn91eq/m
         z6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dB1uRfPpjGptkM5fp/8f4cg3SEJ+eKF9+60Aj4sYSy0=;
        b=FSgDrONlEK8JikqfOd47GZC9+svjmF6u2o5YqV7949CGLcpQnYYS7TQYAYx/yOs1wK
         wQcWZpXSIo2J0QjZfumKUA7U8wYa/WhBr7PZPKcj4QP1bY3qminEbk/GrvEWEDNpFVzw
         iYZ0J91nuTkpy8IG4QL0quIXH2YatcUVkyv+kyN0pYcA32g4oIABNxwQSPe8+PvWrHXB
         WvXolKq5XfZKVSD55FNPKs1dfxewkOkANuVVg0Jn4dRXgDqmSp/L8nwIfJ62kbR9awed
         Uw3yw9Dfs2D+HgJP0LZEv0UxDqabyicYf4GIWuZoaOTYfgpsoxwBmKUlUO+JRfiUY5s2
         cClA==
X-Gm-Message-State: APjAAAWoLdapco0f5TmTX0MCV6ZmZT/skBxcybsndpQMCT2TZ1+5R2rc
        +dDYVLh5nR+ksCdp/bgA3YvsfQ==
X-Google-Smtp-Source: APXvYqz1LZyA7AlmZMFDm1n5K6yUZpJ/JHCd9Y4N/JNAqKd10lI4tdP8z6407KDDeLQxGtWA/LGrSA==
X-Received: by 2002:a7b:cf35:: with SMTP id m21mr7167689wmg.145.1572554690421;
        Thu, 31 Oct 2019 13:44:50 -0700 (PDT)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id 74sm6791420wrm.92.2019.10.31.13.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 13:44:50 -0700 (PDT)
Date:   Thu, 31 Oct 2019 21:44:49 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     kvalo@codeaurora.org, stas.yakovlev@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] ipw2x00: Remove redundant variable "rc"
Message-ID: <20191031204449.GC30739@netronome.com>
References: <1572529580-26594-1-git-send-email-zhongjiang@huawei.com>
 <1572529580-26594-2-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572529580-26594-2-git-send-email-zhongjiang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 09:46:18PM +0800, zhong jiang wrote:
> local variable "rc" is not used. hence it is safe to remove and
> just return 0.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

It appears that there is only one caller of
libipw_qos_convert_ac_to_parameters() and that it ignores the return value
(which, as you point out is always 0). 

Perhaps it would be cleaner if the return type of
libipw_qos_convert_ac_to_parameters() was void.

> ---
>  drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
> index 34cfd81..df0f37e4 100644
> --- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
> +++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
> @@ -1005,7 +1005,6 @@ static int libipw_qos_convert_ac_to_parameters(struct
>  						  libipw_qos_parameters
>  						  *qos_param)
>  {
> -	int rc = 0;
>  	int i;
>  	struct libipw_qos_ac_parameter *ac_params;
>  	u32 txop;
> @@ -1030,7 +1029,8 @@ static int libipw_qos_convert_ac_to_parameters(struct
>  		txop = le16_to_cpu(ac_params->tx_op_limit) * 32;
>  		qos_param->tx_op_limit[i] = cpu_to_le16(txop);
>  	}
> -	return rc;
> +
> +	return 0;
>  }
>  
>  /*
> -- 
> 1.7.12.4
> 
