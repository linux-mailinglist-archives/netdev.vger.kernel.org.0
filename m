Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3A43DF67D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 22:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhHCUiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 16:38:21 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:45711 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhHCUiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 16:38:19 -0400
Received: by mail-io1-f49.google.com with SMTP id a1so11105229ioa.12;
        Tue, 03 Aug 2021 13:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fvnmYs1QqTzW2yna51Y6xDJAV10x3fuuOPqqTukUbws=;
        b=rDTo0vU5LUrSN1syuDdo58GJpCDXwG0P7O5XwoO91FGzvceaNv93hHPXjnN8AKaa/6
         PnFv5Nln0QhnW/pSAMa8wA7Qhlq7X3Dkw7Ztu1M/ertQLy2VGV/mdQaC59o7Wo9eHytg
         KpbunL1u1PnUARZHO8DfLHOrz1jeHxs09dsfud1gkdz7qABQdIIs1KvwhRz8EfA4OBnr
         VWkEEmCLOZ7A/u93SUaCT+rr3jkUEvdBHuwEgmDSyoeqYo9TOTGmVjyLPfo64eb73nvG
         XtYtqpvik8yfSp8JhoQbKKgYr4iAN4ec9oUMY6AX4VUectgcQkmBU4r7keFLGNm6kKSk
         kYKw==
X-Gm-Message-State: AOAM533sxFopuTcKkE9bnCbAM/ToAFpzEvgb1PSb9BZYPox72KUEmXDQ
        37YnQCb5C0tLi1e4ruD/Yg==
X-Google-Smtp-Source: ABdhPJzqIdDa96mcqBrbGTRZM07TZKf1ESiQ6ER/Q2M9+3bHdZ3WZdba6Pv1VAtRg2MbgOcK5XKw/A==
X-Received: by 2002:a6b:e602:: with SMTP id g2mr584669ioh.50.1628023087782;
        Tue, 03 Aug 2021 13:38:07 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id t2sm7795ilq.27.2021.08.03.13.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 13:38:07 -0700 (PDT)
Received: (nullmailer pid 3690786 invoked by uid 1000);
        Tue, 03 Aug 2021 20:38:05 -0000
Date:   Tue, 3 Aug 2021 14:38:05 -0600
From:   Rob Herring <robh@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Imre Kaloz <kaloz@openwrt.org>, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 5/6] ixp4xx_eth: Add devicetree bindings
Message-ID: <YQmpLdH0MA1/7NGz@robh.at.kernel.org>
References: <20210801002737.3038741-1-linus.walleij@linaro.org>
 <20210801002737.3038741-6-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210801002737.3038741-6-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 01 Aug 2021 02:27:36 +0200, Linus Walleij wrote:
> This adds device tree bindings for the IXP46x PTP Timer, a companion
> to the IXP4xx ethernet in newer platforms.
> 
> Cc: devicetree@vger.kernel.org
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  .../bindings/net/intel,ixp46x-ptp-timer.yaml  | 54 +++++++++++++++++++
>  1 file changed, 54 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/intel,ixp46x-ptp-timer.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
