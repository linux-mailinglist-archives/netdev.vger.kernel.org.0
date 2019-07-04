Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9A095FDC5
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfGDU1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:27:21 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46593 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfGDU1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 16:27:21 -0400
Received: by mail-pg1-f196.google.com with SMTP id i8so3279133pgm.13;
        Thu, 04 Jul 2019 13:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z3QWNnk+axnLxPGdoA7WpikkuAhqTqR0RwQrRe4B/Wk=;
        b=s9dovZ+oW6ntyg1lm5hJ6Nk2xoYGOl64SrEAsXpdbNDGuVwcLrCtY/34UArIzNyPTb
         NbbIHp3YANyRBhz8VPgzLDx1nl+OXBheyFrlfba3tZBbh13e1vj8VuZ8OOJYCpooYf1+
         2im6s2YBsdS393cactvL3d1JhNHX4j8+zZX9i+me6hfbhH7tz5NdfKBq4k3DwTbv10NT
         3f+dKJm8NSNguh1cwwGczXwvIyhQxa6/QZXhX4K/3guYDDX5TJsw6fP3qoN3iz+kAbXB
         JVi2H25+uI0M38miL7Fo4wtfYG2WIAbK1ZBip/fWATMJ4lCv0Id9yE79KMGaHkijJUCu
         LZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z3QWNnk+axnLxPGdoA7WpikkuAhqTqR0RwQrRe4B/Wk=;
        b=pXGrQ5hbYDmMxQq4eu4e8M+q+9gAe1XpRV8cH6gSu3uFRmLoBjcbRmdpfP0vxvJ5y1
         JBtunYsSftYRRB3T3+ummhYKX/yHNB8gzVb8Mj9usptVcYcelCXkjTJ6QobKh8WoT+hx
         F2O8kZacQ5LTeQwwSv2N+YcgzspVBJq6B0lt342G0bTD9jsKeTvpIrVm3O9NyUW6knW0
         SANrEKrVwNkeXStSp8gJU5XP50X7HrGtwSWaks9FoI5Rtuo9oY3Z+8jQLoSxqPist/J6
         DkiqZXyZ1RJ6V/VQb1WQDlCXIG7jRFmv8b4K04t8fneCkoGqaIhR2BEWwr9riQnKxanm
         5xSw==
X-Gm-Message-State: APjAAAV0C+IO+PVE2MtJYpl3Z2eRNE9Ab3yKHQoRX6bJ3SFwqeNBTO9Z
        wj5G52CQ33WykLhJLqO23bOg01uL
X-Google-Smtp-Source: APXvYqz9djmZ2omIHJpjj99HnQ5Vv8j+h5oSzcS3wKrJtqBiAeDG19S4J+sCo21Qq46QEny2r8mELw==
X-Received: by 2002:a65:5901:: with SMTP id f1mr369746pgu.84.1562272040171;
        Thu, 04 Jul 2019 13:27:20 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id e124sm5300505pfh.181.2019.07.04.13.27.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 13:27:19 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] net: dsa: vsc73xx: Assert reset if iCPU is enabled
To:     Pawel Dembicki <paweldembicki@gmail.com>
Cc:     linus.walleij@linaro.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190703171924.31801-1-paweldembicki@gmail.com>
 <20190703171924.31801-5-paweldembicki@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <bee690ca-64c2-c974-1658-92b986bb1b04@gmail.com>
Date:   Thu, 4 Jul 2019 13:27:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190703171924.31801-5-paweldembicki@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/3/2019 10:19 AM, Pawel Dembicki wrote:
> Driver allow to use devices with disabled iCPU only.
> 
> Some devices have pre-initialised iCPU by bootloader.
> That state make switch unmanaged. This patch force reset
> if device is in unmanaged state. In the result chip lost
> internal firmware from RAM and it can be managed.
> 
> Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
> ---

[snip]

> @@ -1158,6 +1143,19 @@ int vsc73xx_probe(struct vsc73xx *vsc)
>  		msleep(20);
>  
>  	ret = vsc73xx_detect(vsc);
> +	if (ret == -EAGAIN) {
> +		dev_err(vsc->dev,
> +			"Chip seams to be out of control. Assert reset and try again.\n");
> +		gpiod_set_value_cansleep(vsc->reset, 1);

s/seams/seems/

With that fixed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
