Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DDC2B8A5D
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 04:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgKSDMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 22:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgKSDMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 22:12:51 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A07C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:12:51 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id q34so2900801pgb.11
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hlb3ykzrmHyooRNvpbR1/H/br17R4COc5dYvM60quWE=;
        b=Klq8t8t/zItkBjjKiWp1R6rRr/fKGEMwUx9YT5uYMFDM3ocbZVqeQqCtbxLjTp6sRB
         nRH/mWPJJRhaRvKMA7YSEZezoRIraWrdTlaFbb1fu1YTDEfOj9cVbSQP3Sk4CT/vVRW4
         sxjkgeReUhDWSZk+8iEFmP8aUxCqmoawicuVOJDnjpA3nspGF4Xv3s39Xl9V1G+DdCsh
         ZelVvmdW1mzVSyxq8vj+1XD+0QWph3MjZ8k0FzjcrfxJJ17QgEysv1pmHGvOHpJdLes7
         p3WSlG2btuJUeItkjy3+HRDuyJvHXQtdOq+TZaw4iyFyjSVO2N//18N9GDSu936PFfD7
         xAAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hlb3ykzrmHyooRNvpbR1/H/br17R4COc5dYvM60quWE=;
        b=IbNyjxKI7z+tVWe721WIENyCsy6a59/dCvyzz6hW/3anP/6e1tJqMJfXPK4ilD7BDy
         bkc0zqGOMnmu1cjc9ysTQxDGlYd1Kn5H5AbUxlv6yVZBJnNAOq6XR/kwT0wkDe9poTCC
         aEx4+kf4IKS/uB9ysC4+TyYPDwnX/pePAN3u8AEw1MC3aiVTVC1oVKRPA3apr93jFsRo
         1etRvBx2/Ep5TKjApdM4kDQ5ZAU6z6nj2uga6EeKmeEmSTKcFT19EYMpadLuoRTIFiJ+
         7lQjL8uEPB8BqjLuYxgmQwGvaDMELj2Tj26sUduvC9YZCn+Ox6dQzOnusyg2ujchwpqP
         C7gQ==
X-Gm-Message-State: AOAM5339sU/HYjhtjlnnTDq4pdijaZ52HCdfHbgKoVpoGaoSaytCazsA
        zUut9LSKV7+TG8+gJc08okg=
X-Google-Smtp-Source: ABdhPJwxgjOIYFw3qtGlDsCqne6UCrzSdE4z0L3xc8MAPwMijPgl9bh+8OIMPD4noLFaSGITxI1Grw==
X-Received: by 2002:a62:7781:0:b029:18b:5c31:5c27 with SMTP id s123-20020a6277810000b029018b5c315c27mr7553074pfc.70.1605755571124;
        Wed, 18 Nov 2020 19:12:51 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 19sm12891474pgo.80.2020.11.18.19.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 19:12:50 -0800 (PST)
Subject: Re: [PATCH 09/11] net: dsa: microchip: remove usage of mib_port_count
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, davem@davemloft.net, kernel@pengutronix.de,
        matthias.schiffer@ew.tq-group.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-10-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6fdce97d-efb8-a8cf-8cdf-91a63c0a73ee@gmail.com>
Date:   Wed, 18 Nov 2020 19:12:44 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118220357.22292-10-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2020 2:03 PM, Michael Grzeschik wrote:
> The variable mib_port_cnt has the same meaning as port_cnt.
> This driver removes the extra variable and is using port_cnt
> everywhere instead.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
