Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55FB3D69CA
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 00:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhGZWIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 18:08:47 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:43553 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbhGZWIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 18:08:46 -0400
Received: by mail-io1-f49.google.com with SMTP id 185so13823368iou.10;
        Mon, 26 Jul 2021 15:49:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x5r3y1+DKWIeQAQN8U9/8VbtDbRzxLkCOXbc2pcpkjU=;
        b=oot/0Nl5yctQ/U6bxEgMq2YT7knh8q2al3OfYpPUIhwvUad5njf3Iyd4R00fAHYrId
         W7s37p+r1q1s1m+cxW4/yB25gKYdRCHYDXeOZbLOy71NguEShJ/HGmr3SWoTu+C/ioXC
         wCx1P+ciEQcAoSn3C0TYw67NjofsOdi0mIx2+b6asDrs7/nWWV+kkobVlL/JE5zYI5SA
         5Po/MaD0QWiCK0cQisxuJCqphfH3UALDA0ZzsVqGMJSINqf/kD5p0r5j/yj8NghUqmK9
         JSkKDzNbDGjFXLS27WszLKCJi4DDGOS5vnqm5T6fkKi/f3KA38KhDldQiBxg9iHyX8gK
         qAsA==
X-Gm-Message-State: AOAM530s09EJBJfX8DBOzII8WuEI5o/jrHs55ufmSVeM/vpMUC00K1i0
        ecJk6xGOBEiEcxnG9o0zAA==
X-Google-Smtp-Source: ABdhPJyJjh3WG90d1kwYRJs6UVRWsXpx5xdkuTi7hft+B0IG5gV+4zNE3ygN4r5p+ZgLpM2XEh/RaA==
X-Received: by 2002:a6b:f707:: with SMTP id k7mr16744300iog.125.1627339754633;
        Mon, 26 Jul 2021 15:49:14 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id f3sm739890iob.30.2021.07.26.15.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 15:49:14 -0700 (PDT)
Received: (nullmailer pid 1020198 invoked by uid 1000);
        Mon, 26 Jul 2021 22:49:11 -0000
Date:   Mon, 26 Jul 2021 16:49:11 -0600
From:   Rob Herring <robh@kernel.org>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        olteanv@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch
Subject: Re: [PATCH v3 net-next 01/10] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
Message-ID: <20210726224911.GA1020088@robh.at.kernel.org>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-2-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723173108.459770-2-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Jul 2021 23:00:59 +0530, Prasanna Vengateshan wrote:
> Documentation in .yaml format and updates to the MAINTAINERS
> Also 'make dt_binding_check' is passed
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
>  .../bindings/net/dsa/microchip,lan937x.yaml   | 148 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  2 files changed, 149 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
