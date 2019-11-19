Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFF4101118
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 03:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfKSCDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 21:03:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52790 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfKSCDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 21:03:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E3851151022A1;
        Mon, 18 Nov 2019 18:03:45 -0800 (PST)
Date:   Mon, 18 Nov 2019 18:03:45 -0800 (PST)
Message-Id: <20191118.180345.383002223234440388.davem@davemloft.net>
To:     adisuresh@google.com
Cc:     netdev@vger.kernel.org, csully@google.com
Subject: Re: [PATCH net v2] gve: fix dma sync bug where not all pages synced
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191118234240.191075-1-adisuresh@google.com>
References: <20191118234240.191075-1-adisuresh@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 18:03:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Adi Suresh <adisuresh@google.com>
Date: Mon, 18 Nov 2019 15:42:40 -0800

> The previous commit had a bug where the last page in the memory range
> could not be synced. This change fixes the behavior so that all the
> required pages are synced.
> 
> Fixes: 9cfeeb5 ("gve: Fixes DMA synchronization")

12 digits of SHA1 hash signifigance in Fixes: tags please.

Thank you.

