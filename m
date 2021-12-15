Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B8F4764BC
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 22:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhLOVlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 16:41:07 -0500
Received: from mail-oo1-f43.google.com ([209.85.161.43]:35587 "EHLO
        mail-oo1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhLOVlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 16:41:07 -0500
Received: by mail-oo1-f43.google.com with SMTP id e17-20020a4a8291000000b002c5ee0645e7so6322612oog.2;
        Wed, 15 Dec 2021 13:41:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=83sefhyi8pLfwQAlKQtsqfA9OtRTB/qMJU5Z9a5pxHo=;
        b=k65FyZy4lhY/kbl9pSZgCUscjPx2Uv9FwQRN/2UqBDGsqdiHzGVaulxMZphwu1nkcI
         V66/5xXfs0Oy8lAGL1WKZSQWOdlFO+HY6LBccgtaNWYVierRC1bv5QBQS5I/iYP3pl0y
         5+R5iLYcAQE3NO+LcTkNiKcAWH/k6CBOyW8aHybU2vWywGFWcDDmvTs4DSEirLBOu1st
         EKhU+EBwtm5AVm9ALgcddK/JWFJWoV0Z+u68moGZDF+UXWByBt5coPNmDKHKFbM9BfHA
         t7swAt23YQjSZ9eqleflPTlv+2z5z5sEHQzI05NSkT/HdjGHIsaLHB73mWnXixEboGeK
         v7cw==
X-Gm-Message-State: AOAM531B7BAqy7PI9H2tem0AAOYChmGzUVQuglJLGmOsM5JjNUyAxNJo
        /HQKIsWyiYZtSc5JKslRJFIfS/6SYQ==
X-Google-Smtp-Source: ABdhPJwFH+qsXOdTdC5VvBYP35gdgxLy5NCnQ1+Eo/YD8Ow31Jwmgjt1yekHspFMfe1Nbitvp5plDw==
X-Received: by 2002:a4a:7d52:: with SMTP id q18mr8938275ooe.52.1639604466272;
        Wed, 15 Dec 2021 13:41:06 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id l24sm655162oou.20.2021.12.15.13.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 13:41:05 -0800 (PST)
Received: (nullmailer pid 1888423 invoked by uid 1000);
        Wed, 15 Dec 2021 21:41:04 -0000
Date:   Wed, 15 Dec 2021 15:41:04 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     devicetree@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH devicetree 1/2] dt-bindings: phy: Convert generic PHY
 provider binding to YAML
Message-ID: <Ybpg8OpVCmWqNOL2@robh.at.kernel.org>
References: <20211214233432.22580-1-kabel@kernel.org>
 <20211214233432.22580-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211214233432.22580-2-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 12:34:31AM +0100, Marek Behún wrote:
> Convert phy-bindings.txt to YAML. This creates binding only for PHY
> provider, since PHY consumer binding is in dtschema. Consumer binding
> example is provided.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  .../devicetree/bindings/phy/phy-bindings.txt  | 73 +------------------
>  .../devicetree/bindings/phy/phy.yaml          | 59 +++++++++++++++
>  2 files changed, 60 insertions(+), 72 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/phy/phy.yaml

We already have phy-provider.yaml and phy-consumer.yaml in dtschema 
repo. Add what's missing there (anything copied from here will need to 
be relicensed).

Rob
