Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3949D5E1
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 20:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbfHZSgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 14:36:17 -0400
Received: from mail.nic.cz ([217.31.204.67]:34186 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727687AbfHZSgQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 14:36:16 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 32DFC140936;
        Mon, 26 Aug 2019 20:36:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566844575; bh=QYnqignKdHaA5jPpAYstEX6fduWN7RDVu1inahUrb24=;
        h=Date:From:To;
        b=sawxz3cnHFY5bm7ogd/7r94u06ma92UCP4ZA1u9U344ScKrBj1IZPM0RgvDGIOVc1
         sW+zpahWa+XXd2eSZTC0tERyn+8R6pk54yrwgmxU9fNoCXUmfwWOvkNMMcDEyEw44I
         WTOWOvD23qMBvpMvOzTddO9eFAUYxNhnEZtD5Bsw=
Date:   Mon, 26 Aug 2019 20:36:14 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC] net: dsa: mv88e6xxx: fully support SERDES on Topaz
 family
Message-ID: <20190826203614.6f9f6a8d@nic.cz>
In-Reply-To: <20190826142809.GC9628@t480s.localdomain>
References: <20190826134418.GB29480@t480s.localdomain>
        <20190826175920.21043-1-marek.behun@nic.cz>
        <20190826200315.0e080172@nic.cz>
        <20190826142809.GC9628@t480s.localdomain>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 14:28:09 -0400
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> Ask yourself what is the single task achieved by this function, and name this
> operation accordingly. It seems to change the CMODE to be writable, only
> supported by certain switch models right? So in addition to port_get_cmode
> and port_set_cmode, you can add port_set_cmode_writable, and call it right
> before or after port_set_cmode in mv88e6xxx_port_setup_mac.

Andrew's complaint was also about this function being called every time
cmode is to be changed. The cmode does need to be made writable only
once. In this sense it does make sense to put into into
mv88e6xxx_setup_port.

> Also please address the last comment I made in v3 in the new series.

I shall.
