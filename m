Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FE129589C
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 08:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504402AbgJVGyF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 02:54:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38129 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504386AbgJVGyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 02:54:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id n18so731527wrs.5;
        Wed, 21 Oct 2020 23:54:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wPazIwGxWZXLW6RoMakBTpiJ6QIbqx5NJ2Au3s+esQE=;
        b=sojHn4W2OANVImZz5nQuPhhncC91a2aBMykroN5sQbl5s2VlJnRXtInbdihD3/sMAr
         zwu7Tqj6t8ng3bGQB2KaOrUCqMO3Mh5wZVJB8lbCtMoZczhuYQmgZZEuRAQMKuBK1kul
         lFheECk1UgXeFfEDWEDvJS//yhBLXrly47Dgy5FKplW5OfABF/spnc2hmd1DEZd0b5DR
         ywb9QhWEhEdhEW1TibywCkmZY5GHr3gZVxz5n+lhUUOywGa7vDjE9gWg9nzOUVmv8uuR
         frPLOisEPai8JMfnu772dgOJ4U9F9SX2Ul0wFfNol4kiaBZnwdIwaL0MODrc9I6VXEe7
         UDlA==
X-Gm-Message-State: AOAM5321bUi9BXxnThNKU5p6vW1Axz1vqHsxolHKsky5rncrVIRmRirB
        4zh3Rb9gJ/U1mMM1d6Lp+jA=
X-Google-Smtp-Source: ABdhPJzGbTTMEabPD/ovZyiwJ3eCr6uvy/ZtoLno4XMnWH0VbF/1tP44xnbU3HxS0ABcYBB5P1QdGg==
X-Received: by 2002:a5d:4ed2:: with SMTP id s18mr1034136wrv.36.1603349642999;
        Wed, 21 Oct 2020 23:54:02 -0700 (PDT)
Received: from kozik-lap ([194.230.155.171])
        by smtp.googlemail.com with ESMTPSA id d30sm1804762wrc.19.2020.10.21.23.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 23:54:01 -0700 (PDT)
Date:   Thu, 22 Oct 2020 08:53:59 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v3 1/5] dt-bindings: vendor-prefixes: Add asix prefix
Message-ID: <20201022065359.GA3829@kozik-lap>
References: <20201021214910.20001-1-l.stelmach@samsung.com>
 <CGME20201021214933eucas1p26e8ee82f237e977e8b3324145a929a1a@eucas1p2.samsung.com>
 <20201021214910.20001-2-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201021214910.20001-2-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 11:49:06PM +0200, Łukasz Stelmach wrote:
> Add the prefix for ASIX Electronics Corporation

End the sentence with a full stop.

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
