Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AC23DF677
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 22:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhHCUhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 16:37:37 -0400
Received: from mail-il1-f171.google.com ([209.85.166.171]:40572 "EHLO
        mail-il1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhHCUhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 16:37:35 -0400
Received: by mail-il1-f171.google.com with SMTP id d10so20682658ils.7;
        Tue, 03 Aug 2021 13:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RgbpvV+DJy/21H+Ja2A5N8HnP9/V3qNrzvs5c+zEWSo=;
        b=EH3aYG9jFRhqYGRHjwTmujbY5+CwYxjuCd0bkrIXqjb2KGZf8Wi4GcHk6eJQMpaAOT
         KveOqQb6YSDf6o0fcPlaYiLrjWYQdRk+J1JXaly14kRpsmTKqoKqu5AyDhXIoLZEQ6Ys
         gAqGYfLuUanSxHTAClv/x7bQGBVsxcwwjzgsZOH+jmUxBlAY/aQqHU1gxA0+0m9ROXIF
         1r8Y6JxPhT9Q7l2AIrzaXKYCU9Q8gX9MnZ3wTFWrZRT5yUma5WR7o/TjWMVAKrna1O9u
         JFVe36yRpVdkTvUcLmCnFMDM+L/3WuOLaQLQRtCAbgPQMN/E8DODKcPOZG8XZsCdt8Ui
         d+qA==
X-Gm-Message-State: AOAM532c3o45FeytWtVDLbdjq80/yt+WzeOS/HEzsZjzpQjek8ouEM5A
        BMYm7VLVxSGUe8KB8YSX6A==
X-Google-Smtp-Source: ABdhPJyATthjBsMfRcIXUdC7NeqjYlGbYj+67hncrcnvbFtPRufq2XzZBFa4KY9caXhFlyY1ix/vpA==
X-Received: by 2002:a05:6e02:6cc:: with SMTP id p12mr2136265ils.13.1628023044165;
        Tue, 03 Aug 2021 13:37:24 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id p1sm2907ilh.47.2021.08.03.13.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 13:37:23 -0700 (PDT)
Received: (nullmailer pid 3689699 invoked by uid 1000);
        Tue, 03 Aug 2021 20:37:21 -0000
Date:   Tue, 3 Aug 2021 14:37:21 -0600
From:   Rob Herring <robh@kernel.org>
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-can@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Nishanth Menon <nm@ti.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        devicetree@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH v2] dt-bindings: net: can: Document power-domains property
Message-ID: <YQmpAfV5UrvOwROE@robh.at.kernel.org>
References: <20210802091822.16407-1-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802091822.16407-1-a-govindraju@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 02 Aug 2021 14:48:22 +0530, Aswath Govindraju wrote:
> Document power-domains property for adding the Power domain provider.
> 
> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> ---
> 
> Changes since v1:
> - removed reference in the description
> 
>  Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
