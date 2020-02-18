Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21AA6162821
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 15:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgBRO2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 09:28:17 -0500
Received: from first.geanix.com ([116.203.34.67]:50546 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgBRO2R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 09:28:17 -0500
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id D029AC0029;
        Tue, 18 Feb 2020 14:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582036045; bh=mHzt9vtnKLHNpF1/+TJ0Mqr2u8xuO4Fqk8u6fW/EDks=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To;
        b=NyLbT3+ZSzHRzg/t+SZBSVHIzj+RTsJ8tdYGFRfqqiEUS/jqPTEink6P8B1VeKQhi
         03YfkqFq9I2sRDrqM0dSjOclLHHJv3YSXe9r0dW85VE4IFynlrAuMO4csbTBBuHRnf
         mVm7wqFLiL/jbvxZDh1AZ0iJTuPQgiOV89lvoD2fmQrNuShJ7VB4SWVpAUPNcPjNQn
         UAk4u1b5PwE9sqkSOVAwe/PgUxu/6Tfe9avRct3mnZ+rsG7n4Jzszl2sNz81cZIIrU
         UEQzUDO1jdtad3twes8tIoMr/IP5PMAGMuHXN3eRb2MmX8kv23mFFOaLn88y4gVA/1
         9eN3uSeayg7ZA==
From:   Esben Haabendal <esben@geanix.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Subject: Re: [PATCH 8/8] net: ll_temac: Add ethtool support for coalesce parameters
References: <20200218082741.7710-1-esben@geanix.com>
        <20200218133943.GA10541@lunn.ch>
Date:   Tue, 18 Feb 2020 15:28:13 +0100
In-Reply-To: <20200218133943.GA10541@lunn.ch> (Andrew Lunn's message of "Tue,
        18 Feb 2020 14:39:43 +0100")
Message-ID: <87v9o4gebm.fsf@geanix.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.7 required=4.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=disabled
        version=3.4.3
X-Spam-Checker-Version: SpamAssassin 3.4.3 (2019-12-06) on eb9da72b0f73
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> writes:

> Hi Esben
>
>> +	if (ec->tx_coalesce_usecs)
>> +		lp->coalesce_delay_tx =
>> +			min(255U, (ec->tx_coalesce_usecs * 100) / 512);
>> +
>> +	pr_info("%d -> %d  %d -> %d\n",
>> +		ec->rx_coalesce_usecs, lp->coalesce_delay_rx,
>> +		ec->tx_coalesce_usecs, lp->coalesce_delay_tx);
>
> I guess this is left over from debug? You don't actually want it here?

Yes, I will remove that in v2.  Thanks.

/Esben
