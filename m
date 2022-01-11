Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8733248B492
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344868AbiAKRwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:52:32 -0500
Received: from mail-oo1-f52.google.com ([209.85.161.52]:43932 "EHLO
        mail-oo1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345100AbiAKRvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:51:48 -0500
Received: by mail-oo1-f52.google.com with SMTP id z20-20020a4a3054000000b002dbfaf0b568so4636593ooz.10;
        Tue, 11 Jan 2022 09:51:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UifqrbSv4P6oUwIS9VVpUp4MVpz/i09ZMQyiV9QJa6A=;
        b=gO2slWkHUbjIJ7at6MJLKVJYBjA4lDb5+SJdJ34eK5M4FNOLqdYSUlDD7sS5umpTEi
         Pn5cr/c8XFmzJGcKB5BmXzy55CYxIJo3d2yi8EF8GyDcjiX3BF8TD1YgMNjYEM+bLzlu
         T5ZMfezjQvfdgX0ZZeC9+rNtRuWK1LsHattZf3nvJQCOi6Qz61mpF2H/5Lwo4HrXL8gF
         uRMajAoGN/+CYbdZ/nNAUMickJr7jJNlJaPoi36fhl6+2yzn/LlxZ44RzRnf/DWgAHrH
         WqJIFKDgHVeTFfwSvagBGvPs9hQrE8jE2uzw85m0U9eEZ2uSEEmh2JBuIczOAGdjVzMV
         lY4A==
X-Gm-Message-State: AOAM530IWrvsdlbqSJeRQsJT8xSA2syEd0MrEAIBMC6VTxXNXW6ku0tp
        byF7EatPjXTbctzAWoQOCA==
X-Google-Smtp-Source: ABdhPJznNaT1VvHIngLtpJFtz0iASueDANoXRX2e5SW6ZAucUfj28fstai6hZocWcmtpqr5MeaK/UA==
X-Received: by 2002:a4a:3bd4:: with SMTP id s203mr3882712oos.18.1641923507894;
        Tue, 11 Jan 2022 09:51:47 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id x13sm2018165oof.19.2022.01.11.09.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:51:47 -0800 (PST)
Received: (nullmailer pid 3228864 invoked by uid 1000);
        Tue, 11 Jan 2022 17:51:46 -0000
Date:   Tue, 11 Jan 2022 11:51:46 -0600
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     linux-gpio@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        - <patches@opensource.cirrus.com>, linux-kernel@vger.kernel.org,
        Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org,
        Greentime Hu <greentime.hu@sifive.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-riscv@lists.infradead.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        linux-pci@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Suman Anna <s-anna@ti.com>, netdev@vger.kernel.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] dt-bindings: Drop required 'interrupt-parent'
Message-ID: <Yd3DsoMYTylcOWDo@robh.at.kernel.org>
References: <20220107031905.2406176-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107031905.2406176-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 06 Jan 2022 21:19:04 -0600, Rob Herring wrote:
> 'interrupt-parent' is never required as it can be in a parent node or a
> parent node itself can be an interrupt provider. Where exactly it lives is
> outside the scope of a binding schema.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/gpio/toshiba,gpio-visconti.yaml  | 1 -
>  .../devicetree/bindings/mailbox/ti,omap-mailbox.yaml     | 9 ---------
>  Documentation/devicetree/bindings/mfd/cirrus,madera.yaml | 1 -
>  .../devicetree/bindings/net/lantiq,etop-xway.yaml        | 1 -
>  .../devicetree/bindings/net/lantiq,xrx200-net.yaml       | 1 -
>  .../devicetree/bindings/pci/sifive,fu740-pcie.yaml       | 1 -
>  .../devicetree/bindings/pci/xilinx-versal-cpm.yaml       | 1 -
>  7 files changed, 15 deletions(-)
> 

Applied, thanks!
