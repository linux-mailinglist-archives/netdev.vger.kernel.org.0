Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E50CF4A8B5
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729884AbfFRRng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:43:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50810 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729209AbfFRRnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 13:43:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C8C80151074B0;
        Tue, 18 Jun 2019 10:43:34 -0700 (PDT)
Date:   Tue, 18 Jun 2019 10:43:34 -0700 (PDT)
Message-Id: <20190618.104334.1476926866695813455.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     geoff@infradead.org, benh@kernel.crashing.org, paulus@samba.org,
        mpe@ellerman.id.au, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ps3_gelic: Use [] to denote a flexible array member
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617115044.4406-1-geert+renesas@glider.be>
References: <20190617115044.4406-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 10:43:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Mon, 17 Jun 2019 13:50:44 +0200

> Flexible array members should be denoted using [] instead of [0], else
> gcc will not warn when they are no longer at the end of a struct.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied to net-next, thanks.
