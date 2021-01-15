Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D702F8246
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 18:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731073AbhAOR2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 12:28:01 -0500
Received: from mail-oo1-f42.google.com ([209.85.161.42]:41560 "EHLO
        mail-oo1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbhAOR2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 12:28:01 -0500
Received: by mail-oo1-f42.google.com with SMTP id q6so2381878ooo.8;
        Fri, 15 Jan 2021 09:27:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xdbf/nZWq1DyoQydQMQJD0VQGjVX6ssG5cy5D9hznyk=;
        b=aXwBDO0BTFDDHqiPrCPPmw/a3w4VuF2jYFnS722lB5ppKre+mXpf1PTIlzwgK1WE5v
         ipmmZKs2MOExjzXR96ZDHVxC6qHN+UKYhcoUxvhqfcvoQfCbUFCPev/wnQeLAnjfWbyq
         8JzpJMDEOulW4Kxq+GWoB27lKmCve5+DnaoGWLJPZsJkFAA2YFBm+PwWPPFz8MDhnNRj
         pVlD5+ACO8LTNqVPtdFsy0btyrsUAiU3QaJ7/YGocoCyhyLHuzF+wDn0r6tBGbjc2E4n
         trI+bxLxrhLLur26HNn2r2dQtrptf9pv4BFKthHnX91LL3jJstCcFMwW7b4/jepCcbDj
         nDbg==
X-Gm-Message-State: AOAM533jXsQmV/7jAirPsj5XTIw/rP66PzF/u+jfxHupILfubSlGaVkr
        4ELMFH6RfLyovF8zkw4GG7M2gzXd5g==
X-Google-Smtp-Source: ABdhPJzj7MdSQZ9Txm3E/ya+/J/3ulRP0m+qo2lphvQq28B8haKsLDi1d50WCypoDZhJJmtm+Btytg==
X-Received: by 2002:a05:6820:381:: with SMTP id r1mr9039375ooj.73.1610731639905;
        Fri, 15 Jan 2021 09:27:19 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id p11sm1771883oif.55.2021.01.15.09.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:27:19 -0800 (PST)
Received: (nullmailer pid 1491289 invoked by uid 1000);
        Fri, 15 Jan 2021 17:27:18 -0000
Date:   Fri, 15 Jan 2021 11:27:18 -0600
From:   Rob Herring <robh@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jon Nettleton <jon@solid-run.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] dt: ar803x: document SmartEEE properties
Message-ID: <20210115172718.GA1491253@robh.at.kernel.org>
References: <20210114104455.GP1551@shell.armlinux.org.uk>
 <E1l008O-0004tG-MA@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1l008O-0004tG-MA@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 10:45:44 +0000, Russell King wrote:
> The SmartEEE feature of Atheros AR803x PHYs can cause the link to
> bounce. Add DT properties to allow SmartEEE to be disabled, and to
> allow the Tw parameters for 100M and 1G links to be configured.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  .../devicetree/bindings/net/qca,ar803x.yaml      | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
