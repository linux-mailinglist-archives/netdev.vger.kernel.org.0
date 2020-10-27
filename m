Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70E629C052
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 18:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1817160AbgJ0RN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 13:13:58 -0400
Received: from mail.nic.cz ([217.31.204.67]:50822 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1784260AbgJ0O7A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 10:59:00 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id DD493140B11;
        Tue, 27 Oct 2020 15:58:55 +0100 (CET)
Date:   Tue, 27 Oct 2020 15:58:49 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] net: dsa: mv88e6xxx: use ethertyped dsa for
 6390/6390X
Message-ID: <20201027155849.49c11523@nic.cz>
In-Reply-To: <20201027155436.6458f79b@nic.cz>
References: <20201027105117.23052-1-tobias@waldekranz.com>
        <20201027105117.23052-2-tobias@waldekranz.com>
        <20201027155213.290b66ea@nic.cz>
        <20201027155436.6458f79b@nic.cz>
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

On Tue, 27 Oct 2020 15:54:36 +0100
Marek Behun <marek.behun@nic.cz> wrote:

> But again, what is the benefit here?

OK, you need this for the LAG support, somehow those emails went to
another folder, sorry :)
