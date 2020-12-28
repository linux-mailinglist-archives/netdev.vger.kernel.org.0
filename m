Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2624E2E6B67
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgL1XF6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 28 Dec 2020 18:05:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45482 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728242AbgL1XFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 18:05:55 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id E2B3E4CE686D4;
        Mon, 28 Dec 2020 15:05:14 -0800 (PST)
Date:   Mon, 28 Dec 2020 15:05:14 -0800 (PST)
Message-Id: <20201228.150514.2273977621921676310.davem@davemloft.net>
To:     dftxbs3e@free.fr
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, trivial@kernel.org,
        irusskikh@marvell.com, lle-bout@zaclys.net
Subject: Re: [PATCH v2] atlantic: remove architecture depends
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201227161136.3429-1-dftxbs3e@free.fr>
References: <X+iuoLDI63CBXnfJ@lunn.ch>
        <20201227161136.3429-1-dftxbs3e@free.fr>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 28 Dec 2020 15:05:15 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: dftxbs3e@free.fr
Date: Sun, 27 Dec 2020 17:11:36 +0100

> From: Léo Le Bouter <lle-bout@zaclys.net>
> 
> This was tested on a RaptorCS Talos II with IBM POWER9 DD2.2 CPUs and an
> ASUS XG-C100F PCI-e card without any issue. Speeds of ~8Gbps could be
> attained with not-very-scientific (wget HTTP) both-ways measurements on
> a local network. No warning or error reported in kernel logs. The
> drivers seems to be portable enough for it not to be gated like such.
> 
> Signed-off-by: Léo Le Bouter <lle-bout@zaclys.net>

Applied, thank you.
