Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA2B2DCA17
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgLQAnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:43:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbgLQAnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 19:43:02 -0500
Date:   Wed, 16 Dec 2020 16:42:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608165741;
        bh=rLt1BcYdaZR7V8OTDL/7lAbV+wFHd9ZgRllzEyTqVz0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=gdQC0lKHr55Ny2fDADgD1tmwN78PgX/WArDolyAgxTyGsioExJsQxt0NhheOpN7AT
         sFeMymxe4Y6x/YWWZRousLwTxCnrIQUtIvKOcGmsRoWI3cm7RXLqwamsKzPjCEaXjc
         RN0thh2MYUcppvRYsS9CJQj+E+DRNlskK8cRA1vkjJoEsRGU2GjMVNGWOBDOgMTjUx
         0PhFs1TStfLEw97M5RBPPMPcKtp8LbDjVZeLVvN33LkVVr3r+ygjoXkxZCYkIRiZdD
         QPNT6PoFrN6X7ninL+wJR53EldRXAThhLiefgE1IgKcoYWi+436ltm5WEfLOlRL1Jf
         8dvEkwABYfiXA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     <stefanc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <thomas.petazzoni@bootlin.com>,
        <davem@davemloft.net>, <nadavh@marvell.com>,
        <ymarkman@marvell.com>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, <mw@semihalf.com>, <andrew@lunn.ch>,
        <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net 1/2] net: mvpp2: Fix GoP port 3 Networking Complex
 Control configurations
Message-ID: <20201216164220.71e5fd1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1608039133-16345-1-git-send-email-stefanc@marvell.com>
References: <1608039133-16345-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 15:32:12 +0200 stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> During GoP port 2 Networking Complex Control mode of operation configurations,
> also GoP port 3 mode of operation was wrongly set mode.
> Patch removes these configurations.
> GENCONF_CTRL0_PORTX naming also fixed.

Can we get a Fixes tag?
