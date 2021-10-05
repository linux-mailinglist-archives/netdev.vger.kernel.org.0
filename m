Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECC6421BE5
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhJEBdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:33:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231162AbhJEBdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:33:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E31B1610C8;
        Tue,  5 Oct 2021 01:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633397495;
        bh=TRSCAQ1Si+uY18vh7kgvvlybyOXrKC6bnN84suQm93g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ItyMQmXdVLRgSojfrutm7r/UfDuFYNs4psIhsstmHwDU/Rw2uvKI1gKDFGAAPDovt
         8ViQQCOqqUbdvnp5n7xZeP47g5jULsZfjqDbQx29yS+buAK4wS07ECsPb3BKdDn/4U
         PEd81QohTMdljdLv5w/sGxOuqd249lchvQ8c3WHaRrTpJ4v8S5lc6vWsOkYsEnD0jB
         EZIFuxSPHwBR7W49h+IdMwW9er8G10jnthd14sH/GB/kjr77N2JjJG/NWLXV2lfhkf
         R2/1KWFAf+Mj5eAsKi3OqLR+nrp8qQuq/YL5X/fS6TxfbCl4C8U+QCVEiAn4foANJg
         49HcoqvZYp0GA==
Date:   Mon, 4 Oct 2021 18:31:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Bauer <mail@david-bauer.net>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: at803x: add QCA9561 support
Message-ID: <20211004183134.03739959@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211004193633.730203-1-mail@david-bauer.net>
References: <20211004193633.730203-1-mail@david-bauer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Oct 2021 21:36:33 +0200 David Bauer wrote:
> Add support for the embedded fast-ethernet PHY found on the QCA9561
> WiSoC platform. It supports the usual Atheros PHY featureset including
> the cable tester.
> 
> Tested on a Xiaomi MiRouter 4Q (QCA9561)
> 
> Signed-off-by: David Bauer <mail@david-bauer.net>

Please keep Andrew's tag, rebase this patch on net-next:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/

and resend with [PATCH net-next] as the subject prefix.

We have a number of additions to at803x already queued for the next
release and otherwise this patch conflicts with them.
