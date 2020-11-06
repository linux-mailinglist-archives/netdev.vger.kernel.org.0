Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08B42A9E2B
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 20:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbgKFTjS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 Nov 2020 14:39:18 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38472 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727356AbgKFTjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 14:39:17 -0500
Received: by mail-ed1-f67.google.com with SMTP id k9so2430316edo.5;
        Fri, 06 Nov 2020 11:39:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Gv0cSdVc7Eg5peQhu/XCzN6FvfZ7oplCo0L4j+dSzX0=;
        b=ti1B+baq/CqCyN1gvYxfqYp4l2Y+dg9FuoqlQ/QOry9QS46RphdAHVkfP6fRC47bvb
         cK2mvgHo66kaPWwTGk/Z/iL4jMICWs9slkx0CgZ18/9S2WpYaLoLTsT0JpxcY9dcX8v0
         xKxk9DPp5JnQUnBmPsZn9niPKog0QEfxWZ3iQFNKdqjY4Oev6utjO2JJNzYu6WOV2POG
         mjYJiQyqce26VHrdpbauGop8mj/59cHspii43PhukgyF4ELkNl/vNwcx4Wc6pNdb2MOq
         dBgOWQsJAtCQ+3HteDQlyHEwoVwPsLzDjI2vMfycZJiaKHr/aWqm0YWXbYrirUj/IDRo
         Iblw==
X-Gm-Message-State: AOAM532/sfV3w5PbS4CPkQNI1dNe+gI9+/TzOW6T4sNYmwx1NtsZYZE8
        Y6pnCXAEV/gSI5gGhlRFy3U=
X-Google-Smtp-Source: ABdhPJy7AxqfdYuRa4DJO40CTepe9842ZbaB3uaP3tz30Fk7svP62F/AC6y9tTPgkLU1WuergwJldg==
X-Received: by 2002:a50:9993:: with SMTP id m19mr3560762edb.99.1604691555563;
        Fri, 06 Nov 2020 11:39:15 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id y2sm1697348edu.48.2020.11.06.11.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 11:39:14 -0800 (PST)
Date:   Fri, 6 Nov 2020 20:39:12 +0100
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
Subject: Re: [PATCH v5 4/5] ARM: dts: exynos: Add Ethernet to Artik 5 board
Message-ID: <20201106193912.GA329187@kozik-lap>
References: <20201103151536.26472-1-l.stelmach@samsung.com>
 <CGME20201103151540eucas1p2750cffe062d6abff42ee479a218c8eb8@eucas1p2.samsung.com>
 <20201103151536.26472-5-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201103151536.26472-5-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 04:15:35PM +0100, Łukasz Stelmach wrote:
> Add node for ax88796c ethernet chip.
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  arch/arm/boot/dts/exynos3250-artik5-eval.dts | 29 ++++++++++++++++++++
>  1 file changed, 29 insertions(+)

Thanks, applied.

Best regards,
Krzysztof

