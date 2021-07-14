Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF173C8A14
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 19:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhGNRxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 13:53:51 -0400
Received: from mail-il1-f181.google.com ([209.85.166.181]:41732 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhGNRxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 13:53:50 -0400
Received: by mail-il1-f181.google.com with SMTP id p3so2434583ilg.8;
        Wed, 14 Jul 2021 10:50:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gX4LTTFLYmc/RxwQWs/nxWN49INTvr4EOLjiuJVqyt8=;
        b=aBdtMzQ5jqqBXEQlrmkn+MV4NoXz30E8MwIuRGRrKYDY9uciNJDxfN8oQYGoXsyoxK
         BviRrpO3WrOvh7mW3k2gpJsMPS4/4R5YfFARZO0zeuKsYAcyIkYiZhfGs1EECBPn6DIX
         bWKz5TOsxcgwlZjDNf8pNM/OFZy/omU5Hu9ooKGHZwD8y5jWxHIqiOZkTQbRc6sDpN6y
         IHZRvqcb2Tj6wYOv9dRQbPdyKsR0WxiDk3N2eaWrZG1pclUWLo4rVpXp39BTuvwz6FP8
         nPCFMNsnWFVLN/s329d8T8s9Xb8rjKUa5RNZlKeCRfqDbYd/wGSaQy/dHEESt0I8/E02
         tW9g==
X-Gm-Message-State: AOAM532Dm09mTR8eVHUlHeduM7vgwrXjnAc/pi64pl57hwRCvXANhAxG
        JHShLfj9CS4dcn0aIOkA0w==
X-Google-Smtp-Source: ABdhPJwViJD9A1z/8IbnngeiMUtPqr1sjgkz40zNSHmxuSdivkQHvEVe1WGdVVVaigX7+ujE+pMXjA==
X-Received: by 2002:a92:d848:: with SMTP id h8mr7598706ilq.282.1626285058401;
        Wed, 14 Jul 2021 10:50:58 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id d8sm1514916ilq.88.2021.07.14.10.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 10:50:57 -0700 (PDT)
Received: (nullmailer pid 2831761 invoked by uid 1000);
        Wed, 14 Jul 2021 17:50:54 -0000
Date:   Wed, 14 Jul 2021 11:50:54 -0600
From:   Rob Herring <robh@kernel.org>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: dsa: sja1105: Fix indentation warnings
Message-ID: <20210714175054.GA2831699@robh.at.kernel.org>
References: <20210622113327.3613595-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622113327.3613595-1-thierry.reding@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021 13:33:27 +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Some of the lines aren't properly indented, causing yamllint to warn
> about them:
> 
>     .../nxp,sja1105.yaml:70:17: [warning] wrong indentation: expected 18 but found 16 (indentation)
> 
> Use the proper indentation to fix those warnings.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Applied, thanks!
