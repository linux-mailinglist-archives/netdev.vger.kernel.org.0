Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8715A21A900
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgGIUaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:30:23 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36230 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgGIUaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 16:30:22 -0400
Received: by mail-io1-f66.google.com with SMTP id y2so3744597ioy.3;
        Thu, 09 Jul 2020 13:30:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KuoJiLkjprainlec1ecjgTMZB2cKWXAmKPaY29PFAzA=;
        b=Dcf+KsjQrxlZDMaX0b9ShyzJj6moESxbayjAzjhaG+f2Ws3bohZADVVUkABjSDppxd
         K5sFjso9oK/fhxfAAfpBWlz5EqULutrgyl0TloJ/WHrrQGwI/XRM7NG79o2orVS7Xlwc
         bgWd5U6CPn5Yj/1piBmXyENsqD8O8PRY0fBMrM5pYuKZJIpKRRIHX4g5pE+Aivr/H1+s
         ZBX3XuSRjxk1M8FXkL9kROA+NCzZKMuyhYBwU7sT/eyDWevNwmtZgcFMYPB/lPAtos/8
         0t/30GT1kzEbBkA8Pg9LWe9pvNmoAQ/fN2QpdWqaLGPZ+1prybKing53y7yYQCy5dGtn
         mecA==
X-Gm-Message-State: AOAM531eK9g1kJYYpfU/BVYdd0icuV+Xma0INoBbIIlPYVmWsWCO/oeE
        WSzBC+X7KWTGhEcrblyru1PeQfrqGQ==
X-Google-Smtp-Source: ABdhPJx3AzvFynIgBhDSUMOIYtDu5GgZICqxbyTyD1+BtuQ9XyEYl6v0a8ONVIl1WqsF5NufN/q8qQ==
X-Received: by 2002:a05:6638:2172:: with SMTP id p18mr75832809jak.63.1594326621896;
        Thu, 09 Jul 2020 13:30:21 -0700 (PDT)
Received: from xps15 ([64.188.179.254])
        by smtp.gmail.com with ESMTPSA id z9sm2615120iob.39.2020.07.09.13.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 13:30:21 -0700 (PDT)
Received: (nullmailer pid 837045 invoked by uid 1000);
        Thu, 09 Jul 2020 20:30:20 -0000
Date:   Thu, 9 Jul 2020 14:30:20 -0600
From:   Rob Herring <robh@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v7 5/6] dt-bindings: net: dp83822: Add TI
 dp83822 phy
Message-ID: <20200709203020.GA836973@bogus>
References: <20200617182019.6790-1-dmurphy@ti.com>
 <20200617182019.6790-6-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617182019.6790-6-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 13:20:18 -0500, Dan Murphy wrote:
> Add a dt binding for the TI dp83822 ethernet phy device.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../devicetree/bindings/net/ti,dp83822.yaml   | 51 +++++++++++++++++++
>  1 file changed, 51 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,dp83822.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
