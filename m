Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB70146DC3B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbhLHTcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:32:45 -0500
Received: from mail-ot1-f50.google.com ([209.85.210.50]:43771 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhLHTco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:32:44 -0500
Received: by mail-ot1-f50.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so3760174otu.10;
        Wed, 08 Dec 2021 11:29:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ckCjpw9Wt0QzAlHPhX31N143mOL1S19Il2QDIOPqOCA=;
        b=hYSQLFqWrvyVaP0p7jbz7oWGfR07KBlhY/fnVk/HPmt9DcfKJQkwG7TPwF3w8jcdoj
         PUiaKXhXOdl7CGkYf+8OhEVu1G2agm2fqZhpocI0mhIZWfsxndxDGD+114v/hR0qFNC6
         RlVo/kwW3SGaOQud/TxPuIjcC7JTRzIO4u7G64Lt3PzmSJcAOO4qhEpFYGFPyQDfRFBG
         vZDwzzztYrkvkh/lebHvnjK4H50ZZyZBZrqk+41DNQgilY6uK0EGbCbhrkYssI4wkGLm
         yvkTfXYho7AikhRMx4KvwePATNw1Enx8MKFqLCZ94VT3dWbZWPm/YmbBdvwlF8As0bnP
         myAQ==
X-Gm-Message-State: AOAM531dzt/b0hrLbbgLyId28bfu6TNQdWNsIZKbTy62u4351/fXRr3I
        Md6GyPSiUWwDlgI40aoheg==
X-Google-Smtp-Source: ABdhPJx9k/ncHmytLAq0AS/b0iHXxpdv44SwlV2qYC2c7mdCzTDY2wF9gxBcriS93JNqHo6bhF/OkA==
X-Received: by 2002:a05:6830:453:: with SMTP id d19mr1365276otc.72.1638991752078;
        Wed, 08 Dec 2021 11:29:12 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id l9sm589939oom.4.2021.12.08.11.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:29:11 -0800 (PST)
Received: (nullmailer pid 193603 invoked by uid 1000);
        Wed, 08 Dec 2021 19:29:10 -0000
Date:   Wed, 8 Dec 2021 13:29:10 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Ray Jui <rjui@broadcom.com>,
        Vinod Koul <vkoul@kernel.org>, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        devicetree@vger.kernel.org, Scott Branden <sbranden@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v3 2/8] dt-bindings: net: brcm,unimac-mdio: Update
 maintainers for binding
Message-ID: <YbEHhk66WwiK3rbC@robh.at.kernel.org>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
 <20211206180049.2086907-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206180049.2086907-3-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 06 Dec 2021 10:00:43 -0800, Florian Fainelli wrote:
> Add Doug and myself as maintainers since this binding is used by the
> GENET Ethernet controller for its internal MDIO controller.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Applied, thanks!
