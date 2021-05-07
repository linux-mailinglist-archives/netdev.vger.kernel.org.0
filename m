Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0386376C6E
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 00:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhEGWUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 18:20:08 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:44970 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhEGWUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 18:20:06 -0400
Received: by mail-ot1-f42.google.com with SMTP id r26-20020a056830121ab02902a5ff1c9b81so9197445otp.11;
        Fri, 07 May 2021 15:19:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fwadNbV8+KkUs8qFmkpXR6d10ttjnqJmvX8UqFQkIKY=;
        b=MEF1wbeEDG5NtiFRz01zBckm4QDsjY8KUdbZXQ8w3glwb0OO6u43YHZRJKjBz0A18d
         T6cQ7Qli5GfZMRt3Jg6ABj89X2qYadLFb2xh66b8raIEHQkrYj1z2RFVaqsZRWRNJTVR
         d1oksobaHo9qxtV2z09w0DsxzCfIR2m0hQZQmf/ptHWKyQuuhnmc9+ePgPdkdYNYlmBY
         dXHYLEzBETXDuT6mu6Ay86SxqX+vok3Yo1/eA6SqPgwhlBVgc/o/Rq0LBU8MwFZn/TfE
         xYQANrqLLP8GalH4be9NoJJ88/UbF1QTGunZ7/RIbbwxa5GGPXODAcoeU2tMp97G3mIN
         /KtQ==
X-Gm-Message-State: AOAM531xGUmEIFofXUSsRZFJ5zX4sInK/vLs5EmH4fNhX+gd9uLeItkb
        1H5j7/R+8o8BIJJ9rJsN/Q==
X-Google-Smtp-Source: ABdhPJyCcbQmiRpJd2CqQnKjgYiRFopMfH1qEjpjVeMf60tjrz3OfcABPWEyfBk+W1ThZPQ79aHO6g==
X-Received: by 2002:a9d:5c11:: with SMTP id o17mr10079687otk.178.1620425944844;
        Fri, 07 May 2021 15:19:04 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 186sm1322592oof.14.2021.05.07.15.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 15:19:04 -0700 (PDT)
Received: (nullmailer pid 2999408 invoked by uid 1000);
        Fri, 07 May 2021 22:19:03 -0000
Date:   Fri, 7 May 2021 17:19:03 -0500
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Ulrich Hecht <uli+renesas@fpond.eu>, netdev@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: can: rcar_canfd: Convert to json-schema
Message-ID: <20210507221903.GA2999378@robh.at.kernel.org>
References: <cover.1620323639.git.geert+renesas@glider.be>
 <905134c87f72e2d8e37c309e0ce28ecd7d4f3992.1620323639.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <905134c87f72e2d8e37c309e0ce28ecd7d4f3992.1620323639.git.geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 06 May 2021 19:55:54 +0200, Geert Uytterhoeven wrote:
> Convert the Renesas R-Car CAN FD Controller Device Tree binding
> documentation to json-schema.
> 
> Document missing properties.
> The CANFD clock needs to be configured for the maximum frequency on
> R-Car V3M and V3H, too.
> Update the example to match reality.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> I have listed Fabrizio as the maintainer, as Ramesh is no longer
> available.  Fabrizio: Please scream if this is inappropriate ;-)
> ---
>  .../bindings/net/can/rcar_canfd.txt           | 107 ---------------
>  .../bindings/net/can/renesas,rcar-canfd.yaml  | 122 ++++++++++++++++++
>  2 files changed, 122 insertions(+), 107 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/can/rcar_canfd.txt
>  create mode 100644 Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
