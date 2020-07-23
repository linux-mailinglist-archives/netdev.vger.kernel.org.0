Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7111E22B1C5
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgGWOqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:46:12 -0400
Received: from lists.nic.cz ([217.31.204.67]:59394 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgGWOqM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 10:46:12 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id BA2941409BD;
        Thu, 23 Jul 2020 16:46:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1595515570; bh=T7q1C9ScUBc36W7VsDEoLu3Pb928RN7HBc8InOb1LEI=;
        h=Date:From:To;
        b=LQlALQyhwsnYxG5Hgqtz0sq2AaWLZeQHnnYd804gD7DNcgeuaoumF/J3lzgOnI8q1
         ZkNTTe7/NDkeM8NUpfoagvaQ1RhNDU6qavsq6Ao6HjSqKHdRsOxn9lx3kRP0PKSLRz
         2hZwLdQCSDDXZKR6l4+AA5ZegReCV2Gm4xd3xCVE=
Date:   Thu, 23 Jul 2020 16:46:10 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: dsa: mv88e6xxx losing DHCPv6 solicit packets / IPv6 multicast
 packets?
Message-ID: <20200723164610.62e70bde@dellmb.labs.office.nic.cz>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

a customer of ours filed a ticket saying that when using upstream kernel
(5.8.0-rc6 on Debian 10) on Turris MOX (88e6190 switch) with DSA with
default configuration, the switch is losing DHCPv6 solicit packets /
IPv6 multicast packets sent to ff02::1::2 address.

> Specifically, it seems the 88E6190 hardware switches in the Peridot
> module is swallowing IPv6 multicast packets (sent to ff02::1:2 ).

> We tested this by mirroring the Mox LAN port on the switch and saw the
> DHCPv6 solicit packet arriving out of the switch but the Mox kernel
> didn't see it (using tcpdump).

Is this issue known?

Marek
