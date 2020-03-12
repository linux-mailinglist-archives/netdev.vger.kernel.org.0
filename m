Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 121BC182976
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 08:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388059AbgCLHDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 03:03:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56504 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388016AbgCLHDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 03:03:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DE51514E25406;
        Thu, 12 Mar 2020 00:03:50 -0700 (PDT)
Date:   Thu, 12 Mar 2020 00:03:50 -0700 (PDT)
Message-Id: <20200312.000350.637350189715401251.davem@davemloft.net>
To:     chris.packham@alliedtelesis.co.nz
Cc:     andrew@lunn.ch, josua@solid-run.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mvmdio: avoid error message for optional IRQ
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311200546.9936-1-chris.packham@alliedtelesis.co.nz>
References: <20200311200546.9936-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 00:03:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>
Date: Thu, 12 Mar 2020 09:05:46 +1300

> Per the dt-binding the interrupt is optional so use
> platform_get_irq_optional() instead of platform_get_irq(). Since
> commit 7723f4c5ecdb ("driver core: platform: Add an error message to
> platform_get_irq*()") platform_get_irq() produces an error message
> 
>   orion-mdio f1072004.mdio: IRQ index 0 not found
> 
> which is perfectly normal if one hasn't specified the optional property
> in the device tree.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks.
