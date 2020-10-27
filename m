Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D58229B4D0
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 16:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793531AbgJ0PGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 11:06:48 -0400
Received: from mail.nic.cz ([217.31.204.67]:52344 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790987AbgJ0PFi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 11:05:38 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 5922D140A64;
        Tue, 27 Oct 2020 16:05:36 +0100 (CET)
Date:   Tue, 27 Oct 2020 16:05:30 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
Message-ID: <20201027160530.11fc42db@nic.cz>
In-Reply-To: <20201027105117.23052-1-tobias@waldekranz.com>
References: <20201027105117.23052-1-tobias@waldekranz.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I first read about port trunking in the Peridot documentation, I
immediately thought that this could be used to transparently offload
that which is called Bonding in Linux...

Is this what you want to eventually do?

BTW, I thought about using port trunking to solve the multi-CPU DSA
issue as well. On Turris Omnia we have 2 switch ports connected to the
CPU. So I could trunk these 2 swtich ports, and on the other side
create a bonding interface from eth0 and eth1.

Andrew, what do you think about this? Is this something that can be
done? Or is it too complicated?

Marek
