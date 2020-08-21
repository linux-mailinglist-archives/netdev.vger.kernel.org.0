Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3815724E2F1
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 00:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgHUWBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 18:01:55 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:34836 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgHUWBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 18:01:55 -0400
Received: by mail-il1-f195.google.com with SMTP id q14so2652904ilm.2;
        Fri, 21 Aug 2020 15:01:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7NhKPiyk6xg8AVb5g3l2MlEWghxB32ju1Cu8YCfofgw=;
        b=t3RgOu1z8SYfySAcVvepbpsSMN4C7j64cW+XTLRZiwnUMl00pwcYcc7wVzQ5JjIx73
         hRj4ifHQCwKHsGOqfSNcocgDSydBsT1zVdPJHEEfmvhHle9b6ESS/YvKsqolubG2/o0i
         yMP4eNhJVqg+/23yfdqiVZzDFg76Xx6UZ/usJPPXPlGpuA8XRVbsmvAunknQbenr+bIP
         asz5zPDyHMPrbOOO6sNt06AFiM6ofpWUt335hqYWqFZraL+zJKPiQOno6U+YsK4NiVu0
         ey3mmoG4Szo8rpqbk28DMa6BBmd1q6S5+xWL8fWyjG4Jn6rvuKf3UYIE+qhifUh0F2Px
         HhGA==
X-Gm-Message-State: AOAM531Jyam4RDPqSL+nScjhf2bWco3XwOlkye9E3EYHfw0LLNbaUxvp
        E9JUdj9MTdqsO52ao+QonZlU1PQlqw==
X-Google-Smtp-Source: ABdhPJzogI3k0iUyC74lTsKH8a075e413GabjD7N2VO9bTT2arKFOuRcOrOJ9kQ+Qks2vMyFZeVb5w==
X-Received: by 2002:a05:6e02:d44:: with SMTP id h4mr4116255ilj.296.1598047314352;
        Fri, 21 Aug 2020 15:01:54 -0700 (PDT)
Received: from xps15 ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id t14sm1971024ios.18.2020.08.21.15.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 15:01:53 -0700 (PDT)
Received: (nullmailer pid 1794851 invoked by uid 1000);
        Fri, 21 Aug 2020 22:01:53 -0000
Date:   Fri, 21 Aug 2020 16:01:53 -0600
From:   Rob Herring <robh@kernel.org>
To:     Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, robh+dt@kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: correct description of
 phy-connection-type
Message-ID: <20200821220153.GA1794798@bogus>
References: <1597917724-11127-1-git-send-email-madalin.bucur@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597917724-11127-1-git-send-email-madalin.bucur@oss.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 13:02:04 +0300, Madalin Bucur wrote:
> The phy-connection-type parameter is described in ePAPR 1.1:
> 
> Specifies interface type between the Ethernet device and a physical
> layer (PHY) device. The value of this property is specific to the
> implementation.
> 
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-controller.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Applied, thanks!
