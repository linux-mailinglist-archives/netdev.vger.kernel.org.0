Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9038E36BCF2
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 03:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbhD0Bfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 21:35:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42066 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233916AbhD0Bfx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 21:35:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lbCcw-001HVH-Sk; Tue, 27 Apr 2021 03:35:02 +0200
Date:   Tue, 27 Apr 2021 03:35:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?5pu554Wc?= <cao88yu@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net] dsa: mv88e6xxx: 6161: Use chip wide MAX MTU
Message-ID: <YIdqRlY+2iSqQ8lW@lunn.ch>
References: <20210426233441.302414-1-andrew@lunn.ch>
 <YIdOmvPFTCcmwP/W@lunn.ch>
 <CACu-5+0bnMJPOUZHKfSTEQiFgAVX9kjbgTTQtqLDT57yv0MDHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACu-5+0bnMJPOUZHKfSTEQiFgAVX9kjbgTTQtqLDT57yv0MDHQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 08:18:00AM +0800, 曹煜 wrote:
> Hi Andrew,
> I'll test the patch later, but what about the 88e6171r switch chip,
> this chip also got this issue since kernel 5.9.0 Many thanks.

Saying the 6171 is wrong i have problems with.

The 6161 is part of the 6165 family, consisting of 6123, 6161 and
6165. The 6123 was already using mv88e6185_g1_set_max_frame_size, and
the documentation is ambiguous.

The 6171 is part of the 6351 family: 6171 6175 6350 6351. It is a
couple of generations newer, and all the other members of the family
also use mv88e6165_port_set_jumbo_size. I have the GPL licensed SDK
from Marvell. If i'm reading the SDK correctly, it has a function to
access the per port register for jumbo settings for the 6351 family.

Do you have a 6171 we can test code on?

   Andrew
