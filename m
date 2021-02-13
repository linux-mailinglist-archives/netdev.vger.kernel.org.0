Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A9731A966
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhBMBPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhBMBPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:15:37 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CC0C061574;
        Fri, 12 Feb 2021 17:14:56 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id c6so1977385ede.0;
        Fri, 12 Feb 2021 17:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gMWYDZt8K2yfbZjskINL0z+309220M5RKmWDEdamMtY=;
        b=RvT50idfqQsRm6Jl6xsdUHi6ThXFzbbay3gCqMK2dzXMFpoixjLufoStgiR0Zy2V25
         7eV8lFFKD+O6Psa6/dAQGeT0C3yBk0+ZzqBYh7J6zPX1Bb/mN+fPlV0C53iE3Gd4roI0
         rtXSO1bE7FmHP3oSRII/7jAqm0Rzc6gyqyZLe3f+lqzRoGJVixeIhdrqE5tbx/ZARv+k
         K7qs9dDjCnfietTOC3Cj854lAYpPW42QtUfWfMPZTej5tA8PmGBvPoTWhU3R4wUIItDQ
         8xlNXva2DDRBgVm+LVe9SVv7c4eHNuC2q+Cd2zhswpBs93dnmf8nQ2ED5ktA9HymlRfd
         zKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gMWYDZt8K2yfbZjskINL0z+309220M5RKmWDEdamMtY=;
        b=IGlYyfcez9Dj/VOfCqMC4akMlqaoeYWkQjePXZWPf9IjCBT8/OK4/swJho7vCu6niD
         CNmmodDjflrEW1H4l+EybBpFdXwFJHUAzMqwoOIH/oCKaYYTCqL3ZGx+jG+znxPCN7KZ
         rY14ouHZ+bvTetNttYW1SdnFMrP39uEBxpBjRqmhGHPvPNcxd4yTZXK8ygN4NEhyA9BS
         bVFRX/ubi6on4z1a3O09EyxHM6KhbhdqfdEQ70gqJ+lGiLaP5Gm1yz472602tx8daZtI
         f+8DMcgp/veZ28onXwCuOKHe7bQfVqUWW+ilzJuYtRGzXdw/YtKjY//EAKRAkzmRWXuP
         V+fg==
X-Gm-Message-State: AOAM5324TinlD7Bvw8sw78IESCJaa3sGPsKu0KjcUKWtobPHFPsS9IAD
        ng4gerd/2aqrS7I5kTBr7Bc=
X-Google-Smtp-Source: ABdhPJz+qvb+Ym4CwagaA7ug9BYNmxhVbkTNQ7J1tq8HJwmXtq6UCaPA7pKhAU8exUu0fqBBIMSYCg==
X-Received: by 2002:a50:bf47:: with SMTP id g7mr5888080edk.323.1613178895460;
        Fri, 12 Feb 2021 17:14:55 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t23sm7086378ejs.4.2021.02.12.17.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 17:14:55 -0800 (PST)
Date:   Sat, 13 Feb 2021 03:14:53 +0200
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
Subject: Re: [PATCH net-next 1/3] net: phy: broadcom: Remove unused flags
Message-ID: <20210213011453.k7mwchp6nxo5iks6@skbuf>
References: <20210212205721.2406849-1-f.fainelli@gmail.com>
 <20210212205721.2406849-2-f.fainelli@gmail.com>
 <20210213005659.enht5gsrh5dgmd7h@skbuf>
 <5cd03eea-ece8-7a81-2edc-ed74a76090ba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cd03eea-ece8-7a81-2edc-ed74a76090ba@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 05:08:58PM -0800, Florian Fainelli wrote:
> That's right, tg3 drove a lot of the Broadcom PHY driver changes back
> then, I also would like to rework the way we pass flags towards PHY
> drivers because tg3 is basically the only driver doing it right, where
> it checks the PHY ID first, then sets appropriate flags during connect.

Why does the tg3 controller need to enable the auto power down PHY
feature in the first place and the PHY driver can't just enable it by
itself?
