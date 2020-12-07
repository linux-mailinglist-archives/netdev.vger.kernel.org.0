Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9272D187F
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 19:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgLGSZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 13:25:13 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34674 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgLGSZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 13:25:13 -0500
Received: by mail-ot1-f65.google.com with SMTP id h19so13416858otr.1;
        Mon, 07 Dec 2020 10:24:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m1O1G+zV2kO4jk3UbACjeCYJhnQE4kkHKnxZUsOPyjY=;
        b=mr0o34oRBfSeXLdU2RoWQ4MF38NSLlRafowY4qK2CLf+5GQ+4qtjU0NQsEKI3cAGPD
         hSi6tsqGimrz2XVoJHly4PQJUvIbYhBzKxqB0sV9PNy1R+osia1WxD74kP05ITi2CtoA
         pwFX4Ese4z21imbrKIxEEFqF9Pct8azXig4ZSjT2PHbQRx6Xy9MEQdQ3XzcUeW3hhCtZ
         9/KfKMR6VfxzSZoWUs6v9JslK32MddX8bYYdf94SLXu0iK+xjdMZqE7kY+HaXmavArYa
         YBw++IiY3dRjOg/C/iRO7ibQD4qmltz+7LxJyILoNY6BvpgQbSqMLnGF+UVd/eLBlyJC
         zQqg==
X-Gm-Message-State: AOAM530K0d2vdj0BAJjbnfi3bsQPrMfbpu+WXLOLKgZLxaSnvvAAM7t0
        POYmvRYuXRlCuhl+XC38Nvqep0OGWg==
X-Google-Smtp-Source: ABdhPJxz8l5V6AoslKS7WfaMbptPHMhc+UKpkt9mGl2UWR9QoeurNfGZkTa6je/yL6Zl+ljC/+/udw==
X-Received: by 2002:a05:6830:90f:: with SMTP id v15mr10195901ott.223.1607365471542;
        Mon, 07 Dec 2020 10:24:31 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id k63sm3091682oia.14.2020.12.07.10.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 10:24:30 -0800 (PST)
Received: (nullmailer pid 567087 invoked by uid 1000);
        Mon, 07 Dec 2020 18:24:29 -0000
Date:   Mon, 7 Dec 2020 12:24:29 -0600
From:   Rob Herring <robh@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH v9 1/4] dt-bindings: phy: Add sparx5-serdes bindings
Message-ID: <20201207182429.GA566994@robh.at.kernel.org>
References: <20201207121345.3818234-1-steen.hegelund@microchip.com>
 <20201207121345.3818234-2-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207121345.3818234-2-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 07 Dec 2020 13:13:42 +0100, Steen Hegelund wrote:
> Document the Sparx5 ethernet serdes phy driver bindings.
> 
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> ---
>  .../bindings/phy/microchip,sparx5-serdes.yaml | 100 ++++++++++++++++++
>  1 file changed, 100 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/microchip,sparx5-serdes.yaml
> 


Please add Acked-by/Reviewed-by tags when posting new versions. However,
there's no need to repost patches *only* to add the tags. The upstream
maintainer will do that for acks received on the version they apply.

If a tag was not added on purpose, please state why and what changed.

