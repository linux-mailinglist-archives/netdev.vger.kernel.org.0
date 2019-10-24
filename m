Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE09E2A6D
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 08:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437754AbfJXG3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 02:29:21 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34248 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbfJXG3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 02:29:21 -0400
Received: by mail-pl1-f195.google.com with SMTP id k7so11355603pll.1;
        Wed, 23 Oct 2019 23:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TnQ6iUBhZ6QDqwjf7E/1ik4QV2HCeGlGTNteQTzWdPE=;
        b=Col7n+vz5f4YwdbhXX/IIWvYPUDLvSpR5WS/+OYA+B9B0KPYEmzTQwzE+8YS02cIsp
         zAxUY4fxaMZWliWuGne7Q7u0CDNuNloUcByHFkJvjLJ2ZHLKBwlpnBZFLg18bWVn6Mcm
         LifRkDSw9pgY02ohsvv69ZvC669TvdSgYTfCy4iRqKlTO7Gb6AR6z9qQzpaMcpGpxbP7
         yeVhjSE79UlTsn03gABejtlu+nZd8BkMCldJ3iUF0EMFC/p5f4YB5hqueXs8o6IQzrxU
         Nl3lJOf8dBoXIuZ1jO4g6AmIAjlnu46uuOk6FTgkffa8hkZrJHZSbYSTb5QBiZCNpNSs
         cQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TnQ6iUBhZ6QDqwjf7E/1ik4QV2HCeGlGTNteQTzWdPE=;
        b=a6ZUQxUMC98DkMKKfEMiiZ6a6c/aIBZ8MmHxvG8HYvCrXFYyH4dTFXzbXcPtFjiXnp
         X4JRNEn1uxA+4+uR1l1fybwqkSfv7/yQcNiXAdsSDokJbR9fE5qddtWcwB+Z3uFmzIzt
         bzytX+ymSpKRECqN4Ex1B6+TPeM+nwXGDPO639VwyqGGfF0V1X9rNGsOxoGXrtOqczOh
         nb5640JaZfTGRXIIiseXiAY5OaLXEDIjAKK9D6MNOQgb9FoGavK1aWb3/W140X9VihZ7
         ZTcvwgnWdPLp0XWhDVq315auNjX7X/hI3tANab3s0tf7bh9JFdksRIDVWholq4dWAYq0
         5v2A==
X-Gm-Message-State: APjAAAUaUM5Vaa7oXE8k0cA+WPiZN6sYVwZNm7CV+csFa1253hcM8p7a
        aqMpTwN0RqJ4gUWhfOazY+M=
X-Google-Smtp-Source: APXvYqyZ3Bj2GsNfgwSkrUQpaXxBZQyDDxMEOxw9u5rcNyUF7sEPGB8cWdSZahnHBKymatS99bHpuA==
X-Received: by 2002:a17:902:8505:: with SMTP id bj5mr13430539plb.296.1571898560629;
        Wed, 23 Oct 2019 23:29:20 -0700 (PDT)
Received: from taoren-ubuntuvm (c-24-4-25-55.hsd1.ca.comcast.net. [24.4.25.55])
        by smtp.gmail.com with ESMTPSA id n3sm29168463pff.102.2019.10.23.23.29.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 23:29:20 -0700 (PDT)
Date:   Wed, 23 Oct 2019 23:29:03 -0700
From:   Tao Ren <rentao.bupt@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, olteanv@gmail.com,
        arun.parameswaran@broadcom.com, justinpopo6@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Subject: Re: [PATCH net-next v10 0/3] net: phy: support 1000Base-X
 auto-negotiation for BCM54616S
Message-ID: <20191024062902.GA52817@taoren-ubuntuvm>
References: <20191022183108.14029-1-rentao.bupt@gmail.com>
 <20191023.204311.1181447784152558295.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023.204311.1181447784152558295.davem@davemloft.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 08:43:11PM -0700, David Miller wrote:
> From: rentao.bupt@gmail.com
> Date: Tue, 22 Oct 2019 11:31:05 -0700
> 
> > From: Tao Ren <rentao.bupt@gmail.com>
> > 
> > This patch series aims at supporting auto negotiation when BCM54616S is
> > running in 1000Base-X mode: without the patch series, BCM54616S PHY driver
> > would report incorrect link speed in 1000Base-X mode.
> > 
> > Patch #1 (of 3) modifies assignment to OR when dealing with dev_flags in
> > phy_attach_direct function, so that dev_flags updated in BCM54616S PHY's
> > probe callback won't be lost.
> > 
> > Patch #2 (of 3) adds several genphy_c37_* functions to support clause 37
> > 1000Base-X auto-negotiation, and these functions are called in BCM54616S
> > PHY driver.
> > 
> > Patch #3 (of 3) detects BCM54616S PHY's operation mode and calls according
> > genphy_c37_* functions to configure auto-negotiation and parse link
> > attributes (speed, duplex, and etc.) in 1000Base-X mode.
> 
> Series applied to net-next, thank you.

Great. Thank you David!


Cheers,

Tao
