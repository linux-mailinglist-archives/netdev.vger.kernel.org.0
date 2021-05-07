Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5216A376C63
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 00:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhEGWSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 18:18:02 -0400
Received: from mail-oi1-f171.google.com ([209.85.167.171]:34543 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhEGWSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 18:18:01 -0400
Received: by mail-oi1-f171.google.com with SMTP id l6so10106520oii.1;
        Fri, 07 May 2021 15:17:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GWOEPR/A11iaMsH2CHmu/qIwfEzADJJvuj2QafKuI7c=;
        b=ElbgQlNX9SnSYYP3myOTV1sONa3YVeCc1ld4onGYh6U5FbYlDWpWJP0CsjMkULSl9n
         HxFYrXEZh3YuhhDqCgEc90Wmes3ciGIzuswnPCgnpzCvwoEqW2yyju/OJQflx5sJWINg
         kZ0JR0YGnC0a4lQbDOfe9Ug+pdXPQ+h8BG4zFLZ2lt9L5SBi5rjes58mDiXDhSFuYWPS
         nf7nmVWDxeY8moQ8CuSBgPs4w9UqCATQ7D/L7/LynTX0FRLklJysUhhf8JRqaPInbMxd
         QVLoW9yyiFtQ4twi5AGczEU6jPyjS4ocdJnXtsm52KJSdu3xedLWubGyNMQUnG7Pro3O
         2ZQA==
X-Gm-Message-State: AOAM531KaaNLQPe2Ti8UsxNZse58Dg319k7zNx1fXUprOz87GyxS8gTa
        cAA8FcZIDHkXUXifWrhTKg==
X-Google-Smtp-Source: ABdhPJyccjuuOpjh3uZRoBE6ReAS0JGYPJllnNKSrK89RtwvbRpiMiSzD7NWQO1acGWIvWtOg/YoSA==
X-Received: by 2002:aca:edd1:: with SMTP id l200mr2584059oih.154.1620425820683;
        Fri, 07 May 2021 15:17:00 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id t74sm1208993oie.51.2021.05.07.15.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 15:17:00 -0700 (PDT)
Received: (nullmailer pid 2996061 invoked by uid 1000);
        Fri, 07 May 2021 22:16:58 -0000
Date:   Fri, 7 May 2021 17:16:58 -0500
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Ulrich Hecht <uli+renesas@fpond.eu>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: can: rcar_can: Convert to json-schema
Message-ID: <20210507221658.GA2996032@robh.at.kernel.org>
References: <cover.1620323639.git.geert+renesas@glider.be>
 <561c35648e22a3c1e3b5477ae27fd1a50da7fe98.1620323639.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <561c35648e22a3c1e3b5477ae27fd1a50da7fe98.1620323639.git.geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 06 May 2021 19:55:53 +0200, Geert Uytterhoeven wrote:
> Convert the Renesas R-Car CAN Controller Device Tree binding
> documentation to json-schema.
> 
> Document missing properties.
> Update the example to match reality.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> I have listed Sergei as the maintainer, as he wrote the original driver
> and bindings.  Sergei: Please scream if this is inappropriate ;-)
> ---
>  .../devicetree/bindings/net/can/rcar_can.txt  |  80 ----------
>  .../bindings/net/can/renesas,rcar-can.yaml    | 139 ++++++++++++++++++
>  2 files changed, 139 insertions(+), 80 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/can/rcar_can.txt
>  create mode 100644 Documentation/devicetree/bindings/net/can/renesas,rcar-can.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
