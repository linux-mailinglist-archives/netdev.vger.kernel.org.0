Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F62229AE71
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 15:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753579AbgJ0OA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 10:00:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47332 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1736687AbgJ0OAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 10:00:15 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXPWH-003oXh-2A; Tue, 27 Oct 2020 15:00:13 +0100
Date:   Tue, 27 Oct 2020 15:00:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
Message-ID: <20201027140013.GC878328@lunn.ch>
References: <20201027105117.23052-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027105117.23052-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> (mv88e6xxx) What is the policy regarding the use of DSA vs. EDSA?  It
> seems like all chips capable of doing EDSA are using that, except for
> the Peridot.

Hi Tobias

Marvell removed the ability to use EDSA, in the way we do in Linux
DSA, on Peridot. One of the configuration bits is gone. So i had to
use DSA.  It could be i just don't understand how to configure
Peridot, and EDSA could be used, but i never figured it out.

I will get back to your other questions.

  Andrew
