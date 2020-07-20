Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58780226BCF
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389084AbgGTQok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389062AbgGTQoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:44:38 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31E4C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:44:38 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id s23so470791qtq.12
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NbyVQM7fPeSdvONF5Kg3tQzqW3ZF+2itkrSRzGOxHxc=;
        b=IHT/tFwiRH1Yb3ucXykys8vdtaM5+5TOM54i9W4qHPmVruOc5NKByOxDx44F5R8mnB
         jim8BM3gnTHsxzKsW3TvhTCdP+x4AXDSWUSFx17p3utzASNd96EsQ4eTPkYrU9IyGh5V
         hc1OdF0+X4J+ix+TxnQ7OrsDVtH4Ft3ik8JNV16Dnr0QoiA+ogsMEuDn9tp1Reipz1+q
         f5XInl88vnkce7ZPM7lC94IUIY1uAomh4yKU3V1+A+Zv6hZOJD4wdbzt1pYGmHWRG/ZM
         o7RMy3a7jg4WbWPTZK4CJUrQP+r49F6cGvlUb6UIzaExO/nM/BgJ4GVBPlVX4pEfukI3
         BJ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NbyVQM7fPeSdvONF5Kg3tQzqW3ZF+2itkrSRzGOxHxc=;
        b=pjkAxg0NDz1LW/WhHaWE8RCUpUaCXHD/rMDtFjv59rMfAojIZJMlUcefk4nGopRfJ1
         Qd0leqPndhUlNreQ7MPsB3I+Rsue6tHx83bY6ylSSVkQUu0iVzHyXckX7iXr5Wc8baWt
         K8vJ3f7XLYJyBs/QrOHpCQi1i57eW803q1F98YM9kAzTL1Kmkmslpvdt5NfgevKXNXPe
         VOf22b+98j8NfqMYxC5HD8AOyucP9KPGBMtlE59D26gCSuKsAKWEoianVe/LK8EpDMzO
         XTX8/xyyRQBkcugbejPkRheZGihUn26KtMnZfaK7VTEIb6sgpvogcb8XDeqV7r55S1OY
         z6XQ==
X-Gm-Message-State: AOAM530V0UbiYg4xH9EF6/3ysHskY41NKrMt4kAbkHr0sBRU5VGJNj5l
        bgxaRZ1xBz6WxQS8Cu4S1rEf7ZO0
X-Google-Smtp-Source: ABdhPJzag9h/SWGSkkSIOuffZI09094oG9D06PA0Yw4ne53VSdjk3+krH4ZQ3j+2gJJlcmR23jo6Gw==
X-Received: by 2002:ac8:1baf:: with SMTP id z44mr25437292qtj.129.1595263478018;
        Mon, 20 Jul 2020 09:44:38 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:247a:2d5a:19c4:a32f? ([2601:282:803:7700:247a:2d5a:19c4:a32f])
        by smtp.googlemail.com with ESMTPSA id h197sm83124qke.51.2020.07.20.09.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 09:44:37 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 1/3] devlink: Add a possibility to print
 arrays of devlink port handles
To:     Moshe Shemesh <moshe@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
References: <1595165763-13657-1-git-send-email-moshe@mellanox.com>
 <1595165763-13657-2-git-send-email-moshe@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <84c465a4-867e-80de-f38b-9fb7da733e0e@gmail.com>
Date:   Mon, 20 Jul 2020 10:44:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595165763-13657-2-git-send-email-moshe@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/20 7:36 AM, Moshe Shemesh wrote:
> From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
> 
> Add a capability of printing port handles for arrays in non-JSON format
> in devlink-health manner.
> 
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  devlink/devlink.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index 6768149..bb4588e 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -2112,7 +2112,19 @@ static void __pr_out_port_handle_start(struct dl *dl, const char *bus_name,
>  			open_json_object(buf);
>  		}
>  	} else {
> -		pr_out("%s:", buf);
> +		if (array) {
> +			if (should_arr_last_port_handle_end(dl, bus_name, dev_name, port_index))
> +				__pr_out_indent_dec();
> +			if (should_arr_last_port_handle_start(dl, bus_name,
> +							      dev_name, port_index)) {
> +				pr_out("%s:", buf);
> +				__pr_out_newline();
> +				__pr_out_indent_inc();
> +				arr_last_port_handle_set(dl, bus_name, dev_name, port_index);
> +			}
> +		} else {
> +			pr_out("%s:", buf);
> +		}
>  	}
>  }
>  
> 

Why can't the 'if (dl->json_output) {' check be removed and this part be
folded in with the context handled automatically by the print functions?
