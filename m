Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B163EBC61
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 21:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbhHMTEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 15:04:50 -0400
Received: from mail-oi1-f176.google.com ([209.85.167.176]:33345 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhHMTEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 15:04:49 -0400
Received: by mail-oi1-f176.google.com with SMTP id h11so17425292oie.0;
        Fri, 13 Aug 2021 12:04:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NrmDW/ZBllomE5AxcJODWY1MRA899f7YuB5FSGUGdl4=;
        b=Ikb6ZiWjUBBBReX/1LfTmwtmRNhqRCgpZpQsX2ay7tbuc0THuCzeqhzsZw3Deb8csu
         7WCh19Lnum5+exwTjD7HIwmTjaxKKXQpiTKcGbYCXpCofH4Smu9CsU6Gjr+r1jtkcWJK
         4p+DjM332d8/NUTXCGlTYrP6jhzUmZZI/Ce/ssX5QW+I6qol1cE1V/+lLOrI3HnIwCYL
         I0GkFERoAYLpbYnYAq+nAghP7KRxD+jCl2xMkLmj5zrBVwJNqxn2xF1R0mgH+rsBc2Y/
         y/5/tvqQPJIe6tQK6qJ1qVPAci5yupdhFpGf4qExbnyX0HidZtOTun/0h05ckDoHjmkl
         +xhg==
X-Gm-Message-State: AOAM533Kq7ykPvYOr7PApU9FWMhEG967Oni3m82LvRhB2hXz9q6CSoZQ
        mfssoV4NAk56UD29KMGlPg==
X-Google-Smtp-Source: ABdhPJwqhigabSuyefr+IrvHLf6DHEmD3u1u2FbjzIKZINf4M0ZKaKCqylikcADmgr691peKxmW5kA==
X-Received: by 2002:aca:3c07:: with SMTP id j7mr3309058oia.8.1628881461882;
        Fri, 13 Aug 2021 12:04:21 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id i188sm535845oih.7.2021.08.13.12.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 12:04:21 -0700 (PDT)
Received: (nullmailer pid 3874502 invoked by uid 1000);
        Fri, 13 Aug 2021 19:04:20 -0000
Date:   Fri, 13 Aug 2021 14:04:20 -0500
From:   Rob Herring <robh@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Dario Binacchi <dariobin@libero.it>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5] dt-bindings: net: can: c_can: convert to json-schema
Message-ID: <YRbCNNPbYSC66gIP@robh.at.kernel.org>
References: <20210805192750.9051-1-dariobin@libero.it>
 <20210806072045.akase7hseu4wrxxt@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806072045.akase7hseu4wrxxt@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 09:20:45AM +0200, Marc Kleine-Budde wrote:
> On 05.08.2021 21:27:50, Dario Binacchi wrote:
> > Convert the Bosch C_CAN/D_CAN controller device tree binding
> > documentation to json-schema.
> > 
> > Document missing properties.
> > Remove "ti,hwmods" as it is no longer used in TI dts.
> > Make "clocks" required as it is used in all dts.
> > Update the examples.
> > 
> > Signed-off-by: Dario Binacchi <dariobin@libero.it>
> 
> [...]
> 
> > +if:
> > +  properties:
> > +    compatible:
> > +      contains:
> > +        enum:
> > +          - bosch,d_can
> > +
> > +then:
> > +  properties:
> > +    interrupts:
> > +      minItems: 4
> > +      maxItems: 4
> 
> The driver uses only 1 interrupt, on the other hand the only in-tree
> user the bosch,d_can compatible specifies 4 interrupts.

The DT should reflect all the interrupts. It can't know what some OS or 
some version of OS actually uses.

Rob

