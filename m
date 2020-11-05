Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029F62A89BB
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 23:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbgKEW0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 17:26:55 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44108 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKEW0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 17:26:54 -0500
Received: by mail-ot1-f65.google.com with SMTP id f16so2866098otl.11;
        Thu, 05 Nov 2020 14:26:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=UB3JnZ8ZO2WhkCksk0bd/Ph2fVdk0d46PH2fs96dUDM=;
        b=LV2q1fjYkneGaXDQUcOFvMyA2uiMtu1YtrExDW5WiN1vtZV2+P6d7q55ZakKhiXN9S
         Oi9R72CSLl/1nyVxNvHsW9LVUSg4yxzz8YALw2dtcyzr91Krz5H0NYknNAO567uMaY7T
         O6+qZEvhp2yeTvlqUSB6/RetedZH7YskzRrruhAT6Uwed1Q/NvDQ48cgdXi9ZZNkD1yo
         YMBMMI74MH5AuLVSvtkxlEeCWalwzY5NZ0GI7FhB8R1kwdBXyzG2nHatJGUaXwJL5U7c
         OdOmpuTBVMZ5O9+bk9inWjCN8p/q1fLxtbYsI1nUPyYvb5OUsi1DNxhvwSafkg5IfWva
         jPzQ==
X-Gm-Message-State: AOAM530pOFzUoeGynPpbqNFk/mDQt++5Z+YGUQoIDG14qG48UaWjmQx5
        9OYokSVcL8bC3O6ddLCACg==
X-Google-Smtp-Source: ABdhPJw+B0xyUSen1aJS+VSkyCAjmi3h3Ui8u7d2MZ50yhm/Xda7Hgl0eduKXYsAlGvM6EostU/GKg==
X-Received: by 2002:a9d:20a8:: with SMTP id x37mr3290682ota.94.1604615213562;
        Thu, 05 Nov 2020 14:26:53 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id r184sm692177oie.20.2020.11.05.14.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 14:26:52 -0800 (PST)
Received: (nullmailer pid 1913256 invoked by uid 1000);
        Thu, 05 Nov 2020 22:26:51 -0000
Date:   Thu, 5 Nov 2020 16:26:51 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     linux-samsung-soc@vger.kernel.org, jim.cromie@gmail.com,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>, Heiner Kallweit <hkallweit1@gmail.com>,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v5 2/5] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Message-ID: <20201105222651.GA1913164@bogus>
References: <20201103151536.26472-1-l.stelmach@samsung.com>
 <CGME20201103151539eucas1p234b5fe43c6f26272560a7d2ac791202f@eucas1p2.samsung.com>
 <20201103151536.26472-3-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201103151536.26472-3-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 Nov 2020 16:15:33 +0100, Łukasz Stelmach wrote:
> Add bindings for AX88796C SPI Ethernet Adapter.
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  .../bindings/net/asix,ax88796c.yaml           | 73 +++++++++++++++++++
>  1 file changed, 73 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
