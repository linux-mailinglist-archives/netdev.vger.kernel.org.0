Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FC836142D
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 23:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236118AbhDOVel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 17:34:41 -0400
Received: from mail-oi1-f169.google.com ([209.85.167.169]:33394 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbhDOVek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 17:34:40 -0400
Received: by mail-oi1-f169.google.com with SMTP id l131so20720654oih.0;
        Thu, 15 Apr 2021 14:34:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mrooC9QzlmYRjHYSxhR+URpCdRQcsLYdqpx6Phf3Y/Q=;
        b=tkvA5xjhsi4hihVpoL4cmBfS6kRsRElyR611vbWztb4oA4B7pfxiVQlL1QSfCbnAl8
         HtusoCK+LYJ56PtmUq8qUqs8PxV6vqfQ/z/riba7o0fn176i9Yt4o9MvQoNMblhMZXUj
         fVmaYJCDtWWTn+tcPpnTt3rabFpUB9ReKt7RAI5URRSQw650vlaVaFiNkxuYKqiBTRXr
         n2iQtUPNGVp6Gp7vh6qYGgbwFN2DTChiOYt66mEJg1bH0R/tPi8xJfHZE3RZqP6SDCT5
         1v4iharyEMktR+yRB2bzCRvqv8KCfMP2XVtxN2SEdvn13YA0gIuWTN7p4kR3AMtDZs0n
         k9Qg==
X-Gm-Message-State: AOAM530GD7XVzY/qdye2zCQxyj4XPBO1zz3tjUm/UFkAtwL38Q3t8Lmm
        6WotvfCTjqXHP3EB51OykA==
X-Google-Smtp-Source: ABdhPJyGziaIc1m8LURyRTheRlLuPRsZzloWhQkwnNEE8J2hStLts8TYvz2lSY5pwIZKtOUo7wjlWQ==
X-Received: by 2002:aca:408a:: with SMTP id n132mr4114859oia.70.1618522454880;
        Thu, 15 Apr 2021 14:34:14 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id o20sm794700oos.19.2021.04.15.14.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 14:34:14 -0700 (PDT)
Received: (nullmailer pid 1920043 invoked by uid 1000);
        Thu, 15 Apr 2021 21:34:13 -0000
Date:   Thu, 15 Apr 2021 16:34:13 -0500
From:   Rob Herring <robh@kernel.org>
To:     Shawn Guo <shawn.guo@linaro.org>
Cc:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Franky Lin <franky.lin@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Arend van Spriel <aspriel@gmail.com>,
        brcm80211-dev-list.pdl@broadcom.com, devicetree@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, SHA-cyfmac-dev-list@infineon.com,
        netdev@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wright Feng <wright.feng@infineon.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: bcm4329-fmac: add optional
 brcm,ccode-map
Message-ID: <20210415213413.GA1919973@robh.at.kernel.org>
References: <20210415104728.8471-1-shawn.guo@linaro.org>
 <20210415104728.8471-2-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415104728.8471-2-shawn.guo@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 18:47:27 +0800, Shawn Guo wrote:
> Add optional brcm,ccode-map property to support translation from ISO3166
> country code to brcmfmac firmware country code and revision.
> 
> The country revision is needed because the RF parameters that provide
> regulatory compliance are tweaked per platform/customer.  So depending
> on the RF path tight to the chip, certain country revision needs to be
> specified.  As such they could be seen as device specific calibration
> data which is a good fit into device tree.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>  .../bindings/net/wireless/brcm,bcm4329-fmac.yaml          | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 

Applied, thanks!
