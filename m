Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1134396E3
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhJYNBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:01:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57060 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233431AbhJYNBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 09:01:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1xIvz9EZnq8Pwmitec8eQkiJzbdl6+HYNApMxU/1L10=; b=vRUMtf5DaFs1A7ElnNsb5YJoOz
        LbuLEzxraMMB6OaGUxIGmwx/s76P7p+zU15ljgU7tleoOqtttW93+w5X8C8GM+kMz0i+5uVP8Yx24
        UA+ugLJDgDSOuP6wBDWsSaRFalmuSp7I8lpYsA92BRhka/1dI3JDyM9yh3F1nrN0UtkI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mezZ4-00BeHt-H8; Mon, 25 Oct 2021 14:58:58 +0200
Date:   Mon, 25 Oct 2021 14:58:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: ethtool: ring configuration for CAN devices
Message-ID: <YXaqEk97/WcCxcFE@lunn.ch>
References: <20211024213759.hwhlb4e3repkvo6y@pengutronix.de>
 <YXaimhlXkpBKRQin@lunn.ch>
 <20211025124331.d7r7qbadkzfk7i4f@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025124331.d7r7qbadkzfk7i4f@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > struct ethtool_kringparam {
> > 	__u32	cmd;
> > 	__u32   mode;
> > 	__u32	rx_max_pending;
> > 	__u32	rx_mini_max_pending;
> > 	__u32	rx_jumbo_max_pending;
> > 	__u32	tx_max_pending;
> > 	__u32	rx_pending;
> > 	__u32	rx_mini_pending;
> > 	__u32	rx_jumbo_pending;
> > 	__u32	tx_pending;
> > };
> > 
> > and use this structure between the ethtool core and the drivers. This
> > has already been done at least once to allow extending the
> > API. Semantic patches are good for making the needed changes to all
> > the drivers.
> 
> What about the proposed "two new parameters ringparam_ext and extack for
> .get_ringparam and .set_ringparam to extend more ring params through
> netlink." by Hao Chen/Guangbin Huang in:
> 
> https://lore.kernel.org/all/20211014113943.16231-5-huangguangbin2@huawei.com/
>
> I personally like the conversion of the in in-kernel API to struct
> ethtool_kringparam better than adding ringparam_ext.

Ah, i missed that development. I don't like it.

You should probably jump into that discussion and explain your
requirements. Make sure it is heading in a direction you can extend
for your needs.

    Andrew
