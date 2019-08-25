Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 269FF9C266
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 09:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfHYHNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 03:13:40 -0400
Received: from mail.nic.cz ([217.31.204.67]:45138 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbfHYHNj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Aug 2019 03:13:39 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 1CAD8140BAD;
        Sun, 25 Aug 2019 09:13:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566717218; bh=A3hNoVN5ZlaSFUIFfnPziJkqklzql/UhWKIJNmnGCYo=;
        h=Date:From:To;
        b=gOIHz3q1uerFDWFjmHI8DGJK6xySVHSF/1uNszaXc6sp48ISxlOoZsXHPeg9sxAta
         2+DzfNYLZWv9zfjoi4ymdf6e81rJKjesda35h1f3bXQpnltcp4Ao1pDzzRo9zuj7p5
         UwoWiQj95ieZb9h8/tW+mJ1tBT3erXIAXhN2jEdY=
Date:   Sun, 25 Aug 2019 09:13:37 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Chris Healy <cphealy@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20190825091337.236ee73a@nic.cz>
In-Reply-To: <a7fed8ab-60f3-a30c-5634-fd89e4daf44d@gmail.com>
References: <20190824024251.4542-1-marek.behun@nic.cz>
        <a7fed8ab-60f3-a30c-5634-fd89e4daf44d@gmail.com>
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

On Sat, 24 Aug 2019 13:04:04 -0700
Florian Fainelli <f.fainelli@gmail.com> wrote:

> Now, the 4.9 kernel behavior actually works just fine because eth1 is
> not a special interface, so no tagging is expected, and "wifi", although
> it supports DSA tagging, represents another side of the CPU/host network
> stack, so you never have to inject frames into the switch, because you
> can use eth1 to do that and let MAC learning do its job to forward to
> the correct port of the switch.

Hi Florian,

Sorry, I am having trouble understanding what you mean in the
paragraph I quoted above (and paragraphs afterwards).

eth0 and eth1 are interfaces created by an ethernet driver.
wlan0 is an interface created by wireless driver.
wifi is a slave interface created by DSA for port 5 on the switch.
eth1 is DSA slave or a DSA master connected to port 5?

How does DSA handle two interfaces with same reg property?

Marek
