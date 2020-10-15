Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DC628E985
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 02:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732197AbgJOAfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 20:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727790AbgJOAff (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 20:35:35 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9F1222242;
        Thu, 15 Oct 2020 00:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602722135;
        bh=Vcxh7W6YCHKYo3f4nMTdWacr0l0OOCs4P/U+xxv33L8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RH/Qq7AI9PYrQQCzCpCHMm50bzaPqpWVsN18rUxwYPp2L2AdrSQ9F5lLHgHUnLxIR
         DMC6sgFhuutFcRZQ9l8zxj5fxVaY6tvU2hEIQzCjU/JBNikfmbT2zVipIqLXL91890
         cZT+HmiYwHwkmYkap2+7tW91LXYjiHlZzawwcyuc=
Date:   Wed, 14 Oct 2020 17:35:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] net: dsa: mv88e6xxx: serdes link without phy
Message-ID: <20201014173533.75137c09@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201013021858.20530-1-chris.packham@alliedtelesis.co.nz>
References: <20201013021858.20530-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 15:18:56 +1300 Chris Packham wrote:
> This small series gets my hardware into a working state. The key points are to
> make sure we don't force the link and that we ask the MAC for the link status.
> I also have updated my dts to say `phy-mode = "1000base-x";` and `managed =
> "in-band-status";`

Russell, Andrew, PHY folks - does this look good to you?
