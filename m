Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA75C375E0E
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 02:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbhEGAwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 20:52:53 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:34754 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhEGAwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 20:52:51 -0400
Received: by mail-ot1-f41.google.com with SMTP id u25-20020a0568302319b02902ac3d54c25eso6594516ote.1;
        Thu, 06 May 2021 17:51:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1oMvkH7lap0BqARISWBdTYXD6qDV6VvBmCGhELos5RA=;
        b=LeVdO+1vythN/hMsLuJuDQgYZSsZTqR0LyoZtvVvDltmUuJJ55PoLbxm1lvZ+bkbb0
         iZ0JGjYwN+3HuWrzlvJGTh9njWUmTRnzBGuWeZ5hoSgEW5pVQfGnViNEf6FU7xRUH9ws
         9aQ7rvd8tRItR1k69+Wsj+F00seP46aHS7uKDxgZ/aAXUdtVkPoxQVSPZ+HWFNZj3q9e
         oOjSMhQQ37uTYHxVh4rjTscfXOq627YT7sOl0ZvWTAGyDzqnAK++ADZPz4kIaQ91bi6o
         WjaAU5K8bGfX7h7uZO8FQQKsGHDyDMDtGeHNKvu1V/w220pEOZhS40DPGbWXJ84SSqDJ
         bw3A==
X-Gm-Message-State: AOAM530wQvWrSYo5T91e2hYCT/cpYLlMlxFLmI9uKXMskIQZUx13xHkn
        s4Tuq/lEF7D2O3k8T16stg==
X-Google-Smtp-Source: ABdhPJxJslynABDD4IZSwF0YWJ1VdRqG6Gcl3L0tfHmjUr8H5+oGA09wMWF2ZkTEKw6cHpqwOnK2bg==
X-Received: by 2002:a05:6830:4111:: with SMTP id w17mr6095717ott.99.1620348712375;
        Thu, 06 May 2021 17:51:52 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id r124sm720449oig.38.2021.05.06.17.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 17:51:51 -0700 (PDT)
Received: (nullmailer pid 1096458 invoked by uid 1000);
        Fri, 07 May 2021 00:51:50 -0000
Date:   Thu, 6 May 2021 19:51:50 -0500
From:   Rob Herring <robh@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH v5] dt-bindings: net: Convert mdio-gpio to yaml
Message-ID: <20210507005150.GA1096383@robh.at.kernel.org>
References: <20210505202815.2665920-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505202815.2665920-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 05 May 2021 20:28:15 +0000, Corentin Labbe wrote:
> Converts net/mdio-gpio.txt to yaml
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
> Changes since v1:
> - fixes yamllint warning about indent
> - added maxItems 3
> 
> Changes since v2:
> - fixed example (gpios need 2 entries)
> 
> Changes since v3:
> - fixed gpios description
> - added additionalProperties/type: object
> 
> Changes since v4:
> - fixed maintainers list
> 
>  .../devicetree/bindings/net/mdio-gpio.txt     | 27 ---------
>  .../devicetree/bindings/net/mdio-gpio.yaml    | 58 +++++++++++++++++++
>  2 files changed, 58 insertions(+), 27 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/mdio-gpio.txt
>  create mode 100644 Documentation/devicetree/bindings/net/mdio-gpio.yaml
> 

Applied, thanks!
