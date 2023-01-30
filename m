Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12162681C5D
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjA3VKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjA3VKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:10:14 -0500
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88190F5;
        Mon, 30 Jan 2023 13:10:13 -0800 (PST)
Received: by mail-oi1-f178.google.com with SMTP id dt8so8124992oib.0;
        Mon, 30 Jan 2023 13:10:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RBJKJ6/VwgSwHP7G7YqO0kzXMj6xYtW6R7DRznC2l3M=;
        b=UxLCh5yl6DWLtSmSHeBezWWl9A0S+CdNCW/sHMNU2tmI6rcaDayd7ZY8Ko6JgVifZN
         ioeD1EdlijmkSP95jm2ElvH83l/5LV+ZTtYp2a3fS3gq+SQXjRRxnFG3sjdbKsX/eGCP
         iIsrsa3LYs6AWYlNVSP2GOt4vqSsXcqERMk5pqAHFZLuj7KXaQoq355hWUFWjqS3D1Xq
         x39NkalLKNEWDYfJueecTMkGNt96LAwvFpF2dKjvZ81VnJPygchKQl159lTbZnx6RASJ
         iYwWvhq+x7p6df/nUTLv+1sjrZWP7UnUlBWkMYHacGyRCEbaqErpZUnZQ+HMeNFd3NMY
         LjEw==
X-Gm-Message-State: AFqh2kpKZZ+QRd/4yQ0+lpoUVNGLtQAfiZU/nkefztiJJXbGgiZ44WGl
        ctOMMM0NXh1slRDN/qTZyQ==
X-Google-Smtp-Source: AMrXdXs7D5y8n3+ciZ786qs+JrNTBM8YTqr6YzZmzb6oCf8bW+j3DjUmah8tL0zpZi65IxFG9lHDkA==
X-Received: by 2002:a05:6808:2103:b0:36a:7d3c:b423 with SMTP id r3-20020a056808210300b0036a7d3cb423mr31345506oiw.21.1675113012814;
        Mon, 30 Jan 2023 13:10:12 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id ca26-20020a056808331a00b003436fa2c23bsm5096053oib.7.2023.01.30.13.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:10:12 -0800 (PST)
Received: (nullmailer pid 3377252 invoked by uid 1000);
        Mon, 30 Jan 2023 21:10:11 -0000
Date:   Mon, 30 Jan 2023 15:10:11 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, UNGLinuxDriver@microchip.com,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v5 net-next 10/13] dt-bindings: net: mscc,vsc7514-switch:
 add dsa binding for the vsc7512
Message-ID: <167511300714.3376362.12441778266739540601.robh@kernel.org>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
 <20230127193559.1001051-11-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127193559.1001051-11-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 27 Jan 2023 11:35:56 -0800, Colin Foster wrote:
> The VSC7511, VSC7512, VSC7513 and VSC7514 all have the ability to be
> controlled either internally by a memory-mapped CPU, or externally via
> interfaces like SPI and PCIe. The internal CPU of the VSC7511 and 7512
> don't have the resources to run Linux, so must be controlled via these
> external interfaces in a DSA configuration.
> 
> Add mscc,vsc7512-switch compatible string to indicate that the chips are
> being controlled externally in a DSA configuration.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v5
>     * New patch after a documentation overhaul series
> 
> ---
>  .../bindings/net/mscc,vsc7514-switch.yaml     | 113 ++++++++++++++----
>  1 file changed, 90 insertions(+), 23 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
