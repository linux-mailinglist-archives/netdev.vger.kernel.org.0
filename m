Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31F23F09CF
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhHRRC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 13:02:56 -0400
Received: from mail-ot1-f51.google.com ([209.85.210.51]:39825 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhHRRCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 13:02:44 -0400
Received: by mail-ot1-f51.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so4900910otf.6;
        Wed, 18 Aug 2021 10:02:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cVPO0RsaG7ZZEe1S+shwggQUFadw+t7i37Gf0lJyhZc=;
        b=NWaNr1TvhuxOqk/9L5CkBq7AhvXDHxVxMVJi30NKl8yKRT5vdCKeEogfr9TiJWTcxF
         hMEsRJC3AK2M4Nqwfeg86dUQ8kgLy6ZyUM1flYR0SZIwp/ienjhFtOhvBktLp2InSG9L
         hHtF6rgge0yZ1w9C4UNDhgR4Ktr5Lk5es3EF7EzVl38yXk6LXXICmAATZL6bWV3TKvpN
         6zGk1aYGAWxuz9NcS4+kWWfbOuEuGZMZm7QLzpZulWH6R1EMezTxf6Kz6na10J6LHEAm
         JLDiUri5JVmiq0doJmwoukvKtcOzatnOFNlU8mt/0yOFiYQT3HaEX385k2ewrC7pdyv3
         eAoA==
X-Gm-Message-State: AOAM533NeJjU/AviyatRF+JHB+lk7+2dxtFM6z86BXJP7OukLi+M0/oB
        tN+g2q+z2Fd72jjvV68Pyg==
X-Google-Smtp-Source: ABdhPJwIsX8I3VTAoTg8Y7M/qyV+hY63Vx99dlOgAMOVUleX/XZ21KM+WUakMXZAb0YpZ1QmYTezOw==
X-Received: by 2002:a05:6830:1f5a:: with SMTP id u26mr7950563oth.135.1629306129355;
        Wed, 18 Aug 2021 10:02:09 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id w16sm139213oiv.15.2021.08.18.10.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 10:02:08 -0700 (PDT)
Received: (nullmailer pid 2760403 invoked by uid 1000);
        Wed, 18 Aug 2021 17:02:07 -0000
Date:   Wed, 18 Aug 2021 12:02:07 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     linux-can@vger.kernel.org, David Jander <david@protonic.nl>,
        kernel@pengutronix.de, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 2/3] dt-bindings: can: fsl,flexcan: enable
 termination-* bindings
Message-ID: <YR09D7S9fNzID4bu@robh.at.kernel.org>
References: <20210818071232.20585-1-o.rempel@pengutronix.de>
 <20210818071232.20585-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818071232.20585-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Aug 2021 09:12:31 +0200, Oleksij Rempel wrote:
> Enable termination-* binding and provide validation example for it.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../bindings/net/can/fsl,flexcan.yaml           | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
