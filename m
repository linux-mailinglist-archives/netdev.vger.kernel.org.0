Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52A73476BC
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 12:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhCXLCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 07:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbhCXLCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 07:02:32 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C914CC061763;
        Wed, 24 Mar 2021 04:02:31 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id j3so27076305edp.11;
        Wed, 24 Mar 2021 04:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KKl0KkEX6t9Xqz1prDQrY1FQVQA6VtdXfFF/5x63PVs=;
        b=K1nMx7uXrTZjhGKAtDMdCiAfrLyVNHcZCMcMaxCm6pZpveVGyxxItuTVIQoNrDkQ8O
         WxC5UkZkRsciM1qyD3M0HoZCl8dt6ZZ76TXIx4VekyJ+93T8tyis1dRh3AIDiUXVjkkk
         SBpzWBuQKsJvRV0XHVjo8RJd1rGpCpA3Orb6tinhEg6sEr6PcuHpI6IQFop0oZRmmTu8
         8V6cGpaXQ0D2GVvcJoKcH3SJ+2iygCxdNs6RzHUDPYqALAU0m2V7Sdro6XeE7JfU37DJ
         3x05TBCtQEHKuU7Q0wVx8QTPUnJ9REf9PSoTMbrRknGPwzk/rFvGel/kCHZND7FFlh9R
         t+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KKl0KkEX6t9Xqz1prDQrY1FQVQA6VtdXfFF/5x63PVs=;
        b=ddT+8SeYLy1Gqw7FCCse9iErkJACwPasX8SSbdB59XFVnlklYiiuJwG+qMfwpl1teX
         Oye69mT989BhylwMsoBttbzDO4xwyVoWRtzuD4PT3rRfLPQiTrViad7MClG8rdfN+hrx
         fOc47K2b+Mzlk/FX2qiePBrFVhHmN+QLBqFeST08ui81YbS67a/PUBD7uaUNJkD+/lEV
         K4yZnnlnnTMIB9MdipgMVD27QRqlQxRUbQd7igABQNf2hj/o/UyJL2L7zW0CMkHMR5YE
         7CGFDOyx/dVIbYPbeKpylED+tvpwo/84Y0ZW68lMhPWS6POGvBnAOtUkO6Q/3Un5EXKr
         geaQ==
X-Gm-Message-State: AOAM530MhBngSrs6QhgKLky4ne+n0TviqrVqgceZA5jKigevrw4zeEw9
        9SXZ7QPvBSR7kbpOKQkI7Yw=
X-Google-Smtp-Source: ABdhPJzkuBuRqf2PPGo9BGJigUH8B3ewGVhBsi5M4rKp1/XTq6oRfu57ZSE9aIC5kZ1y3T9KOa1MTQ==
X-Received: by 2002:aa7:cb4d:: with SMTP id w13mr2752141edt.249.1616583750548;
        Wed, 24 Mar 2021 04:02:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:b93f:6606:a130:666? (p200300ea8f1fbb00b93f6606a1300666.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:b93f:6606:a130:666])
        by smtp.googlemail.com with ESMTPSA id dg26sm951863edb.88.2021.03.24.04.02.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 04:02:30 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: phy: add genphy_c45_loopback
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
References: <20210323164641.26059-1-vee.khee.wong@linux.intel.com>
 <20210323164641.26059-2-vee.khee.wong@linux.intel.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3d344c5e-f1d9-67a6-9cd2-e7ee53cb413d@gmail.com>
Date:   Wed, 24 Mar 2021 12:02:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210323164641.26059-2-vee.khee.wong@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.03.2021 17:46, Wong Vee Khee wrote:
> Add generic code to enable C45 PHY loopback into the common phy-c45.c
> file. This will allow C45 PHY drivers aceess this by setting
> .set_loopback.
> 
> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> ---
>  drivers/net/phy/phy-c45.c | 8 ++++++++
>  include/linux/phy.h       | 1 +
>  2 files changed, 9 insertions(+)
> 

LGTM

Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>



