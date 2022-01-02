Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE14482A5C
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbiABGzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiABGzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:55:47 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBE4C061574;
        Sat,  1 Jan 2022 22:55:46 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id g26so68615333lfv.11;
        Sat, 01 Jan 2022 22:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yKohwUfQEFVBXK7OsXwhTLqP6vf411mUeEybmo+ePPU=;
        b=F392G/xCIjkld3ML3YYQw0ge5dJWPYk9JWX9kegf7axEe/r9OeGsuYw85hSRx3/Z+1
         iasOHUW5o7n0Q49D/FlArWpULj4du7Ra6id65KazF4eRB2ooTEAoGjWn2YFHdjzYMuC7
         4raIxhj05gceuTGNImtcoX66PS1A3VowseeVmKcINXFSQv0YdSqgv3YDGo1aAwoSM6BH
         y2HTShtkNbOG0NrZXrpICdR7yvdk/1MS71vaw27zlQDyhFakrvykrHZcnQqMICEtyD3/
         YDKuss0M/Mit0bC7ApebRIFRA9ZYEw/WlLt13RYPOApE2vY3NhFnJAXqvuVQWB8SGLET
         /P/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yKohwUfQEFVBXK7OsXwhTLqP6vf411mUeEybmo+ePPU=;
        b=Qw8f0neX3cAVXQSZ1Cs+YTT6XqddbMWD05IwIU3gLD6EmIFePEqiMcjU8/3woqZ8sI
         FkCVpJj9+Hd0UJoASXCXzdoi/HSr43ZclyxVklSo5IyRbeT3fNAB8/3FesbMgiKT6/M9
         fja++cEz4nD8A+kG6hrwNNGw4wjcFyNWmefeY76AS0aPHz8gTdnAF/dJjmgKIXecdDkI
         U6BfowCBIypsPXl3bti4iRThY9gpeinFef2HFvlkuv/iDnY7cqsCrmhTzkHLtzzJ2mi/
         5K5BBxN5LlNu+LKzKx2jTnBvJ++FPeGmxlKvH+in5tW3CiCJ3XpU/BEMazPaOIil8zuq
         Z5xg==
X-Gm-Message-State: AOAM530D4vekkYpQBaerqBkXC8qUM+wIjrpW3BXIYU5urmD3Nk4Li3xy
        tfozW5AfKS88ps+7TTlQe6UNr9vFFdk=
X-Google-Smtp-Source: ABdhPJxx8fAdFekFT8jG42etZP+IZYr9utEEtDEqchhhI0D7TO/CCgLvctiL8C3mOsSCNNZOB5/r9g==
X-Received: by 2002:ac2:5109:: with SMTP id q9mr37092799lfb.146.1641106544969;
        Sat, 01 Jan 2022 22:55:44 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id d5sm3268933lfv.83.2022.01.01.22.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Jan 2022 22:55:44 -0800 (PST)
Subject: Re: [PATCH 03/34] brcmfmac: firmware: Support having multiple alt
 paths
To:     Hector Martin <marcan@marcan.st>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-4-marcan@marcan.st>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <ecb54095-9af9-cf65-53e0-2f42029c1511@gmail.com>
Date:   Sun, 2 Jan 2022 09:55:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211226153624.162281-4-marcan@marcan.st>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

26.12.2021 18:35, Hector Martin пишет:
>  struct brcmf_fw {
>  	struct device *dev;
>  	struct brcmf_fw_request *req;
> +	const char **alt_paths;

> +	int alt_index;
...
> +static void brcm_free_alt_fw_paths(const char **alt_paths)
> +{
> +	int i;
...
>  static int brcmf_fw_request_firmware(const struct firmware **fw,
>  				     struct brcmf_fw *fwctx)
>  {
>  	struct brcmf_fw_item *cur = &fwctx->req->items[fwctx->curpos];
> -	int ret;
> +	int ret, i;

unsigned int
