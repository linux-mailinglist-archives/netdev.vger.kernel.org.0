Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36D3C9F9E2
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 07:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfH1Fiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 01:38:51 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33507 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfH1Fiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 01:38:51 -0400
Received: by mail-wm1-f66.google.com with SMTP id r17so876279wme.0
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 22:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=czAr2A3TwP0QMru7//H5vTli6j5BKfOCKk3bGjvej+c=;
        b=U1cL1WY3OQKb3vwYPEh8EYlzVdzHHbC4q9EvTwMudgsqdIXlGyvXBcJmxEpv8klWOD
         9M6ILnb2fXznyKEELhNeLw/kRyMW2u9IdpHxd0Ngyi1TNxgh2yuqsi9t59tGEIYTCNvL
         bMyWXU6Z7bwqplWuG91fW8ngXhqImEmyVxKbj8bw4aiRXFsjNsEguHZf6fHtLRkrHoOv
         IbnpVV8AKumzsG3UOutY8WJELLDIG60R7G22QBV7/GNyvyMIz481Z3BV4L68PTbWcxew
         oM1jynL4/LraEdpPIWlkPgzW4rUx2qbVIjLwGvGF/VYCnPkZasmOg1gpj7tCoAt8ycpS
         /MiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=czAr2A3TwP0QMru7//H5vTli6j5BKfOCKk3bGjvej+c=;
        b=M6blXEj6fCTFXQxuxqIitWFmSE/uJ6YWMJNj8Smrc8ePOA70/oELPP1k0UvJIHFjoi
         1Gmp3EAtIrLTd3V+LGUSMvBDLkdy58mCZcpck1xzpsJt4PjC09B9mNq48OkWKHETQ906
         aoG02FqCK7RHwjVSdN61aXxdWTK5cVCa0P/DyTOk8g4BWCQgYxQbzZ/QHGSj3EbyIxur
         HkEYB82ooSmx2trwhaYdpfx/y8VYhouZQmDR4YWboyUgi7gVdj9z/qQfhOyqnZnpSmby
         wD1OiFLhinVorn0rM7BOk6Npx5C8pHZRPvmOZfhcuF61tIta84w8ybmTONjMPmBcB6yr
         F4RA==
X-Gm-Message-State: APjAAAUv+2wk58kJZrPg9CI09IJqa3ma8IAfWgzhWmZYIP38KG/f6g1i
        7Ilk7+KXZRBV3SRha9Kume0=
X-Google-Smtp-Source: APXvYqzFUO2U0yNBSPZVPMRw0QsR2Qd+PgmMoUq2XUM5SlO5c4oGz95SEmRW8gIII0QyHT3gVCdjbg==
X-Received: by 2002:a1c:c909:: with SMTP id f9mr2460373wmb.52.1566970728941;
        Tue, 27 Aug 2019 22:38:48 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:3ca9:fbff:ec1b:c219? (p200300EA8F047C003CA9FBFFEC1BC219.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:3ca9:fbff:ec1b:c219])
        by smtp.googlemail.com with ESMTPSA id s64sm4270245wmf.16.2019.08.27.22.38.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 22:38:48 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: force phy suspend when calling
 phy_stop
To:     Jian Shen <shenjian15@huawei.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, davem@davemloft.net,
        sergei.shtylyov@cogentembedded.com
Cc:     netdev@vger.kernel.org, forest.zhouchang@huawei.com,
        linuxarm@huawei.com
References: <1566956087-37096-1-git-send-email-shenjian15@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1d549709-9bbb-a199-9430-bfc2012c1dcb@gmail.com>
Date:   Wed, 28 Aug 2019 07:38:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1566956087-37096-1-git-send-email-shenjian15@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.08.2019 03:34, Jian Shen wrote:
> Some ethernet drivers may call phy_start() and phy_stop() from
> ndo_open() and ndo_close() respectively.
> 
> When network cable is unconnected, and operate like below:
> step 1: ifconfig ethX up -> ndo_open -> phy_start ->start
> autoneg, and phy is no link.
> step 2: ifconfig ethX down -> ndo_close -> phy_stop -> just stop
> phy state machine.
> 
> This patch forces phy suspend even phydev->link is off.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> ---
>  drivers/net/phy/phy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index f3adea9..0acd5b4 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -911,8 +911,8 @@ void phy_state_machine(struct work_struct *work)
>  		if (phydev->link) {
>  			phydev->link = 0;
>  			phy_link_down(phydev, true);
> -			do_suspend = true;
>  		}
> +		do_suspend = true;
>  		break;
>  	}
>  
> 
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
