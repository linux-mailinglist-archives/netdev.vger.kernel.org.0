Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC241E6BFC
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 22:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406957AbgE1UEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 16:04:54 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35334 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406894AbgE1UEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 16:04:50 -0400
Received: by mail-io1-f67.google.com with SMTP id s18so17579253ioe.2;
        Thu, 28 May 2020 13:04:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HVlLEYGeMbf+YyIxWDa0JWoHM/67cr8/Tm3DJy/2JBg=;
        b=R6uAMPhiZMot4DEjfIypQnvjX7WDmGc5uPIgTJBbS4SoTJfFWxlJUcnvjAaKHAQkXt
         lmgWqGXJ8+uS5uz46ATfHyvYk3fW65qofTDpKGERn1gWiHBSMJW61jaKakl5HgBVKKM7
         vjG4bAXo5JSLhmYTTTn9k4wd3Gt665DluRG50liruCIYMrD8ZUx0EM4mIxZrE5/ZqAkI
         cKAJ1GwlGkcOMJa2r/3npuJrfdkijiF1QV4toQYU9klc47g7HjdrMRQ/2d5V6tWxWERR
         vUPLYLarXmPSEp+rF1JrCm08m3PXYDnhuzivYkjiqgufsO6lj2wl3Kd4zoDQNs3QlUJh
         7WHA==
X-Gm-Message-State: AOAM530XeUeZDMREc0X+pPAZR5G3fHlqTqjgZOIvd6/ebLD8c7NefZnD
        28J2ngBvUhY1kII9pJiWCw==
X-Google-Smtp-Source: ABdhPJy+cfvvDfF/xtHXpnNw6KV3I4Hf3Sfs3msSFnj3UaMZ+P/hDzOGIaWDzeg2LGWHJzpP8Ttkmg==
X-Received: by 2002:a6b:6709:: with SMTP id b9mr3849319ioc.108.1590696288949;
        Thu, 28 May 2020 13:04:48 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id f66sm3757029ilf.63.2020.05.28.13.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 13:04:46 -0700 (PDT)
Received: (nullmailer pid 591263 invoked by uid 1000);
        Thu, 28 May 2020 20:04:44 -0000
Date:   Thu, 28 May 2020 14:04:44 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-i2c@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 11/17] dt-bindings: net: renesas,ether: Document R8A7742
 SoC
Message-ID: <20200528200444.GA591213@bogus>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-12-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589555337-5498-12-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 May 2020 16:08:51 +0100, Lad Prabhakar wrote:
> Document RZ/G1H (R8A7742) SoC bindings.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/net/renesas,ether.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Applied, thanks!
