Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4029D3BEAA1
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbhGGPZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:25:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44638 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232050AbhGGPZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 11:25:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=N/88Mkb8xuG8nFUIgXNDURTCNhXu6zncd1fGitnNCyk=; b=P3EHOJ76pnMoz1OO6NfGMZLquJ
        0cp/sShYG21Pyc1DSqu9aemkILeXZwIMrHg5AxMiKfji43JgLMR3FRJqCdM1miBmH7fwHm9P/WBhQ
        +3ZQL+unIgaO/zSlvObShEN+Q+mG0Rk6RCB2flMGle4li8KuMUFl1OjdUYX0aWSwacNE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m19NP-00CX6V-I1; Wed, 07 Jul 2021 17:22:15 +0200
Date:   Wed, 7 Jul 2021 17:22:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Liang Xu <lxu@maxlinear.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "mohammad.athari.ismail@intel.com" <mohammad.athari.ismail@intel.com>
Subject: Re: [PATCH v5 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YOXGp39i6foOHv02@lunn.ch>
References: <20210701082658.21875-1-lxu@maxlinear.com>
 <20210701082658.21875-2-lxu@maxlinear.com>
 <7e2b16b4-839c-0e1d-4d36-3b3fbf5be9eb@maxlinear.com>
 <20210706154454.GR22278@shell.armlinux.org.uk>
 <c4772ca8-42e3-9c9d-2388-e19acb19e073@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4772ca8-42e3-9c9d-2388-e19acb19e073@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Is the merging failure due to the tree declaration? Or something else I also
> need take care.

It is probably due to the tree declaration, assuming you are actually
using the correct tree.

> When did the net-next was closed? I saw some other patches after 1 Jul were
> accepted, how many days before the close should I submit?

It varies by subsystem. ARM SoC tends to close around a week before
the merge window opens. netdev sees some patches accepted one or two
days after the merge window opens, but you should not assume patches
will be accepted that late. Also, you should submit patches earlier,
rather than later. They get more testing that way, you have time to
fix issues etc.

> Do I need re-submit the patch when net_next is open again, or the current patch
> will be pulled in next open window?

You need to resubmit.

    Andrew
