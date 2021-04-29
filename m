Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E62B36F06E
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 21:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbhD2TYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 15:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234292AbhD2TUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 15:20:49 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BEAC06138B
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 12:20:00 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id h4so58989507wrt.12
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 12:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=a3CpVQZ8aV3Tj3Vdd2PnPs8NyjMlVHJ8Wg502P1LUKo=;
        b=OZrJaow6sYDuvdfYXiA2HW4XGAuP5hH7jyYb3zhlY5TxVBKxnV+DEhGNJWqfuci6ci
         Z3c+oTp2maAKG2g1TPVJgWIidZHvww8/2w2FBTbJ/7GUeMM+az911CN5h/MMEmAQeuaF
         lU3jG9IBz2AMqTpH35XgrZqIp+m8jfG4UZ8JxTL1iqICrq6guN8bKp5dxTmGWv94eUin
         Qq/1IqwgCZaoZpBMlpELHBT0JRbua2RWR0XhToJpTJaNJmStmL2MKSgRHyzqTFdfwxsF
         Qp+DWDODZ/ZKahL4cuQ3LrUUlWYsjGiytIR9KuOCrUgJYMbnplGtAs34WWQ786Ubbben
         KeJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=a3CpVQZ8aV3Tj3Vdd2PnPs8NyjMlVHJ8Wg502P1LUKo=;
        b=kXbqnyvj+2U+ucJd0PtNs9xl5RXc7G4hRmC9YmNqDDm/HTAAJhWej/p6MPlnV5xcgw
         3ws4kzQDFXP1Aswd7faHjimsx1HLtJjImFj2Ux3I3s3r1sRpaXr88y1klEzbfYSDUEe/
         jJjjl/z4nMkaFlpEMvM+b+Gnrehijj4GP4WPUHLIEF3kOsZUloa23HeDu+FionUlTfn0
         zTW2N5wyyLaOkB+LNdohzdXZj5tdwr4vQxq8yhg7xWsWriSYfp5JvU5FSmtREw86xTRT
         8dG08OvX4TfJj2XTIw7WvYjJXuOs0nPqmgVGQWpeL3YzOwDnnqhPaVXF1nNfsORy/HmH
         Sx+A==
X-Gm-Message-State: AOAM5334L07wvG4QLm5RQtiNvVzybvyrthuhntKFBBvdv1rvmI+Cite4
        qI45rJ4xaLOVa8ZN6F1W0Ap7TA==
X-Google-Smtp-Source: ABdhPJzWUa9ryD/T+eDkGPNcW0qKaF99RcmCbCJvHT51XVxGZiZ+3gCFC+u06g7mKkh+kxlio7sz8g==
X-Received: by 2002:a5d:674c:: with SMTP id l12mr1456412wrw.357.1619723999741;
        Thu, 29 Apr 2021 12:19:59 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id a15sm7078207wrx.9.2021.04.29.12.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 12:19:59 -0700 (PDT)
Date:   Thu, 29 Apr 2021 21:19:57 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        linus.walleij@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: Convert mdio-gpio to yaml
Message-ID: <YIsG3dOpVxqyC5J4@Red>
References: <20210428163120.3657234-1-clabbe@baylibre.com>
 <YIm1REuYDPUwqSYf@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YIm1REuYDPUwqSYf@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, Apr 28, 2021 at 09:19:32PM +0200, Andrew Lunn a écrit :
> > +  gpios:
> > +    minItems: 2
> > +    description: |
> > +      MDC and MDIO lines connected to GPIO controllers are listed in
> > +      the gpios property as described in section VIII.1 in the
> > +      following order: MDC, MDIO.
> 
> You should probably add maxItems: 3, or however you describe this in
> yaml. You often find with x86 machines you don't have GPIOs, just GPI
> and GPO, and you need to combine two to form the MDIO line of the MDIO
> bus.
> 

I will do it.
Thanks
