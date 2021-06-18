Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CC13AD451
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 23:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbhFRVUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 17:20:55 -0400
Received: from mail-ot1-f53.google.com ([209.85.210.53]:38831 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233969AbhFRVUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 17:20:54 -0400
Received: by mail-ot1-f53.google.com with SMTP id j11-20020a9d738b0000b02903ea3c02ded8so11043462otk.5;
        Fri, 18 Jun 2021 14:18:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1tTAvbzUxCMolhXVAQzs0vDAJPIKYPpd5x8wrOjw/wM=;
        b=rwDKrDtg512A7ey1pO0oMUDRR86EcrrPuCN48OnjriUfobUohfJpmqSd7zfxCb31qf
         J81t6nsp8400BFM0EPsVelLJdEd4NE9gVzJrvNmWudVadyIdAIlV9HJu+ksZRzwi56tL
         Lilb3QnRLIW1G9AlvKy03Lj9lU5evHVEkYZcA+Myd22SFjbJzUqKXzRc++wEpTz4/hNo
         UigP5z6IbMFihqYBprzbFpZH75snLRcDAJikKyMU2Eg7Pp4Rjymu986tVzofPLfiq0ve
         X895mCYUsKYxCR7kHTogbRCSNM7zDVeiUt3i2epk6uIZEfEn8JyX1RE5ryJBeCSnsayR
         5PLg==
X-Gm-Message-State: AOAM532pUaylyPNgXEkZsqYdEDlbN8JsWB/a2o0E12uflbE6e+s2Eao1
        19k7b5CU+GE7k1R2RiFoOQ==
X-Google-Smtp-Source: ABdhPJyjmEd4UJKkTLlkwPJWWRoeQK5msJvyvKkN7b5+w2zTRr+Mf802XN2MbPXGoWn3T1PADoLVqA==
X-Received: by 2002:a9d:5d11:: with SMTP id b17mr11351394oti.216.1624051124012;
        Fri, 18 Jun 2021 14:18:44 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id r2sm2261326otd.54.2021.06.18.14.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 14:18:43 -0700 (PDT)
Received: (nullmailer pid 2925425 invoked by uid 1000);
        Fri, 18 Jun 2021 21:18:41 -0000
Date:   Fri, 18 Jun 2021 15:18:41 -0600
From:   Rob Herring <robh@kernel.org>
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, Andy Gross <agross@kernel.org>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH RESEND 2/2] dt-bindings: net: stmmac: add ahb reset to
 example
Message-ID: <20210618211841.GA2925338@robh.at.kernel.org>
References: <20210609230946.1294326-1-mnhagan88@gmail.com>
 <20210609230946.1294326-3-mnhagan88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609230946.1294326-3-mnhagan88@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Jun 2021 00:09:45 +0100, Matthew Hagan wrote:
> Add ahb reset to the reset properties within the example GMAC node.
> 
> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/ipq806x-dwmac.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
