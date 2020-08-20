Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DD024BB48
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 14:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgHTM0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 08:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728324AbgHTM0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 08:26:16 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4242BC061385;
        Thu, 20 Aug 2020 05:26:14 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id g6so1831167ljn.11;
        Thu, 20 Aug 2020 05:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eSqfcQbBFm3GesGK6cttjQeofDcApyj4QPCbAu/dN3Q=;
        b=DFPJl3B781/WFvVelGdirLeJnJ25wfmXAH6jF8BGbpQOmQz5oeVphZSoz9xUStxRvE
         G4Q730xU+FpPyrHyARHBkycGEBBfel0qIZW1wqzXn/utMCIrCeZkC2DmfB3F47u3QhK7
         oz+CuMrHDXjfXqERTEgAxv3170I2QM2l4M3+AgeYitjIHURGMDQG6P4tVsinFP5ddyI2
         P5x7yqXGQQcgKxoovW+uMw1l0pMd8FfVAv1YzG+zTLLCCpaEgkKPVRsnU288AxEttZEf
         PlVKiMRObvqAIbQ923akmxNzh9VE+PADbGlnNJrHWtczbT+T478AZF0BsYLd4mzIDyBl
         vREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eSqfcQbBFm3GesGK6cttjQeofDcApyj4QPCbAu/dN3Q=;
        b=Sgdyk4xkoSlfm2nd7aKkaTXtJf33/5KNYqi8VPUZQ/lTaesHipyxT6eXCR8VrXTpPS
         whnklzKcga9zgHxrloWnrXQzPGEcpWWVNauKY7S6u293aAHOtfCm7A6tvWkaAryHKG0C
         jz19ot3defnSzHRYzRC0ku8DQG2T+Bys7hshGiplZnCqKK8r41tmZd58xhDxWz36GRP8
         YfvUO66ene7ExvRVOHUBydW0jHyFHvYAqwVTCEjS1oaA/dAzinBSMjg5xEJzVdhvpa9F
         iSl/z6NpcaKZAagpANXZb9I2jlpyZMs+P52N9nlkx2CUXlmU34BO+cT1pDjaCB0gkved
         sxxQ==
X-Gm-Message-State: AOAM532Pd+cXY0pjskfG/SpLwMVMwjP1ITxMSAu55YF0e+NgLW5qXcUD
        4UWom5Pke1+NBOKhBJ1Yt9xG5o4ZU2hFlg==
X-Google-Smtp-Source: ABdhPJxuG4DEsCDL907sWu6JlNXh1nMac4n7NDiOXL3yVsSjvk+lIi59nuhn2st5soxGdvOwqun/Yg==
X-Received: by 2002:a2e:96c3:: with SMTP id d3mr1578582ljj.270.1597926372748;
        Thu, 20 Aug 2020 05:26:12 -0700 (PDT)
Received: from wasted.omprussia.ru ([2a00:1fa0:46d7:4a60:acca:c7f9:9bba:62e5])
        by smtp.gmail.com with ESMTPSA id a17sm415149ljd.123.2020.08.20.05.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 05:26:12 -0700 (PDT)
Subject: Re: [PATCH v2] dt-bindings: net: renesas,ether: Improve schema
 validation
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20200819124539.20239-1-geert+renesas@glider.be>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <df7f61fe-3103-168e-0744-d6b20ee42224@gmail.com>
Date:   Thu, 20 Aug 2020 15:26:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200819124539.20239-1-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/20 3:45 PM, Geert Uytterhoeven wrote:

>   - Remove pinctrl consumer properties, as they are handled by core

   So you're removing them even from the example?

>     dt-schema,
>   - Document missing properties,
>   - Document missing PHY child node,
>   - Add "additionalProperties: false".
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Rob Herring <robh@kernel.org>
[...]

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

MBR, Sergei
