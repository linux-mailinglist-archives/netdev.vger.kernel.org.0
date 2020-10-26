Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904FE2990AD
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 16:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783364AbgJZPK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 11:10:59 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44345 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1783253AbgJZPK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 11:10:58 -0400
Received: by mail-oi1-f194.google.com with SMTP id k27so10773220oij.11;
        Mon, 26 Oct 2020 08:10:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3HbYXNrV89e842a6MV9RdUrR65g9NlVHZqi5zKDo5U8=;
        b=QEV+3S137E0rOgbOCh6PNRFLocHrzU/PbObUvxgPRwCPzUvAbZB4oI4lZ3sqt6a7lH
         8sRn9R/hQjQoc6Iws1CTH9fvTIq4seEIj1HSZT5050KeBknKliR1Koy/q2SKFb7gtMk7
         oH+ZnewxT19WH2IQIBQMaGhdEDEoBR9pXVZisKnqmeZgbqtLEJs/u2JnivwXDMHJdnyk
         eOkSiIxqPsTcu1Xn+tkKYek9s3iX8Fm4nOq8RdP7Frq8llcmwU3ej0BVsdMrE049sd2Y
         Ol5lcPcuVnohkMPJ7N5OCOrCUod6FTS6rdmXEh3tGbleShXwi+2lIbsuOYfFMU56ZhWv
         a9xw==
X-Gm-Message-State: AOAM533v/a+aSdV9Guw+5xv5rmQfsxwmKY2EW0FUorgyGSAWGHOKT3uS
        Do/8mCBqrd4UO2s1L4cqpw==
X-Google-Smtp-Source: ABdhPJyWP3XeVGgGn153qgWhB22dCYTxeCn9J85Go+pr8k0vTyH+0Y10upM7t1rL5cpFBdoymPBcbQ==
X-Received: by 2002:aca:db05:: with SMTP id s5mr14038412oig.133.1603725057317;
        Mon, 26 Oct 2020 08:10:57 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id f18sm3795142otf.55.2020.10.26.08.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 08:10:56 -0700 (PDT)
Received: (nullmailer pid 167521 invoked by uid 1000);
        Mon, 26 Oct 2020 15:10:55 -0000
Date:   Mon, 26 Oct 2020 10:10:55 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, jim.cromie@gmail.com,
        Jakub Kicinski <kuba@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 1/5] dt-bindings: vendor-prefixes: Add asix prefix
Message-ID: <20201026151055.GA167469@bogus>
References: <20201021214910.20001-1-l.stelmach@samsung.com>
 <CGME20201021214933eucas1p26e8ee82f237e977e8b3324145a929a1a@eucas1p2.samsung.com>
 <20201021214910.20001-2-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201021214910.20001-2-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 23:49:06 +0200, Łukasz Stelmach wrote:
> Add the prefix for ASIX Electronics Corporation
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
