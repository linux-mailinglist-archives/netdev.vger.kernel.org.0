Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486DC221504
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 21:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGOTXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 15:23:30 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39560 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgGOTXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 15:23:30 -0400
Received: by mail-io1-f65.google.com with SMTP id f23so3458131iof.6;
        Wed, 15 Jul 2020 12:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gdwKQpu0Px21p6Yo1ji0WQqiSg9ZqCi72tqfSZPNfnE=;
        b=JDlzrf/iy1rd1hsaXICJVuyZ308k1uDYRYyY3bQxzaJ5ZyotfOT42A0tjXVVsf7Kx7
         WQn6nEFC0nz2wIMyCwvQNc86pVve7rEzQ7355MJ0Du2ZXM4zQg4XT1x1YpW8l4lazA0H
         Ab8B442EpS50IBb0ja8b1ojirM4oE9Z0t43GID4o1Rtt80WfRgI5+zkNLzI4kUrtaKPo
         3/0WCbAIXPO2NBYsMex9DNNxS89TBkJ/eYEW7IXwETxC6K0IQJvzgIdLMWrEzE2QHlAT
         eWrX6e9Boxfgw2iemgC5kq23BCdPEqgmZ6OBzCHrJLoL81qxgl47cTMvIOODWbI+98cR
         aoLw==
X-Gm-Message-State: AOAM531+Y+qDrJfzJJZ88gHTf5128h5u76oeFNDk7I7S1chnADsBHgig
        +dE8V6vBZJFWzCPNAZvwPw==
X-Google-Smtp-Source: ABdhPJwbc9mImdlrnoACZBodTTQTYY0dq9F2rd+dhmlIFNlisTAwMXoWbRXWs9vI0WzIlwOnasAcSg==
X-Received: by 2002:a05:6602:2ac8:: with SMTP id m8mr908011iov.36.1594841009339;
        Wed, 15 Jul 2020 12:23:29 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id x71sm1504496ilk.43.2020.07.15.12.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 12:23:28 -0700 (PDT)
Received: (nullmailer pid 677216 invoked by uid 1000);
        Wed, 15 Jul 2020 19:23:27 -0000
Date:   Wed, 15 Jul 2020 13:23:27 -0600
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: renesas,ether: Improve schema
 validation
Message-ID: <20200715192327.GA677138@bogus>
References: <20200619151429.14944-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619151429.14944-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Jun 2020 17:14:29 +0200, Geert Uytterhoeven wrote:
>   - Remove pinctrl consumer properties, as they are handled by core
>     dt-schema,
>   - Document missing properties,
>   - Document missing PHY child node,
>   - Add "additionalProperties: false".
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  .../bindings/net/renesas,ether.yaml           | 22 +++++++++++++------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
