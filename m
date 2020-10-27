Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626F329C138
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 18:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818770AbgJ0RXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 13:23:21 -0400
Received: from mail.nic.cz ([217.31.204.67]:49790 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780413AbgJ0Oyo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 10:54:44 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id A1C3B140A6B;
        Tue, 27 Oct 2020 15:54:42 +0100 (CET)
Date:   Tue, 27 Oct 2020 15:54:36 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] net: dsa: mv88e6xxx: use ethertyped dsa for
 6390/6390X
Message-ID: <20201027155436.6458f79b@nic.cz>
In-Reply-To: <20201027155213.290b66ea@nic.cz>
References: <20201027105117.23052-1-tobias@waldekranz.com>
        <20201027105117.23052-2-tobias@waldekranz.com>
        <20201027155213.290b66ea@nic.cz>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 15:52:13 +0100
Marek Behun <marek.behun@nic.cz> wrote:

> On Tue, 27 Oct 2020 11:51:14 +0100
> Tobias Waldekranz <tobias@waldekranz.com> wrote:
> 
> > The policy is to use ethertyped DSA for all devices that are capable
> > of doing so, which the Peridot is.
> 
> What is the benefit here?

Also, when you are changing something for 6390, please do the same
change for the non-industrial version of Peridot (6190, 6190X), for
6290 and 6191.

And since Topaz (6341 and 6141) are basically smaller Peridot's (with 6
ports instead of 11), such a change should also go there.

But again, what is the benefit here?

Marek
