Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E6140C502
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 14:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237358AbhIOMQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 08:16:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42454 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237379AbhIOMQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 08:16:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2oIS4QY+0GOEZidow5b7JM+rhjr0bAga38TzrSaxCWI=; b=rEublDaYwuNgtU5rEMw3+QKxt0
        teaoWfkxNGDYuIZHKnH/SbwLM7oV/HKkAV3gYSn1fOD38IXDWVISEpPjoJNtaGCp9L4awdD/QlqnQ
        4RoA+GP1pxQNpsg2+yku5B4CJEhEMgMRLlvabMmwHDk2LC240tnRKdEfrzeIEHrccC9M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mQToS-006kiE-En; Wed, 15 Sep 2021 14:14:52 +0200
Date:   Wed, 15 Sep 2021 14:14:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 0/6] fw_devlink improvements
Message-ID: <YUHjvKRX76Jf7Bt5@lunn.ch>
References: <20210915081139.480263-1-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915081139.480263-1-saravanak@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 01:11:32AM -0700, Saravana Kannan wrote:
> Patches ready for picking up:
> Patch 1 fixes a bug in fw_devlink.
> Patch 2-4 are meant to make debugging easier
> Patch 5 and 6 fix fw_devlink issues with PHYs and networking
> 
> Andrew,
> 
> I think Patch 5 and 6 should be picked up be Greg too. Let me know if
> you disagree.
> 
> -Saravana

You are mixing fixes and development work. You should not do that,
please keep them separate. They are heading in different
directions. Fixed should get applied to -rc1, where as development
work will be queued for the next merge window.

You are also missing Fixes: tags for the two MDIO patches. Stable
needs them to know how far back to port the fixes.

      Andrew
