Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F52E42CE24
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhJMWdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbhJMWdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:33:09 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CCBC061764
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:31:02 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id f15so1382537ilu.7
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=otZN8F+fG9zAX7wVdqQ3N8LhCQgLBn+dCk9vdX4N79k=;
        b=EuNhCjX6qv4SHl5vGJ6JJNVDiRLzJDAc11ZlKzibulsYq/szMLC5oz1UUjSAcevNWa
         4wiwPvp2FoWkh/YY66rUNRbZPm2G+bZ2qutdDQfA0jwhdbnMfe/n4pIfsAENt8Wn/meB
         vnNj6gLX3cVN1/CzuJGEe97w6OyXi8cj24khI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=otZN8F+fG9zAX7wVdqQ3N8LhCQgLBn+dCk9vdX4N79k=;
        b=2M2QAJ0ZvyZeb35Fsjs+rjL4sKCGbUShSWmd0nWYtyal87wVx4SHF8iaErTo/krAvf
         0Uw81lc7Eq/VzW3sIsZ0AqawFpiSu25/b8z7bYXlwPaHGPDkTQuTgkct023QHtuGWJ+Q
         zb4BODsmsGc8H3A4LgVTUsvcJcWMr+8kLrhiynZps25HVmY8edkUHy0N+m1R/Gfh6pfd
         ZUyjQqzJqNj1YKumlL5T5QLd+1LI+EuciGGN2FeGElXDepDjFrTeD+v7Tm0KQnsBELSn
         njTF39TFrRbLbrtXdZS5mVF48rZ+5Wzm7qkRGQ8kbDsg1I2yqG6s5F6sWaCuhAUs3DGM
         eUng==
X-Gm-Message-State: AOAM533dGKumDtiGZ1YhoyqdgPuaNrht/vMvekPB1lt9Ezd3BoXy55ZT
        qu2k/4lTEKILtzPciIrJtPPE8Q==
X-Google-Smtp-Source: ABdhPJwo3yLSsRZNFqu7UKIUCDgR8yc4ZXmM9i3Tvb+hzqHpIewQsz5A1oY8eYgYcKDR3SvJqyYjRw==
X-Received: by 2002:a05:6e02:1889:: with SMTP id o9mr1401742ilu.219.1634164262205;
        Wed, 13 Oct 2021 15:31:02 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id b13sm340163ioq.26.2021.10.13.15.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 15:31:01 -0700 (PDT)
Subject: Re: [RFC PATCH 17/17] dt-bindings: net: qcom,ipa: Add support for
 MSM8953 and MSM8996 IPA
To:     Sireesh Kodali <sireeshkodali1@gmail.com>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
 <20210920030811.57273-18-sireeshkodali1@gmail.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <0166e268-5162-95d0-e5c5-8831525b7d84@ieee.org>
Date:   Wed, 13 Oct 2021 17:31:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210920030811.57273-18-sireeshkodali1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/21 10:08 PM, Sireesh Kodali wrote:
> MSM8996 uses IPA v2.5 and MSM8953 uses IPA v2.6l
> 
> Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>

This looks good.  And if it's good enough for Rob, it
*must* be good.

					-Alex

> ---
>   Documentation/devicetree/bindings/net/qcom,ipa.yaml | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index b8a0b392b24e..e857827bfa54 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -44,6 +44,8 @@ description:
>   properties:
>     compatible:
>       enum:
> +      - qcom,msm8953-ipa
> +      - qcom,msm8996-ipa
>         - qcom,msm8998-ipa
>         - qcom,sc7180-ipa
>         - qcom,sc7280-ipa
> 

