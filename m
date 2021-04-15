Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3983D36141F
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 23:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbhDOV2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 17:28:24 -0400
Received: from mail-oo1-f43.google.com ([209.85.161.43]:33481 "EHLO
        mail-oo1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbhDOV2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 17:28:23 -0400
Received: by mail-oo1-f43.google.com with SMTP id i25-20020a4aa1190000b02901bbd9429832so5720340ool.0;
        Thu, 15 Apr 2021 14:28:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LlSYClYyjrVNpAtzPLHqsC4Akv1Vowc0qSp13MS1Yco=;
        b=LhGBadnS2wnAPosB6xJMdhYj8EJpjhSOuHCB79DmTuy35QROrRppm4mBjxxiOJ5CV7
         81XgKjicUqCwlJYkcM3SFTxsasVEOM2xKJEvfLC5wOkJWyJ5XbH8ml9OYfHWbQUtd2Ss
         AXHLnaEYmaHwkr9j9rSaE97oyCBHu5skuKFn3P9dUHOWYSMVwKfaF8RBAMMZ4WRgoF+i
         KObuW5P9Bao9iwgn8Nk/xE943oSlanR8I0zAIY6CBc5gwwaW+d/7L+qbQuU8BtvlUJmN
         e7w2zGdsMLXza0Wzih06um3fqoFpql49pMXbx2m2Wic0frklabpb2lbkziwm1Wad4mjc
         NLJg==
X-Gm-Message-State: AOAM533piEE5sQ9xcU7Yts194hdmSwuzcspHpD0DoofvxovWQbjAp9fy
        gynW25lokoEuNrFt4OOMZA==
X-Google-Smtp-Source: ABdhPJzsY7yEIIJmPGYwN/De+lVERrc0rNefswnCjP8X4ZoqwEwCV18fajBpajLu2Mw9RZpTMAmJ9w==
X-Received: by 2002:a4a:d781:: with SMTP id c1mr861725oou.44.1618522079719;
        Thu, 15 Apr 2021 14:27:59 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 8sm896531ott.68.2021.04.15.14.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 14:27:59 -0700 (PDT)
Received: (nullmailer pid 1911639 invoked by uid 1000);
        Thu, 15 Apr 2021 21:27:58 -0000
Date:   Thu, 15 Apr 2021 16:27:58 -0500
From:   Rob Herring <robh@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 5/5] dt-bindings: net: dsa: Document
 dsa,tag-protocol property
Message-ID: <20210415212758.GA1909992@robh.at.kernel.org>
References: <20210415092610.953134-1-tobias@waldekranz.com>
 <20210415092610.953134-6-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415092610.953134-6-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 11:26:10AM +0200, Tobias Waldekranz wrote:
> The 'dsa,tag-protocol' is used to force a switch tree to use a
> particular tag protocol, typically because the Ethernet controller
> that it is connected to is not compatible with the default one.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> index 8a3494db4d8d..c4dec0654c6a 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> @@ -70,6 +70,15 @@ patternProperties:
>                device is what the switch port is connected to
>              $ref: /schemas/types.yaml#/definitions/phandle
>  
> +          dsa,tag-protocol:

'dsa' is not a vendor. 'dsa-tag-protocol' instead.

> +            description:
> +              Instead of the default, the switch will use this tag protocol if
> +              possible. Useful when a device supports multiple protcols and
> +              the default is incompatible with the Ethernet device.
> +            enum:
> +              - dsa
> +              - edsa
> +
>            phy-handle: true
>  
>            phy-mode: true
> -- 
> 2.25.1
> 
