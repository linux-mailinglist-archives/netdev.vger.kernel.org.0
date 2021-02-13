Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B485831AAE4
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 11:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhBMKeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 05:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhBMKec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 05:34:32 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C13C061574;
        Sat, 13 Feb 2021 02:33:51 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id bl23so3487610ejb.5;
        Sat, 13 Feb 2021 02:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eFwl5mhrQbPFn+RsZgWSDZMNCTp67nYrqsXxJP82DM4=;
        b=UdeKv4297N8msxSAGDghzwHwP1WBY8ZaDCre0DnNARVQQAcnwZbPXYzcoK0xTOvAcW
         ykUgcIy+xQBZJXtVp6U5vZw6DN+5O9feyuUKtzdQ0VzfpKUwXH8kNRKu6ecdrmvssFJH
         Pq8Qap5oTDXtr7v7oQYThM/6o4yHDzBBETtwNGfijVAWrYQneg0t+sGvk6FHeXIN+bIJ
         OUtukN5kZRwRJ+7OFau8E0oWOXggF632r4gv14qxqR/wdaCEg76uXbwvi2tgVhzixsWR
         CBVDdxsmjf7N2bo0tZ8YH4BCkphlr0ZaXKfCmUkbfc1v10SqpeFDTdYSpIC3Z09GUM3Y
         nKww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eFwl5mhrQbPFn+RsZgWSDZMNCTp67nYrqsXxJP82DM4=;
        b=SjvRg5mvAe1b6bz5ZWKYNJt8kytVovN5QUZnnWmMAIu06bd5GsxTnRD+InWtVhI3Qp
         exthDKS4NtvYkYfZNsCAzocWKs2Mc+OGMbDF5bC3VwJ+y92Nel9PITnFFfuOWKB7Xbbu
         wGyjW7yhqU5LhXlfDCr2Uk2fyouQBmDvCPPsWrVbAImExbM6UPuNYXuSQ0vBuNAaqwWh
         R29/RxY44OTchGq8SkVjr1xPWqYt6Wka+Z/KeiztmLKT49glugd5WhuHCyXE/Y4DlAYx
         QjPBvs34kaN9tuxq+xhgvTn4K9RGBfN6uWgpc45OB+g7Q1mwfJiEOVtF3V59csiUjHV/
         rqng==
X-Gm-Message-State: AOAM5326D73WAO0490dw60C1AYS+YyF6MizqCy2u2DyTcoIFIWVMnrS/
        KtIoD1VmqbrQiN7RIl+SzfI=
X-Google-Smtp-Source: ABdhPJzUn3JWnOUVuRtG1G10WLhTV7beWjqHhi8gxZiQlmcoeyoUTT72akBw31MBPNvOgOFTgVtkqw==
X-Received: by 2002:a17:906:fb9a:: with SMTP id lr26mr7186980ejb.474.1613212430519;
        Sat, 13 Feb 2021 02:33:50 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id hr31sm7295797ejc.125.2021.02.13.02.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 02:33:50 -0800 (PST)
Date:   Sat, 13 Feb 2021 12:33:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>, michael@walle.cc
Subject: Re: [PATCH net-next v2 2/3] net: phy: broadcom: Remove unused flags
Message-ID: <20210213103349.hv2l3a5xyxjrmane@skbuf>
References: <20210213034632.2420998-1-f.fainelli@gmail.com>
 <20210213034632.2420998-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210213034632.2420998-3-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 07:46:31PM -0800, Florian Fainelli wrote:
> We have a number of unused flags defined today and since we are scarce
> on space and may need to introduce new flags in the future remove and
> shift every existing flag down into a contiguous assignment.
> PHY_BCM_FLAGS_MODE_1000BX was only used internally for the BCM54616S
> PHY, so we allocate a driver private structure instead to store that
> flag instead of canibalizing one from phydev->dev_flags for that
> purpose.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

So you want to remove the IBND dev_flags separately, okay.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
