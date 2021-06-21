Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546C33AE833
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 13:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhFULdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 07:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhFULdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 07:33:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63C3560FE9;
        Mon, 21 Jun 2021 11:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624275051;
        bh=LG6QB8SVQUWlDQVvmjlKt3qg1g6KvcmwLsMeAmJ+OGE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=an59891NjcUMADK+isizPY3/fQW+2kC7ybyqrYIdsoLDnTEuMPEJJ1EDUPieuSs/g
         HjtAL5+StKHQbqZa1aCyomuiACEBGxpDjQ6QeZg62OmTTJphMfLRdgbGkZFFukEla4
         ivMIUacx2d/FEn2RmBxMHrnMlxV7o4lJ7/k70P7jtUNHEdGQzyUBT4gtub9to5pD5r
         x177oVg5k8UOcF6vp3uDE8rnpefdFLTAHwNUnDUkcIPzzMuP+4iuj7IOBY/Mnfqqm0
         rAKfsP16MxrW8RbaXid2ROTt8gl6ys5wMyYp2w0oB1an1irY/u3Qbwa4S/9xE4CN0p
         3sj0d/XeXmvxw==
Date:   Mon, 21 Jun 2021 13:30:48 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Eldar Gasanov <eldargasanov2@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] mv88e6xxx: fixed adding vlan 0
Message-ID: <20210621133026.475c3564@dellmb>
In-Reply-To: <20210621085437.25777-1-eldargasanov2@gmail.com>
References: <20210621085437.25777-1-eldargasanov2@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Jun 2021 11:54:38 +0300
Eldar Gasanov <eldargasanov2@gmail.com> wrote:

> 8021q module adds vlan 0 to all interfaces when it starts.
> When 8021q module is loaded it isn't possible to create bond
> with mv88e6xxx interfaces, bonding module dipslay error
> "Couldn't add bond vlan ids", because it tries to add vlan 0
> to slave interfaces.
> 
> There is unexpected behavior in the switch. When a PVID
> is assigned to a port the switch changes VID to PVID
> in ingress frames with VID 0 on the port. Expected
> that the switch doesn't assign PVID to tagged frames
> with VID 0. But there isn't a way to change this behavior
> in the switch.
> 
> Signed-off-by: Eldar Gasanov <eldargasanov2@gmail.com>

Patch subject should be
  net: dsa: mv88e6xxx: Fix adding VLAN 0

We use present simple tense in commit messages.
