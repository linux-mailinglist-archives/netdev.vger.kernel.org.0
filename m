Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE2E349A06
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 20:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhCYTMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 15:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhCYTLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 15:11:42 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5A7C06174A;
        Thu, 25 Mar 2021 12:11:42 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x126so3004812pfc.13;
        Thu, 25 Mar 2021 12:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O6BUmoVALUOMOrdFrqvxYj6lFfNbs+jP8qOgg/KmhBc=;
        b=b+kvqkofrku/I2KsaAuP8m8gXXMZEPWOohB8R0ZxPLBXpoG2EX6CHpSXs015L9wf8Y
         2PIg61n6QWE1V1ZwfwT4u62OjN//fPHGs/Y2tlh9oyuilwXTx33yKPX43DlayNLjUppg
         /rEn6JjFqQY3F1dzkrLd/I56qDKg4f7s0DRpIfQlr5+3Yq4qNzPy+/PWyVmO8yqblz45
         YZdb8w27O1Wnfj+bZ2oMbiWof6UU7KjWfmm8lPOkfmbvZNuTeFClw37BCsy0uhsHZPrG
         sw0dMOcD+TP0Mr/PC46cmD1ppdUBHVcnqkHTf/WzVPGDfasVQPBRTPKsf6PohkryWWJD
         MbMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O6BUmoVALUOMOrdFrqvxYj6lFfNbs+jP8qOgg/KmhBc=;
        b=ongOXkCYe2EZKt62dXqogEo4W408JpS0IZatvH+xVA+imUZksFwkYWT2FjdgQ6aMrL
         ELOLiwV3PUmMqxdcV0ZQXvDTTU+hQdG5yUVOEQVuWibNfLdYKCu6kwbYjzrFhvtTCAVk
         AGvPv0ZfhqgyfEhKfX1ahjc3L9OlR7mYYjbxLbyC7SevdT88Fj+7KIdNQ8LGElyXow2s
         jsdu0sWQktpfrIgCt6QFkGATTvTMEej4urEIVZpAFElMEAguIDD0KV7uYJaiusgBQMAY
         dTRg8CMjfYu762KS9aFFa5qrrC/WD9gHhPyjfAPP9pxVNWD6ZmJ/XJfWNAeaDZ4vkbyV
         kHGg==
X-Gm-Message-State: AOAM533ucZHkJkYxDqc/vdfBXtu/Elif8pm5wesnUFXiR7erSl+6bsde
        ne8AFVYTNvuDnh6I54wR4qY=
X-Google-Smtp-Source: ABdhPJy62bPBzXU8Dftgv417LSmA9fJVevEj5b8FKs/niHS/ftyRYizek4y5makkPH3TvgZMZEVnaw==
X-Received: by 2002:a17:902:b68b:b029:e6:cda9:39d with SMTP id c11-20020a170902b68bb02900e6cda9039dmr11451732pls.63.1616699501689;
        Thu, 25 Mar 2021 12:11:41 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n184sm6760331pfd.205.2021.03.25.12.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 12:11:41 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: b53: spi: add missing
 MODULE_DEVICE_TABLE
To:     Qinglang Miao <miaoqinglang@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
References: <20210325091954.1920344-1-miaoqinglang@huawei.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <10778792-bf0a-1fb1-b0a6-00e30af1727e@gmail.com>
Date:   Thu, 25 Mar 2021 12:11:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210325091954.1920344-1-miaoqinglang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/2021 2:19 AM, Qinglang Miao wrote:
> This patch adds missing MODULE_DEVICE_TABLE definition which generates
> correct modalias for automatic loading of this driver when it is built
> as an external module.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
