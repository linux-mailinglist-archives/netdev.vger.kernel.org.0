Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C7712549B
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 22:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLRV1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 16:27:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56674 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfLRV1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 16:27:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 65B8B153DBDC3;
        Wed, 18 Dec 2019 13:27:51 -0800 (PST)
Date:   Wed, 18 Dec 2019 13:27:50 -0800 (PST)
Message-Id: <20191218.132750.22964331376514008.davem@davemloft.net>
To:     ldir@darbyshire-bryant.me.uk
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] sch_cake: drop unused variable
 tin_quantum_prio
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191218140459.24992-1-ldir@darbyshire-bryant.me.uk>
References: <20191218140459.24992-1-ldir@darbyshire-bryant.me.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Dec 2019 13:27:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Date: Wed, 18 Dec 2019 14:05:13 +0000

> Turns out tin_quantum_prio isn't used anymore and is a leftover from a
> previous implementation of diffserv tins.  Since the variable isn't used
> in any calculations it can be eliminated.
> 
> Drop variable and places where it was set.  Rename remaining variable
> and consolidate naming of intermediate variables that set it.
> 
> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>

Applied, thank you.
