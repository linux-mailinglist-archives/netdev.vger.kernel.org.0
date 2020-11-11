Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846022AFB69
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 23:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgKKWfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 17:35:39 -0500
Received: from mail-oo1-f66.google.com ([209.85.161.66]:43170 "EHLO
        mail-oo1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbgKKWdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 17:33:36 -0500
Received: by mail-oo1-f66.google.com with SMTP id z14so827519oom.10;
        Wed, 11 Nov 2020 14:33:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GlGS0LXck2zvjSqZInI29+3nCtaLlmcbk23C9GXQGWg=;
        b=q6w3BdXA++UWhlPBx3l17PANNjYBqe5JOPD5pRZTRYfvQowpH8bDp3w0YVKkrwtA8X
         ninyD7bCf85uoMkk+tVaQntKFaAw2Ru9pgJfkPx2tGcVXn8YSUg1pDncmAKJkvOddH3L
         wm+oVJ6XSpryH9B0ojuhprwjl+zFKFz2zWpfiF2W1TORFcFgBCNO0Bw0nNByAiRHaNM1
         cmosKj8PJu+N66z+AkFh/dcIkpCLhps4zOoId7OMY8NBPoJWnDAKaf5OcPtvZPvpHW+A
         XaejU5WUHSx07HYGG2ie87GmmqMfScww1xfMkOgmubFr401NOGEA3FoLZ/N+FAWBCZEx
         UFXw==
X-Gm-Message-State: AOAM531SbKu4obH1vElLTrcrSaphOS37byYnx+KuBGi5c5nytIBVUbip
        4E5ThJRw1jEw/72Ipx9PTA==
X-Google-Smtp-Source: ABdhPJw4y1JyEVbNvcvh7dUyrE9yri6Sag7u6fPFPiCxL0rb6dHQcl970C8SZwaxLAN3Gpp1taJ0GA==
X-Received: by 2002:a4a:8519:: with SMTP id k25mr18865903ooh.32.1605134013373;
        Wed, 11 Nov 2020 14:33:33 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id j7sm720548oie.44.2020.11.11.14.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 14:33:32 -0800 (PST)
Received: (nullmailer pid 2164300 invoked by uid 1000);
        Wed, 11 Nov 2020 22:33:31 -0000
Date:   Wed, 11 Nov 2020 16:33:31 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Scott Branden <sbranden@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Kurt Kanzenbach <kurt@kmk-computers.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 02/10] dt-bindings: net: dsa: Document sfp and managed
 properties
Message-ID: <20201111223331.GA2164249@bogus>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110033113.31090-3-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 09 Nov 2020 19:31:05 -0800, Florian Fainelli wrote:
> The 'sfp' and 'managed' properties are commonly used to describe
> Ethernet switch ports connecting to SFP/SFF cages, describe these two
> properties as valid that we inherit from ethernet-controller.yaml.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
