Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290F9415E9E
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241061AbhIWMoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:44:11 -0400
Received: from mail-oo1-f50.google.com ([209.85.161.50]:46638 "EHLO
        mail-oo1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240911AbhIWMoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:44:10 -0400
Received: by mail-oo1-f50.google.com with SMTP id q26-20020a4adc5a000000b002918a69c8eeso2070465oov.13;
        Thu, 23 Sep 2021 05:42:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EQoFaazURf0T5iPiEHtr8R2ifsqYmGtx+pVuh7cl/+k=;
        b=CXeuSBeeCcaibIRzwOnmgSigsc1zlVlMP/a3IXyv2SAdWTToOQUf1ZYteWFcjq5xg0
         clO1RaQRKJdYG8cn0EjTLbQbptY7xGwUyKW4p7cU5WpIQzl/tuYky4NuNC8XPBlNmuNm
         TwyOSJ4E97nhXp+oKKAEzJuxCoC0zVm3QpH5CkcQlQF1aMm9FpghIrbU4IY08MTXMyCa
         mTLUP3abwcnZFljk+2CXOLPbxSCtvIcu/C48LdAHL8COO3wR5RGrS0STHI0Lj8Gj+liM
         vTrW6NyajbQsRTSU44hx02oJwLcj5t5XORLhzOdcxnvZ53n8E6lsB3WieHSBjtiAzMUz
         uSig==
X-Gm-Message-State: AOAM530yOlCYBNDFxCGoeGyNZ04mMsKvA6jxkfPce+1ps8TPBrLNVCUf
        tnrLid/0M8p0mgPv4WxSRg==
X-Google-Smtp-Source: ABdhPJwrgYbulGwbPiYtS0EElA0FGBwUloejY13vS7nH+r61vSAMDCynPfMD/VZzkVpdL13OLOkYTA==
X-Received: by 2002:a4a:942:: with SMTP id 63mr3533940ooa.25.1632400958139;
        Thu, 23 Sep 2021 05:42:38 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id y9sm1331567ooe.10.2021.09.23.05.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 05:42:37 -0700 (PDT)
Received: (nullmailer pid 2819083 invoked by uid 1000);
        Thu, 23 Sep 2021 12:42:36 -0000
Date:   Thu, 23 Sep 2021 07:42:36 -0500
From:   Rob Herring <robh@kernel.org>
To:     Sireesh Kodali <sireeshkodali1@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        ~postmarketos/upstreaming@lists.sr.ht, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, phone-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH 17/17] dt-bindings: net: qcom,ipa: Add support for
 MSM8953 and MSM8996 IPA
Message-ID: <YUx2PLKZOMtKfru0@robh.at.kernel.org>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
 <20210920030811.57273-18-sireeshkodali1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920030811.57273-18-sireeshkodali1@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Sep 2021 08:38:11 +0530, Sireesh Kodali wrote:
> MSM8996 uses IPA v2.5 and MSM8953 uses IPA v2.6l
> 
> Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
