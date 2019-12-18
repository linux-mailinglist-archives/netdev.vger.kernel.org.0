Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3215125293
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfLRUFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:05:31 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33155 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfLRUFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:05:31 -0500
Received: by mail-oi1-f196.google.com with SMTP id v140so1826450oie.0;
        Wed, 18 Dec 2019 12:05:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=luwrgC7+qH/Ur9A/Nsp7QnQnVUaRjavxT2mne/G9Kmw=;
        b=Hybqm75uoXgIyLYn8gSn9CdaaFeFGYRofheEEl5U599ikXocJMTADVpJ97yb6PPfJw
         3dosJwisBVo0fxzWSiAj2JicNjYDkOScC8G2+Onlr9FUXyrFOw3neSym7vyfNfN2U5Fn
         pXhX72JDUOmPRJUxb/1zueY63dBDBB0kDsmk2tqMjTKZ8HUTdydZJY4ZAfez9Q/6kiA3
         KF4faGPUr5V/AOg4FOmipH+w4Vs7yVOIwslqYs3REWT9ijq9a6Orzkh2QL7vP14r5won
         dqI/EfW3zTKNxzcXIHLiLmEIgElmG392BFy83hb2NqCgmW88dK3SkVLoSGvnZ2qTXy0+
         Q0dQ==
X-Gm-Message-State: APjAAAXZYbOK3exyVbwLoJTYrHoYlzxxR6CZMwkUpXePFBHeqmfvZwnA
        /5HOUkVoHQ7JUrquysk+Ag==
X-Google-Smtp-Source: APXvYqyKtPCzZ9eJN7d2aG+nZxd6kk8OkqyiXUCvKvUCm4No2qVARb/BxbijMUzokBU6hqkVURb75g==
X-Received: by 2002:aca:6086:: with SMTP id u128mr1338321oib.12.1576699530172;
        Wed, 18 Dec 2019 12:05:30 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id n2sm1130788oia.58.2019.12.18.12.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 12:05:29 -0800 (PST)
Date:   Wed, 18 Dec 2019 14:05:28 -0600
From:   Rob Herring <robh@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V6 net-next 09/11] net: mdio: of: Register discovered MII
 time stampers.
Message-ID: <20191218200528.GA896@bogus>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <4abb37f501cb51bf84cb5512f637747d73dcd3cc.1576511937.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4abb37f501cb51bf84cb5512f637747d73dcd3cc.1576511937.git.richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 08:13:24 -0800, Richard Cochran wrote:
> When parsing a PHY node, register its time stamper, if any, and attach
> the instance to the PHY device.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> ---
>  drivers/net/phy/phy_device.c |  3 +++
>  drivers/of/of_mdio.c         | 30 +++++++++++++++++++++++++++++-
>  2 files changed, 32 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
