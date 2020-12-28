Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968162E6C6F
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbgL1Wzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729484AbgL1VHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 16:07:39 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3534C0613D6;
        Mon, 28 Dec 2020 13:06:58 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id f14so279229pju.4;
        Mon, 28 Dec 2020 13:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nJ5sqR0HFrrpP8VODHPa/STLCx17P5kOSNJVjY/F3jY=;
        b=TFv8Q4oj0hrMK90UI1iMuYcnETqYM0PlOsZ2NxMBX5py+hJIR+N6BTtXlAvha5VBtZ
         tmoK6QOvCXfUr5JDtn4oToIrpPFtnVfRl2F8Z5c23c6aNxDC8n8RtPCOtWSJNEx4dfn6
         fW3lNg00KsK6OAUS77YsR78XZhLKKWzpMcNJSo7W0gVEncuJokwYIyo9gjuFwNyZ6FP4
         wPTN4AIESongPfmkyUm4vwzTS4uU4ksl5GN2dm3fqDysEoSDNM1RnF3bsWrF04YpdZNp
         LhTvD0D87HUgf9dcWeDg9dXGCKPj/2BAMm8Q+nVv2QaP6XupkMB6qNmNxBg4nQ3i9XIL
         V5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nJ5sqR0HFrrpP8VODHPa/STLCx17P5kOSNJVjY/F3jY=;
        b=MLwYJA8WchE+Q7NBgi1eG0tMBCZ8d6Q+WYfV5I4nwoV5MOd7Buvxd6MbsxPJBOHCxE
         rPltI8gjLghV1TJLM5obHJFopeXmIoeT1hb2By1dn7Y+n6f58/aE562K7an6SxMrogTX
         QE758DN34LQ0ykyt0VpUTl/EwnpdpyKqCW8GaDv04f2P4VN+dfwzwfoVT9YLobk26T15
         DJc9H3WC65AAF1o2uarRoRw1Q+fcemymKuOmq4wQVirjLG/B1JU8pBdri9KWD5f8SXrF
         iFh61RCGhbQ2yb/QQCJqx4pL10JMm5i/PEZS2BYJjfROHLIdVc3lrn5oJqcFBgcIMKb5
         Mm8A==
X-Gm-Message-State: AOAM531r312FqcLM2gjAe9SaEAWGSCEUnJ2YVfzipXrayxG94erEd4WQ
        XeICPMoBn4q3bKGVGhT9EY0=
X-Google-Smtp-Source: ABdhPJzGb5+rfvqdiTMT7ceeWIm7Jk6ra4y+shJ+cMwhcgMiGkADJf/6ute3mXb7Y0HzRaISyKOZEw==
X-Received: by 2002:a17:902:8a88:b029:dc:f3:6db2 with SMTP id p8-20020a1709028a88b02900dc00f36db2mr22385056plo.2.1609189618507;
        Mon, 28 Dec 2020 13:06:58 -0800 (PST)
Received: from [10.230.29.27] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q15sm26820960pgk.11.2020.12.28.13.06.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 13:06:57 -0800 (PST)
Subject: Re: [PATCH v3 1/5] dt-bindings: net: dwmac-meson: use picoseconds for
 the RGMII RX delay
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, jianxin.pan@amlogic.com, narmstrong@baylibre.com,
        khilman@baylibre.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jbrunet@baylibre.com
References: <20201223232905.2958651-1-martin.blumenstingl@googlemail.com>
 <20201223232905.2958651-2-martin.blumenstingl@googlemail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b6bfb849-3d68-59aa-1e75-201a978702f3@gmail.com>
Date:   Mon, 28 Dec 2020 13:06:55 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201223232905.2958651-2-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/23/2020 3:29 PM, Martin Blumenstingl wrote:
> Amlogic Meson G12A, G12B and SM1 SoCs have a more advanced RGMII RX
> delay register which allows picoseconds precision. Deprecate the old
> "amlogic,rx-delay-ns" in favour of the generic "rx-internal-delay-ps"
> property.
> 
> For older SoCs the only known supported values were 0ns and 2ns. The new
> SoCs have support for RGMII RX delays between 0ps and 3000ps in 200ps
> steps.
> 
> Don't carry over the description for the "rx-internal-delay-ps" property
> and inherit that from ethernet-controller.yaml instead.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
