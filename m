Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94CF71257E0
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 00:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfLRXkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 18:40:37 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:33201 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLRXkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 18:40:37 -0500
Received: by mail-oi1-f194.google.com with SMTP id v140so2171826oie.0;
        Wed, 18 Dec 2019 15:40:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VARAFC9+zJVGLynLPSD/8fNjpOZOSM8utbqoiVOdLxg=;
        b=PqIGvfOkvaNgR64PZbeBjD+g8hoESv2KixJ3HAN98eKZjwgdUf/nUb8C8B0BCC9/mB
         qq8vjvgw4ZosZAdZQ/0AYXnJdJmte5On0RsZ/PofscGwbkg6Fz8O0tGb3kiICKBwoI0m
         J/TGPuGUalINPhBeT7MR4T3fjIzXwWQGtAPs+0yUZAKtOtm5R6Om0oQt7pRSQI23O0zy
         Hs7doFQKMyFjcW5aArCYDjUdwjpqsiOMpeb1UexehDIqARB8jT4IUsBEjgJJTXvLg1Wr
         B3wbCS+YYFbIc+UlQPmofKeAV+jk4WpIb+qJFhBTbCYa+8iIV2DbwExK5nXAe2T78BuS
         J+/w==
X-Gm-Message-State: APjAAAX1Few9flapM0KsMq9am7mk8r+Hhbdvn5Yfcd75GbRkBdIPctmz
        GGt/HsRg4BzmgGJV1ndx5Q==
X-Google-Smtp-Source: APXvYqwB2vw2qHG9y3dCTfJWi2amPTNMHbJ4N9DyWYWIStYuy9XtghchhKEz6jHlCvliPqI2kKXzmQ==
X-Received: by 2002:aca:72cd:: with SMTP id p196mr1579769oic.99.1576712436113;
        Wed, 18 Dec 2019 15:40:36 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id q1sm1454270otr.40.2019.12.18.15.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 15:40:35 -0800 (PST)
Date:   Wed, 18 Dec 2019 17:40:35 -0600
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH] dt-bindings: net: ravb: Document r8a77961 support
Message-ID: <20191218234035.GA13742@bogus>
References: <20191205134504.6533-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205134504.6533-1-geert+renesas@glider.be>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 Dec 2019 14:45:04 +0100, Geert Uytterhoeven wrote:
> Document support for the Ethernet AVB interface in the Renesas R-Car
> M3-W+ (R8A77961) SoC.
> 
> Update all references to R-Car M3-W from "r8a7796" to "r8a77960", to
> avoid confusion between R-Car M3-W (R8A77960) and M3-W+.
> 
> No driver update is needed.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/devicetree/bindings/net/renesas,ravb.txt | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 

Applied, thanks.

Rob
