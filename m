Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5235DA3D
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfGCBFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:05:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45450 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727147AbfGCBFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:05:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5209F14012593;
        Tue,  2 Jul 2019 15:28:46 -0700 (PDT)
Date:   Tue, 02 Jul 2019 15:28:45 -0700 (PDT)
Message-Id: <20190702.152845.752075477835616011.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH net-next] Revert "r8169: improve handling VLAN tag"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <df6fcca2-6db6-0d76-deb2-6b2e98e8bf54@gmail.com>
References: <df6fcca2-6db6-0d76-deb2-6b2e98e8bf54@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 15:28:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 2 Jul 2019 07:59:17 +0200

> This reverts commit 759d095741721888b6ee51afa74e0a66ce65e974.
> 
> The patch was based on a misunderstanding. As Al Viro pointed out [0]
> it's simply wrong on big endian. So let's revert it.
> 
> [0] https://marc.info/?t=156200975600004&r=1&w=2
> 
> Reported-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
