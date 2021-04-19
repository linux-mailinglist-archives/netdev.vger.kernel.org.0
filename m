Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C54D364A29
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 20:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239503AbhDSS4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 14:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbhDSS4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 14:56:09 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32ACC06174A;
        Mon, 19 Apr 2021 11:55:39 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u21so54563852ejo.13;
        Mon, 19 Apr 2021 11:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2Kl6/XsKB4uVxndqv3mYsWGSZextgKDhPDmtJ8QQBRM=;
        b=q5QFZ/hH5e0MENcVZCOWxgrIcVD+x58W9oga6EEDqv1wAOyLGDVwtrlayWli6GN5AK
         Lmheu1RHFV/UN1f8+FG/4dsc/ebkprq4wsmtISxnN+wQwbsyfAnzprqe0eYyb+6Wg4TR
         12l8yFYZ7CDVSKpM87GyWSnc/pW4OwuTEyxcbT804MOR4psebIb5Z+1rO4oStjzRDODF
         5IyPmwGXHYJ45WSyjD8vQgBn78Rz/zFgdml86o6xj9spVQCZCY7sy1XXEOWuHaJziXJT
         h0Gu/aMVmjFtERx9Y2X23N6ZNDYb5bl034IU9k9Vp40TtY7bBqZTQwqFA9MTTnLvC0Qp
         HknA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2Kl6/XsKB4uVxndqv3mYsWGSZextgKDhPDmtJ8QQBRM=;
        b=n8qfyjWpDKS4W2KdosKM5vZLz6syfz+XRR6hs8kxUQsICN8iuZofEH8mkUSHy4XH+4
         WNjrU4tpfiId169e8h9PwMWTemmEB7XmI/eIYDINnIIQCO0/tLf0IeE5okA6uAZ1moU8
         /zXk0Ih3j2aWAZ1gxu8T8B9cQEGDHqjrtmL8bc5KTC1M+PQFnvswxB1fmQGgL4q5jiS9
         J0w9n2MgUyLJSX/i9Wg8k5EAUvQf+wnjLNzgdLp98RvOdYPYE2rC3qcPZSP4sm29yKls
         rNO0VBhGQYx/HnCbhF3lPS6eFK0XE8vULorqK4HWRONRdoT+SU/yZwDdrX42u21hDGeN
         gw3w==
X-Gm-Message-State: AOAM530+dblYmMczFQ1qE1ILuwJQAY8tblF1Q6dO1ySnKxCZW7SseApU
        mCcxUnJJsW0oiR95b5PyHCGwp7yg5ZyScw==
X-Google-Smtp-Source: ABdhPJyqZ3UKB+EigHMcMycYToCXsV86+2xkdrbAkiThQH6r+sg7GVidMSVwKmTOpk6QSfw6LC70Yg==
X-Received: by 2002:a17:906:b85a:: with SMTP id ga26mr23484691ejb.366.1618858538430;
        Mon, 19 Apr 2021 11:55:38 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t14sm10968949ejj.77.2021.04.19.11.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 11:55:37 -0700 (PDT)
Date:   Mon, 19 Apr 2021 21:55:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Rob Herring <robh@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 5/5] dt-bindings: net: dsa: Document
 dsa,tag-protocol property
Message-ID: <20210419185536.csivtk5557fcr6nh@skbuf>
References: <20210415092610.953134-1-tobias@waldekranz.com>
 <20210415092610.953134-6-tobias@waldekranz.com>
 <20210415212758.GA1909992@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415212758.GA1909992@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 04:27:58PM -0500, Rob Herring wrote:
> On Thu, Apr 15, 2021 at 11:26:10AM +0200, Tobias Waldekranz wrote:
> > The 'dsa,tag-protocol' is used to force a switch tree to use a
> > particular tag protocol, typically because the Ethernet controller
> > that it is connected to is not compatible with the default one.
> > 
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> > ---
> >  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > index 8a3494db4d8d..c4dec0654c6a 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > @@ -70,6 +70,15 @@ patternProperties:
> >                device is what the switch port is connected to
> >              $ref: /schemas/types.yaml#/definitions/phandle
> >  
> > +          dsa,tag-protocol:
> 
> 'dsa' is not a vendor. 'dsa-tag-protocol' instead.

Can confirm, DSA is not a vendor.
You can change to 'dsa-tag-protocol' if this makes acceptance any easier.
