Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4551BA2E
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 17:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731398AbfEMPgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 11:36:14 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39020 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729793AbfEMPgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 11:36:14 -0400
Received: by mail-lj1-f194.google.com with SMTP id a10so3426255ljf.6
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 08:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aBobX/gRQlSguqoBZZQLy/K1F4tBo5qMszjuejS20Co=;
        b=gBlt9XMxpnYqx/4cyDasaIs3y4oMCc99NXC9pZof4vo3wRkQsQuOQBAmGySmbeIsnT
         pGlcYsS4yR9ytTI6FC1eSjbPpj8iz4s9dZBkDcrSiPAPC7OMzW0Rt0OqIJrPgtasoPCC
         r1LwRRJMyGIeT5nK+1RtGNaHi07nNrgYKip5lk0MdY8M8i+ortxgZcPNOlwIaF3i2knk
         k8J9A+Kc8GGfGKhqh/R2ogQFyXVw8qLb70PRA9fmxiriz2JDhlOr9Yn/Kz/5CvFVx+L4
         /j+HRZj4hBADoWB5wd5ni0jZq65JQozmkv8mwyQYZgxiIQZjdhUkU1QQujGdGVWS5gX9
         Rbrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aBobX/gRQlSguqoBZZQLy/K1F4tBo5qMszjuejS20Co=;
        b=ZZ57yh3hiCLyoOD2lwn0MuFcVgDgsFKJsps1bFBiFhClpzs3HS6399cQQWn98f1Kp9
         1yJQFzSkW1NCdjwreCU6QTbJ0wU+Q3sUJV6AfGns4Rge4vZOHUtmE9Zo9unIiBcpkWOV
         m0d2EOnSDSHxFol1UXjRgwID0rkMDTXlMas3k4u8NfmCmhwdTJQlZSGoylwVC9l9aEFA
         e+9puOfju9Hi3xCDmR47YVPgOkjWqkcpnswaRrYxZDFBclsWjP4GbvVRPsflZI11spsY
         XLP5hkjOhvivRNM7W8y96isdiWyTBZpIYqfHQ9NSQPMowZsoUsOKYazpYB+gWgzfR1a1
         3ttA==
X-Gm-Message-State: APjAAAU6e6q6VK6LHIZN6DBTI77WLttcl8sEY5ckei4HMle+yxW566ym
        idqZp40GmfUvafzIHgRyFSeHKA==
X-Google-Smtp-Source: APXvYqx7EAgiVp7E/GNOloy5P70soEYmNXt7Mr3QGKLLM+PPeltgJmRtjYkCOSVI8X18cOxFkFgHYw==
X-Received: by 2002:a2e:9713:: with SMTP id r19mr14381849lji.189.1557761772644;
        Mon, 13 May 2019 08:36:12 -0700 (PDT)
Received: from wasted.cogentembedded.com ([31.173.81.227])
        by smtp.gmail.com with ESMTPSA id t23sm711845lfk.9.2019.05.13.08.36.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 08:36:11 -0700 (PDT)
Subject: Re: [PATCH] net: ethernet: stmmac: dwmac-sun8i: enable support of
 unicast filtering
To:     Corentin Labbe <clabbe@baylibre.com>, alexandre.torgue@st.com,
        davem@davemloft.net, joabreu@synopsys.com,
        maxime.ripard@bootlin.com, peppe.cavallaro@st.com, wens@csie.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-sunxi@googlegroups.com
References: <1557752799-9989-1-git-send-email-clabbe@baylibre.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <a4c3f91a-cad2-29f8-841f-df1a0fee0781@cogentembedded.com>
Date:   Mon, 13 May 2019 18:36:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <1557752799-9989-1-git-send-email-clabbe@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 05/13/2019 04:06 PM, Corentin Labbe wrote:

> When adding more MAC address to a dwmac-sun8i interface, the device goes

   Addresses?

> directly in promiscuous mode.
> This is due to IFF_UNICAST_FLT missing flag.
> 
> So since the hardware support unicast filtering, let's add IFF_UNICAST_FLT.
> 
> Fixes: 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i")
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
[...]

MBR, Sergei
