Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7042E16AB5E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 17:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgBXQ2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 11:28:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbgBXQ2I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 11:28:08 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98AE42080D;
        Mon, 24 Feb 2020 16:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582561688;
        bh=6SBywWytE60ZAELPFUndIoheBRs0SIEAwmcaQ/Ves78=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a/V0EDlpq0YTVwHVkthZGj4bvoDTDsHugS03iiJXHMHDijhRfVxmJmK7bKKvqcigJ
         b37YMnWgLqWJzLnpjuNEcPCwOyPzv9Tk61h0K4OqR0Dhk8mL/jU+CJuCFIc8hUraf3
         q0bD/PQbYpwQjGvuJcGIFz/Jdeake2AvQcp10LR8=
Date:   Mon, 24 Feb 2020 18:28:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Wahren <wahrenst@gmx.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL
 when not needed
Message-ID: <20200224162804.GB4526@unreal>
References: <20200224153609.24948-1-nsaenzjulienne@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224153609.24948-1-nsaenzjulienne@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 04:36:09PM +0100, Nicolas Saenz Julienne wrote:
> Outdated Raspberry Pi 4 firmware might configure the external PHY as
> rgmii although the kernel currently sets it as rgmii-rxid. This makes
> connections unreliable as ID_MODE_DIS is left enabled. To avoid this,
> explicitly clear that bit whenever we don't need it.
>
> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> Fixes: da38802211cc ("net: bcmgenet: Add RGMII_RXID support")

The expectation is that Fixes line comes before SOB line.

Thanks
