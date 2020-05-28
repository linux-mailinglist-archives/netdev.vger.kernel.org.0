Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEA21E6BD9
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 22:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406879AbgE1UDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 16:03:36 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44275 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406768AbgE1UDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 16:03:32 -0400
Received: by mail-io1-f68.google.com with SMTP id p20so18110717iop.11;
        Thu, 28 May 2020 13:03:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WOZJJYcxACXW/f86CWGzaIWG9UVyWDM2VBeq6ibxzFA=;
        b=faJNQ/AMpjNpyEqqNZ6VWKJDQzjwOpCUerNO/r9v3nkLHNsvHlMnEzDbhHlq/rkXPi
         /FHxFKJj8LXCX9+GT51wXmhXc4xUPu1QGeG2dvAfyTrivimr6IL7FZLRLcJpZLC1x0IR
         SZ+QiHRgrrrz1c9RmiAs+yvuE15/oL7+dmqPZWfCxHVnGGaDKdwfAmPtC//etQm5gUNG
         ko8+xR/wsL4/g8sIk1dLadaxvzpatJ5Ko2gHs5IoPUMZuteE/2gS50IUAhxDSBqWj+XI
         KlWLTw0XoTbtoOiR9+/CC1kQuYS9csG/9sEOdIyZRq33yBbyumVhmBvXmd5CqF/g0fAK
         G8+A==
X-Gm-Message-State: AOAM5316ZiHeGm1kXkgEsY3PBD7GjI1lj5+R04mn1SG/JEWBYpFYIZst
        Ct6949y/2CqiooLkG6hACA==
X-Google-Smtp-Source: ABdhPJy6bw+eVdj/3BkqQEG8iWgPJd3s+TdcOk/LXrCK3tBxvHyGnDNQ1TXnU6AiW/ROgs77w1FZzg==
X-Received: by 2002:a02:c8d2:: with SMTP id q18mr4157449jao.127.1590696211401;
        Thu, 28 May 2020 13:03:31 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id n22sm2921088ioh.46.2020.05.28.13.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 13:03:30 -0700 (PDT)
Received: (nullmailer pid 589004 invoked by uid 1000);
        Thu, 28 May 2020 20:03:29 -0000
Date:   Thu, 28 May 2020 14:03:29 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-mmc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        devicetree@vger.kernel.org, Prabhakar <prabhakar.csengg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, linux-i2c@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 01/17] dt-bindings: i2c: renesas,i2c: Document r8a7742
 support
Message-ID: <20200528200329.GA588958@bogus>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-2-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589555337-5498-2-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 May 2020 16:08:41 +0100, Lad Prabhakar wrote:
> Document i2c controller for RZ/G1H (R8A7742) SoC, which is compatible
> with R-Car Gen2 SoC family.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/i2c/renesas,i2c.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Applied, thanks!
