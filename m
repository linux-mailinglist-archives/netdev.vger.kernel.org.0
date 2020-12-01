Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089102CAAF2
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 19:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgLASlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 13:41:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60418 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728249AbgLASlp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 13:41:45 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkAaC-009jeQ-Lp; Tue, 01 Dec 2020 19:41:00 +0100
Date:   Tue, 1 Dec 2020 19:41:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jean Pihet <jean.pihet@newoldbits.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryan Barnett <ryan.barnett@rockwellcollins.com>,
        Conrad Ratschan <conrad.ratschan@rockwellcollins.com>,
        Hugo Cornelis <hugo.cornelis@essensium.com>,
        Arnout Vandecappelle <arnout.vandecappelle@essensium.com>
Subject: Re: [PATCH v2] net: dsa: ksz8795: adjust CPU link to host interface
Message-ID: <20201201184100.GN2073444@lunn.ch>
References: <20201201083408.51006-1-jean.pihet@newoldbits.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201083408.51006-1-jean.pihet@newoldbits.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 09:34:08AM +0100, Jean Pihet wrote:
> Add support for RGMII in 100 and 1000 Mbps.
> 
> Adjust the CPU port settings from the host interface settings: interface
> MII type, speed, duplex.

Hi Jean

You have still not explained why this is needed. Why? is always the
important question to answer in the commit message. The What? is
obvious from reading the patch. Why does you board need this, when no
over board does?

Thanks
	Andrew
