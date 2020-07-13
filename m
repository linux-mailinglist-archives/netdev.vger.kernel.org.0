Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E8721D776
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 15:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbgGMNpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 09:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729873AbgGMNpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 09:45:38 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89652C061755;
        Mon, 13 Jul 2020 06:45:38 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id n2so13738111edr.5;
        Mon, 13 Jul 2020 06:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qhevLNzqIY18aN/wr6u6dhwAFYFM0C8iq2L8OEb+kGs=;
        b=Zco6WLh1gHLq9ofieCcTsVnVgxGxMSvX5PMVP8dScAEfSEcZIM6fzvoI2YCUiTr953
         E0+6tQCtFpYLamgC7BJpN1bH4rJWf2vFJ/hN+z5CkAd5wN78F9Ug5OUX+zTkdJOYoQ/W
         r4gk2qpTW2sV0FeMHlTZS/uid7ltOJpq9BGS3MfLJPIpMz2ZPRRd7NXz9yFkXihCPo9x
         Q009oqUiWBL24xy3wxUGX7NjLj9TJAgokQ/XlNj8QZs2zGDv9kL5ScadFMWXfPBnHzKu
         7r/5BVy/aiMJJuytWkgd8QvxYC3afecfyvK1UM3OnbnG1Ixkw4tuzppAF7x4Dr3GD/31
         JDcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qhevLNzqIY18aN/wr6u6dhwAFYFM0C8iq2L8OEb+kGs=;
        b=aNvJcNAHZTZuqeC5d79R+CiP6MFm/q78/ofy+wViO3u7H5voz54ZvacXO90eT6H6zT
         fDfLnzpjftsPvG5fe69Ln6buZy/g1mA/MrRlL4B1oDK2pJdkSzkE10kvj1wrUEIgz4ZT
         +QUdntPFWf0VKczssj+ri8x689ZzYEqAgut9QQ5u0HQlUgt72hphhsocgiTFhd/DlpYY
         r8QRzkgmxfiyhtc5k8tDmd2oJel3EwU6vHHs24C9/jd5JHldCf8b4IA46/iwK+eJ3LV1
         +zmpRRvK1OFrUYqpd+dow94Ea95cahMOdjCitxVTu647ANRIIJq5qVfcCrP7r/PHXi47
         OHmA==
X-Gm-Message-State: AOAM5336MKzbYFjpFEsJKEjRpZBAIpuA7KdBzHhixySW+G5XuZMIKmCM
        1MrtDrSlUI9DVJuA4CDWu+i9fuGZoA8=
X-Google-Smtp-Source: ABdhPJw8tcl7JEi/xxx+7c1G1kruZxLTgevyq466t9suOvpPgeEnjCnFABfVtglpp72QMrlY9qInqQ==
X-Received: by 2002:a05:6402:b4c:: with SMTP id bx12mr33646902edb.157.1594647937071;
        Mon, 13 Jul 2020 06:45:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:d1f7:b47e:ecba:b607? (p200300ea8f235700d1f7b47eecbab607.dip0.t-ipconnect.de. [2003:ea:8f23:5700:d1f7:b47e:ecba:b607])
        by smtp.googlemail.com with ESMTPSA id gr15sm9522994ejb.84.2020.07.13.06.45.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 06:45:36 -0700 (PDT)
Subject: Re: [RFC PATCH 12/35] r8169: Tidy Success/Failure checks
To:     "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        helgaas@kernel.org,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     bjorn@helgaas.com, skhan@linuxfoundation.org,
        linux-pci@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200713122247.10985-1-refactormyself@gmail.com>
 <20200713122247.10985-13-refactormyself@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e6610668-4d16-cbaa-8513-9ca335b06225@gmail.com>
Date:   Mon, 13 Jul 2020 15:45:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200713122247.10985-13-refactormyself@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.07.2020 14:22, Saheed O. Bolarinwa wrote:
> Remove unnecessary check for 0.
> 
> Signed-off-by: "Saheed O. Bolarinwa" <refactormyself@gmail.com>
> ---
> This patch depends on PATCH 11/35
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 206dac958cb2..79edbc0c4476 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2656,7 +2656,7 @@ static void rtl_csi_access_enable(struct rtl8169_private *tp, u8 val)
>  	 * first and if it fails fall back to CSI.
>  	 */
>  	if (pdev->cfg_size > 0x070f &&
> -	    pci_write_config_byte(pdev, 0x070f, val) == 0)
> +	    !pci_write_config_byte(pdev, 0x070f, val))
>  		return;
>  
>  	netdev_notice_once(tp->dev,
> 
Patches 11 and 12 are both trivial, wouldn't it make sense to merge them?
Apart from that: Acked-by: Heiner Kallweit <hkallweit1@gmail.com>
