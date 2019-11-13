Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E40FB164
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 14:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfKMNeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 08:34:06 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35165 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfKMNeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 08:34:05 -0500
Received: by mail-oi1-f194.google.com with SMTP id n16so1781893oig.2;
        Wed, 13 Nov 2019 05:34:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VtkrGBXt5/pajENzRj9VBOc7DaKgloGMFkv/89/lG94=;
        b=EolGQHsDR3Sv14Rr13vBoz6kTA12iBQb/0ewyAIXwncnDg+Rb9w/c58gFnuA7MI73N
         +7auJe+3LXdlFwaHsnPlTptS3ta0VwCWpkeawKh0JkzcGux1hJZeJdiURntlcsVMAOSs
         iFbULxpUAkBFvFXmIkSxk8gRzVLtwZtOr4J1gpXGZVjcJ3D3Y/ndRj7Ayo+Cw+GmFsaZ
         Kn5cIFwtGgFZqjd4fZ70V+VmrsKqqAwMe0RhVjjFbukACoCCnsJ7npI2XnK9awk2bnS+
         6s1CYs+z2g1cTbsVFc44RlVlwg3MUl2yPY8QUDAP7N68AX8NzzSGdLumBmSLp71ZBd7T
         xa8A==
X-Gm-Message-State: APjAAAVqr7xUPxT9gfaE8lQZ88AtplscHS/34Yade4SNBGY+INv32FKm
        wyWLt/+Hzjv7k7InnJDDzdDULk4=
X-Google-Smtp-Source: APXvYqyRd+C1kodajD214ZNnNAuzonzUUWf2Kj6mZvmsZY3dAHriEwj8KUccQYCClho2Pzu5E6HcnQ==
X-Received: by 2002:aca:4c4a:: with SMTP id z71mr3511351oia.147.1573652045171;
        Wed, 13 Nov 2019 05:34:05 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id o14sm642232oie.24.2019.11.13.05.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 05:34:04 -0800 (PST)
Date:   Wed, 13 Nov 2019 07:34:04 -0600
From:   Rob Herring <robh@kernel.org>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, Tristram.Ha@microchip.com,
        UNGLinuxDriver@microchip.com, kernel@pengutronix.de,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v1 4/4] dt-bindings: net: dsa: document additional
 Microchip KSZ8863/8873 switch
Message-ID: <20191113133404.GA4824@bogus>
References: <20191107110030.25199-1-m.grzeschik@pengutronix.de>
 <20191107110030.25199-5-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107110030.25199-5-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Nov 2019 12:00:30 +0100, Michael Grzeschik wrote:
> It is a 3-Port 10/100 Ethernet Switch. One CPU-Port and two
> Switch-Ports.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/net/dsa/ksz.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
