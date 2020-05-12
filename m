Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CFC1D019A
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 00:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731463AbgELWKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 18:10:05 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33143 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731171AbgELWKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 18:10:05 -0400
Received: by mail-oi1-f193.google.com with SMTP id o24so19690421oic.0;
        Tue, 12 May 2020 15:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=q6CAAU7vleDGueuJGVvolBhXIu/csSl1xRiaOGj3440=;
        b=i6t6SNmcnJlmGQ70z/g6b37BQoEpZJ39Y0bTbQfGDUwzZvdxJ/Wgo5PmbE/ST8yzFP
         JIonDj16L2ovdSTxrIoDJ4wyJqEFT4VdeOcSaK//nrpJjx9UEl6N4GI5rTjs3d8JNsXZ
         5OvuMfL+GdVdfNaoZeiaBqqbxoVMIa0ycc2VK6S3YMTeU67lyfPj4gbQnYtcABJUC9lX
         a0ZEz2d7VhwPmC4mNdHJZwu58l1MFry/1dTH7JbIZT1tP0UhJfVNflP0ZsrDPVSFilbJ
         hLUEOTE3lk2yIYjFfXDeLhcZLvcKsR2Gq4W8EeVrRedUp8kgxpsRw0MWb0NeVNb5Uhvq
         P2iw==
X-Gm-Message-State: AGi0PuaN4cCOIBowU+A40YJSfRHzROs8r3PHG61mQd2t4qBKX1XAlz7v
        274M2Gyttd/57HX0sY8aVtqRgV8=
X-Google-Smtp-Source: APiQypLw7zczZZ/cmpR/UVgqIUbJ0LI2bRfUOe7N1KLLVlXaHRfbsnNpK4kUSO++hz7BmofQdUffjw==
X-Received: by 2002:a54:4510:: with SMTP id l16mr23819423oil.151.1589321403979;
        Tue, 12 May 2020 15:10:03 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id r10sm3769706otn.70.2020.05.12.15.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 15:10:03 -0700 (PDT)
Received: (nullmailer pid 23234 invoked by uid 1000);
        Tue, 12 May 2020 22:10:02 -0000
Date:   Tue, 12 May 2020 17:10:02 -0500
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        netdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v2] dt-bindings: net: renesas,ether: Sort compatible
 string in increasing number of the SoC
Message-ID: <20200512221002.GA22502@bogus>
References: <1588519279-13364-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588519279-13364-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  3 May 2020 16:21:19 +0100, Lad Prabhakar wrote:
> Sort the items in the compatible string list in increasing number of SoC.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Changes for v2:
>  * Included renesas,ether in subject instead of sh_eth.
>  * Included Reviewed-by tags.
> 
>  Documentation/devicetree/bindings/net/renesas,ether.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

I already applied v1. 

Rob
