Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9349B2A2714
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 10:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgKBJcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 04:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgKBJcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 04:32:03 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4360CC0617A6;
        Mon,  2 Nov 2020 01:32:03 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id p19so839459wmg.0;
        Mon, 02 Nov 2020 01:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fxn54+spuIXW0t4s3BDcY6uqQBBHMmtfchzkmc933PE=;
        b=ANwLl6TsKpDmt4VwXtzxP4sK2m5hQ+sSgLcptDfFtRRpXprfPF+VMZMHQvGJoxbt/y
         BlLIBeKIQg5P1PwyH8qm7YV8RnvOAdFH+usbJF84uvERnHMRSm2SE2PC9wRhkh72lVo9
         LU1VjePgujid5ieBeWykpvEiksGBdegyA8V/53JE9maeFE+rLK4zw2Db/iNVNYmBqJDy
         W2nO6/aqwQsfyhjeCEcLMlJrMqLSZMzWMJa31n2dc04DqlDE4z89JF6NKQ6KaYubK1nC
         K0smz5QP5rO0XIiiKJtOs8pkjhhvEkQViZirNGaSDfDk5vjsuAEJkWwfxR/6/0XWMKBA
         duOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fxn54+spuIXW0t4s3BDcY6uqQBBHMmtfchzkmc933PE=;
        b=NGo0Z8foF8ruAzvwhdte3/24npR2untygR5L7QbHUPpidAhGztlO56g6qqufZfYzLA
         VK7TBlqLdQ5voVbhJ/Li7QK8Lh1OvMTy3zJ2DtgRBM137gVPkMRqEpNQ6DRKrn99QeJF
         gARIclinSi2ijcEos25TJF6pM71zOg6CJ3sWaAlQT1lwhRklOxtXbp7VdkEHKXw0iO7I
         RrVkCLXOexyQMF5/sCSTY72KBxDTnzVSP1pDh32LyTOSglqUC0S9hyo4YXyTAgC/8Jnu
         wdUWkm9XBtnWL8qSFroN9nqdpZP0/z4VeMmqsHdSB1qzBQCmh5r2tVr6m6glgbQA7CB2
         to9g==
X-Gm-Message-State: AOAM532kTZ3ZJ9ciO7+4H7wBRtZYrXqFcWeWVIyJtI0hJ0K8hc7Q/sSh
        v7Ynqa4jE1DylySHLD1xCSCTm+5C/G4=
X-Google-Smtp-Source: ABdhPJyopv8ojRtnQV+gjgi7YOURbJT35p3dzUR7KcDk9qfqH+rV61n7VQm/cd/WHTU3HCjDS6lY+Q==
X-Received: by 2002:a7b:c4c3:: with SMTP id g3mr16056892wmk.127.1604309521914;
        Mon, 02 Nov 2020 01:32:01 -0800 (PST)
Received: from [10.21.182.73] ([212.23.236.67])
        by smtp.gmail.com with ESMTPSA id f4sm21281301wrq.54.2020.11.02.01.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 01:32:01 -0800 (PST)
Subject: Re: [PATCH] net/mlx4_core : remove unneeded semicolon
To:     trix@redhat.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201101140528.2279424-1-trix@redhat.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <78cd4150-0040-44a7-81cf-02c17d61f463@gmail.com>
Date:   Mon, 2 Nov 2020 11:31:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201101140528.2279424-1-trix@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2020 4:05 PM, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> A semicolon is not needed after a switch statement.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> index 1187ef1375e2..394f43add85c 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> @@ -300,7 +300,7 @@ static const char *resource_str(enum mlx4_resource rt)
>   	case RES_FS_RULE: return "RES_FS_RULE";
>   	case RES_XRCD: return "RES_XRCD";
>   	default: return "Unknown resource type !!!";
> -	};
> +	}
>   }
>   
>   static void rem_slave_vlans(struct mlx4_dev *dev, int slave);
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks,
Tariq
