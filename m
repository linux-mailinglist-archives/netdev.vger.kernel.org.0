Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 541759D55B
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 20:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387610AbfHZSDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 14:03:17 -0400
Received: from mail.nic.cz ([217.31.204.67]:34048 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731879AbfHZSDR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 14:03:17 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id B933D1409B6;
        Mon, 26 Aug 2019 20:03:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566842595; bh=jtG3puCmCk/AHo16GWH8UaSFW1q59F0dAK+dKDLF8q0=;
        h=Date:From:To;
        b=pDhm+8TD/k76TQPYB0pTw1vu5nNc71Kmqq+D8H9y6hr/3u6Z4YrCgKaJsi2mjbOJB
         0rpE/lBrhnrD+Rmq5+W3xNQAMp5N4APgkFsTfcqzcuxUUJI0A6E3mgAz6+dyEC8vI9
         Fh5tFgFHAU/5Go1+cQQG0lql5xZPLqcdxYMPeO+s=
Date:   Mon, 26 Aug 2019 20:03:15 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC] net: dsa: mv88e6xxx: fully support SERDES on Topaz
 family
Message-ID: <20190826200315.0e080172@nic.cz>
In-Reply-To: <20190826175920.21043-1-marek.behun@nic.cz>
References: <20190826134418.GB29480@t480s.localdomain>
        <20190826175920.21043-1-marek.behun@nic.cz>
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

What about this?

It adds a new chip operation (I know Vivien said not to, but I was
doing it already) port_setup_extra, and implements it for Topaz.

Also it changes the mv88e6xxx_port_set_cmode so that it does not use
those 2 additional parameters.

Should I rewrite it so that only the second change is applied?

Should I send a new series, v5, today? I think that I once read David
complain that he does not like if new versions of patch series are sent
at the same day.

Marek
