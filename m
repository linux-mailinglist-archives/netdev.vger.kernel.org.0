Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C955427C95
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 20:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhJIST2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 14:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhJISTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 14:19:21 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6DCC061570;
        Sat,  9 Oct 2021 11:17:24 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i20so32938890edj.10;
        Sat, 09 Oct 2021 11:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fuBuwonIJ/RYFG6qboWBn9V7FEmG4HhkblayeVkZims=;
        b=ZNED6jBa7yKU3y0a4qmmg0m4NOHYArHGUNDJsaeJXyAv2CTC9NJc7+yM6ML2OTr761
         2RE+wNLxTOQmG7QAwsyOp71L5v7TdgXeKwIAHYV4zr4FbzzhPEBxW2WZJieydPUWzGFw
         qUgVr1/x1B1JCXpP4AwB2bLCVqjPEaNhQHgEi0qoQHjmoQuF2fry3h4Sx9jT0nDrZBWU
         ITVq6gMl96sNOS36X5GomkudDfkwaYTskPOauoOUagcH02z0NOKMnpuFMbRsabWNo69+
         c86nIMQscoPtM3R3peCO+eJxs7Spk4lYRIi3z6ibc1kPjJaGtHVGfr5bpgXohuh5YgXA
         YNBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fuBuwonIJ/RYFG6qboWBn9V7FEmG4HhkblayeVkZims=;
        b=sf0mE8LTBHbkxI0gmLD6xxIHjv411RtbzNH/2XWy8OxWRI4AQapIUJY5dD1NBmxD/q
         IRJPv+U3/2QmFDdis9CkNUcwJqJ9ydj+iyt2FHtjdHhMZ8a7LIZG/VwU6TXdYZxd06Gx
         BIn8vi03DhoLz08UqQYnnmdOWeub9+YXcThONLj3KCtZFvJs+UC80O/dVhogXNxhgptA
         CcOuggkahT9oCqlR51P4QlTd1uonXBSqhxYlCFXlHGiZ1u8/K1IVE64r0pIKHrBrFjGc
         Y7xsAVTr5AsESXTiedZDCW6wKtaUo9H35HSyrjV3efzJWesNWdxqnYLjGisrnqnYlwJf
         gKhQ==
X-Gm-Message-State: AOAM531+y7XS/aiRilbCJ4KZ0LhzlnOoWtCG/bE9ZyoBPTIXEMD9QGRg
        7gtBdH7vh6ITA07FjxdovsqHdQ11gaM=
X-Google-Smtp-Source: ABdhPJzPt4YW3wsGvqc7+shQyegZckapPHFmZy1Q0kXu7hZxEshZjuFYPyViQIpSEUad4HtSnoanpw==
X-Received: by 2002:a05:6402:4389:: with SMTP id o9mr26674669edc.38.1633803442907;
        Sat, 09 Oct 2021 11:17:22 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id t19sm1243182ejb.115.2021.10.09.11.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:17:22 -0700 (PDT)
Date:   Sat, 9 Oct 2021 20:17:19 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 15/15] dt-bindings: net: dsa: qca8k: document
 support for qca8328
Message-ID: <YWHcr0wkdN0XjBNZ@Ansuel-xps.localdomain>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-16-ansuelsmth@gmail.com>
 <YWHQXYx7kYckTcqT@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWHQXYx7kYckTcqT@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 07:24:45PM +0200, Andrew Lunn wrote:
> On Fri, Oct 08, 2021 at 02:22:25AM +0200, Ansuel Smith wrote:
> > QCA8328 is the birrget brother of 8327. Document the new compatible
> 
> birrget?
> 
> 
>

Me sending patch lat at night... it was brother.

> > binding.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > index 9fb4db65907e..0e84500b8db2 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > @@ -3,6 +3,7 @@
> >  Required properties:
> >  
> >  - compatible: should be one of:
> > +    "qca,qca8328"
> >      "qca,qca8327"
> >      "qca,qca8334"
> >      "qca,qca8337"
> 
> This is much nice than the old DT property. But since the internal IDs
> are the same, i think it would be good to add a little documentation
> here about how the 8327 and 8328 differ, since most people are not
> going to look at the commit message.
> 
>       Andrew

Ok will add some description on how to understand the correct compatible
to use.

-- 
	Ansuel
