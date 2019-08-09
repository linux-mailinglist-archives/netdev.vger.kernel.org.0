Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B3C87187
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405298AbfHIFfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:35:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56190 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbfHIFfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:35:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 438F7143750FA;
        Thu,  8 Aug 2019 22:35:22 -0700 (PDT)
Date:   Thu, 08 Aug 2019 22:35:21 -0700 (PDT)
Message-Id: <20190808.223521.258592952923110054.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: allocate rx buffers using
 alloc_pages_node
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7d79d794-b41c-101f-0720-59eea88bf9ab@gmail.com>
References: <7d79d794-b41c-101f-0720-59eea88bf9ab@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 22:35:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 7 Aug 2019 21:38:22 +0200

> We allocate 16kb per rx buffer, so we can avoid some overhead by using
> alloc_pages_node directly instead of bothering kmalloc_node. Due to
> this change buffers are page-aligned now, therefore the alignment check
> can be removed.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thank you.
