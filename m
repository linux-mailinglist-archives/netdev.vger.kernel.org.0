Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C0B29C785
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 19:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794534AbgJ0Sdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 14:33:46 -0400
Received: from mail.nic.cz ([217.31.204.67]:43650 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506351AbgJ0Sdp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 14:33:45 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 66103140757;
        Tue, 27 Oct 2020 19:33:43 +0100 (CET)
Date:   Tue, 27 Oct 2020 19:33:37 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
Message-ID: <20201027193337.50f22df0@nic.cz>
In-Reply-To: <87k0vbv84z.fsf@waldekranz.com>
References: <20201027105117.23052-1-tobias@waldekranz.com>
        <20201027160530.11fc42db@nic.cz>
        <20201027152330.GF878328@lunn.ch>
        <87k0vbv84z.fsf@waldekranz.com>
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

> In order for this to work on transmit, we need to add forward offloading
> to the bridge so that we can, for example, send one FORWARD from the CPU
> to send an ARP broadcast to swp1..4 instead of four FROM_CPUs.

Wouldn't this be solved if the CPU master interface was a bonding interface?
