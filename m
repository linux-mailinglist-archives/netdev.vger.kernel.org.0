Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B25B375C99
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 23:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhEFVIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 17:08:18 -0400
Received: from mail-oi1-f181.google.com ([209.85.167.181]:34478 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhEFVIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 17:08:14 -0400
Received: by mail-oi1-f181.google.com with SMTP id l6so6823397oii.1;
        Thu, 06 May 2021 14:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iKX3LHXZv0BvjS3bipSGfKXJD/9b3cak+lbdOklEPjI=;
        b=uJAexvBEoUWB12pVqTf95bMQc60YcL994Utae3gJyf0ytIuuVH3ddtePHL3QXIu5Rg
         S4XGzHh3CBIHARKdr+Yy3GdNGd/aFtu1IAnjhWFlBm0X3onS2vkxT8uRzcXtFOy00dPD
         EbFvmtBM6zAuo9JQ2sitM1eVxfgH8fPKL70MccEvwttEdJALQhHyFwWkodWaDfUn7zoe
         FgWPj8nQGAuBXE6ihZfmBulWO/4309sjl9NdqWuEULcbLmJvmfY6ZEdP8MS9qjyCLXqr
         zRt0nCScuLENNaqRoyA5iFqasxwrlOnZFlHzgX64v0hDtLehuZDl4bNlQ6Jl5hqUiuqC
         96qg==
X-Gm-Message-State: AOAM532MjU5vBm1SBLTaM3JYOtW72+Q1cOebTxODj3+EpRLINKv9bk9q
        hwUoMrpDVa4fSWGJ/ZZJ/Q==
X-Google-Smtp-Source: ABdhPJxY8vlPgPoMMnP+id8T2vqMqDSW8kt0xtv4unHZPNK+5glEk2Bt3h+JXCBwgRmBBP2j6En6DQ==
X-Received: by 2002:aca:dd82:: with SMTP id u124mr12147758oig.35.1620335233763;
        Thu, 06 May 2021 14:07:13 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id i18sm720872oot.48.2021.05.06.14.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 14:07:13 -0700 (PDT)
Received: (nullmailer pid 802405 invoked by uid 1000);
        Thu, 06 May 2021 21:07:12 -0000
Date:   Thu, 6 May 2021 16:07:12 -0500
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 09/20] devicetree: net: dsa: qca8k:
 Document new compatible qca8327
Message-ID: <20210506210712.GA802352@robh.at.kernel.org>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-9-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-9-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 05 May 2021 00:29:03 +0200, Ansuel Smith wrote:
> Add support for qca8327 in the compatible list.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
