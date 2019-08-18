Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCFF915B7
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 11:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbfHRJI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 05:08:58 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51382 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfHRJI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 05:08:57 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so488892wma.1
        for <netdev@vger.kernel.org>; Sun, 18 Aug 2019 02:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MXsOHISmCpUILyy9WHiVYPcKhs15OcsHvOVCutfJVTQ=;
        b=VnCEES/UltGfTFiTg/85Nqzwi5/ac6wr6TakwWpR7pOAZlH9NoN4dI+SNQbrTNye8+
         ArfSICQSVhQyfo4G9syzmU00C8Hzn3dUwkMMDfGVws4EIQ9zr8dOp+X4LukKiXZ7VmIC
         zkCyy6Ev4yGgywH69ioOaqXxOm6xPvV++me6ZhKHs1QgOJLY/yZXl2jmnC8D29sYRLHE
         +xhAWaS66VDRWtmazSF3gUeFaQbfC6etJ2lvgmeCxo4zelZjtIr4YLN7c2oAkVfFRrdm
         rcvS7tr74BBsCyDHTylY/ZLZi3wxoAiTuq9hNnxjIYU4HcX0z1vwatZ7a9PZRBbpdSfg
         ktkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MXsOHISmCpUILyy9WHiVYPcKhs15OcsHvOVCutfJVTQ=;
        b=nlfY8BWvU5j21rEpgpLD3cUKV07OVVeQ5D7W2+HT5S2/UgnugeEy27lvU88Hoa2KhT
         1ke+mqBFuClxzMILl38fW5Awq40DuoCsnG2uC/ToCwvoVB1gm7wArjkKG0zNvq6MtAxi
         fQa4VPEwcsq1vf+jKBb/gDgz3CotmEOzhObzCOjovqlwtv1ubE6We9ujhLlZUtSy98TG
         ikBximsbtvNpH5WqMABIcef2Tg+q2sEI9xmOeiYYQ67MBhin4YWpw50T7DhOpn0O8hij
         K2rcTsHwd9V048zuc1pfAH0iJOHpWn7VaF0HRZXyo2NqGdheBdIbPlMLx7K2ql+MQTv+
         TT7Q==
X-Gm-Message-State: APjAAAUWyj8wRkIOdCGA7C9ySZiA0K8fZ8hqRnve7nnpL4Gczl7bYgP5
        rLC9FShX230EhIHZ3b8uqCK424Ei8Hw=
X-Google-Smtp-Source: APXvYqyHX+LW9YR2h2Sapt+smYzR6FMkFbhNfzF9MEfgizCxuJ1WxMrjeaOYDF1/XkV6nlK+MuPFTQ==
X-Received: by 2002:a1c:2314:: with SMTP id j20mr14813865wmj.152.1566119334824;
        Sun, 18 Aug 2019 02:08:54 -0700 (PDT)
Received: from [192.168.86.34] (cpc89974-aztw32-2-0-cust43.18-1.cable.virginm.net. [86.30.250.44])
        by smtp.googlemail.com with ESMTPSA id p7sm8422702wmh.38.2019.08.18.02.08.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 02:08:54 -0700 (PDT)
Subject: Re: [PATCH 1/3] nvmem: mxs-ocotp: update MODULE_AUTHOR() email
 address
To:     Stefan Wahren <wahrenst@gmx.net>, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "David S. Miller" <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     linux-hwmon@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <1565720249-6549-1-git-send-email-wahrenst@gmx.net>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <5883944e-efef-ed3d-fdfb-19d9964762f9@linaro.org>
Date:   Sun, 18 Aug 2019 10:08:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1565720249-6549-1-git-send-email-wahrenst@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13/08/2019 19:17, Stefan Wahren wrote:
> The email address listed in MODULE_AUTHOR() will be disabled in the
> near future. Replace it with my private one.
> 
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> =2D--
>   drivers/nvmem/mxs-ocotp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Applied thanks.

--srini
