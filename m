Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A733FEB35
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 11:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245638AbhIBJ3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 05:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343507AbhIBJ3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 05:29:12 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE44C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 02:28:13 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id g18so1808394wrc.11
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 02:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JulsKOOHoUI648OBMneLJD+Pe4T/1GCL07CNgEfZXgk=;
        b=rvX9zXCID20fIilvSAkjd4Ra9SnD24QjvpUrI6S1ze5XFnydaO4qW+BEsfoFNGCvpe
         8h+uMZG5ERJA2X+9BfuQxTv//xrju7s2W8HlEl4cwfAWZY83IAf3eh8ab9EoHAUAu1Y+
         2makvCsDrQd0ggTyLREza3i6Xp2H6YErAiqubL7CS6xjSNRfRMzaFOu04J3MuLBJJTpy
         KLuHysnpMQ+aQ0QVaF6jci/cCB0dKxq/VaZaT3it9ggFNRbA8L0uTcQUL3zgz4UcgZfI
         qSFMrogIpYuyzhZ4UxigzMfGAv0DQy+8SKvIRZnTdP1Ngzf1O7cvbopfo+p3P2EOSM6A
         4Neg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JulsKOOHoUI648OBMneLJD+Pe4T/1GCL07CNgEfZXgk=;
        b=lEAT17I+fge6jjBSNY2EJT+++GySms/IurRzUwT3LEj0gwLyyKUQTwPonAKYjFky0P
         uBSihL7lpCAFy4DpAt/rKY6eWnpZ4FDjVUSWxdhh70D3EDnS6HcrJHJVQp7BFwFWicsF
         nJaz2EBlMutVoCFAmFvUY3BGozIH66vxFB7KRLH2+Jluv/k9Q3ejN7a6qIYAX8HVZlP+
         R2f9UTpoPuE2FADcnbpP3fkGOf/LlWia3vtZARBBKivHGd7NujPG78qxPgrW/WmARDY7
         O4DX5H2ySYbO/JJnHIT/TY8JPiKoPgL5PwLoRIzHN4Cad9tr6d0PZ1vut6nmsRiBZdgR
         NXmg==
X-Gm-Message-State: AOAM532deOf4n1U6/SnUNxxUICsWqxFz58rD6WllC+cZ6ANouuC/1MRH
        odjYnHPe6Z2dWPIAmeH5hc5YqoTUVtMp7A==
X-Google-Smtp-Source: ABdhPJzFyo8/t2ymlfo2L3m7r4EgO6FKW9Ly2eu67gMFWa75yF0K65Cnk4haXpEkH2rlnwViTpCkMA==
X-Received: by 2002:a5d:534c:: with SMTP id t12mr2494344wrv.219.1630574892606;
        Thu, 02 Sep 2021 02:28:12 -0700 (PDT)
Received: from [192.168.86.34] (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.googlemail.com with ESMTPSA id z5sm1123749wmp.26.2021.09.02.02.28.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 02:28:11 -0700 (PDT)
Subject: Re: [GIT PULL] Networking for v5.15
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        John Stultz <john.stultz@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
References: <20210902092500.GA11020@kili>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <38288aff-71d4-bde2-7547-dff5ca20091c@linaro.org>
Date:   Thu, 2 Sep 2021 10:28:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210902092500.GA11020@kili>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02/09/2021 10:25, Dan Carpenter wrote:
> I'm sorry John,
> 
> Can you try this partial revert?  I'll resend with a commit message if
> it works.
I was about to send similar patch.

This should work, I think your original patch introduced a qrtr packet 
payload alignment constraint which was not there originally.


Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

--srini
> 
> ---
>   net/qrtr/qrtr.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index 525e3ea063b1..ec2322529727 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
>   		goto err;
>   	}
>   
> -	if (!size || size & 3 || len != size + hdrlen)
> +	if (!size || len != ALIGN(size, 4) + hdrlen)
>   		goto err;
>   
>   	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
> 
