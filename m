Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF9E1E6BE0
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 22:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406901AbgE1UD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 16:03:57 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:42838 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406768AbgE1UDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 16:03:54 -0400
Received: by mail-il1-f196.google.com with SMTP id 18so143849iln.9;
        Thu, 28 May 2020 13:03:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FHu3F5X3NxMrKOgZjhGD2mCvqvQCtLkiz/NEHPErfv8=;
        b=TJK6xWhRRAUkHTndccw1o7424BeK8Bvlq3m5bxqKsSJAudOAkAhJeqipqdTX+crd87
         kAqruBl/myKCOQ/yioIv2H08hzC2oTlmnkmrZpK7cuDD4TGz+WlAFKBcJ7SSSqoV1yfJ
         9nljiIqJmpOVdywywoTYLtvEPPOp7fy51nraP/iROZuqzlmLsXV1ghNaBGx0s5738Gm7
         gosL6UcWNALGaj1Y17gh7/pbvuYudpTlo67YMc/wHXfM4pKuUpEFxFBGbg6LiSRnm/BF
         empZxM50aeLT9RzRNRhNSFYK66XSF/pBzNBimUjC9vIqWr3QRCwX9cisEvuU450mermt
         p7hQ==
X-Gm-Message-State: AOAM5301PkcjA+w2vQ7+WQPrfg1+ipNrwgrWg76JM1aqDfQNOyiG+SSI
        KN5J5krus2HvnAfosKs5kg==
X-Google-Smtp-Source: ABdhPJxMb2z2inz2w10Sd2JjUVCK8xdBAe4V/OeB0PGl/nv0l+DIyu+cb3XscNkKJdlYonZDXloQMw==
X-Received: by 2002:a92:5dd2:: with SMTP id e79mr4096431ilg.94.1590696233380;
        Thu, 28 May 2020 13:03:53 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id q6sm3627662ilj.72.2020.05.28.13.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 13:03:52 -0700 (PDT)
Received: (nullmailer pid 589624 invoked by uid 1000);
        Thu, 28 May 2020 20:03:51 -0000
Date:   Thu, 28 May 2020 14:03:51 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>, linux-mmc@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-ide@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        devicetree@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        linux-watchdog@vger.kernel.org, netdev@vger.kernel.org,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/17] dt-bindings: i2c: renesas,iic: Document r8a7742
 support
Message-ID: <20200528200351.GA589571@bogus>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589555337-5498-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 May 2020 16:08:42 +0100, Lad Prabhakar wrote:
> Document IIC controller for RZ/G1H (R8A7742) SoC, which is compatible
> with R-Car Gen2 SoC family.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/i2c/renesas,iic.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Applied, thanks!
