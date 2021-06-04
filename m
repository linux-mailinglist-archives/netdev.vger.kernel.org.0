Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8965E39B447
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 09:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhFDHvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 03:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFDHva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 03:51:30 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2168C06174A;
        Fri,  4 Jun 2021 00:49:28 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id v206-20020a1cded70000b02901a586d3fa23so790112wmg.4;
        Fri, 04 Jun 2021 00:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xnoAUTpaCdypfBGwnpMOOc1nDOXkUvW0rC9PluekUyI=;
        b=M02mDnDnLn3DFse45nzkc5rhL71fIJFsA8mAfPw7LNOkLlz8pw81zl3iK14Ax4pUZZ
         44fUB/vNWMfXum+2IslOY466KjSoGozUwjXY4bXPcHVerVlQ1j4At+IJZFz1LX3THUQA
         bkUb+IypSGTOVotaaxdiw+f+vuo2nybxFrLP00HspA7k5KuOq5fyXUrbB9jEEtEQSNjw
         E2EW/hqrZ3/zeFrrN1rpSFtS+5Xa3yYeqgZQF1fpdTIa6lN1HnQE8xmmX7XELPH8CGOK
         roSyRdyP6lxzpncmDEdLyAoqNgzLzyS3Rkf/U5TN8A0lj6Ibw+2YG9HoOwlgcmGy52yA
         CnKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xnoAUTpaCdypfBGwnpMOOc1nDOXkUvW0rC9PluekUyI=;
        b=X5g+d02CdpwBLORrd4PoSrjvWFrfQepmQV0b2Q/aDDENleANOl1T2Xx2VBp5IP1lNU
         8cB3SA+aa90+sdNZUxrflV97wgezWChRLhcfAt29lE8SbjY/OHD50ECGisY3IbzGobWo
         iGAmJlZunEuwCVvvBsjpeGtWDQeDpL4LJ0NtRF1ETEJFx9nPXonaRPoZ5XUGj8+//m4e
         efq3QbBkmoDSGoGoXy5tgqStNS+fT8CgulOpYopQT+0C8sxKvjj2eJDRoMTg57s/wY8x
         GRWkit+5yGX87NWgCAXZLj2I5Hq7HVfv9zwXMZzidktQiUogxfHSADqHYXMy/2jwMk3b
         EpVQ==
X-Gm-Message-State: AOAM531ObYjhcMmADxzYC0tIIygTnTt3DZ3qEp/7Kh4fIxoWMPmINSZY
        gmXVLcuytHPkFKS4a+75h8EPqbYVlMI=
X-Google-Smtp-Source: ABdhPJyCtEbHQ06CU3pNlIMIdOcgnuOxX5LAc22pEqBygYYTvl8lcKM4wGFHRxudg3NlZ/ylE/Fiaw==
X-Received: by 2002:a05:600c:4106:: with SMTP id j6mr2288333wmi.76.1622792967484;
        Fri, 04 Jun 2021 00:49:27 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:c00:bdf8:e0de:4417:41e3? (p200300ea8f2f0c00bdf8e0de441741e3.dip0.t-ipconnect.de. [2003:ea:8f2f:c00:bdf8:e0de:4417:41e3])
        by smtp.googlemail.com with ESMTPSA id n12sm5759569wrs.19.2021.06.04.00.49.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 00:49:27 -0700 (PDT)
Subject: Re: [PATCH] net: phy: Simplify the return expression of
 dp83640_ack_interrupt
To:     dingsenjie@163.com, richardcochran@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
References: <20210604032224.136268-1-dingsenjie@163.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <91609670-c3a2-2281-514e-01dfe7907f11@gmail.com>
Date:   Fri, 4 Jun 2021 09:49:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210604032224.136268-1-dingsenjie@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.06.2021 05:22, dingsenjie@163.com wrote:
> From: dingsenjie <dingsenjie@yulong.com>
> 
> Simplify the return expression.
> 
> Signed-off-by: dingsenjie <dingsenjie@yulong.com>
> ---
>  drivers/net/phy/dp83640.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
> index 0d79f68..bcd14ec 100644
> --- a/drivers/net/phy/dp83640.c
> +++ b/drivers/net/phy/dp83640.c
> @@ -1141,12 +1141,7 @@ static int dp83640_config_init(struct phy_device *phydev)
>  
>  static int dp83640_ack_interrupt(struct phy_device *phydev)
>  {
> -	int err = phy_read(phydev, MII_DP83640_MISR);
> -
> -	if (err < 0)
> -		return err;
> -
> -	return 0;
> +	return phy_read(phydev, MII_DP83640_MISR);
>  }
>  
>  static int dp83640_config_intr(struct phy_device *phydev)
> 
This would be a functional change. You'd return a positive value
instead of 0.
