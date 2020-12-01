Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12F32CADA4
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgLAUqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:46:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60676 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729183AbgLAUqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 15:46:01 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkCWS-009kqp-7Q; Tue, 01 Dec 2020 21:45:16 +0100
Date:   Tue, 1 Dec 2020 21:45:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jean Pihet <jean.pihet@newoldbits.com>
Cc:     netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ryan Barnett <ryan.barnett@rockwellcollins.com>,
        Conrad Ratschan <conrad.ratschan@rockwellcollins.com>,
        Hugo Cornelis <hugo.cornelis@essensium.com>,
        Arnout Vandecappelle <arnout.vandecappelle@essensium.com>
Subject: Re: [PATCH v2] net: dsa: ksz8795: adjust CPU link to host interface
Message-ID: <20201201204516.GA2324545@lunn.ch>
References: <20201201083408.51006-1-jean.pihet@newoldbits.com>
 <20201201184100.GN2073444@lunn.ch>
 <CAORVsuXv5Gw18EeHwP36EkzF4nN5PeGerBQQa-6ruWAQRX+GoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAORVsuXv5Gw18EeHwP36EkzF4nN5PeGerBQQa-6ruWAQRX+GoQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Configure the host port of the switch to match the host interface
> settings. This is useful when the switch is directly connected to the
> host MAC interface.

Why do you need this when no other board does? Why is your board
special?

As i said before, i'm guessing your board has back to back PHYs
between the SoC and the switch and nobody else does. Is that the
reason why? Without this, nothing is configuring the switch MAC to the
results of the auto-neg between the two PHYs?

Or am i completely wrong?

   Andrew

