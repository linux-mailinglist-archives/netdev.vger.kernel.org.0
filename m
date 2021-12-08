Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A4E46DC7A
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239824AbhLHTwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:52:54 -0500
Received: from mail-oi1-f179.google.com ([209.85.167.179]:35663 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239819AbhLHTwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:52:53 -0500
Received: by mail-oi1-f179.google.com with SMTP id m6so5577510oim.2;
        Wed, 08 Dec 2021 11:49:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4Wh1I5JYEr/o41ru6y2qk0Uzdgv5Ih2RCK1RyBVMOWc=;
        b=QUq+5+ZPOLzBJGcLEFbdQgCvncS7PTns+VLR4kD0rr64zDMHy3I8B6vqukAILIwHsL
         nj0J0dmlyB9BkFoOuhEoGSAZjyb0fonkxOK5ERzWZrEv+ULjfBfQnMtM6hDEMK0d467q
         MYvG3OwZ+g2Y2ssAUYoqkzlI7e4eyOlH1Hs7VENMbM39nOCoAxS6IAFYLyOLhDMaJ4O3
         42pDZ5gChoWZiHxhgJ77Ow8TVuv6BbY5CRh28UPVUTOzriGWCEb9nHOzWffk7kVcNyFd
         HXj0pw4lyoGBcEfDoBiW62UmYzoIcrg2byPl6acAPjJ5EpdSWQW8Qd9R7y80CKEAqqdP
         osjw==
X-Gm-Message-State: AOAM531YBZ3nYNss9vBWNLZJRBxRt819Zy97PFjad2nYy8duI8+2PM8J
        VXXSOZHsatJPWGYavm4WXg==
X-Google-Smtp-Source: ABdhPJwyBIV3aQbgMKzfqWmWyLPrM7CHHKkCpSkAUAumo1jNWI5hmwmTU0fRkaUVEt8X5mnBTN3FwQ==
X-Received: by 2002:a05:6808:3097:: with SMTP id bl23mr1583944oib.77.1638992960658;
        Wed, 08 Dec 2021 11:49:20 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id g24sm642748oti.19.2021.12.08.11.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:49:19 -0800 (PST)
Received: (nullmailer pid 256878 invoked by uid 1000);
        Wed, 08 Dec 2021 19:49:18 -0000
Date:   Wed, 8 Dec 2021 13:49:18 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vinod Koul <vkoul@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Ray Jui <rjui@broadcom.com>, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Scott Branden <sbranden@broadcom.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH v3 8/8] dt-bindings: net: Convert iProc MDIO mux to YAML
Message-ID: <YbEMPhJ/xuDDiQl3@robh.at.kernel.org>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
 <20211206180049.2086907-9-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206180049.2086907-9-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 06 Dec 2021 10:00:49 -0800, Florian Fainelli wrote:
> Conver the Broadcom iProc MDIO mux Device Tree binding to YAML.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../bindings/net/brcm,mdio-mux-iproc.txt      | 62 --------------
>  .../bindings/net/brcm,mdio-mux-iproc.yaml     | 80 +++++++++++++++++++
>  2 files changed, 80 insertions(+), 62 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml
> 

Applied, thanks!
