Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218243F34DF
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 21:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238663AbhHTT66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 15:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbhHTT66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 15:58:58 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015C0C061575;
        Fri, 20 Aug 2021 12:58:20 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id o2so10261355pgr.9;
        Fri, 20 Aug 2021 12:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+h705EnRDH2hW6ZSNEyHm+JKcWt62ky1ja/Tpo9gbEA=;
        b=JNN8D2+AbXA9C4Nrk9qKwQsvZ6Gr/GFKwR0zENSwK8tmPZbzTFGR8Q8GCn3s6Z4lNM
         yJvpVZBsddxkEYmOYzOvj05dDh/NaJF4R0u+EWlp6S+FQZF2TksOlqLPBg8u7AOedoLp
         ByPH60gzMxPc4Jk2uD7qseC2nCUx9m6XGihIazh9H40lDPJaAei7wzYx+TM8UgGOj8HN
         sIxaHy9iCvfbrC2HMhRlBpjl/7x99On8G8WWCgPM+JawkaWgghUNuppIpzltGAp4InIG
         0/vRDM6DD/+g2QOMpjTptflDJh/P6fW4FLMdRqSPn98pdheHExZJmaj/0+ahLNBJoqcB
         zXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+h705EnRDH2hW6ZSNEyHm+JKcWt62ky1ja/Tpo9gbEA=;
        b=m8JnujTNmQZYcinOL1rx0gOnI1EJbc2IZAgpwqoMg/ek8wm46R+jNUX1kytaV+yo18
         jNrHtJJsyzne4xg7LkPA56N3TKoRIflb2aSiNvXfpkT09DmlFrTXgZ0qkBdK+Oa1OXcr
         S+slHGIUP3sfYKR8Rsez+2YFlBckl9bgEoNwXZN2XM8YljSBQ3ngIm2EfniU78RzU1Pb
         8eDqjL9VL4PzHSBm12JwQsogKdCRTu4AWzPU67A9h68F7alV2cijdETf01g6vaGPdZbm
         fin8vFaxHab6aVwKV5wfvrhJRx0t/DU5+rcWzEpP+CvnSKdYzyy3FTdAiHgIEnzOV5PW
         dDtw==
X-Gm-Message-State: AOAM533RjN0boL1NaeJZwQmvO2IT208dkNqy+jqLflsQrIh69rcYNvdv
        nLjpenQ4VXUSDXrWTXDtGOCzV8+Ky9zwgw==
X-Google-Smtp-Source: ABdhPJzNxRns6J5gNCRPQUJLpO/2DMosR70t+lV/9DnaC8+gK/PzHE4iHLlXRCUZ/Ii1DNYJaUNffQ==
X-Received: by 2002:a63:d14c:: with SMTP id c12mr19979450pgj.412.1629489499347;
        Fri, 20 Aug 2021 12:58:19 -0700 (PDT)
Received: from [10.230.32.55] ([192.19.148.250])
        by smtp.gmail.com with ESMTPSA id j6sm7626467pfi.220.2021.08.20.12.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 12:58:18 -0700 (PDT)
Subject: Re: [PATCH V2] dt-bindings: net: brcm,unimac-mdio: convert to the
 json-schema
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210819100946.10748-1-zajec5@gmail.com>
 <20210820161533.20611-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2e6807c0-6b52-a35c-b14a-7fc579e44254@gmail.com>
Date:   Fri, 20 Aug 2021 21:58:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210820161533.20611-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/2021 6:15 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This helps validating DTS files.
> 
> Introduced example binding changes:
> 1. Fixed reg formatting
> 2. Swapped #address-cells and #size-cells incorrect values
> 3. Renamed node: s/phy/ethernet-phy/
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
