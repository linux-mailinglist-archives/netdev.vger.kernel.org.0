Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDD9415EBB
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241126AbhIWMrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:47:55 -0400
Received: from mail-oo1-f46.google.com ([209.85.161.46]:34662 "EHLO
        mail-oo1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241116AbhIWMqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:46:13 -0400
Received: by mail-oo1-f46.google.com with SMTP id g4-20020a4ab044000000b002900bf3b03fso2105933oon.1;
        Thu, 23 Sep 2021 05:44:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yyCfzvwg7rIpGSlFRFU708w/wushQ4Qj9uJQW9oaWkM=;
        b=EwVXEkrieMOWDaRb19z88majvozBRwUJxYXYnNq+SAtXe8GFCPUbiBX3Kqm+dkB6vX
         NO42j2n1DQKhWjT45xwLWi6bRJthSkb7jGQocwSSwK75Y1L4R1/rVr++yV7hxujXKKKw
         e4p/Gfy/1sJZdicNLQPQcBF60GPxUxaQtUHQSSv3/oMPsC+FqhnKdLR++lNbP3XiQMeD
         GiwpOlbtBgEJGjbNaMzBLcrwGSS1lnmqqI6xsq5lmepwG0++etsbengVoOen37TeVPAe
         W4LNJnjEw8H8tt0tdbrqdoirkVVRaoQndd/e5Z3fdUN/sFw/IEzV3XFQsQRIVkUsj49M
         9nPg==
X-Gm-Message-State: AOAM533aZvYZHtuQyYmI0RNfWaw8K9aqi7sIUkZcgbCR6N2HrlpcMdPy
        RJ3IV0Qjr7iFE2q0zS8+ag==
X-Google-Smtp-Source: ABdhPJzXu7gb0sE2NjJ46JZwTbWeh+Ijwxmw3FPbEw8Q6iZMZJ0aBglmL1tLfscRCdYSN9AElFVH5g==
X-Received: by 2002:a4a:3ecd:: with SMTP id t196mr3527500oot.69.1632401081681;
        Thu, 23 Sep 2021 05:44:41 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id ay42sm1237921oib.22.2021.09.23.05.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 05:44:41 -0700 (PDT)
Received: (nullmailer pid 2822288 invoked by uid 1000);
        Thu, 23 Sep 2021 12:44:40 -0000
Date:   Thu, 23 Sep 2021 07:44:40 -0500
From:   Rob Herring <robh@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        alexandre.belloni@bootlin.com, vladimir.oltean@nxp.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH net-next 03/12] phy: Add lan966x ethernet serdes PHY
 driver
Message-ID: <YUx2uGeXcMFojrXk@robh.at.kernel.org>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
 <20210920095218.1108151-4-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920095218.1108151-4-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:52:09AM +0200, Horatiu Vultur wrote:
> Add the Microchip lan966x ethernet serdes PHY driver for 1G interfaces
> available in the lan966x SoC.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/phy/microchip/Kconfig               |   8 +
>  drivers/phy/microchip/Makefile              |   1 +
>  drivers/phy/microchip/lan966x_serdes.c      | 525 ++++++++++++++++++++
>  drivers/phy/microchip/lan966x_serdes_regs.h | 482 ++++++++++++++++++
>  include/dt-bindings/phy/lan966x_serdes.h    |  14 +

This belongs with the binding change. 

>  5 files changed, 1030 insertions(+)
>  create mode 100644 drivers/phy/microchip/lan966x_serdes.c
>  create mode 100644 drivers/phy/microchip/lan966x_serdes_regs.h
>  create mode 100644 include/dt-bindings/phy/lan966x_serdes.h
