Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED512AFB81
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 23:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgKKWje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 17:39:34 -0500
Received: from mail-oo1-f66.google.com ([209.85.161.66]:36052 "EHLO
        mail-oo1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbgKKWhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 17:37:33 -0500
Received: by mail-oo1-f66.google.com with SMTP id l20so837879oot.3;
        Wed, 11 Nov 2020 14:37:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i7Ry0yhfayXC/BqLVWYKkth2SuWU6ba0AdxpS9Zg0gs=;
        b=WmjoQ5nPny4xvqrbMbNoblhBL+IzZdbFKJhid8Fp6VouqLx3qGnKNfvxnWL1nDu1e7
         ar4bu1d9HAmrk+Dn+V93iZuCc0HR5Yxm2wjM1N5ctF0CLAFjy722dsXLNIlhxBqI5IHV
         7q2bBuYqQV+bKN6M8Onh0/6baiWmpww9pGKGJbaFIy2PH+NlesTsjc89xUqYpPjGG9pD
         CUnCMpWxO8+vVe4je+VJdr0f0EH5hfJKacbb8+wAR5dhTztETfoCQpTd7h56hVhPyJgQ
         G5M3CgII2m3wyDGvRyKaDJ4rhKKsST9K2N9+BokPExzXaJyT+x45rykNWymHklhLhSSn
         z7ig==
X-Gm-Message-State: AOAM5301TrPo57l7cibYiy0vQkeyg/niYevmN0ajdtCID6wTeIL4paZ7
        rR0Q+9rqQui462T6ysglUw==
X-Google-Smtp-Source: ABdhPJxZdYi7/q5dK+NoVtMT82epFre5O3KgLm3TlKYLSNx0m1CV3kuNyQfGQ22OBbks2Ii+zS3/Zg==
X-Received: by 2002:a4a:a445:: with SMTP id w5mr14003746ool.63.1605134252531;
        Wed, 11 Nov 2020 14:37:32 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id d202sm720330oig.3.2020.11.11.14.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 14:37:31 -0800 (PST)
Received: (nullmailer pid 2170567 invoked by uid 1000);
        Wed, 11 Nov 2020 22:37:30 -0000
Date:   Wed, 11 Nov 2020 16:37:30 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        Scott Branden <sbranden@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Kurt Kanzenbach <kurt@kmk-computers.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ray Jui <rjui@broadcom.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH 10/10] dt-bindings: net: dsa: b53: Add YAML bindings
Message-ID: <20201111223730.GA2169778@bogus>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-11-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110033113.31090-11-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 09 Nov 2020 19:31:13 -0800, Florian Fainelli wrote:
> From: Kurt Kanzenbach <kurt@kmk-computers.de>
> 
> Convert the b53 DSA device tree bindings to YAML in order to allow
> for automatic checking and such.
> 
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
> ---
>  .../devicetree/bindings/net/dsa/b53.txt       | 149 -----------
>  .../devicetree/bindings/net/dsa/b53.yaml      | 249 ++++++++++++++++++
>  MAINTAINERS                                   |   2 +-
>  3 files changed, 250 insertions(+), 150 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/b53.txt
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/b53.yaml
> 

With the rename (don't forget $id):

Reviewed-by: Rob Herring <robh@kernel.org>
