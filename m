Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D1B356B5C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 13:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346966AbhDGLhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 07:37:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:55362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235017AbhDGLhD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 07:37:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617795413; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5B4EydAFySuCx8ASw1PaHZMQMaOqH+r5Eq4RihuTXNA=;
        b=CrwLL+E/olIlNRBqWPvrbL0WQ2iEw44W3FFa+BGiNYi7CUUhsahv3kR8QnwYS4h6o86vTW
        KWULfN8tNgXexqlOlvfkdYcLsAY6C4DsVkYPs44dMykSwaTyFI23MLUn1frgmczfahayzP
        8QgEAwTJtIc10kl8CKHnl09/MEjhLEU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4B88BB122;
        Wed,  7 Apr 2021 11:36:53 +0000 (UTC)
Message-ID: <e3cc8ecb4ce8c61b9eb79a2238b2b3570334ce5a.camel@suse.com>
Subject: Re: [PATCH net-next v4 0/4] usbnet: speed reporting for devices
 without MDIO
From:   Oliver Neukum <oneukum@suse.com>
To:     Grant Grundler <grundler@chromium.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Wed, 07 Apr 2021 13:36:43 +0200
In-Reply-To: <CANEJEGs7LtNCG4qPMi1PTK_NWBybO9TjzF3nMrFQYV5S5ZqZ9g@mail.gmail.com>
References: <20210405231344.1403025-1-grundler@chromium.org>
         <YGumuzcPl+9l5ZHV@lunn.ch>
         <CANEJEGsYQm9EhqVLA4oedP2fuKrP=3bOUDV9=7owfdZzX7SpUA@mail.gmail.com>
         <YGxbXOXquilXNV2W@lunn.ch>
         <CANEJEGs7LtNCG4qPMi1PTK_NWBybO9TjzF3nMrFQYV5S5ZqZ9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Dienstag, den 06.04.2021, 18:01 +0000 schrieb Grant Grundler:

> > Ethernet does not support
> > different rates in each direction. So if RX and TX are different, i
> > would actually say something is broken.
> 
> Agreed. The question is: Is there data or some heuristics we can use
> to determine if the physical layer/link is ethernet?
> I'm pessimistic we will be able to since this is at odds with the
> intent of the CDC spec.

Yes, CDC intends to hide that. We can conclude that an asymmetric link
rules out ethernet, but anything else is difficult.

	Regards
		Oliver


