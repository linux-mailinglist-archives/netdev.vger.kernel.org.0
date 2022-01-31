Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C10F4A52F5
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 00:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237462AbiAaXLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 18:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237418AbiAaXLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 18:11:50 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F96C061714;
        Mon, 31 Jan 2022 15:11:50 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o16-20020a17090aac1000b001b62f629953so698922pjq.3;
        Mon, 31 Jan 2022 15:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wjPghJ2FTNZ5W0woqreUfJCGSMslHYBonQKjH2YGK/c=;
        b=CvdPCAeHHR21ncoEVeefAryOB7PeUjmTLQpgdRDC71EmL1xqO3H+Hx4DW6HE2p0RFf
         O+T7udhR7D6dm31kO8XXiapdKceb9tJHB0n876eluLE2DyU4uhX/zrsJ2PbFqQaabhtF
         NsWZ5Ri+sYInM7Tjv5Y82XzF+NtEsifDn83nmHX5NzsVqox/0hnr/SdqT+wMmR03nGBv
         r/rBHKKKAXbDSYJlzTA1Kycs8/GzHt1eYLp1squtI6DwJM5wPja2DlSOvk8ljLPF8PYM
         1fefTAVgAYWolPAauJuYoibcEahy9yWVDu8iMenxd71y9ks90zBECKtXEDdHKPNC2K1Z
         grbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wjPghJ2FTNZ5W0woqreUfJCGSMslHYBonQKjH2YGK/c=;
        b=Gi9U/T7/Hq4Tn3hYxzAacP9lhQ42ScTt34OrYAsbc3975CqEgkvS96GfnPKr9b4vih
         tbIaCnjQhw2kzG1JbWTJHACHsIXdJLgC+IyBGOdAWEM0U7AAqQuVQtnH35GlxDPlJqB1
         He3N66iigz9KYIYEaX6ZWZwnf77w2az+ZYqvZ+C+JWKZM+nc2fWqCaQewU8b1aoSsaU3
         wKCAj80etHhernwJEjjdn8uRIw+uvAB9jTUOqqF9qqVL7UAehMxoeM4+gf+9w+QbziHe
         KRGii1twZAti8OD6lBZSlQikxMs9cZcwHoTC/WNEFmUj7LMo+5b/2CQJenbyCciklLAo
         KCfw==
X-Gm-Message-State: AOAM531Trmdj7XOV+3coYBXJ9k9sYWKBpqaZiX/E9Yn9BPevuCCN+Tg3
        7hVvNAALXfyc9PRXpO0rZ5A=
X-Google-Smtp-Source: ABdhPJxQ2tP/Cu7ZsuYkoiUe8W9KnvlUk5iFT3DsEwgDbApIk6MQqNi0ruCaBHn7qX2M4CJk/c2ryw==
X-Received: by 2002:a17:90b:33c6:: with SMTP id lk6mr26990073pjb.213.1643670709597;
        Mon, 31 Jan 2022 15:11:49 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id j12sm19449219pgf.63.2022.01.31.15.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 15:11:48 -0800 (PST)
Message-ID: <38635f9f-eec3-57fc-a72f-7cd6b0a0c590@gmail.com>
Date:   Mon, 31 Jan 2022 15:11:47 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC v6 net-next 1/9] pinctrl: ocelot: allow pinctrl-ocelot to be
 loaded as a module
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-2-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220129220221.2823127-2-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/29/2022 2:02 PM, Colin Foster wrote:
> Work is being done to allow external control of Ocelot chips. When pinctrl
> drivers are used internally, it wouldn't make much sense to allow them to
> be loaded as modules. In the case where the Ocelot chip is controlled
> externally, this scenario becomes practical.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
