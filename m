Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFDB3D4246
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 23:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhGWU6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 16:58:41 -0400
Received: from mail-io1-f46.google.com ([209.85.166.46]:40824 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbhGWU6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 16:58:40 -0400
Received: by mail-io1-f46.google.com with SMTP id m13so4183730iol.7;
        Fri, 23 Jul 2021 14:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rIhYYXxukLgg8TD2NbXNlHlkw0nYJkZGtnmLs/1uf8I=;
        b=nY8I7AmqO0oxWr6Xzp8Z3tc13cF+DGgDEVqI6F3ilWtg3HdvwjxSsX+XKSKdFI4XLG
         pgdvSBRej1PZ/6ZFOasWHMJP1B4RlSU+LcS8jyRF640Ch5QXTUtSGa5gKBIr693XXYx8
         EvlT1rZnEGedjFPwOJTEmq61FGQ3daAs9azo7SqI7odyvy3hKo+Fa2ysGqEgYx1iB5lI
         bTj/r8dz7nI58crZQQWrqzsBjN1LDHU5zzPEAZYlUfv66Gv9kelwxOSWbUgc2MxovD22
         Q+LbafbdD0Yodyv7OfrroNkkEU7XdDqDpFneFFhYWB77ryX+ht4qAT3g0bpXoz5Kdxzw
         iTnw==
X-Gm-Message-State: AOAM531f7YZAAWnIbrWkiv5m0fOW9VSUAn4zC9+9EXc5uNDNfALmU8MH
        z4EOy8D1Skrsti4dnXHqrA==
X-Google-Smtp-Source: ABdhPJy+Tfje0G1Mfg/je5d9v76xYoo1B0reyeAtMDY7fjK6/ymMSUYAVvXKfey5xPgIiGR7ginAuA==
X-Received: by 2002:a02:ca58:: with SMTP id i24mr5745966jal.101.1627076352997;
        Fri, 23 Jul 2021 14:39:12 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id n14sm16400043ili.22.2021.07.23.14.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 14:39:12 -0700 (PDT)
Received: (nullmailer pid 2635349 invoked by uid 1000);
        Fri, 23 Jul 2021 21:39:10 -0000
Date:   Fri, 23 Jul 2021 15:39:10 -0600
From:   Rob Herring <robh@kernel.org>
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-sunxi@googlegroups.com,
        Alistair Francis <alistair@alistair23.me>,
        devicetree@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 08/54] dt-bindings: bluetooth: realtek: Add missing
 max-speed
Message-ID: <20210723213910.GA2635297@robh.at.kernel.org>
References: <20210721140424.725744-1-maxime@cerno.tech>
 <20210721140424.725744-9-maxime@cerno.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721140424.725744-9-maxime@cerno.tech>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Jul 2021 16:03:38 +0200, Maxime Ripard wrote:
> additionalProperties prevent any property not explicitly defined in the
> binding to be used. Yet, some serial properties like max-speed are valid
> and validated through the serial/serial.yaml binding.
> 
> Even though the ideal solution would be to use unevaluatedProperties
> instead, it's not pratical due to the way the bus bindings have been
> described. Let's add max-speed to remove the warning.
> 
> Cc: Alistair Francis <alistair@alistair23.me>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: Vasily Khoruzhick <anarsoul@gmail.com>
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>
> ---
>  Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
