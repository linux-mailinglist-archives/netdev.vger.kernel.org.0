Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C564229E2C1
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404444AbgJ2CiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404438AbgJ2ChT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:37:19 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1CEC0613CF;
        Wed, 28 Oct 2020 19:37:18 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 13so1111009pfy.4;
        Wed, 28 Oct 2020 19:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SfPETHJW2bmykg6fooNc2zKiaqTDW1VZc2TFcTnVdDQ=;
        b=q9NVcsWumb0BvVd7t17D7q3L8lpBvEaRkcqzGGHDO5z+CrqRkZZVXxPFOCIsMa8ZIe
         Qp8fnOFdoqcPhY5o6kNLTFnAqG3HXy2VlL48fWZunRI3BCDq1U4zNpFYCO58hdnqvF4R
         YTI/lxVtolU72nq3PJCsRLDTbkK+UilS5uhAM8FNcl1kthZwdJIYf4gHuPxjV2xAXA7u
         S2BrUs4fCcMT+UFa8nRtP4zIl25GSh/BMw1Uupazf26lM78cM3qF7wgFZFWcnfn7yAWm
         0xgCZzk23S2WqWEnMXlPoPJfohI25dY09C3J4kq9ZrMCKDB7OSuK/Tt+nwXxzfhNAFgM
         s05w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SfPETHJW2bmykg6fooNc2zKiaqTDW1VZc2TFcTnVdDQ=;
        b=hOPLJ54rTX/4TShVQ8Tfl0zHMLRNjhb5dQalzTbPMfZG/q7D6gIxDt2QftCY8e44z8
         j7cAVnHAvfj83jefh9btazmxPMrdofHMYf8GDVT5M3SKptpGLdcTI9D6ZXr7PxWXIJR3
         TJj7O2puI0U9W0Mytpip15QaEPrLNadDjE3SFqLGJZe0LRglaE0RQBAlAPBC9A6R0GRN
         ez9MDKj0hbZvxyf2QdNI30iMnk2HwH5+NYyeZf/E6b4JngHEEO7M7As3SXnHwGMYqtFC
         MbTg7AlfvajoxHfYCFT4PA/ja8pPW2iu4qJ5WE/0kYyVM4E5AHZNGu5pAKPDfwO1dHJy
         DRZQ==
X-Gm-Message-State: AOAM533WJ9yHj7UonIN2hhpMGli4K2xtYo5B76St9q1Vsyb/18489Np0
        qpiywS5DHaelU+hhxEAst6fe+KmPvio=
X-Google-Smtp-Source: ABdhPJyyY/uc2C6iB73OdiRrVISho6mhFUh/DXypEfPwm0mG9dT4pRWYmo/FrMNSpSy690ZCqdYLFQ==
X-Received: by 2002:a17:90b:204:: with SMTP id fy4mr2054895pjb.156.1603939037529;
        Wed, 28 Oct 2020 19:37:17 -0700 (PDT)
Received: from [10.230.28.251] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z3sm906832pfk.159.2020.10.28.19.37.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 19:37:16 -0700 (PDT)
Subject: Re: [PATCH net-next 4/5] net: mscc: ocelot: make entry_type a member
 of struct ocelot_multicast
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201029022738.722794-1-vladimir.oltean@nxp.com>
 <20201029022738.722794-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5831e03c-1714-4ac8-3073-d18f807aff26@gmail.com>
Date:   Wed, 28 Oct 2020 19:37:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201029022738.722794-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/28/2020 7:27 PM, Vladimir Oltean wrote:
> This saves a re-classification of the MDB address on deletion.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

[snip]

>  	mc = ocelot_multicast_get(ocelot, mdb->addr, vid);
>  	if (!mc) {
>  		/* New entry */
> -		int pgid = ocelot_mdb_get_pgid(ocelot, entry_type);
> +		int pgid;
> +
> +		mc = devm_kzalloc(ocelot->dev, sizeof(*mc), GFP_KERNEL);

If the MDB object is programmed with SWITCHDEV_OBJ_ID_HOST_MDB then you
would need this gfp_t to be GFP_ATOMIC per
net/bridge/br_mdb.c::__br_mdb_notify, if this is a regular
SWITCHDEV_OBJ_ID_MDB then GFP_KERNEL appears to be fine.

Looks like this existed before, so that might have to be fixed separately.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
