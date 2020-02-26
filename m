Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4882F170B60
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 23:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgBZWT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 17:19:59 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38880 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727715AbgBZWT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 17:19:59 -0500
Received: by mail-ot1-f67.google.com with SMTP id z9so1021870oth.5;
        Wed, 26 Feb 2020 14:19:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=APzUm9Uqdb1AHoFIbybkkvfceWP8Qb3Vps+wDfO9Ixc=;
        b=AKd+nZpvj1FLe7xAA674eqB2/r4NYLvwss7eL8uLyQZLaHdT48CsVm8WCLQyJLWtOK
         U5JDKWTjY6vMN2wzhN4fROBspxx2J7O7Vj09EEXtnEbkueqCCg/+2oPSw7EJRH6uZwJV
         AhzCiIvOzgQK3EKkl8y95k1rYMc3hEhI1pfmewBpBEGpd04ZdUrMb+M8JB3qXstGJfPe
         rpFi2xCbCztHeMbPMKiMmrj+TxPwW7JJtXS1o4/P9illFMklhd4oXFpPmij8sNp1+O16
         MEb/Jegc7AveIWG0GAajjXk6Ze5I3kh0q9tQ9BbJpdzScAUQdxWRgEEwTAjJGr2HSR04
         Nszw==
X-Gm-Message-State: APjAAAV/ZzBHPcfXJE6hBlOThNKFHATifWSO/vPMsavpDuscbY+1YM6c
        4XxopJ5h6ZmEjSGGbPSzwA==
X-Google-Smtp-Source: APXvYqzJ67z3QKNb5f0MEKdgKj5bNuL222LJdlX3AvANxrD0qrkW110WbpjtOgkTN1PvTjI4SZ10xA==
X-Received: by 2002:a9d:638d:: with SMTP id w13mr862127otk.220.1582755598032;
        Wed, 26 Feb 2020 14:19:58 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id k18sm1246187oiw.44.2020.02.26.14.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 14:19:57 -0800 (PST)
Received: (nullmailer pid 4045 invoked by uid 1000);
        Wed, 26 Feb 2020 22:19:56 -0000
Date:   Wed, 26 Feb 2020 16:19:56 -0600
From:   Rob Herring <robh@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [for-next PATCH 2/5] dt-bindings: phy: ti: gmii-sel: add support
 for am654x/j721e soc
Message-ID: <20200226221956.GA3992@bogus>
References: <20200222120358.10003-1-grygorii.strashko@ti.com>
 <20200222120358.10003-3-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200222120358.10003-3-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Feb 2020 14:03:55 +0200, Grygorii Strashko wrote:
> TI AM654x/J721E SoCs have the same PHY interface selection mechanism for
> CPSWx subsystem as TI SoCs (AM3/4/5/DRA7), but registers and bit-fields
> placement is different.
> 
> This patch adds corresponding compatible strings to enable support for TI
> AM654x/J721E SoCs.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  Documentation/devicetree/bindings/phy/ti-phy-gmii-sel.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
